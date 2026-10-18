# Study 1: what SuperDex's accuracy settings cost

| | |
|---|---|
| Registration | First: [PREREGISTRATION_01.md](../../preregistrations/PREREGISTRATION_01.md) |
| Question | Can the cost of SuperDex's accuracy settings be read, in order, on Meta's three benchmark scenes? |
| Outcome | Did not hold in full: 16 of 27 cells |
| Registered | 13 October 2026, before the rig had produced any stream |
| Result | [Run 002](../../validation/run_002_instrument/README.md), 13 October 2026 |
| Runs | [001, the counts](../../validation/run_001_counts/) and [002, the reading](../../validation/run_002_instrument/) |
| Data | [`streams/01/`](../../streams/01/) (45 encoder streams), [`actions/01/`](../../actions/01/) (the seeded commands) |
| Played by | [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp), [`tools/plays/play_01.sh`](../../tools/plays/play_01.sh) |
| Measured by | [`measure/instrument/sx_settings.sx`](../../measure/instrument/sx_settings.sx) |

Next: [Study 2](02-independent-calibration.md). All studies: [index](README.md).

## The question

SuperDex Physics documents where it trades accuracy for stability, and each trade is a setting.

- **Solver convergence.** When the solver reaches its iteration limit it continues to the next step with the answer
  it has, because "speed and robustness must be prioritized over absolute accuracy". The shipped limit is 4.
- **Time integration.** The default integrator, backward Euler, "provides maximum stability", and for "scenarios
  where quantitative accuracy is desired, BDF2 is recommended".
- **Contact compliance.** Contact "allows for some interpenetration of colliding bodies", and the penalty is
  smoothed over a half-distance of 5 mm by default.

SuperDex is deterministic within a build, so the same commanded episode can be played twice under two settings,
step for step. This study asks how far apart the two land, where, and in what order.

## What was played

**The scenes.** SuperDex v1.0.0, `assets/benchmarks/`: the three scenes Meta publishes with SuperDex Lab, each built
the way its own environment builds it.

| Scene | Simulation and control rate | Actuated degrees of freedom | Action range | Recorded joint |
|---|---|---|---|---|
| `cart_pole` | 50 Hz and 25 Hz | 1 (100 N a unit of action) | -3 to 3 | 1, the pole |
| `half_cheetah` | 100 Hz and 20 Hz | 6 | -1 to 1 | 3 |
| `ant` | 100 Hz and 20 Hz | 8 (150 a unit of action each) | -1 to 1 | 6 |

Two things differ from the environments, both for determinism: every episode starts from the unperturbed pose at
rest, and one worker thread is used.

**The commands.** Seeded random actions, uniform over the action range, played unchanged into every source of a
scene. 108 episodes a scene, 200 readings each.

**The sensor.** One channel a scene: the recorded joint as a 14-bit absolute encoder, 16,384 counts a turn, read at
every shipped simulation step. The rig's streams carry no noise. A sensor error of one count either way, seeded, is
added as each stream is read.

**The settings.** Three ladders, one variable each. Shipped is backward Euler, iteration limit 4, one solver step a
simulation step, and 5 mm of contact smoothing.

| Ladder | The variable | Rungs, coarse to fine | Its reference |
|---|---|---|---|
| S, solver convergence | Iteration limit | 1, 2, 4 (shipped), 8, 16 | Limit 200 |
| T, time integration | Backward Euler step | Shipped, 1/2, 1/4, 1/8 | BDF2 at 1/16 of the shipped step |
| C, contact compliance | Smoothing half-distance | 10, 5 (shipped), 2.5, 1.25 mm | 0.625 mm |

That is 15 sources a scene and 45 in all. Two of the 15 are also reported beside the ladders: BDF2 at the shipped
step, which is the documentation's recommendation and on no ladder, and the shipped source, each read against ladder
T's reference.

## How it was read

