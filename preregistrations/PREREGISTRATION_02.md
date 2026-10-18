# Second pre-registration: independent calibration, and references only where they exist

Registered 13 October 2026, after the first registration ([PREREGISTRATION_01.md](PREREGISTRATION_01.md)) did not hold in
full (16 of 27 cells, [README.md](../README.md)), and after design probes on throwaway actions
([validation/run_003_design_probes](../validation/run_003_design_probes/)). Registered before any stream of this
registration existed and before the instrument had read anything played for it. The instrument is unchanged.

## Why a second registration

The first did not hold for two reasons that were weaknesses of its design.

1. **Its 27 calibration readings were 3.** A calibration reading is one noisy run of a reference minus another. The
   reference cancels and the simulated sensor noise remains, and that noise was seeded the same way in every cell. We
   have since found why seeding each cell differently would not have been enough: the random generator is linear in
   its seed, so two runs whose seeds differ by the same amount differ by the same sequence in every cell.
2. **Its references were not converged.** The fine-step reference ended `stopped` on 92% to 100% of its solver
   steps.

## What SuperDex offers for accuracy

Read from the source at v1.0.0 (`UPSTREAM_COMMIT`). The first registration used three of these.

| Dial | Shipped | More accurate |
|---|---|---|
| Arithmetic precision (build option `MOCHI_USE_DOUBLE_PRECISION`) | 32-bit | 64-bit |
| Solver stop on a small update (`relStepTol`) | 10 x machine precision | follows the precision; 0 switches it off |
| Solver tolerances (`absTol`, `relTol`) | 1e-3, 1e-6 | smaller |
| Solver iteration limit (`maxIter`) | 4 | larger |
| Linear solve (`linearToleranceStrategy`, `solverType`) | inexact, automatic | constant tolerance; direct |
| Time integrator (`integrationMethod`) | backward Euler | BDF2; also BDF3, three DIRK methods, two symplectic |
| Time step | 10 or 20 ms | smaller |
| Contact (`penaltySmoothingHalfDistance`, `penaltyCoefficient`) | 5 mm, 1e9 | sharper, stiffer |
| Friction (`frictionFalloffVel`, friction model) | 0.01 m/s | smaller |
| Fitted derivatives in saturation terms (`fittedSaturationHessian`) | on | off, exact |

