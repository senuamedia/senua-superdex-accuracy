# Third pre-registration: whose failure is it

Registered 13 October 2026, after the second registration ([PREREGISTRATION_02.md](PREREGISTRATION_02.md)) did not hold
in full (25 of 36 cells, [README.md](../README.md)), and after design probes on throwaway actions
([validation/run_006_design_probes](../validation/run_006_design_probes/)). Registered before any stream of this
registration existed and before the instrument had read anything played for it. The instrument is unchanged.

## Why a third registration

The second registration failed in 11 cells. Ten of them were failures of order: it had predicted that every step
toward a finer setting changes the motion less than the step before. On `half_cheetah`'s time step, on the sharpest
contact settings and once on `ant`'s solver ladder, that did not happen.

What failed was the prediction. The record did not say whose failure it was, and that is the question a reader has
to have answered before the result is of any use. There are four possible owners, and each calls for a different
action.

| Owner | What it would mean |
|---|---|
| The instrument (Senua's) | SuperDex's output is in order and the instrument misorders it |
| The rig (ours, `tools/sdx_player.cpp`) | The program that drives SuperDex drives it wrongly as the step shrinks |
| The scene | The motion is so sensitive to small changes that no simulator would settle on one trajectory, and the prediction asked for something that cannot hold |
| The engine (SuperDex) | Its answer does not settle as its own accuracy setting is refined, over the range tested |

Before the probes our working guess was the scene. The probes refuted that guess.

## The test behind this

Refinement is the standard check of a numerical solver: for a method of order p, halving the step divides the
difference between successive solutions by 2 to the power p, once the step is small enough to be in the method's
working range (Richardson 1911; Roache 1998; Oberkampf and Roy 2010). Backward Euler, SuperDex's shipped integrator,
is first order, so successive gaps should halve. Seeing the halving is evidence that the solver and the program
driving it are right in that regime. Not seeing it says the solutions are not in the working range there: a time
scale the step does not resolve, an event that is not smooth, or a defect. Erez, Tassa and Todorov (ICRA 2015) used
the same idea to compare physics engines for robotics. Sensitivity to small changes is tested the way Lorenz (1963)
did: make a small known change and follow it in time.

## What the design probes showed

Twelve episodes a scene on actions that are not the registered ones, no instrument, plain subtraction of the rig's
noiseless encoder streams ([validation/run_006_design_probes](../validation/run_006_design_probes/)).

- **The rig repeats.** The reference played twice, and played with the nudge set to zero, gives byte-identical
  streams on all three scenes.
- **The scenes do not amplify a small change. They forget it.** A nudge of 1e-6 or less to the first command leaves
  every reading identical on all three scenes. A nudge of 1 gives a small response that peaks early and fades, and
  a nudge of 10 gives ten times that response. This refuted our working guess.
- **Without the ground, `half_cheetah`'s time-step settings halve through the whole episode.** Readings 40 to 80,
  from the coarsest gap to the finest: 15,204, 8,494, 4,351, 2,149.
- **With the ground they stop halving once the ground starts to matter**, about 0.1 s in. The same readings:
  16,157, 11,695, 18,614, 29,651, 42,407, 30,826. The finer gaps are larger than the coarser ones, and they are
  still not falling at 1/64 of the shipped step. For the first 0.1 s the two chains are the same to the count.
- **`cart_pole`**, which has no contact, halves at every step out to 1/64. **`ant`** without the ground is in order
  in every part of the episode. With the ground it halves early and loses its order late and at the fine end.
- **No single contact setting is a cure** (exploratory): with friction off the coarse steps converge and the finest
  does not; a softer contact and a more gradual friction law change little.
- **The second registration's order failures are in the subtraction.** Its own streams, subtracted with no
  instrument, give the instrument's sizes to within a few percent and in the same order, in every failing cell we
  checked. A dry run of this registration's harness on three of its lists (nine cells, with noise used by no
  registration) has the instrument and plain subtraction ordering alike in all nine.

