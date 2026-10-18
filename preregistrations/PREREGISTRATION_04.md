# Fourth pre-registration: the cause, isolated

Registered 13 October 2026, after the third registration ([PREREGISTRATION_03.md](PREREGISTRATION_03.md),
[run 008](../validation/run_008_instrument/)) placed `half_cheetah`'s time-step failure in ground contact, and after
design probes ([validation/run_009_design_probes](../validation/run_009_design_probes/)). Registered before any run or
stream of this registration existed. The instrument is not used here: every measurement is arithmetic on what the
simulator did.

## The question

The third registration says where the failure lives. It does not say what in SuperDex does it, and "does not
converge between 10 ms and 0.16 ms" could still be a method working as designed at steps that are too coarse. To
call something a flaw of the library it has to be shown on a case with a right answer that does not depend on the
time step, with nothing else in the scene, and then tied back to the benchmark.

## The smallest contact scene

One rigid cube and the static ground plane, under gravity (`tools/sdx_contact.cpp`). Three things about it have a
right answer:

1. **The bounce.** With no friction and no contact damping, SuperDex's contact force comes from an energy (its
   penalty), so the exact motion gives all of the impact energy back: a dropped cube returns to the height it was
   dropped from. An implicit first-order integrator damps what it does not resolve by an amount that depends on the
   step (Hairer and Wanner 1996), so the bounce it produces is a property of the step.
2. **Coulomb's law at impact.** While a contact slides, the friction force is the coefficient times the normal
   force at every instant, so over an impact the horizontal momentum lost is the coefficient times the vertical
   momentum the ground gives (Stronge 2000).
3. **Stick.** A body at rest pushed with less than friction can hold does not move. A friction law that is zero at
   zero slip speed cannot do this: the body creeps at the speed at which the law's force equals the push.

## What SuperDex's source says (v1.0.0, `UPSTREAM_COMMIT`)

- `ContactParams.normalViscousDampingCoefficient` is 0 as shipped, and neither benchmark scene file sets any contact
  parameter. The contact is the penalty alone, with no loss of its own.
- `ExperimentalEvalParams.implicitNormalForceForDissipation` is false as shipped: friction and contact damping use
  the normal force at the start of the step, and that start-of-step distance is estimated unless `explicitNormals`
  is set. The header says of the implicit choice that it "can improve the accuracy of the effective coefficient of
  restitution at a given time step size".
- The friction force is the coefficient times the penalty part of the normal force times a function of the slip
  over the step. Both smoothing laws SuperDex ships are zero at zero slip. There is no stick state, no anchor and
  no static coefficient in the contact path.

## What the design probes showed

Probe parameters and throwaway actions, not the registered ones
([validation/run_009_design_probes](../validation/run_009_design_probes/)).

- **The step sets the bounce.** A 1 kg cube dropped 0.05 m with the shipped contact and the shipped integrator
  rebounds to 0% of its drop height at the shipped 10 ms step, 28% at 1/16 of it, 69% at 1/64 and 83% at 1/128.
  SuperDex's own third-order integrator reaches 99.99%. Nothing in the shipped contact loses energy. The integrator
  does, by an amount set by the step.
- **Friction at impact is short of Coulomb's law** by 6% to 29% as shipped, depending on the step, and exact at
  every step with SuperDex's own `implicitNormalForceForDissipation` switch.
- **No friction switch gives a stick.** A resting cube pushed with half of what friction can hold creeps at
  2.9 mm/s as shipped, and under every one of six switches. Only the falloff speed changes the creep, in
  proportion, and it does not reach zero.
- **The benchmark's failure appears in the smallest scene, and so does its cure.** Each step against the next finer
  one, the differences grow as the step shrinks with the shipped contact, exactly as on `half_cheetah`. With
  friction off they are the same. With contact damping they fall at every step. When the cube never reaches the
  ground they halve exactly.
- **On the benchmark**, twelve throwaway episodes: with contact damping 5, `half_cheetah`'s time-step chain halves
  in every part of the episode out to 1/32 of the step, and `ant`'s keeps its order to 1/64.

## The claim

The second registration's time-step failure is caused by SuperDex's own contact handling as shipped:

- **K1** the contact has no loss of its own, so how much a body bounces is set by the time step, across the whole
  range of steps the benchmark was played at;
- **K2** friction during an impact is short of Coulomb's law because it uses the normal force of the start of the
  step, and SuperDex's own switch restores it;
- **K3** no friction switch SuperDex ships gives a stick;
- **K4** the smallest scene reproduces the benchmark's failure, and a contact loss cures it;
- **L1** the same cure puts `half_cheetah`'s time-step chain in order with the ground.

## Part A: the smallest scene, registered parameters

A cube of 2 kg and half-size 0.04 m (`tools/contact_all.sh`). None of these numbers was used in the probes. Steps:
10 ms divided by 1, 2, 4, 8, 16, 32 and 64. 64-bit build, iteration limit 200, backward Euler unless said.

