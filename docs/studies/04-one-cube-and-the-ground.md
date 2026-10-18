# Study 4: the cause, isolated on one cube and the ground

| | |
|---|---|
| Registration | Fourth: [PREREGISTRATION_04.md](../../preregistrations/PREREGISTRATION_04.md) |
| Question | What in SuperDex's contact puts the benchmark out of order, shown on a case with a right answer and nothing else in the scene? |
| Outcome | Every rule held: both controls and all five rules of the claim |
| Registered | 13 October 2026, before any run or stream of this registration existed |
| Result | [Runs 010](../../validation/run_010_contact/README.md) and [011](../../validation/run_011_counts/README.md). Run 010's plays began at 23:46 on 13 October 2026, local time, and its reading was made at 00:32 on 14 October; run 011 was played and read on 14 October |
| Runs | [009, design probes](../../validation/run_009_design_probes/), [010, one cube](../../validation/run_010_contact/), [011, the benchmark link](../../validation/run_011_counts/) |
| Data | [`contact/`](../../contact/) (80 one-cube runs), [`streams/04/`](../../streams/04/) (13 encoder streams) |
| Played by | [`tools/sdx_contact.cpp`](../../tools/sdx_contact.cpp), [`tools/contact_all.sh`](../../tools/contact_all.sh), [`tools/plays/play_04.sh`](../../tools/plays/play_04.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx), `sx_contact_run.sh`, `sx_link.sh` |

Previous: [Study 3](03-whose-failure.md). Next: [Study 5](05-contact-patches.md). All studies: [index](README.md).

## Why it was asked

Study 3 says where the failure lives. It does not say what in SuperDex does it, and "does not converge between
10 ms and 0.16 ms" could still be a method working as designed at steps that are too coarse. To call something a
flaw of a library it has to be shown on a case whose right answer does not depend on the time step, with nothing
else in the scene, and then tied back to the benchmark.

## The smallest contact scene

One rigid cube and the static ground plane, under gravity. Three things about it have a right answer.

1. **The bounce.** With no friction and no contact damping, SuperDex's contact force comes from an energy, so the
   exact motion gives all of the impact energy back: a dropped cube returns to the height it was dropped from. An
   implicit first-order integrator damps what it does not resolve by an amount that depends on the step (Hairer
   and Wanner 1996), so the bounce it produces is a property of the step.
2. **Coulomb's law at impact.** While a contact slides, the friction force is the coefficient times the normal
   force at every instant. So over an impact the horizontal momentum lost is the coefficient times the vertical
   momentum the ground gives (Stronge 2000).
3. **Stick.** A body at rest pushed with less than friction can hold does not move. A friction law that is zero at
   zero slip speed cannot do this.

## What SuperDex's source says

- `normalViscousDampingCoefficient` is 0 as shipped, and neither benchmark scene sets any contact parameter. The
  contact is the penalty alone, with no loss of its own.
- `implicitNormalForceForDissipation` is false as shipped: friction and contact damping use the normal force at the
  start of the step.
- The friction force is the coefficient times the penalty part of the normal force times a function of the slip
  over the step. Both smoothing laws SuperDex ships are zero at zero slip. There is no stick state, no anchor and no
  static coefficient in the contact path.

## What was played

**Part A, one cube.** 2 kg, half-size 0.04 m. None of these numbers was used in the design probes. Steps: 10 ms
divided by 1, 2, 4, 8, 16, 32 and 64. 64-bit build, iteration limit 200.

| Run | Set-up | Settings played |
|---|---|---|
| Drop | Released at rest 0.08 m above the ground, no friction | Shipped; third-order integrator; contact damping 5 |
| Oblique | The same drop with 4 m/s sideways and friction 0.4, rotation held | Shipped; implicit normal force; and two reported settings with damping |
| Chain | The same drop with 1.5 m/s sideways and friction 0.4, for 1 s | Shipped; contact damping 5; and released 10 m up so that it never reaches the ground |
| Slide | Set on the ground at 5 m/s, friction 0.4 | Shipped |
| Creep | Set on the ground with friction 0.5, which can hold 9.8 N, and pushed with 5.88 N | Shipped, and seven of SuperDex's own switches and settings |