## Scenes, commands, sensor

As the second registration: SuperDex v1.0.0 (`UPSTREAM_COMMIT`), `assets/benchmarks/` `cart_pole`, `half_cheetah` and
`ant`, each built as its own SuperDex Lab environment builds it, unperturbed start, one worker thread, the 64-bit
build. 108 episodes a scene of 200 readings on seeded random actions with new seeds (4401, 4402, 4403; `actions/03/`).
One channel a scene: the recorded joint as a 14-bit encoder (16,384 counts a turn, one count is 0.022 degrees).

## Sources

Every source is the 64-bit build, backward Euler, iteration limit 200, played by `tools/plays/play_03.sh`.

| Source | Settings | Scenes |
|---|---|---|
| `sref`, `srefb` | The reference, played twice | all |
| `z` | As `sref` with the nudge set to zero | all |
| `n9 n6 n3 n0` | As `sref`, with the command on the first actuated joint larger by 1e-9, 1e-6, 1e-3 and 1 (newtons on `cart_pole`, newton metres on the others) during the first control step of every episode | all |
| `t2 t4 t8 t16 t32 t64` | At 1/2 to 1/64 of the shipped step | all |
| `g1 g2 g4 g8 g16` | The ground plane left out, at 1 to 1/16 of the shipped step | `half_cheetah`, `ant` |
| `m1 m2 m4 m8 m16` | Friction off on every actor, at 1 to 1/16 of the shipped step | `half_cheetah`, `ant` |
| `c10 c2 c1 c06 c03` | Contact smoothing 10, 2.5, 1.25, 0.625, 0.3125 mm (`sref` is 5 mm) | `half_cheetah`, `ant` |
| `s1 s2 s4 s8 s16` | Iteration limit 1, 2, 4, 8, 16 | all |

`cart_pole` has no ground and no contact, so its time-step chain is already a chain with nothing touching the agent.

## What is measured

- **Plain subtraction.** For two sources, over the 36 test episodes of a fold (the same three folds as before): the
  two noiseless encoder streams are subtracted reading for reading, the difference is summed over every window of
  32 readings, and the absolute values of those window sums are added up. This is arithmetic only. It is the
  instrument's own size measure with its gate, its declared normal and the sensor noise all taken away.
- **In order.** The size falls at every step toward the fine end of a list. In a chain each source is compared with
  the next finer one; in a ladder each rung is compared with the reference.
- **The instrument's reading** of a gap, exactly as in the second registration, with the same detection bar (219 of
  6,084 windows, measured in that registration's stage 0 at this geometry and this noise).
- **Parting.** The first reading of an episode at which two streams are more than one count apart.
- **By part of the episode** (reported): the summed absolute difference in readings 0 to 5, 5 to 10, 10 to 20,
  20 to 40, 40 to 80, 80 to 120, 120 to 160 and 160 to 200.

## The claim

The second registration's time-step order failure belongs to the engine's side of the boundary, and specifically to
ground contact as the step is refined:

1. the instrument orders the gaps as plain subtraction does;
2. the rig repeats exactly, its nudge at zero changes nothing, and with nothing touching the agent from outside its
   time-step chain is in order;
3. the scenes do not carry a tiny change of the input to where the sensor sees it;
4. on `half_cheetah` with the ground, the time-step chain is again not in order.

## The rules, fixed in advance, and the owner each one names