In two stages. Stage 1 plays every source and records counts only: readings, solver steps, steps that did not
converge, and whether a rung's stream is byte-identical to its reference. Stage 2 is the instrument's one reading.

Senua AI's gap instrument reads the difference between a source and its reference at the same step of the same
episode. What it is read against is the difference between two runs of the reference under sensor noise, so nobody
sets a tolerance by hand. For each window of 32 readings it reports a flag, at a designed false-alarm rate of 1 in
100, and a size in encoder counts.

Episodes are split into three blocks of 36. Each fold declares what is normal on one block and reads another. A
cell is one scene, one ladder and one fold: 27 cells.

## The rules fixed in advance

A rung is detected when its flagged windows are more than those of run C of its reference (the reference read
against itself under sensor noise) and more than 2 in 100.

| Rule | What it requires of each cell |
|---|---|
| G0, calibration | A run of the reference read against itself is flagged on at most 2 in 100 of its windows |
| G1, detection | The coarsest rung of the ladder is detected |
| A1, order | Among the detected rungs, the size falls at every step toward the reference, and no rung that is not detected lies coarser than one that is |
| N0, no causal tie | On `cart_pole`, which has no contact, no rung of ladder C is detected |

Known before the run and written down: the shipped iteration limit is 4, `cart_pole` has no contact, and a
reference with a limit of 200 is a limit and not a guarantee of convergence.

## The result

### 1. What SuperDex's solver reports about itself

This needs no instrument. SuperDex gives every solver step a status; `stopped` is its status for a step that "met
at least one stopping criterion without converging to the requested tolerance". Under seeded random actions, at the
shipped settings (backward Euler, at most 4 iterations a step):

| Scene | Solver steps | Stopped without converging | Share |
|---|---|---|---|
| cart_pole | 21,600 | 22 | 0.1% |
| half_cheetah | 21,600 | 19,350 | 89.6% |
| ant | 21,600 | 17,089 | 79.1% |

No step in any of the 45 sources diverged. Raising the limit to 200 leaves 20.5% of `half_cheetah` steps and 11.7%
of `ant` steps stopped, and the fine-step reference (BDF2 at 1/16 step) stops on 92% of steps on `cart_pole` and on
all but a handful on the other two. So the references used below are more accurate settings of SuperDex, not
converged solutions. Details:
[validation/run_001_counts](../../validation/run_001_counts/).

### 2. What the instrument read at the shipped settings

Each cell: the share of windows the instrument flagged for the shipped setting against that ladder's reference,
and the mean difference in the recorded joint over those windows. The ranges are over the three folds.

| Scene | Iteration limit 4 (against 200) | Shipped time step (against BDF2 at 1/16 step) | 5 mm contact smoothing (against 0.625 mm) |
|---|---|---|---|
| cart_pole | 2% to 8% flagged; 0.01 to 0.06 degrees | 96% to 99%; 0.6 to 0.9 degrees | no contact in this scene: byte-identical |
| half_cheetah | 94% to 98%; 2.1 to 2.7 degrees | 99% to 100%; 2.2 to 2.5 degrees | 68% to 81%; 0.13 to 0.16 degrees |
| ant | 50% to 62%; 0.8 to 1.0 degrees | 89% to 99%; 1.3 to 1.6 degrees | 28% to 45%; 0.3 to 0.9 degrees |

The same reference against itself, under the same sensor noise, was flagged on 0.4%, 0.7% and 2.1% of windows.

The degrees are derived from the instrument's size (size / flagged readings); differences that change sign inside
a window partly cancel, so they understate. Each column is against its own reference, which is another SuperDex
setting and not ground truth, so the columns are not one scale.

### 3. The ladders

- **Solver convergence: in order in all 9 cells.** On `half_cheetah`, limits 1, 2, 4, 8 and 16 read 33.1M, 32.3M,
  17.4M, 2.35M and 0.28M counts in fold 0, with 98%, 97%, 94%, 76% and 23% of windows flagged. On `cart_pole`,
  limits 8 and 16 are byte-identical to 200: the solver never needs more than 7 iterations there.
