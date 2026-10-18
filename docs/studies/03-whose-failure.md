# Study 3: whose failure is it

| | |
|---|---|
| Registration | Third: [PREREGISTRATION_03.md](../../preregistrations/PREREGISTRATION_03.md) |
| Question | Study 2's settings came out of order. Is that the instrument's doing, the rig's, the scene's or the engine's? |
| Outcome | Five rules of six held. The instrument orders every gap as plain subtraction does (I0, I1), the rig repeats exactly (R1), the scenes do not amplify a tiny change (N1), and `half_cheetah` with the ground is out of order (E1). R2, the rig's stepping, fired on `cart_pole` in one fold, so the registered conclusion that the failure belongs to ground contact did not fire |
| Registered | 13 October 2026, before any stream of this registration existed |
| Result | [Run 008](../../validation/run_008_instrument/README.md), 13 October 2026 |
| Runs | [006, design probes](../../validation/run_006_design_probes/), [007, stage 1 with no instrument](../../validation/run_007_counts/), [008, the instrument beside plain subtraction](../../validation/run_008_instrument/) |
| Data | [`streams/03/`](../../streams/03/) (84 encoder streams), [`actions/03/`](../../actions/03/) |
| Played by | [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp), [`tools/plays/play_03.sh`](../../tools/plays/play_03.sh) |
| Measured by | [`measure/instrument/sx_settings3.sx`](../../measure/instrument/sx_settings3.sx), `sx_count3.sh`, `sx_run3.sh` |

Previous: [Study 2](02-independent-calibration.md). Next: [Study 4](04-one-cube-and-the-ground.md). All studies:
[index](README.md).

## Why it was asked

Study 2 failed in 11 cells, and ten of those were failures of order. It had predicted that every step toward a
finer setting changes the motion less than the step before. On `half_cheetah`'s time step, on the sharpest contact
settings and once on `ant`'s solver ladder, that did not happen.

What failed was the prediction. The record did not say whose failure it was, and a reader needs that answered
before the result is of any use. There are four possible owners, and each calls for a different action.

