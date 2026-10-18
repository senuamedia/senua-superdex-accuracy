# Study 2: the same question, with independent calibration and converged references

| | |
|---|---|
| Registration | Second: [PREREGISTRATION_02.md](../../preregistrations/PREREGISTRATION_02.md) |
| Question | With the first study's two design weaknesses removed, can SuperDex's accuracy settings be read in order? |
| Outcome | Did not hold in full: 25 of 36 cells. Calibration, detection and the solver's reference held. The finest time-step and contact settings are out of order |
| Registered | 13 October 2026, before any stream of this registration existed |
| Result | [Run 005](../../validation/run_005_instrument/README.md), 13 October 2026 |
| Runs | [003, design probes](../../validation/run_003_design_probes/), [004, calibration and counts](../../validation/run_004_counts/), [005, the reading](../../validation/run_005_instrument/) |
| Data | [`streams/02/`](../../streams/02/) (63 encoder streams), [`actions/02/`](../../actions/02/) |
| Played by | [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp), [`tools/plays/play_02.sh`](../../tools/plays/play_02.sh) |
| Measured by | [`measure/instrument/sx_settings2.sx`](../../measure/instrument/sx_settings2.sx), `sx_run2.sh` |

Previous: [Study 1](01-accuracy-settings.md). Next: [Study 3](03-whose-failure.md). All studies: [index](README.md).

## Why it was asked