**Part B, the benchmark link.** `half_cheetah` and `ant` with the ground, on Study 3's commands, with contact
damping 5 on every actor and nothing else changed. Each source differs from Study 3's shipped source of the same
step by the damping alone.

## The rules fixed in advance

Two controls first. If a control fails, the scene or the rig is not what it is taken to be, and nothing else is
read.

| Control | It holds when |
|---|---|
| K0a, nothing touches the cube | In the chain that never reaches the ground, every gap is between 45% and 55% of the one before |
| K0b, steady sliding | Friction force over normal force is within 1% of 0.4, at both steps |

Then the claim. Each rule can fail, and failing means SuperDex gets that case right.

| Rule | It holds when |
|---|---|
| K1, the step sets the bounce | Shipped, the rebound is under 5% of the drop height at the shipped step and more than 50 points higher at 1/64 of it, and SuperDex's third-order integrator at 1/64 gives 99% or more |
| K2, Coulomb at impact | Shipped, the impact ratio is more than 1% from 0.4 at the shipped step. With the implicit normal force it is within 1% of 0.4 at all seven steps. And the cube is still sliding at the end of every impact used |
| K3, no stick | All eight creep runs move, and the shipped and C-infinity speeds are within 1 part in 100 of what their laws predict for this push: 3,675 and 3,750 micrometres a second |
| K4, the chain on one cube | Shipped, the gaps do not fall at every step. With contact damping 5, they do |
| L1, the benchmark link | `half_cheetah`'s damped chain at 1, 1/2, 1/4, 1/8 and 1/16 of the step is in order by plain subtraction in all three folds |

The damping value 5 was looked at in the probes on other parameters. It was not tuned on the registered ones, and
it is SuperDex's own parameter, not a change to its code.

## The result

| Rule | Result |
|---|---|
| K0a, control | Held. Each gap is 50.00% to 50.02% of the one before |
| K0b, control | Held. Friction over normal force 0.4000 and 0.4001 |
| K1 | Held |
| K2 | Held |
| K3 | Held |
| K4 | Held |
| L1 | Held |

### K1. The step sets the bounce

The exact motion returns the cube to the height it was dropped from: 10,000 parts in 10,000.

| Rebound per 10,000 of the drop height | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| SuperDex as shipped (backward Euler) | 0 | 8 | 353 | 1,307 | 3,080 | 5,264 | 7,148 |
| SuperDex's own third-order integrator | 2,443 | 3,014 | 6,846 | 9,005 | 9,813 | 9,973 | 9,996 |
| Shipped integrator, contact damping 5 (reported) | 0 | 0 | 0 | 0 | 14 | 40 | 57 |

At the shipped step the cube keeps none of its impact energy. At 1/64 of that step it keeps 71%. SuperDex's
third-order integrator reaches 99.96%, the right answer for SuperDex's own contact law. So the shipped contact has
no loss of its own, and how much a body bounces is decided by the time step.

### K2. Friction during an impact is short of Coulomb's law

The cube slides through the whole impact, so the horizontal speed it loses must be 0.4 times the vertical speed the
ground gives it: 4,000 parts in 10,000.

| Friction impulse over normal impulse, per 10,000 | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| SuperDex as shipped | 2,203 | 2,336 | 2,224 | 3,032 | 3,164 | 3,372 | 3,598 |
| With `implicitNormalForceForDissipation` | 4,000 | 3,999 | 4,000 | 3,999 | 3,999 | 4,000 | 4,000 |
| Contact damping 5 (reported) | 2,207 | 2,364 | 1,937 | 2,371 | 1,578 | 1,560 | 1,339 |
| Contact damping 5 with the implicit switch (reported) | 2,417 | 2,455 | 2,240 | 1,890 | 1,765 | 1,511 | 1,426 |