| Owner | What it would mean |
|---|---|
| The instrument (Senua AI's) | SuperDex's output is in order and the instrument misorders it |
| The rig (ours, `tools/sdx_player.cpp`) | The program that drives SuperDex drives it wrongly as the step shrinks |
| The scene | The motion is so sensitive to small changes that no simulator would settle on one trajectory |
| The engine (SuperDex) | Its answer does not settle as its own accuracy setting is refined |

Before the design probes our working guess was the scene. The probes refuted that guess.

## The test behind it

Refinement is the standard check of a numerical solver. For a method of order p, halving the step divides the
difference between successive solutions by 2 to the power p, once the step is small enough (Richardson 1911, Roache
1998, Oberkampf and Roy 2010). Backward Euler is first order, so successive gaps should halve. Seeing the halving is
evidence that the solver and the program driving it are right. Sensitivity to small changes is tested the way
Lorenz did in 1963: make a small known change and follow it in time.

## What was played

Every source is the 64-bit build, backward Euler, iteration limit 200. There are 84 sources.

| Source | Settings | Scenes |
|---|---|---|
| `sref`, `srefb` | The reference, played twice | All three |
| `z` | As `sref` with the nudge set to zero | All three |
| `n9 n6 n3 n0` | As `sref`, with the first command larger by 1e-9, 1e-6, 1e-3 and 1 during the first control step of every episode | All three |
| `t2` to `t64` | At 1/2 to 1/64 of the shipped step | All three |
| `g1` to `g16` | The ground plane left out, at 1 to 1/16 of the shipped step | `half_cheetah`, `ant` |
| `m1` to `m16` | Friction off on every actor, at 1 to 1/16 of the shipped step | `half_cheetah`, `ant` |
| `c10 c2 c1 c06 c03` | Contact smoothing 10, 2.5, 1.25, 0.625, 0.3125 mm | `half_cheetah`, `ant` |
| `s1` to `s16` | Iteration limit 1, 2, 4, 8, 16 | All three |

## What was measured

- **Plain subtraction.** Two noiseless encoder streams are subtracted reading for reading, the difference is summed
  over every window of 32 readings, and the absolute values of those sums are added up. It is arithmetic only: the
  instrument's own size measure with everything else taken away.
- **In order.** The size falls at every step toward the fine end of a list.
- **The instrument's reading** of the same gaps, exactly as in Study 2, with the same detection bar.
- **Parting.** The first reading of an episode at which two streams are more than one count apart.

## The rules fixed in advance, and the owner each one names

| Rule | It holds when | If it fires |
|---|---|---|
| I0, calibration | At most 2 windows in 100 are flagged on noise alone, pooled | The instrument is not calibrated on this run |
| I1, the instrument against arithmetic | In every cell, a list is in order by the instrument exactly when it is in order by plain subtraction, both taken over the gaps the instrument detected | The instrument owns the order |
| R1, the rig repeats | The reference played twice, and with the nudge at zero, is byte-identical on all three scenes | The rig is not deterministic, and nothing else can be read |
| R2, the rig's stepping | With nothing touching the agent from outside, plain subtraction is in order in every fold | The failure is not specific to contact: the rig's stepping, or the engine's dynamics without contact, own it |
| N1, the scene | Nudges of 1e-9 and 1e-6 never part from the reference, in any episode | The scene owns it |
| E1, the failure itself | On `half_cheetah` with the ground, plain subtraction is out of order in every fold | There is nothing to attribute |

Stage 1 decides R1, R2, N1 and E1 with no instrument. Stage 2 is the instrument's one reading, and decides I0 and
I1 over ten lists and three folds: 30 cells.

The registration drew its conclusion only if every rule held: then the time-step order failure belongs to
SuperDex's handling of ground contact under a smaller step, and the contact and solver order failures are present in
SuperDex's output as plain arithmetic, not made by the instrument's reading of it.

It also said what a pass would not mean. It would say where the failure lives. It would not say that
SuperDex's code is wrong: a penalty contact with a regularised friction law has time scales far shorter than the
shipped step, and not converging between 10 ms and 0.16 ms can be the method working as designed at steps too
coarse for its own contact handling.

## The result

| Rule | Result |
|---|---|
| I0, calibration | Held. 12,228 of 894,348 windows flagged on noise alone: 1.37% |
| I1, the instrument orders as arithmetic does | Held. 30 of 30 cells. In 17 both are in order, in 13 both are out of order, in none do they differ |
| R1, the rig repeats | Held. 6 of 6 pairs byte-identical, encoder stream and state file |
| N1, the scenes do not amplify a tiny change | Held. With the first command nudged by 1e-9 or 1e-6, every one of the 21,600 readings is identical to the reference, on all three scenes |
| E1, `half_cheetah` with the ground is out of order | Held. 3 folds of 3 |
| R2, in order with nothing touching the agent | **Fired on `cart_pole`**, in one fold: 2 folds of 3 in order. `half_cheetah` and `ant` without the ground: 3 of 3 each |

### The instrument does not own any order failure

Its sizes are the plain sizes, a little lower where it leaves windows out. Fold 0:

| List | The instrument's sizes | Plain subtraction |
|---|---|---|
| `half_cheetah` time step, with the ground | 4,141,157; 3,198,598; 4,675,196; 8,011,549; 9,909,207; 9,997,846 | 4,144,564; 3,200,618; 4,688,047; 8,051,707; 9,965,728; 10,027,632 |
| `half_cheetah` time step, no ground | 2,680,474; 1,470,160; 776,709; 356,286 | 2,706,016; 1,500,647; 804,733; 411,653 |
| `half_cheetah` contact smoothing | 757,144; 570,909; 340,477; 214,122; 251,786 | 886,501; 617,348; 393,759; 263,567; 314,568 |
| `ant` contact smoothing | 4,295,854; 392,324; 203,026; 375,760; 99,713 | 4,556,465; 520,932; 261,202; 443,497; 165,720 |

### On `half_cheetah`, with the ground and without it

Plain subtraction over each fold's 36 test episodes, from the coarsest gap to the finest (step 1 to 1/2, 1/2 to
1/4, 1/4 to 1/8, 1/8 to 1/16):

