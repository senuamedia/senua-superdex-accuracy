# Fifth pre-registration: the patches

Registered 14 October 2026, after the fourth registration ([PREREGISTRATION_04.md](PREREGISTRATION_04.md),
[run 010](../validation/run_010_contact/)) isolated the cause on one cube, and after design probes with four builds
of the patch ([validation/run_012_design_probes](../validation/run_012_design_probes/)). Registered before any run of
this registration existed.

## The question

The fourth registration showed what in SuperDex's shipped contact is wrong against a known right answer. This one
asks, for each correction we propose: does stock fail a test with a right answer, does the correction make it pass,
does it leave everything else alone, is SuperDex's output untouched when it is off, and does SuperDex's solver keep
converging when it is on. A patch that does not meet all of these is not proposed.

## What is proposed

| | What it does | How it is switched on |
|---|---|---|
| Setting | Gives the contact a loss of its own: SuperDex's `normalViscousDampingCoefficient` at 5 (shipped: 0) | The scene's contact parameters |
| Patch A | Friction on the full normal force. With contact damping on, friction is proportional to the penalty part plus the damping part | `SUPERDEX_FRICTION_FULL_NORMAL=1` |
| Patch B | Contact damping that cannot pull. The damping part can cancel the penalty force of the step and no more | `SUPERDEX_DAMPING_UNILATERAL=1` |
| Patch C | Anchored Coulomb friction: a contact holds at rest within a stick distance (our patch of 26 September), at 300 micrometres here | `SUPERDEX_STICK_DISTANCE=0.0003` |

**The recommended configuration** is all four, with SuperDex's shipped start-of-step normal force.

The setting is SuperDex's own and needs no patch. The three patches are in one file,
[`patches/senua_contact.patch`](../patches/senua_contact.patch), against v1.0.0. It only adds lines: the shipped
contact kernel is left exactly as it is, the corrected kernel is a separate copy, and the library calls the copy
only when a switch is set.

**Not recommended with contact damping: SuperDex's `implicitNormalForceForDissipation`.** It gives Coulomb's law
exactly over an impact (fourth registration). It is tested here and reported alongside the recommended
configuration. It is left out of the recommendation because of what the probes showed about the solver.

## Why each one

- **The setting.** With no loss of its own, the contact's bounce is decided by the time step (fourth registration).
  SuperDex's own test of the bounce sets this coefficient, with a second-order integrator and a 0.1 ms step. The
  benchmark scenes leave it at zero and run at 10 ms.
- **Patch A.** Coulomb's law is on the whole normal force. SuperDex computes friction from the penalty part alone.
  Once contact damping is on, friction is short while a body is pressed in and too large while it settles.
- **Patch B.** A contact pushes and never pulls. SuperDex's damping term multiplies the penalty force by one minus
  the coefficient times the leaving speed, and nothing stops that factor going below zero. A body that leaves
  faster than one over the coefficient is pulled back by the ground.
- **Patch C.** A friction law that depends on slip speed alone is zero at rest, so it cannot hold a load. An
  anchored law holds it with a small elastic displacement.

## What the design probes showed

On the fourth registration's cube and on throwaway actions
([validation/run_012_design_probes](../validation/run_012_design_probes/)).

- **The first build of the patch was not identical to stock with its switches off.** One benchmark stream of ten
  differed in 3 of 21,600 readings by one count. SuperDex is compiled with `-ffp-contract=fast`, so editing its
  kernel changes the rounding even where the logic is unchanged. The patch was restructured to add lines only.
  Whether that restores identity on the benchmark is rule S0 below, and it is not known.
- **The shipped friction's shortfall at an impact is a one-step delay.** Over the impact alone it delivers 55% to
  90% of what Coulomb's law requires. Over the impact and the 0.1 s after it, it delivers 96% at the shipped step
  and all of it from 1/8 of the step on.
- **With contact damping on stock code, friction is too much.** Over the impact and the 0.1 s after it, 5% to 27%
  more than Coulomb's law allows. Patch A brings it back to the one-step delay.
- **With contact damping on stock code, the ground pulls.** A 2 kg cube was pulled with 12.9 N when lifted and
  335 N on a fast rebound. Patch B as first written stopped that only with the implicit setting on. Corrected, it
  stops it without, on the fourth registration's cube.
- **The solver.** A stick distance of 10 micrometres leaves 87 of 2,400 steps unconverged on `half_cheetah` at the
  shipped step, and 300 micrometres leaves none. SuperDex's own implicit setting leaves 12 steps unconverged on
  `ant` as soon as there is contact damping, with no patch involved, and with the patches on as well 11 to 20
  steps diverge. Without the implicit setting, damping with all three patches left no step unconverged on either
  scene, where stock leaves 21 on `ant`.