In 32-bit arithmetic the solver stops as soon as an update is smaller than about a millionth of the state, which is
why the first registration's fine-step sources were `stopped`. SuperDex's FAQ says to "try double precision or a
smaller time-step size" when solves do not converge
([FAQ](https://projectsuperdex.com/physics/docs/faq/)).

## What the design probes showed

Six episodes a scene on actions that are not the registered ones, no instrument
([validation/run_003_design_probes](../validation/run_003_design_probes/)).

- **64-bit arithmetic makes the solves converge.** Backward Euler at the shipped step with the limit at 200:
  `stopped` on 0 of 1,200 steps on `cart_pole`, 0 on `half_cheetah`, 11 on `ant`. Every finer-step source: none.
- **The iteration limit saturates.** A limit of 1,000 gives a stream byte-identical to a limit of 200 on all three
  scenes.
- **The time step does not.** Successive refinements keep differing: BDF2 at 1/16 of the shipped step against 1/32
  by up to 45 encoder counts on `cart_pole`, 553 on `half_cheetah` and 272 on `ant`, from within the first ten
  readings of an episode. There is no converged time reference on these scenes at this horizon.
- **Nor does contact smoothing.** 0.625 mm against 0.3125 mm differs by up to 6 counts on `half_cheetah` and 101 on
  `ant`.
- **A difference with no causal tie exists.** Exact against fitted derivatives, both converged, differ on a few
  readings in a hundred and never by more than one count.

## What changes from the first registration

1. **Noise.** Every noisy run is drawn in sequence from one state of the generator, so no two runs share a draw.
   Each fold of each cell draws its own runs.
2. **Calibration is decided once, pooled** over every calibration reading of the deciding cells. Each reading is
   printed.
3. **The sources are played in 64-bit arithmetic.** SuperDex as shipped (32-bit) is read against the same settings
   in 64-bit and reported.
4. **A reference only where one exists.** Solver convergence has one, and it is checked: a reference with five
   times the iterations is read against it. Time step and contact smoothing have none, so each is read as a chain:
   every setting against the next finer one, with no source called a reference.
5. **A control whose streams differ:** exact against fitted derivatives.
6. **Fresh commands**, so nothing here was chosen on episodes the instrument has already read.
7. **Detection by a measured bar.** A reading is detected when it exceeds the level that 1 in 100 calibration
   readings on noise alone exceed (stage 0), not when it exceeds one calibration reading and a hand-set 2 in
   100.
8. **Twelve processes.** The instrument's programs are capped in CPU time, so stage 2 runs as twelve
   processes (three scenes by four parts), each drawing its noise from its own stretch of the one sequence.
   A last step pools the twelve into the verdict.

## Scenes, commands, sensor

As the first registration: SuperDex v1.0.0, `cart_pole`, `half_cheetah`, `ant`, each built as its own environment
builds it, starting from the unperturbed pose, one worker thread. 108 episodes a scene of 200 readings. Seeded
random actions over the action range, new seeds, in `actions/02/`. One channel a scene: the recorded joint as a 14-bit
encoder, with a sensor error of -1 .. +1 count added as each stream is read.

## Sources (21 a scene; 64-bit build unless said)

| Source | Settings |
|---|---|
| `ship32` | 32-bit build, backward Euler, iteration limit 4: SuperDex as shipped |
| `s1 s2 s4 s8 s16` | backward Euler, limit 1, 2, 4, 8, 16 |
| `sref`, `sref2` | backward Euler, limit 200; limit 1,000 |
| `nref` | as `sref`, exact derivatives |
| `tight` | as `sref`, solver tolerances a thousand times smaller |
| `t2 t4 t8 t16` | backward Euler, limit 200, at 1/2, 1/4, 1/8 and 1/16 of the shipped step |
| `b16`, `b32` | BDF2, limit 200, at 1/16 and 1/32 |
| `c10 c2 c1 c06 c03` | as `sref` with smoothing 10, 2.5, 1.25, 0.625 and 0.3125 mm (`sref` is 5 mm) |

The exact command line of every source is in `tools/plays/play_02.sh`.

## Cells

Roles by block of 36 episodes as before: fold f declares its normal on one block and reads another.

| Cell | Form | Decided by |
|---|---|---|
| S solver convergence | ladder: `s1 s2 s4 s8 s16` against `sref`; refined reference `sref2` | G1, A1, R0 |
| T time step | chain: `sref`, `t2`, `t4`, `t8`, `t16` (four gaps) | G1, A1 |
| C contact smoothing | chain: `c10`, `sref`, `c2`, `c1`, `c06`, `c03` (five gaps) | G1, A1 |
| N no causal tie | `nref` against `sref` | N0 |

Three scenes, three folds: 36 cells. In a chain, a gap is one source read against the next finer one; its normal is
two noisy runs of the finer source.

Reported, not deciding: `ship32` against `s4` (precision alone); `tight` against `sref` (tolerance); `b16` against
`t16` (second order at the same fine step); `b16` against `b32` (BDF2's own refinement); `ship32` and `sref` against
`t16` (the default against the finest step played).

## Stage 0, before registration: calibration on noise alone

A calibration reading is one noisy run of a reference minus another: the reference cancels and only the
simulated sensor noise remains. On a deterministic engine, calibration therefore says nothing about a scene. It is a
property of the instrument on this noise, and it can be measured before any stream exists.

**Preliminary measurement:** 405 independent readings on noise alone, at the registered geometry
(`validation/run_003_design_probes/null_preliminary.txt`; the run was set for 810 and was stopped at 405 by a
CPU-time cap on the instrument's processes).

- Pooled, 1.17% of windows are flagged: near the instrument's design of 1 in 100.
- Single readings scatter widely: smallest 0, median 1.0% of windows, nine in ten under 2.3%, largest 5.0%.
- **60 of 405 readings (15%) exceed 2 in 100.** The first registration asked every cell's reading to stay under 2
  in 100, and called a source "detected" when it exceeded one calibration reading and 2 in 100. On three
  independent readings that calibration rule fails by chance about four times in ten, and that detection rule
  calls a source with no difference "detected" about one time in seven.

**The registered stage 0:** 810 readings on noise alone, in six processes of 135, each drawing its own stretch of
the one noise sequence. Its summary gives the pooled share, the scatter, and the **detection bar B: the level that
at most 1 in 100 of the 810 readings exceed**, which is the instrument's own false-alarm rate applied to whole
readings. B is a number fixed by this procedure on noise alone; no stream of SuperDex enters it. It is recorded in
`validation/run_004_counts/` before stage 2 runs. The preliminary 405 readings put it at 222 of the 6,084 windows of
a reading (3.6%).

## Stage 1, before the instrument runs: counts only

The rig plays every source. Recorded with no instrument: the solver's own status of every step, the most
iterations, the worst residual and the range of the recorded joint; for the ladder, whether each rung and the
refined reference are byte-identical to the reference and how far apart they are; for each gap of a chain, the
same. A rung identical to its reference leaves the ladder, and a gap whose two streams are identical leaves the
chain. Nothing else about the streams is looked at before stage 2.

## Known before the run

- Everything under "What the design probes showed", on other actions.
- `cart_pole` has no contact. Its contact chain is expected to be empty and its control may be empty; neither is
  asked of `cart_pole` if stage 1 finds it so.
- `ant`'s reference keeps about 1% of its steps `stopped` at any iteration limit.
- The pooled calibration rule is not the first registration's rule, which asked every cell separately. Under the
  pooled rule the first registration's three readings (0.38%, 0.72%, 2.10%) pool to 1.07% and would have held. The
  rule is changed here, before any stream of this registration exists, for the reason stage 0 measures.

## Claim

On the three scenes, with nothing tuned, the instrument (a) is calibrated; (b) detects the coarse end of the
solver-convergence ladder and sizes its rungs in order, against a reference that more iterations do not change; (c)
reads the time-step chain and the contact-smoothing chain in order, each halving changing the motion less than the
one before; and (d) reads nothing where two sources differ without a causal tie.

## Falsifiers

A reading is DETECTED when its flagged windows are more than the bar B of stage 0.

- **G0 calibration, once.** Pooled over every calibration reading of the cells S, T, C and N, the flagged windows
  are at most 2 in 100. More refutes the registration. Calibration reads only the simulated noise, so this checks
  that the run's readings behave as stage 0's.
- **G1 detection, each S, T and C cell.** The coarsest rung not identical to the reference, or the coarsest gap not
  identical, is detected.
- **A1 order, each S, T and C cell.** Among the detected rungs or gaps the size falls at every step toward the fine
  end, and none that is not detected lies coarser than one that is.
- **R0 the reference, each S cell.** `sref2` is identical to `sref` or is not detected against it.
- **N0 no causal tie, each N cell.** `nref` is not detected against `sref`.

Reported, not deciding: every reading; each cell's calibration share; the finest detected rung or gap; the reported
pairs above; and the accuracy budget along single-variable steps (`ship32` to `s4`: precision; `s4` to `sref`:
iterations; `sref` to `t2`: the first halving of the step; `sref` to `c2`: the first halving of the smoothing).

## Risks, stated before the run

- **A chain may not be in order where refinement does not converge.** In the probes a third-order integrator's
  successive gaps on `cart_pole` did not shrink. A1 firing on a chain says the motion is not converging under that
  dial at this horizon on that scene: a finding about the scene and the engine as much as about the instrument.
- **N0 may fire.** Exact against fitted derivatives differ by one count on a few readings in a hundred, and the
  sensor noise is one count. An instrument that resolves a persistent one-count difference would flag it.
- **A chain reads change, not error.** A small gap says the next halving changes little. It does not say the motion
  is right. Nothing here has a ground truth.
- The sharper contact settings stop on a few steps in a hundred on `ant`.

## Limits

Simulation against simulation: one engine against its own settings. One sensor channel a scene. Sources replayed in
step. The sensor noise is simulated. Three standard control benchmarks under random actions, not dexterous
manipulation. Nothing here is simulation against a real machine.

## Decision

G0 holds and every cell holds: the instrument reads SuperDex's accuracy settings on Meta's published scenes, in
order, with nothing tuned, calibrated on independent readings, against a reference only where one exists. Anything
fires: recorded as measured, cell by cell. The instrument is not changed under this registration either way, and
every run is kept.
