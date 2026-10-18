# Eleventh pre-registration: friction at an impact, given the normal force of the step being solved

Registered 14 October 2026, after design probes on throwaway cubes and throwaway commands
([run 022](../validation/run_022_design_probes/), [run 023](../validation/run_023_design_probes/)). Registered before
any run of this registration existed.

## The question

Every study since the fourth found it: over the step in which a sliding cube lands, SuperDex's friction is short of
Coulomb's law. The recommended configuration passed nine of the contact suite's ten tests and failed that one
(T05). The open list carried it as "friction one step late at the impact itself".

## The cause

Read from SuperDex's source at v1.0.0 (`contact_utils.h`): friction is scaled by the penalty force at the
start-of-step distance. Over the step in which a body lands that distance is still open, so the force friction is
given is zero or small, while the step's own normal impulse is the whole impact. SuperDex's own switch
`implicitNormalForceForDissipation` moves friction and contact damping together to the step's force; with contact
damping on, the damping term's derivative is then incomplete, and the fifth study found that `ant` did not converge
with it.

## The right answer, and where it comes from

While the contact point slides, the tangential impulse is the friction coefficient times the normal impulse, step
by step and in total (Routh's impact process; Stronge, Impact Mechanics, 2000). Incremental potential contact lags
the normal force friction is scaled by to keep the step a minimisation (Li et al., ACM Trans. Graph. 2020); the
price is the step it arrives late.

## The correction (patch F)

Lines added to the Senua contact kernel in `contact_utils.h`
([`patches/senua_contact.patch`](../patches/senua_contact.patch)), off unless `SUPERDEX_FRICTION_STEP_NORMAL` is set:
Coulomb friction takes the whole normal force of the step being solved (the penalty force at the current distance
plus the damping part as it is applied to the body, never below zero); contact damping and viscous friction keep
the start-of-step force, so their derivatives stay exact; and friction's Hessian is SuperDex's own fitted one.

The probes found the last part necessary. With anchored friction's exact Hessian, which is not positive definite
once the normal force moves within the step, `ant` diverged on 4 steps of 21,600; with the fitted Hessian it had no
stopped step and none diverged.

The same patch file carries two changes to anchored friction (patch C) found by reading: its anchors are keyed by
the collider's feature as well as the sample, and an anchor is appended for the contacts SuperDex appends when its
`explicitNormals` switch is on. With no switch set none of it runs.

## The scenes, registered parameters

None of these numbers was used in the probes, except where a rule compares with an earlier registration's files.

**The first contact suite** (`tools/contact_suite.sh`): a cube of 1.4 kg and half-size 0.03 m; dropped from 0.09 m;
the oblique impact at 3 m/s with friction 0.3, so the law for T05 and T10 is 3,000 per 10,000; the refinement chain
at 1.1 m/s; the steady slide at 2.5 m/s; the hold and the slip with friction 0.4 and pushes of 3.2928 N and
6.5856 N (0.6 and 1.2 of what friction can hold); the lift 41.16 N (three times the weight).

**The second contact suite** (`tools/contact_suite2.sh`): the same cube, friction 0.3, set sliding at 1.1 m/s, and
landing while sliding from 0.05 m; a pair of 3 kg (half-size 0.25 m) and 0.5 kg (0.03 m), friction 0.45 between
them, pushes of 7.7175 N and 23.1525 N (half and one and a half times what friction can carry), the side impact at
1 m/s and the top slide at 0.7 m/s. Right answers: 29,400 mN and 4,900 mN carried at rest; slip accelerations of
6,982 and 4,410 mm/s2.

**The benchmark**: the fifth registration's commands for `half_cheetah` and `ant`, the third's for `cart_pole`.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **F0** safe when off | The patched library, with no switch set and under each registered configuration's switches, reproduces every file in all nine parts of [`tools/play_identity.sh`](../tools/play_identity.sh) byte for byte ([run 025](../validation/run_025_identity/)) |
| **F1** required | The recommended configuration (patches A to E) without the correction fails T05, and at the shipped step the friction impulse over the impact is no more than 8 tenths of the law (2,400 per 10,000) |
| **F2** correct | With the correction the friction impulse over the impact is within 1 part in 100 of the law at each of the seven steps, and T10 passes |
| **F3** the suites | With the correction the first suite's code is 1111111111 and the second's is 1111111 |
| **F4** the solver on the suites | With the correction no step of either suite stops and none diverges |
| **F5** the benchmark | With the correction added to the recommended configuration, at the shipped step on the three scenes: no step diverges, and no more stop than without it plus 21 (1 in 1,000 of 21,600) |
| **F6** the other tests do not move | With the correction T01 to T04 and T06 to T09 pass or fail as they do without it |

## A decision fixed in advance

The correction joins the recommended configuration if, with it added, `half_cheetah` and `ant` at steps 1 to 1/16
are in order in 3 folds of 3 and no step diverges. Otherwise it is recorded as correct and optional.

Reported, not deciding: every measured line; the distance of a slide that ends at each step, with and without the
correction; the correction alone on stock contact; solver iterations with and without.

## Known risks, stated before the run

- **F3 asks for all seventeen tests on cubes the correction has not seen.** T10's band is 1 part in 100 at the
  three finest steps.
- **F5:** on the probe commands the correction removed `ant`'s stopped steps; on the registered commands it may not.
- **The fitted Hessian is an approximation.** The hold and slip tests (T07, T08) are where an extra brake would show.
- **F0 has failed before** for a change to the contact kernel.
- **The chains have not been probed** with the correction.

## What this does and does not say

If the rules hold, patch F is recorded as required, correct and safe, and the open item is closed. It says nothing
about friction at an impact through SuperDex's point-cloud contact, which is a separate path with its own study.

If a rule fails, it is recorded as measured.

## As registered

Patches: `patches/senua_contact.patch` sha256 1baa6dfec5400d35... (patches A, B and C, and F), `patches/senua_joint_limit.patch` 80f4c8c28ffacf51... (D), `patches/senua_rotation_axis.patch` 1ce1e2b97003929d... (E), `patches/senua_inertia_transport.patch` e39d71c153a3485e... (G). The four apply together to v1.0.0 and give the tree the library was built from (checked file by file). The patched library, build 12: ccb1aefeb3fc91f1.... The stock library: 5a213c925bc86b61.... Measuring program: `measure/sx_contact.sx` d18cbf6fc9dfd08e..., which is the ninth registration's program with lines added and none changed; with it the records of the fourth to the ninth registrations are re-made byte for byte. Safe when off: `tools/play_identity.sh` 220b28d98e06e1e8.... Runner: `measure/runners/sx_study11_run.sh` 95438f6e5bb2ac13.... Plays: `tools/plays/play_11.sh` 5f244295a952df95....