- **The build this registration tests, in the recommended configuration, on throwaway actions:** `half_cheetah`
  has no step unconverged at any of the five steps and needs at most 10 solver iterations, where stock needs 178.
  `ant` has none unconverged at the shipped step, where stock has 21, and one at each finer step. No step
  diverges, and both time-step chains are in order in every part of the episode.

## The suite, registered parameters

One cube and the ground (`tools/contact_suite.sh`). The cube is 0.5 kg with half-size 0.03 m, and none of these
numbers has been used before: dropped 0.12 m; the oblique impact at 3 m/s with friction 0.3; the chain at 1 m/s;
the steady slide at 4 m/s; hold and slip with friction 0.6, which can hold 2.94 N, pushed with 1.764 N and 3.528 N;
lifted with 14.7 N. Steps are 10 ms divided by 1 to 64.

| Test | The right answer | It passes when |
|---|---|---|
| T01 never reaches the ground | Each halving of the step halves the gap | Every gap is 45 to 55 parts in 100 of the one before |
| T02 steady sliding | Friction is the coefficient times the normal force | Within 1 part in 100, at two steps |
| T03 at rest | The ground carries the weight | Mean force within 1 part in 100, at two steps |
| T04 the bounce | The same at every step | Rebounds at the seven steps are within 500 per 10,000 of each other |
| T05 Coulomb over the impact | Friction impulse is the coefficient times the normal impulse | Within 1 part in 100 at all seven steps, and still sliding |
| T06 held below the friction limit | It does not move | Mean speed within 10 micrometres a second of zero, at two steps |
| T07 pushed above it | It accelerates at push minus friction, over mass | Mean speed within 3 parts in 100, at two steps |
| T08 the refinement chain | The gaps fall at every step | They do |
| T09 the ground never pulls | The ground's force is never below zero | Lowest force at or above minus 1 mN, in two lifts and a fast rebound |
| T10 Coulomb over the impact and the 0.1 s after it | Friction impulse is the coefficient times the normal impulse, and never more | Never more than 1 part in 100 above, and within 1 part in 100 at the three finest steps |

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **S0** safe when off | (a) All 39 suite runs are byte-identical between the stock library and the patched library with no switch set. (b) With the patched library and no switch set, each of 38 registered benchmark streams reproduces byte for byte: all 18 of `cart_pole` (third registration); `ant` `sref t2 s4 s16 c10 c2 c1 c06 c03 g1 m1` (third) and `d1 d2` (fourth); `half_cheetah` `sref t2 s1 s16 c03 m1` (third) and `d1` (fourth). The list includes the stream the first build failed on |
| **S1** required | Stock fails T04, T05, T06 and T08 on the new cube. With contact damping 5 on stock code, T09 and T10 fail |
| **S2** correct | The implicit setting alone passes T05. Damping 5 alone passes T04 and T08. Damping with patch A passes T10. Damping with patches A and B passes T09 and T10. Patch C alone passes T06. The recommended configuration passes every test but T05 |
| **S3** nothing else gets worse | Every configuration passes T01, T02, T03 and T07. T09 passes wherever there is no damping or patch B is on. T10 passes wherever there is no damping or patch A is on |
| **B1** the benchmark keeps its order | On fresh commands (seeds 4602 and 4603, 108 episodes), `half_cheetah`'s shipped time-step chain is out of order by plain subtraction in at least one fold, and with the recommended configuration it is in order in all three |
| **B2** the solver keeps converging | With the recommended configuration on the fresh commands, no step diverges at any of the five steps on either scene. At the shipped step, on each scene, the steps that stop without converging are no more than stock's plus 1 in 1,000 of the steps |

Reported, not deciding: every measured line; the recommended configuration with the implicit setting added, on the
suite, and its solver status at the shipped step on the benchmark; `ant`'s chains on the fresh commands; the wall
time of each benchmark source.

## Known risks, stated before the run

- **S0 may fail again.** Even with the shipped kernel's text untouched, the compiler is free to fuse differently.
  If it does, the patch is not safe by this registration's own rule, and that is the result.
- **The build tested here has been run on the fourth registration's cube and on throwaway actions only.** The new
  cube and the fresh commands may differ.
- **The new cube is four times lighter.** Damping 5 may not hold its bounce within 500 per 10,000 across the steps.
  A 300 micrometre stick distance may be too soft to hold it within the tolerance, or to let it slip on time.
- **B1 and B2 are predictions** about a configuration whose benchmark chain has not been played.

## Limits

One cube, one ground. Rigid contact only: the corrected kernel is reached from the rigid and articulated contact
path, and not from point-cloud contact. Contact damping 5 makes impacts nearly dead. A contact that should bounce
needs SuperDex's own calibration of the coefficient, a higher-order integrator and a step near 0.1 ms, as its own
test uses. The recommended configuration leaves friction one step late at an impact. Nothing here is against a real
robot.