Study 1 did not hold in full. Its registration names two weaknesses of its design, which this one removes. (Of
Study 1's order failures, its run does not attribute the one on `cart_pole` to either, and gives no cause for the
one on `ant`'s contact.)

1. **Its 27 calibration readings were 3.** A calibration reading is one noisy run of a reference minus another. The
   reference cancels and only the sensor noise is left, and that noise was seeded the same way in every cell.
2. **Its references were not converged.** The fine-step reference ended `stopped` on 92% to 100% of its solver
   steps.

## What SuperDex offers for accuracy

Read from the source at v1.0.0. Study 1 used three of these ten.

| Setting | Shipped | More accurate |
|---|---|---|
| Arithmetic precision (build option `MOCHI_USE_DOUBLE_PRECISION`) | 32-bit | 64-bit |
| Solver stop on a small update (`relStepTol`) | 10 times machine precision | Follows the precision; 0 switches it off |
| Solver tolerances (`absTol`, `relTol`) | 1e-3, 1e-6 | Smaller |
| Solver iteration limit (`maxIter`) | 4 | Larger |
| Linear solve (`linearToleranceStrategy`, `solverType`) | Inexact, automatic | Constant tolerance; direct |
| Time integrator (`integrationMethod`) | Backward Euler | BDF2; also BDF3, three DIRK methods, two symplectic |
| Time step | 10 or 20 ms | Smaller |
| Contact (`penaltySmoothingHalfDistance`, `penaltyCoefficient`) | 5 mm, 1e9 | Sharper, stiffer |
| Friction (`frictionFalloffVel`, the friction smoothing) | 0.01 m/s | Smaller |
| Fitted derivatives in saturation terms (`fittedSaturationHessian`) | On | Off, exact |

The decisive one is the first. In 32-bit arithmetic the solver stops as soon as an update is smaller than about a
millionth of the state, which is why Study 1's fine-step sources were `stopped`.

## What the design probes showed

Six episodes a scene on commands that are not the registered ones, with no instrument
([run 003](../../validation/run_003_design_probes/)).

- **64-bit arithmetic makes the solves converge.** Backward Euler at the shipped step with the limit at 200:
  `stopped` on 0 of 1,200 steps on `cart_pole`, 0 on `half_cheetah` and 11 on `ant`.
- **The iteration limit saturates.** A limit of 1,000 gives a stream byte-identical to a limit of 200 on all three
  scenes.
- **The time step does not.** Successive refinements keep differing: BDF2 at 1/16 of the shipped step against 1/32
  by up to 45 encoder counts on `cart_pole`, 553 on `half_cheetah` and 272 on `ant`.
- **Nor does contact smoothing.** 0.625 mm against 0.3125 mm differs by up to 6 counts on `half_cheetah` and 101 on
  `ant`.

So a time reference and a contact reference do not exist on these scenes, and the design had to stop pretending
they did.

## What was played

The scenes, the sensor and the form of the commands are as in Study 1, with fresh seeds. There are 21 sources a
scene, 63 in all, played in 64-bit unless said.

| Source | Settings |
|---|---|
| `ship32` | The 32-bit build, backward Euler, iteration limit 4: SuperDex as shipped |
| `s1 s2 s4 s8 s16` | Backward Euler, limit 1, 2, 4, 8, 16 |
| `sref`, `sref2` | Backward Euler, limit 200; limit 1,000 |
| `nref` | As `sref`, with exact derivatives |
| `tight` | As `sref`, with solver tolerances a thousand times smaller |
| `t2 t4 t8 t16` | Backward Euler, limit 200, at 1/2, 1/4, 1/8 and 1/16 of the shipped step |
| `b16`, `b32` | BDF2, limit 200, at 1/16 and 1/32 |
| `c10 c2 c1 c06 c03` | As `sref` with smoothing 10, 2.5, 1.25, 0.625 and 0.3125 mm (`sref` is 5 mm) |

## How it was read

- **Independent calibration.** Every noisy run is drawn from its own stretch of one random sequence, and
  calibration is judged once, pooled.
- **A measured detection bar.** Before registration, a preliminary run of calibration readings on noise alone, set
  for 810 and stopped at 405 by a CPU-time cap, showed that single readings scatter from 0% to 5% of windows flagged,
  and put the bar at 222 of the 6,084 windows of a reading. The registered stage 0, recorded in
  [run 004](../../validation/run_004_counts/) after the rules were committed and before any stream was read, is 810
  readings on noise alone. The bar is the level that at most 1 in 100 of them exceed: 219 of 6,084 windows.
- **A reference only where one exists.** Solver convergence is read against a reference, because the iteration
  limit saturates. The time step and the contact smoothing are read as chains: each setting against the next finer
  one, with no source called a reference.
- **A control whose streams differ.** Exact against fitted derivatives differ on a few readings in a hundred, for no
  reason that should matter. In the design probe they never differed by more than one count. On the registered
  streams ([run 004](../../validation/run_004_counts/)) they differ by more than one count on 69 readings of
  `half_cheetah` (largest 6) and on 123 of `ant` (largest 58).

| Cell | Form | Decided by |
|---|---|---|
| S, solver convergence | A ladder: `s1` to `s16` against `sref`, with `sref2` as a refined reference | G1, A1, R0 |
| T, time step | A chain: `sref`, `t2`, `t4`, `t8`, `t16` (four gaps) | G1, A1 |
| C, contact smoothing | A chain: `c10`, `sref`, `c2`, `c1`, `c06`, `c03` (five gaps) | G1, A1 |
| N, no causal tie | `nref` against `sref` | N0 |

Three scenes and three folds make 36 cells.

## The rules fixed in advance

| Rule | What it requires |
|---|---|
| G0, calibration, once | Pooled over every calibration reading, at most 2 in 100 windows are flagged |
| G1, detection | The coarsest rung or gap that is not identical is detected |
| A1, order | Among the detected rungs or gaps the size falls at every step toward the fine end, and none that is not detected lies coarser than one that is |
| R0, the reference | `sref2` is identical to `sref` or is not detected against it |
| N0, no causal tie | `nref` is not detected against `sref` |

A risk written down before the run: a chain may not be in order where refinement does not converge, and that would
be a finding about the scene and the engine as much as about the instrument.

## The result

### 1. What SuperDex's solver reports about itself

Steps that ended `stopped`, without converging to tolerance, under seeded random actions:

| Source | cart_pole | half_cheetah | ant |
|---|---|---|---|
| SuperDex as shipped (32-bit, at most 4 iterations) | 21 of 21,600 | 19,267 (89.2%) | 17,125 (79.3%) |
| 64-bit, at most 200 iterations | 0 | 0 | 237 (1.1%) |
| 64-bit, at most 1,000 iterations | 0 | 0 | 226 (1.0%) |

No step in any source diverged. Details: [validation/run_004_counts](../../validation/run_004_counts/).

### 2. What held

- **Calibration:** 1.23% of windows flagged, pooled over 84 independent readings (bound: 2 in 100).
- **Detection:** the coarse end of every ladder and chain was detected, 24 of 24 cells.
- **The solver's reference:** five times the iterations was byte-identical to it on two scenes and not detected
  against it on `ant`, 9 of 9 cells.
- **Solver convergence in order:** 8 of 9 cells. On `half_cheetah`, limits 1, 2, 4, 8 and 16 read 34.1M, 29.2M,
  18.8M, 2.81M and 0.26M counts in fold 0.
- **The time step converges on `cart_pole` and `ant`:** every halving changes the motion less than the one before,
  in every fold. On `cart_pole` each gap is about half the one before: 2.16M, 1.11M, 0.57M, 0.29M in fold 0.

### 3. What did not hold

- **The time step on `half_cheetah` does not converge, in all three folds.** The second halving changes the motion
  less than the first, in every fold; from the third on, each further halving changes it more, not less: 4.39M,
  3.59M, 4.86M, 7.16M in fold 0. The raw streams show the same
  without the instrument: the largest difference of those four gaps is 351, 325, 440 and 504 counts.
- **Contact smoothing stops converging below about 1 mm, on both contact scenes, in every fold.** On
  `half_cheetah` the first four gaps fall three times in a row and then the last halving (0.625 to 0.3125 mm)
  changes slightly more than the one before. On `ant` they are irregular below 1.25 mm. These sharper settings are also where the
  solver starts to stop short again.
- **One solver-convergence cell on `ant`**, where the limit 16 rung reads larger than limit 8 in one fold.
- **The control, once.** Exact against fitted derivatives was detected in one of six cells: 237 windows against the
  bar of 219, on streams that do differ slightly there.

### 4. What each shipped setting costs, one change at a time

Size of the change in encoder counts (16,384 a turn), folds 0 / 1 / 2. A value in brackets was not detected.

| One change, everything else held | cart_pole | half_cheetah | ant |
|---|---|---|---|
| 32-bit to 64-bit arithmetic | not detected | 22.6k / 121.1k / (5.3k) | 3.68M / 2.75M / 1.58M |
| Iteration limit 4 to 200 | 27.4k / (1.8k) / (18.3k) | 18.84M / 18.07M / 20.55M | 3.85M / 3.24M / 2.05M |
| Time step, shipped to half | 2.16M / 3.06M / 1.58M | 4.39M / 4.18M / 4.03M | 8.49M / 7.82M / 8.62M |
| Contact smoothing, 5 mm to 2.5 mm | no contact | 483k / 459k / 458k | 1.27M / 1.19M / 652k |

On `half_cheetah` the iteration limit is the largest single cost: with it at the shipped 4, 98% of windows are
flagged, at about 2 degrees of the recorded joint a reading. On `ant` the time step is the largest and arithmetic
precision is comparable to the iteration limit. On `cart_pole` only the time step matters.

Every reading: [validation/run_005_instrument](../../validation/run_005_instrument/).

### Limits

Simulation against simulation: one engine against its own settings, with no ground truth. A chain reads how much
the next refinement changes the motion, not how wrong the motion is. One sensor channel a scene. Sources replayed
in step. The sensor noise is simulated. Three standard control benchmarks under random actions, not dexterous
manipulation. Nothing here is simulation against a real machine.

## What it led to

With the design weaknesses gone, the order failures were left: on `half_cheetah`, from the third halving on, halving
the time step changes the motion more, not less, and the same happens to contact smoothing below about 1 mm. For the
time step, run 004's raw streams show it with no instrument: the largest difference of the four gaps is 351, 325,
440 and 504 counts. For contact smoothing they do not: on `half_cheetah` the largest difference falls at every step
(98, 91, 57, 38 and 32 counts). The plain subtraction of this study's streams, made later in Study 3's design probe
([run 006](../../validation/run_006_design_probes/), `old_streams.txt`), shows the contact disorder with no
instrument: on `half_cheetah` in fold 0 the last gap is larger than the one before (202,130 then 223,540).

That left a question the study could not answer. Was the disorder the instrument's, the rig's, the scene's or the
engine's? [Study 3](03-whose-failure.md) was registered to find out.