| Run | Set-up | Settings played |
|---|---|---|
| drop | Released at rest 0.08 m above the ground, no friction, 0.5 s | Shipped; third-order integrator; contact damping 5 |
| oblique | The same drop with 4 m/s sideways, friction 0.4, rotation held, 0.3 s | Shipped; implicit normal force. Reported: damping 5, and damping 5 with the implicit normal force |
| chain | The same drop with 1.5 m/s sideways, friction 0.4, 1 s | Shipped; contact damping 5; released 10 m up so that it never reaches the ground |
| slide | Set on the ground at 5 m/s, friction 0.4, 0.5 s, at two steps | Shipped |
| creep | Set on the ground, friction 0.5 (it can hold 9.8 N), pushed with 5.88 N, 1 s | Shipped; C-infinity friction law; implicit normal force; explicit normals; no fading; Armijo line search; falloff 0.001; viscous 100 |

What is measured, in whole numbers throughout:

- **Bounce.** The highest the cube's lowest face gets after its first impact, per 10,000 of the drop height.
- **Impact.** From the last step before the ground pushes to the first step the cube no longer moves down: the
  horizontal speed lost, over the vertical speed the ground gave (gravity's share removed), per 10,000.
- **Creep.** The mean horizontal speed over the second half of the run, and the friction force over the normal
  force.
- **Gap.** Two step sizes compared at the instants of the 10 ms step: the summed absolute difference of the cube's
  height.

## Part B: the benchmark link

`half_cheetah` and `ant` with the ground, on the third registration's commands (`actions/03/`, 108 episodes), with
contact damping 5 on every actor and nothing else changed (`tools/plays/play_04.sh`): at 1, 1/2, 1/4, 1/8, 1/16 and 1/32
of the shipped step, and 1/64 on `ant`. Each source differs from the third registration's shipped source of the same
step by the damping alone. Plain subtraction over the same three folds.

## The rules, fixed in advance

Controls. If a control fails, the scene or the rig is not what it is taken to be, and nothing below is read.

| Control | It holds when |
|---|---|
| **K0a** nothing touches the cube | In the chain that never reaches the ground, every gap is between 45 and 55 parts in 100 of the one before |
| **K0b** steady sliding | Friction force over normal force is within 1 part in 100 of 0.4, at both steps |

The claim. Each rule can fail, and failing means SuperDex gets that case right.

| Rule | It holds when |
|---|---|
| **K1** the step sets the bounce | Shipped, the rebound is under 500 per 10,000 at the shipped step, and more than 5,000 per 10,000 higher at 1/64 of it; and SuperDex's third-order integrator at 1/64 gives 9,900 or more |
| **K2** Coulomb at impact | Shipped, at the shipped step, the impact ratio is more than 1 part in 100 from 0.4; with the implicit normal force it is within 1 part in 100 of 0.4 at all seven steps; and the cube is still sliding at the end of every impact used |
| **K3** no stick | All eight creep runs move, and the shipped and C-infinity speeds are within 1 part in 100 of what their laws predict for this push: 3,675 and 3,750 micrometres a second |
| **K4** the smallest scene's chain | Shipped, the gaps do not fall at every step. With contact damping 5, they do |
| **L1** the benchmark link | `half_cheetah`'s damped chain at 1, 1/2, 1/4, 1/8, 1/16 is in order by plain subtraction in all three folds (its shipped chain on the same commands was in order in none) |

Reported, not deciding: every measured line; the damped drop; the damped oblique impact; `ant`'s damped chain to
1/64 and `half_cheetah`'s to 1/32, by part of the episode; the solver's own status.

## Known before the run, so it cannot be discovered afterwards

- Everything in the design probes, on other parameters and other actions.
- The shipped chain on these commands, from the third registration: `half_cheetah` out of order in three folds of
  three; `ant` in order to 1/16 and out of order at 1/64.
- The damping value 5 was looked at in the probes on other parameters. It is not tuned on the registered ones. It
  is SuperDex's own parameter, not a change to its code.

## Known risks, stated before the run

- The registered cube is heavier and smaller than the probe's and falls further. Its rebound at each step will
  differ from the probe's numbers, and K1's three bounds may not all be met.
- K2 needs the cube to slide through the whole impact. At 4 m/s and friction 0.4 it should.
- Damping 5 was enough on the probe's actions. On the registered commands a fold may still be out of order.

## What this does and does not say

It says what in SuperDex's shipped contact produces the failure, on cases with a right answer, and that SuperDex's
own parameter removes it on the benchmark.

Whether a contact with no loss of its own is a defect or a default is a judgement. The measured consequence is not:
the outcome of every impact is chosen by the time step, and a smaller step, the setting offered for accuracy, moves
the physics toward a perfectly elastic bounce instead of refining one answer. K2 and K3 are departures from
Coulomb's law in the shipped code path.

Limits: one cube, one ground, one drop; three benchmark scenes under random actions; a simulator against its own
right answers, and nothing against a real robot.