| Rule | It holds when | If it fires |
|---|---|---|
| **I0** calibration | Pooled over every calibration reading of stage 2, at most 2 windows in 100 are flagged | The instrument is not calibrated on this run, and I1 is not read |
| **I1** the instrument against arithmetic | In every cell (one list of one scene, one fold), the list is in order by the instrument's size exactly when it is in order by plain subtraction, both taken over the gaps the instrument detected | The instrument owns the order in that cell |
| **R1** the rig repeats | `srefb` and `z` are byte-identical to `sref` on all three scenes (encoder stream and state file) | The rig is not deterministic or the nudge is not inert at zero, and nothing below can be read |
| **R2** the rig's stepping | With nothing touching the agent from outside (`cart_pole`: `sref t2 t4 t8 t16`; `half_cheetah` and `ant`: `g1 g2 g4 g8 g16`), plain subtraction is in order in every fold | The failure is not specific to contact: the rig's stepping, or the engine's dynamics without contact, own it |
| **N1** the scene | `n9` and `n6` never part from `sref`, in any episode of any scene | The scene owns it: order cannot be asked after the parting |
| **E1** the failure itself | On `half_cheetah` with the ground (`sref t2 t4 t8 t16`), plain subtraction is not in order, in every fold | The second registration's failure was a property of its commands, and there is nothing to attribute |

The instrument reads ten lists (rule I1): the time-step chain `sref t2 t4 t8 t16 t32 t64` on all three scenes, the
chain without ground on two, the contact-smoothing chain `c10 sref c2 c1 c06 c03` on two, and the solver ladder on
all three. Three folds each: 30 cells.

If every rule holds, the time-step order failure belongs to SuperDex's handling of ground contact under a smaller
step, and the contact and solver order failures are present in SuperDex's output as plain arithmetic, not made by
the instrument's reading of it.

That is a statement of where the failure lives. It is not a statement that SuperDex's code is wrong. A penalty
contact with a regularised friction law has time scales far shorter than the shipped step, and a first-order
implicit integrator damps what it does not resolve by an amount that depends on the step. Not converging between
10 ms and 0.16 ms can be the method working as designed at steps too coarse for its own contact handling. This
registration decides where the failure lives. It does not decide between designed and defective.

Reported, not deciding: every reading; every chain by part of the episode; the gaps beyond 1/16 of the step; the
time-step chain with the ground on `ant` and `cart_pole`; the solver's own status of every step; `n3` and `n0`
(whether the response is in proportion to the nudge, and whether it fades); the time-step chain with friction off (`m1` to `m16`), by part and by plain subtraction.

## Stages

1. **Stage 1, no instrument.** The rig plays every source. Recorded: the solver's status of every step; rule R1 by
   byte comparison; every chain by part of the episode, and its parting; plain subtraction and its order for every
   list. Rules R1, R2, N1 and E1 are decided here, before the instrument has read anything.
2. **Stage 2, the instrument, once.** Ten processes, one list of one scene each, then a pooled verdict. Rules I0 and
   I1 are decided here.

## Known before the run, so it cannot be discovered afterwards

- Everything in the design probes above, on other actions, and the second registration's own streams read again by
  plain subtraction.
- If R1, R2, N1 and E1 come out as predicted, the ownership of the time-step failure is settled before the
  instrument reads anything. Stage 2 then answers one question only: does the instrument agree with arithmetic.

## Known risks, stated before the run

- **I1 can fire on a near tie.** Sensor noise moves a size by a few thousand counts. Two gaps whose plain values are
  closer than that can be ordered either way by the instrument. A cell that differs is printed with both sets of
  values, and it counts against the instrument as registered.
- **`cart_pole` can pass near its upright balance point**, where a small difference decides which way the pole
  falls. One such episode could put a large late gap into a fine pair and fire R2 on `cart_pole`, or part a nudged
  run and fire N1. It is recorded as measured if so.
- **R2 clears the rig only for what it exercises**: stepping, and holding the command, with nothing touching the
  agent. The ground plane is created the way SuperDex Lab's environment creates it. That the rig builds the ground
  as the environment does is established by reading the two, not by experiment.

## Limits

Simulation against simulation: one engine against its own settings. One sensor channel a scene. Three control
benchmarks under random actions for two to four seconds, not dexterous manipulation and not a trained policy.
Nothing here has a ground truth, and nothing is simulation against a real robot.