As shipped, friction delivers 55% of what Coulomb's law requires at the shipped step and 90% at 1/64 of it,
because it is computed from the normal force at the start of the step. SuperDex's own switch gives the right
answer at every step.

The two reported rows show a second departure. With contact damping on, friction is far short again and the switch
does not restore it: friction is computed from the penalty part of the normal force, and the damping part is left
out. That became patch A in [Study 5](05-contact-patches.md).

### K3. No friction switch gives a stick

| Setting | Creep, micrometres a second |
|---|---|
| Shipped (its law predicts 3,675) | 3,670 |
| C-infinity friction law (predicts 3,750) | 3,742 |
| Implicit normal force | 3,670 |
| Explicit normals | 3,670 |
| No fading | 3,670 |
| Armijo line search | 3,670 |
| Falloff speed 0.001 (shipped 0.01) | 367 |
| Viscous friction 100 | 1,559 |

Under every switch the cube creeps, at the speed the friction law's own formula gives. Lowering the falloff speed
lowers the creep in proportion and does not remove it.

### K4. The benchmark's failure, with one cube

Each step against the next finer one: the summed difference of the cube's height, in micrometres.

| | 1 to 1/2 | 1/2 to 1/4 | 1/4 to 1/8 | 1/8 to 1/16 | 1/16 to 1/32 | 1/32 to 1/64 |
|---|---|---|---|---|---|---|
| Shipped | 21,560 | 23,587 | 76,841 | 270,334 | 734,510 | 1,279,314 |
| Contact damping 5 | 20,144 | 10,494 | 5,832 | 3,425 | 2,199 | 1,359 |
| The cube never reaches the ground | 1,237,250 | 618,600 | 309,300 | 154,650 | 77,321 | 38,667 |

With the shipped contact the differences grow sixty-fold as the step shrinks. That is `half_cheetah`'s failure,
with one cube and nothing else. With a contact loss they fall at every step. With nothing to hit they halve
exactly, which is what a first-order integrator should do.

### L1. The same cure puts the benchmark in order

Plain subtraction over each fold's 36 test episodes, from the coarsest gap to the finest.

| `half_cheetah` with the ground | Fold 0 | Fold 1 | Fold 2 | In order |
|---|---|---|---|---|
| Shipped | 4,144,564; 3,200,618; 4,688,047; 8,051,707 | 4,266,572; 3,388,408; 4,711,505; 7,035,001 | 3,504,062; 3,053,908; 3,415,118; 5,662,877 | 0 folds of 3 |
| Contact damping 5 | 3,929,347; 2,333,050; 1,470,814; 1,278,152 | 4,219,209; 2,587,302; 1,483,106; 883,347 | 3,229,993; 1,861,165; 1,102,688; 782,590 | 3 folds of 3 |

Reported: with contact damping `ant`'s chain is in order in all three folds out to 1/64 of the step, where shipped
it was in order in none. `ant`'s steps that stop without converging fall from 228 of 21,600 to 9 at the shipped
step. No step diverged.

## What it means

- The cause of the benchmark's disorder is in SuperDex's contact as shipped. It has no loss of its own, so the time
  step decides the outcome of every impact. A smaller step, the setting offered for accuracy, moves the physics
  toward a perfectly elastic bounce instead of refining one answer.
- Friction during an impact departs from Coulomb's law in the shipped code path, and one of SuperDex's own switches
  corrects it on one cube.
- No friction setting SuperDex ships holds a body at rest under a load.

## What it led to

A contact loss cures the benchmark, but the reported rows show that switching damping on with stock code breaks
friction. So the corrections had to be tested one by one, each against a right answer.
That is [Study 5](05-contact-patches.md).

Limits: one cube, one ground, one drop. A simulator against its own right answers, and nothing against a real
robot.