| Chain | Fold 0 | Fold 1 | Fold 2 |
|---|---|---|---|
| `half_cheetah` with the ground | 4,144,564; 3,200,618; 4,688,047; 8,051,707 | 4,266,572; 3,388,408; 4,711,505; 7,035,001 | 3,504,062; 3,053,908; 3,415,118; 5,662,877 |
| `half_cheetah` without the ground | 2,706,016; 1,500,647; 804,733; 411,653 | 2,499,612; 1,385,238; 742,798; 381,279 | 2,338,801; 1,311,616; 688,374; 355,058 |
| `ant` with the ground | 8,773,448; 4,265,563; 2,504,577; 1,609,182 | 10,374,235; 4,933,983; 2,910,289; 1,666,059 | 11,813,878; 6,702,443; 3,747,664; 2,987,318 |
| `ant` without the ground | 7,763,092; 3,518,317; 1,959,527; 1,240,413 | 8,578,761; 4,533,357; 2,710,896; 1,229,790 | 9,719,125; 6,006,797; 2,488,569; 1,786,433 |
| `cart_pole` (no ground, no contact) | 2,189,682; 1,108,814; 562,389; 310,285 | 31,102,509; 1,383,158; 655,841; 294,097 | 12,109,368; 22,562,429; 1,015,323; 413,291 |

Without the ground each gap on `half_cheetah` is a little over half the one before, in every fold. With the ground
the finest gap is the largest, in every fold. The commands, the rig and the stepping are the same in the two chains;
only the ground plane differs. That is what was measured. The registration would have attributed the failure to
ground contact only if every rule held, and R2 did not.

By part of the episode, for the first ten readings the two chains are the same to within two counts, because the
ground plays no part yet. After that the chain without the ground keeps halving and the chain with the ground
stops. Out to 1/64 of the shipped step its gaps do not fall back: the gap from 1/32 to 1/64 is larger than the one
before it in folds 0 and 2, and in fold 1 it is 2% smaller (8,822,762 then 8,673,072), nowhere near half.

### The solver's own status

No step in any of the 84 sources diverged. Steps that ended `stopped`, of 21,600 at the shipped step:

| Source | `cart_pole` | `half_cheetah` | `ant` |
|---|---|---|---|
| `sref` | 0 | 3 | 228 |
| `g1` to `g16`, no ground | Not played | 0 | 0 |
| `m1` to `m16`, friction off | Not played | 0 | 0 |
| `c10 c2 c1 c06 c03` | Not played | 2, 2, 12, 33, 85 | 116, 333, 370, 434, 430 |
| `s1 s2 s4 s8 s16`, iteration limit 1 to 16 | 4,103; 328; 28; 0; 0 | 21,587; 20,054; 18,640; 10,346; 3,135 | 21,600; 20,671; 17,041; 4,022; 760 |

At the iteration limit of 200, every solve converges without the ground and with friction off; the steps that stop
are on the ground with friction on, and more of them stop as the contact is made sharper. At the low iteration
limits steps stop with no ground as well: `cart_pole`, which has none, stops on 4,103, 328 and 28 steps at limits 1,
2 and 4 ([run 007](../../validation/run_007_counts/), `stats_cart_pole.txt`).

### The rule that fired

On `cart_pole`, in one fold, the gap between the 10 ms and 5 ms steps is larger than the gap between 20 ms and
10 ms. Read from run 007's streams after the run: the pole ends every episode resting on one of its joint limits,
and in two or three of 108 episodes the coarsest steps put it on the opposite limit from the finer steps. The
registration named this risk before the run, and the verdict is recorded as a fail.

## What it settled, and what it led to

- The instrument does not own any order failure: it ordered every gap as plain subtraction does, in 30 cells of 30,
  with its calibration held.
- The rig repeats exactly, and its nudge at zero changes nothing (R1). The scenes do not carry a tiny change of the
  input to the sensor (N1).
- `half_cheetah` with the ground is out of order in every fold (E1), and the same chain without the ground is in
  order in every fold, as is `ant`'s.
- R2 fired on `cart_pole`, so the rig's stepping is not cleared. By the registration, a fired R2 leaves the rig's
  stepping, or SuperDex's dynamics without contact, as an owner of the failure, and the registered conclusion, that
  the time-step order failure belongs to SuperDex's handling of ground contact, did not fire.

What it left open: whether the rig's stepping or the engine's dynamics without contact own any part of the order
failures, and what in SuperDex's contact, if anything, does it, and whether by design.
[Study 4](04-one-cube-and-the-ground.md) took the question down to one cube and the ground, where the right answer
is known.
