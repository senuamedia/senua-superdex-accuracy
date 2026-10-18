# Pre-registration: what SuperDex's accuracy settings cost, on Meta's three published scenes

Registered 13 October 2026, before the rig had produced any stream and before the instrument had read anything from
these scenes. Nothing below was changed after the first stream existed; the result is appended to `README.md`, not
written here.

## The question

SuperDex Physics documents where it trades accuracy for stability, and each trade is a setting:

- **Solver convergence.** When the nonlinear solver reaches its iteration limit, the default is "to continue to the
  next time integration step", because "speed and robustness must be prioritized over absolute accuracy"
  ([Solvers](https://projectsuperdex.com/physics/docs/concepts/solvers/#newtons-method)). The shipped limit is 4
  (`NonLinearSolverParams::maxIter`).
- **Time integration.** The default integrator "provides maximum stability", and the "heavy numerical dissipation
  from backward Euler can compensate for incomplete specification of physical dissipation mechanisms"; for
  "scenarios where quantitative accuracy is desired, BDF2 is recommended"
  ([Dynamics](https://projectsuperdex.com/physics/docs/concepts/dynamics/#comparison-and-recommendations)).
- **Contact compliance.** Contact "allows for some interpenetration of colliding bodies"
  ([Contact](https://projectsuperdex.com/physics/docs/concepts/contact/)); the penalty is smoothed over a
  half-distance of 5 mm by default.

SuperDex is deterministic "within a given build"
([FAQ](https://projectsuperdex.com/physics/docs/faq/#is-superdex-physics-deterministic)), so the same commanded
episode can be played twice under two settings, step for step. How far apart do the two land, where, and in what
order? A fourth trade, friction near rest, was read earlier
([senua-tactile-reflex](https://github.com/senuamedia/senua-tactile-reflex)).

## The scenes

SuperDex v1.0.0 (commit in `UPSTREAM_COMMIT`), `assets/benchmarks/`: `cart_pole`, `half_cheetah`, `ant`, the three
scenes Meta publishes with SuperDex Lab. Each is built the way its own environment builds it
(`superdex_lab/.../benchmarks/*_env.py`, `superdex_python/.../scene_helpers.py`): the published prefab, a +Y ground
plane with default contact parameters for half_cheetah and ant, the environment's rates and force scales, and the
action applied before every simulation step.

| Scene | Simulation / control rate | Actuated degrees of freedom, force per unit action | Action range | Recorded joint |
|---|---|---|---|---|
| cart_pole | 50 Hz / 25 Hz | 0: 100 N | -3 .. 3 | 1 (the pole) |
| half_cheetah | 100 Hz / 20 Hz | 3 .. 8: 120, 90, 60, 120, 60, 30 | -1 .. 1 | 3 |
| ant | 100 Hz / 20 Hz | 6 .. 13: 150 each | -1 .. 1 | 6 |

The recorded joint is the first revolute degree of freedom outside the root joint. Ant's environment also sets the
linear solver's absolute tolerance to 1e-10 and an initial pose (height 0.55, ankles 57.30 degrees); both are kept.

Two departures from the environments, both for determinism: every episode starts from the unperturbed initial pose
at rest (the environments add reset noise of scale 0.1), and one worker thread is used.

## The commands

Seeded random actions, uniform over the action range, one per actuated degree of freedom per control step: what
`action_space.sample()` gives a new policy. They are in `actions/01/` as integers in -32767 .. 32767 and are played
unchanged into every source of a scene. 108 episodes a scene, each 200 readings (cart_pole 100 control steps, 4 s;
the others 40 control steps, 2 s).

## The sensor

One channel a scene: the recorded joint as a 14-bit absolute encoder, 16,384 counts a turn, read at every shipped
simulation step. The rig's streams carry no noise. A sensor error of -1 .. +1 count, seeded, is added as each stream
is read: a reference three times (runs A, B and C), every other source once.

## The settings: three ladders, one variable each

Shipped: backward Euler, iteration limit 4, one solver step a simulation step, smoothing half-distance 5 mm.

| Ladder | The variable | Rungs, coarse to fine | Its reference | Held fixed |
|---|---|---|---|---|
| S solver convergence | iteration limit | 1, 2, 4 (shipped), 8, 16 | limit 200 | backward Euler, shipped step, shipped contact |
| T time integration | backward Euler step | shipped, /2, /4, /8 | BDF2 at shipped / 16 | limit 200, shipped contact |
| C contact compliance | smoothing half-distance | 10, 5 (shipped), 2.5, 1.25 mm | 0.625 mm | backward Euler, shipped step, limit 200 |

Sub-stepped sources are read at the shipped simulation rate, so every source has the same 200 readings an episode.
Reported beside the ladders, not on them: BDF2 at the shipped step (the documentation's recommendation) and the
shipped source, each read against T's reference.

## The instrument

Senua AI's gap instrument, unchanged from its validation on a test world with known faults. It reads the difference
between a source and the reference at the same step of the same episode. The normal it is read against is the
difference between two runs of the reference under sensor noise (B minus A); no tolerance is set by hand. It
reports, per window of 32 readings, a flag at a designed false-alarm rate of 1 in 100, and a size: the gated
magnitude, the summed absolute difference over the flagged windows, in encoder counts.

Roles by block of 36 episodes (7,200 readings): fold f declares its normal on block (f + 1) mod 3 and reads block
(f + 2) mod 3. A cell is one scene, one ladder, one fold: 27 cells.

The engine is proprietary. Its readings are published here as records, with every stream it read.

## Stage 1, before the instrument runs: counts only

The rig plays every source. Recorded with no instrument: readings, solver steps, steps that did not converge, the
most iterations used, the recorded joint's range, and for each rung whether its stream is byte-identical to its
ladder's reference. A rung identical to its reference is the reference: it leaves the ladder and is reported as
such. Nothing else about the streams is looked at before stage 2.

## Known before the run

- The shipped iteration limit is 4, and a step that reaches it is kept (read from the source).
- cart_pole has no contact: its links have collider type None and its environment adds no ground plane. Ladder C on
  cart_pole can change nothing. It is the control with no causal tie.
- Backward Euler is first order and damps; BDF2 is second order.
- half_cheetah and ant under random actions are contact-rich and sensitive: two settings can part quickly.

## Claim

On each of the three scenes the instrument (a) does not flag a reference against itself, (b) flags the coarse end of
each accuracy ladder, (c) sizes the rungs in order, nearer the reference meaning a smaller gap, and (d) reads nothing
on the ladder that cannot matter.

## Falsifiers (each cell separately)

A rung is DETECTED when its flagged windows are more than run C's and more than 2 in 100.

- **G0 calibration.** Run C of the ladder's reference flags at most 2 in 100 of its windows.
- **G1 detection.** The coarsest rung of the ladder is detected. (Not asked of ladder C on cart_pole, nor of a
  ladder that stage 1 leaves empty.)
- **A1 order.** Among the detected rungs the gated magnitude falls at every step toward the reference, and no rung
  that is not detected lies coarser than one that is. One step that does not fall, or one such rung, refutes for
  the cell.
- **N0 no causal tie (ladder C on cart_pole only).** No rung is detected.

Reported, not deciding: every rung's flagged windows and magnitude; the finest detected rung of each ladder; the
shipped rung's magnitude on each ladder (the accuracy budget: which shipped trade costs most on each scene); the two
sources beside the ladders.

## Risks, stated before the run

- **Divergence may saturate the size.** If two settings part early in an episode, the difference is bounded by the
  joint's limits, coarse rungs may read the same size, and A1 fires.
- **Fine rungs may sit under the sensor's resolution.** A1 is asked only of detected rungs for this reason, decided
  here and not after the data.
- **A reference may not be converged.** Limit 200 is a limit, not a guarantee; the count of unconverged steps of
  every reference is recorded in stage 1 and reported with the result.
- **BDF2 on scenes damped for backward Euler** may ring. It is still the more accurate solution of the model as
  written.

## Limits

Simulation against simulation: one engine against its own settings. One sensor channel a scene. Sources replayed in
step. The sensor noise is simulated. Three standard control benchmarks, not dexterous manipulation. Nothing here is
simulation against a real machine.

## Decision

Every cell holds: the instrument reads SuperDex's own accuracy settings, in order, on Meta's published scenes, with
nothing tuned. A cell fires: recorded for that cell as measured. The instrument is not changed under this
registration either way, and every run is kept.