- **Time integration: in order on `half_cheetah` and `ant` in every fold; on `cart_pole` in fold 0 only.** Halving the backward
  Euler step three times closes little of the distance to the fine-step BDF2 reference on `half_cheetah`: 2.2 to
  2.5 degrees at the shipped step, 1.6 to 2.0 degrees at 1/8 step.
- **Contact compliance: in order on `half_cheetah` in every fold, and on `ant` in two of three.** On
  `half_cheetah` the size falls 1.52M, 0.86M, 0.44M, 0.13M as the smoothing distance halves (fold 0).
- **Beside the ladders.** BDF2 at the shipped step is what the documentation recommends "for scenarios where
  quantitative accuracy is desired". Against the fine-step BDF2 reference it reads farther away than the shipped
  backward Euler source on `cart_pole` (every window flagged, 6.5 to 10.8 degrees, 8 to 14 times the shipped
  source's size) and on `ant`, and nearer on `half_cheetah`. The reference's own convergence (part 1) limits what
  this says.

Every reading, by scene, ladder and fold: [validation/run_002_instrument](../../validation/run_002_instrument/).

### 4. Why the registered claim was not met

| Registered check | Held | Where it fired |
|---|---|---|
| Calibration: the reference against itself flags at most 2 in 100 windows | 18 of 27 cells | every cell of one fold: 2.10% |
| Detection: the coarsest rung of each ladder is detected (flagged on more windows than run C and more than 2 in 100) | 24 of 24 | nowhere |
| Order: nearer the reference, smaller the size, and no rung that is not detected coarser than one that is | 21 of 24 | `cart_pole` time integration (two folds); `ant` contact (one fold) |
| Control: a setting that cannot matter reads nothing | 3 of 3 | nowhere, but the control was empty |

- **Calibration.** The calibration reading does not depend on the scene: one noisy run of a reference minus another
  leaves only the simulated sensor noise, which was seeded the same way everywhere. The 27 cells therefore share three
  calibration readings, and one of the three was 7 windows over the bound. That is a weakness of this design, and it
  is counted as registered: against all nine cells of that fold.
- **Order on `cart_pole`.** In one fold the 1/4 and 1/8 step sources read farther from the reference than the
  shipped step, and 13 to 17 times larger than the same sources read in another fold. Either a few episodes part
  completely on this unstable scene, a risk the pre-registration named, or the reference is not converged (92% of
  its steps stop). This run does not separate the two.
- **Order on `ant` contact.** In one fold the shipped 5 mm rung reads below the two finer rungs.
- **The control.** On `cart_pole` the contact setting changes nothing at all: all four rungs are byte-identical to
  the reference. The check held by construction and tested nothing.

### Limits

Simulation against simulation: one engine against its own settings, and no reference here is a converged solution
by the solver's own tolerance. One sensor channel a scene. Sources replayed in step. The sensor noise is simulated.
Three standard control benchmarks under random actions, not dexterous manipulation. Nothing here is simulation
against a real machine.

### What a second registration would change

Calibration readings that are independent for every scene and ladder. A reference shown to converge before it is
used as one. Where in an episode two sources part, read before how far, so that a parting on an unstable scene is
told from a steady difference. A control whose streams differ.

## What it led to

The study did not hold in full. Calibration failed in one fold, and its 27 calibration readings were really 3, a
weakness of its design. Order failed in three cells: on `cart_pole` this run does not separate a few episodes
parting on an unstable scene from a reference that had not converged, and on `ant`'s contact ladder it gives no
cause. Nothing was re-run. [Study 2](02-independent-calibration.md) is the design with those weaknesses removed,
with independent calibration readings and references shown to converge, under a registration of its own.

One finding stood on its own, with no instrument involved: as shipped, SuperDex's solver stops without converging on
nine steps in ten of `half_cheetah` and eight in ten of `ant`.
