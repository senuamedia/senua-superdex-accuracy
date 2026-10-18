# Patch ledger for SuperDex Physics

Corrections to [facebookresearch/project_superdex](https://github.com/facebookresearch/project_superdex) at v1.0.0
(`../UPSTREAM_COMMIT`), each proposed only after the same five checks.

1. **Required.** Stock SuperDex fails a test whose right answer is known from physics and does not depend on the
   time step.
2. **Correct.** With the correction on, that test passes.
3. **Nothing else gets worse.** No other test in the suite fails that passed before.
4. **Safe when off.** With the patch applied and no switch set, SuperDex's output is byte-identical to stock.
5. **The solver keeps converging.** On Meta's benchmark scenes, with the correction on, no solver step diverges and
   no more steps stop without converging than stock's count plus 1 in 1,000 of the steps (the fifth to twelfth registrations;
   from the thirteenth on, for the whole configuration, no more than 1 in 1,000 of the steps).

The rules were fixed before the runs ([PREREGISTRATION_05.md](../preregistrations/PREREGISTRATION_05.md)). Every number below is from
that registration's one run, up to the sections the later registrations added, each named for its registration.

## Library build 16: patch G's derived form under BDF2 (twenty-second registration), and patches F and G on fresh numbers (twenty-first)

**Patch G under BDF2.** [Study 22](../docs/studies/22-bdf2-chain.md) put patch G's derived form under BDF2 head to
head with the share of 1/3 on fresh chains ([PREREGISTRATION_22.md](../preregistrations/PREREGISTRATION_22.md), run
[052](../validation/run_052_study22/README.md)). **Every rule held, 66 rule lines of 66.** With the share a free
chain's angular momentum fell about twice a halving of the step; with the derived form its momentum and energy fell
3.56 to 4.59 times on every halving ruled, and at 1/16 of the step under the accurate configuration the momentum drift
was 5 or 6 parts per million. With patch G's switch unset the derived library made the identity list's plays as
registered (the eight of them Linux makes differently from the laptop as run 040 kept them) and its own 48 plays with
no switch as stock; under backward Euler with patch G's switch set it made the identity part fg as registered (four
plays as run 040 kept them), and its own 84 plays and Meta's scenes under the recommended configuration byte for byte
as library build 15. By the decision fixed
in advance the derived form is `senua_inertia_transport.patch` (328 lines added, none removed; sha256
c3e1442befd6dee9...), the share's file is kept as `superseded/senua_inertia_transport_registration22.patch`
(9807f00f6b543135...), and the four files are **library build 16**. The contact, joint-limit and rotation files are
build 15's. On Linux the play script's part build made it (sha256 2dc292922b3fa4e5...,
`../validation/run_052_study22/rigs.sha256`). Its cost: a single joint loses about (omega h)^2 of its speed once, at
the backward-Euler step that starts BDF2.

**Patches F and G on fresh numbers.** [Study 21](../docs/studies/21-recommended-configuration.md) held both to every
rule of their registrations again under the recommended configuration, on library build 15
([PREREGISTRATION_21.md](../preregistrations/PREREGISTRATION_21.md), run
[051](../validation/run_051_study21/README.md)). 117 rule lines of 118 held. **Every rule of patch G held (30 of 30), so
patch G is recorded as required, correct and safe under the recommended configuration, under backward Euler.** Patch F
held 13 of its 14: F3 failed on the second suite's T16, momentum between two cubes, the same with and without patch F.
Its cause is the measuring program, which reads each cube's mass in whole units of 10 g (the fresh pair, 4,177 g and
698 g, reads as 4,170 and 690); the final speeds keep the momentum. So the decision that would record patch F as
required, correct and safe did not fire, nor the one that would record the configuration as validated end to end.

**Study 23** ([run 055](../validation/run_055_study23/README.md)) put the same rules to library build 16 on fresh
numbers, with momentum between two cubes read by `pairg`, which takes each mass in whole grams. 117 rule lines of 118
held. **Every rule of patch F held (14 of 14), so patch F is recorded as required, correct and safe under the
recommended configuration; every rule of patch G held (30 of 30), replicating Study 21's decision on build 16.** One
line of P2 failed: on the point-cloud floor, friction over a one-step impact read 4,173 per 10,000 at step 1/4 against
the law's 3,970 (bound 1 in 25), so the decision that would record the configuration as validated end to end did not
fire.

## Library builds 14 and 15: two code reviews' corrections (fifteenth and sixteenth registrations)

Two independent reviews read every patched line, each given the code and the patches' purpose but not the results.
Neither found anything that runs with the switches off and differs from stock. The first found three defects with the
switches on: a switch set to `0` was on, a scene's creation or destruction dropped every scene's anchors, and a
restored state kept stale anchors. Library build 14 corrects them; [Study 15](../docs/studies/15-replication.md)
validated the corrections and found build 14 safe when off on 904 of 904 registered files, all made on build 14 but
for run 032's 17 stock play files, made on the stock library as run 032 had them
([run 033](../validation/run_033_identity/README.md)). The second found four
more: anchors on contacts a mapped collider missed at the start of a step, anchors surviving a body set to a new pose,
viscous friction under patch F taking a force its energy does not, and the anchor table's lifetime at process exit.
Library build 15 corrects them, with added lines only, in the contact and joint-limit files (the joint-limit change
reads a Jacobian's rows only when they are used). [Study 16](../docs/studies/16-second-review.md) found build 15 safe
when off on the 1,130 registered files made again, in 64-bit and in SuperDex's shipped 32-bit build, all made on
build 15 but for 28 (25 stock play files of runs 032 and 034 on the stock library, and 3 review plays on library
build 13, as those runs had them; [Study 18](../docs/studies/18-stock-plays.md) made the 25 again on build 15), and
validated the teleport and viscous corrections against build 14. The mapped-collider and table corrections were played in
[Study 19](../docs/studies/19-two-corrections.md), and held.

## Patch G extended to BDF2, fourteenth registration (played in Studies 14 and 15)

Patch G projects each link's translational inertial force with the Jacobian of the start of the step, which is right
for backward Euler only. The design probes ([run 030](../validation/run_030_design_probes/)) found that every SuperDex
integrator carries the defect patch G corrects, and derived where each one's force must be projected. In this
registration's form patch G's file scales its correction by that share: 1 for backward Euler (its arithmetic unchanged), 1/3 for BDF2, and 0 for
the integrators it has not been derived and validated for. 212 lines added, none removed (216 since library build 14); the twelfth registration's
file is kept in `superseded/`. Registered in [PREREGISTRATION_14.md](../preregistrations/PREREGISTRATION_14.md).

**Measured.** With the share, a pendulum under BDF2 keeps 99.6% to 99.9% of each of its first three swings at the
shipped step, and over 20 s every swing within 9,999 to 10,001 per 10,000 at 1/16 and 1/64 at the configurations'
tolerances ([Studies 14 and 15](../docs/studies/15-replication.md)). Its rules held (I5 in Study 14; V5 and V9 in
Study 15), but neither decision on the accurate configuration fired: Study 14's to recommend it (A5 failed) and
Study 15's to record it, at the final configuration's tolerances, as validated end to end (V8 failed). At SuperDex's shipped tolerances BDF2 with patch
G gains energy as the step shrinks, which moved the accurate configuration to the configurations' tolerances. On a
free two-link chain under BDF2 it keeps the energy but loses angular momentum at first order, 0.15% over 2 s at 1/16;
backward Euler with patch G keeps it to 6 parts per million. The cause is in stock SuperDex
([run 049](../validation/run_049_patch_g_review/README.md)): for a jointed body it starts each BDF2 stage from the
forward kinematics of the combined joint angles, where BDF2 for a constrained system combines each link's own centres,
and the share of 1/3 cancels the difference for one joint only. By the twenty-second registration's decision patch G
under BDF2 takes a derived form that makes a chain second order and changes nothing under backward Euler or with the
switch off (library build 16, above); the file with the share is kept as
`superseded/senua_inertia_transport_registration22.patch`.

## Patches F and G, eleventh and twelfth registrations, and the whole list end to end (thirteenth)

**Patch F, friction at an impact** ([PREREGISTRATION_11.md](../preregistrations/PREREGISTRATION_11.md), run
[027](../validation/run_027_friction/)), in `senua_contact.patch`, switch `SUPERDEX_FRICTION_STEP_NORMAL=1`. Coulomb
friction takes the whole normal force of the step being solved, contact damping and viscous friction keep the
start-of-step force, and friction's Hessian is SuperDex's own fitted one. **16 rule lines of 17 held (6 rules of 7).** Friction over an
impact went from 60% of Coulomb's law at the shipped step to within 1 in 1,000 of it at every step (2,999 or 3,000 per 10,000, against 3,000); the first suite
passed 10 of 10 on cubes the patch had not seen; no suite step stopped; `ant`'s stopped steps on the benchmark went
from 7 to 0. Rule F3 did not hold: the second suite's T15 (a light cube slipping on a heavy one) read 4% short at
1/16 of the step with and without the patch, and at the shipped step the patch moved it out of its band of 2 in 100
(4,224 against the law's 4,410; 4,392 without it); the cause is SuperDex's default grid distance field (run 030), not patch F, which needed no change ([run 048](../validation/run_048_patch_f_review/README.md)), and on the recommended configuration's grid the slip is right with patch F. **It joined the recommended configuration** by
the rule fixed in
advance.

**Patch G, the loss on joint motion** ([PREREGISTRATION_12.md](../preregistrations/PREREGISTRATION_12.md), run
[028](../validation/run_028_joint_motion/)), `senua_inertia_transport.patch`, switch `SUPERDEX_INERTIA_TRANSPORT=1`,
used with SuperDex's own experimental Newton-Euler inertia. The translational inertial force of each link is
projected onto the joints with the Jacobian of the start of the step. **8 of its 10 rules held (31 of 33 lines of the record).** A free arm kept 9,999
of every 10,000 of its speed at the shipped step, a free two-link chain its energy and angular momentum. G2 did not
hold on one play of nine (9,987 per 10,000 at 1/16 of the step: the solver's tolerance, met after one iteration a
step, leaves an error of one sign); G8 did not hold on one reading (the joint-friction slip test moved to its right
answer, away from stock's value). **It joined the recommended configuration** by the rule fixed in advance. A review
of patch G for publication ([run 049](../validation/run_049_patch_g_review/README.md)) found no defect in its code under
backward Euler, and on probe numbers under the recommended configuration it met every rule G1 to G9, G8 read against
the slip's right answer.

**The whole list end to end** ([PREREGISTRATION_13.md](../preregistrations/PREREGISTRATION_13.md), run
[029](../validation/run_029_end_to_end/)): every earlier known-answer test under patches A to G with SuperDex's
Newton-Euler inertia, contact damping 5 and a friction falloff of 0.03 m/s, and the three areas no study had tested.
**65 rule lines of 68 held; J4, D6 and G2 each failed on one line, so the decision that records the patch list as
validated end to end did not fire.** Both contact suites 17 of 17; the arm passes but for J4 (the joint-friction
slip moved to within 1 in 10,000 of its right answer, away from stock's value), and the limits and the rotations
pass; on the point-cloud floor friction over an impact went from 3.8 times Coulomb's law to within 5% of it; the
gripper holds where stock lets the cube creep out (G2 failed on stock's FR3 hand); the cloth and the soft cube on a
tilted floor stop where stock creeps, but the soft cube's centre moved 0.37 mm, past the 0.3 mm stick distance (D6);
and on fresh benchmark commands `ant` stopped 0 steps of 21,600 against stock's 231. The three failed lines are on
[Study 13's page](../docs/studies/13-end-to-end.md).

The same contact file carries two changes to patch C found by reading the source since the seventh registration:
its anchors are keyed by the collider's feature as well as the sample, and an anchor is appended for the contacts
SuperDex appends when its `explicitNormals` switch is on. The ninth registration's contact file is kept in
`superseded/`. Safe when off, for all four registrations, on library build 12: 362 of 362 registered files
byte-identical ([`../validation/run_025_identity/`](../validation/run_025_identity/)).

## Patch E, ninth registration: the axis of a small rotation. Every rule held

[PREREGISTRATION_09.md](../preregistrations/PREREGISTRATION_09.md), run once:
[`../validation/run_021_rotation/`](../validation/run_021_rotation/).

**The defect, in stock SuperDex.** `Quaternion::ToAxisAngle` (`mochi_core/utils/quaternion_inl.h`) takes the axis of a
rotation as the quaternion's vector part over its length only when that length is above 1e-9, and otherwise returns
the x axis. So the rotation vector of any rotation of 2e-9 rad or less points along x. Sixteen places in SuperDex
call it: the rigid rotation constraints, the articulated bodies, the time integration. A body whose rotation is held
has a rotation of about a nano-radian once something has touched it, and the rotation constraint's error then jumps
between the true axis and x, by its stiffness times a few nano-radians. That sits on the solver's tolerance, and
the solver runs to its iteration limit on steps whose answer it already has.

**The correction.** [`senua_rotation_axis.patch`](senua_rotation_axis.patch) (19 added lines since library build 14, none removed; sha256 279c951076464943...; the form registered before it, 15 lines, sha256
1ce1e2b97003929d..., is in `superseded/`), switched on by `SUPERDEX_ROTATION_AXIS_EXACT=1`: the axis is the vector part over its own
length whenever that length is not zero.

| Rule | Result |
|---|---|
| **E0** safe when off | Held. The rotations file, 8 of 8 two-cube files, 67 of 67 suite files against stock, 67 of 67 under the recommended configuration against the seventh registration's, 40 of 40 one-joint files and 38 of 38 benchmark streams, all byte-identical |
| **E1** required: the function | Held. Stock passes 20 of 20 rotations larger than 2e-9 rad and the 4 smaller ones about x, and fails the other 16, off by 113% to 163% of the angle |
| **E2** correct: the function | Held. 40 of 40, exact to the millionth |
| **E3** required: the solver | Held. Two free cubes at 1/64 of the step after they part: 930 of 3,079 steps at the iteration limit, 203,419 iterations |
| **E4** correct: the solver | Held. No step stops at any of the four steps; 3,080 iterations for 3,079 steps at 1/64 |
| **E5** the motion is the same | Held. The cubes end within 4 nm, with the same speeds |
| **E6** nothing else gets worse | Held. Both suites' codes unchanged under stock contact and under the recommended configuration |
| **E7** the solver on the suites | Held. Steps stopped: 36 and 231 to 0 and 0 under stock contact, 551 and 728 to 0 and 0 under the recommended configuration |
| **E8** the benchmark | Held. 2, 206 and 0 steps stopped, exactly stock's counts; none diverged |

**The decision fixed in advance** was met, and patch E joins the recommended configuration. On the benchmark it
changes nothing: all 13 streams played with it are byte-identical to the same configuration without it.

**What it shows about the corrected contact configuration.** The extra solver stops the seventh registration measured
on the one-cube suites (551 of 48,090 steps against 36, and 728 of 35,530 against 231) are this defect, not a cost of
the patches: with patch E the count is 0 in both suites.

## Correction, seventh registration: patch C as first recorded is withdrawn

The fifth registration's tests did not ask whether a cube that slides to a stop stays stopped. The seventh
registration asked ([PREREGISTRATION_07.md](../preregistrations/PREREGISTRATION_07.md), run once, every rule held:
[`../validation/run_017_counts/`](../validation/run_017_counts/)).

**The fault.** Stock SuperDex stops dead: the cube's speed over the last third of the run is 0 at every step. With
patch C as first recorded the cube comes back by the stick distance and rings on it. The integrator hides the
ringing at the shipped 10 ms step and it grows as the step is refined: 380 micrometres a second left at 1/16 of the
step and 12,857 at 1/64; when the cube also bounces, 147,786 micrometres a second and 15 mm from where it stopped.
The recommended configuration of the fifth registration had the same fault (333 and 14,767). The fault was in our
patch. SuperDex had none here.

**The cause.** Anchored friction is a spring between a contact and its anchor. As first written it had no loss of
its own, and it kept its anchor while the contact was open.

**The correction**, in [`senua_contact.patch`](senua_contact.patch), switched on by `SUPERDEX_STICK_DAMPING=1`:

- *A damped stick.* Friction acts on the offset from the anchor over the stick distance plus the sliding speed over
  SuperDex's own `frictionFalloffVel`, inside the one saturation. At rest it holds as before, while sliding it is the
  friction coefficient times the normal force as before, and in between the speed term is the loss. This is the
  bristle damping of the LuGre friction law (Canudas de Wit and others 1995).
- *A fresh anchor when the contact is open.* A contact that carries no normal force at the start of a step holds no
  stick: the return mapping of penalty friction onto a friction limit of zero.

**The recommended configuration from this registration:** contact damping 5, `frictionFalloffVel` 0.03, patches A
and B, and patch C with `SUPERDEX_STICK_DISTANCE=0.0003` and `SUPERDEX_STICK_DAMPING=1`.

| Rule of the seventh registration | Result |
|---|---|
| **G0** safe when off | Held. 39 and 28 suite files and 38 registered benchmark streams byte-identical to stock |
| **G1** patch C as first recorded does not stay stopped | Held. Stock 0 at every step; patch C 380 and 12,857 micrometres a second at the two finest steps |
| **G2** the correction | Held. 0 at every step; the cube comes back 297 to 299 micrometres, once |
| **G3** two moving bodies, stock | Held. Momentum kept (52 to 87 parts per million, the resolution of the measure), slip at Coulomb's value, weights carried; a cube that should ride on a pushed cube falls behind at 2,919 and 2,927 micrometres a second (the shipped friction law: 2,929) |
| **G4** two moving bodies, corrected | Held. The cube rides (0), slips at Coulomb's value (within 0.3%), momentum kept |
| **G5** nothing else gets worse | Held. The first suite on a new cube: 1111011111, every test but T05 |
| **G6** the benchmark | Held. `half_cheetah` in order in 3 folds of 3 (stock 0 of 3); no step diverged; steps stopped at the shipped step: `half_cheetah` 7 (stock 2), `ant` 11 (stock 206), of 21,600 |
| **G7** the solver on the suites | Held. Steps stopped: first suite 645 as recorded, 551 corrected; second suite 2,197 and 728 |

**What the corrected configuration costs, as measured.**

- A cube that slides to a stop comes back by about the stick distance (0.3 mm), once, and then stays. Stock does not
  come back at all. This is the elastic part of any friction law that can hold a load; a smaller stick distance
  makes it smaller and costs `half_cheetah`'s solver (design probes, run 016).
- On the one-cube suites the solver still stops without converging more often than stock, nearly all of it at the
  finest steps: 551 of 48,090 steps on the first suite (stock 36) and 728 of 35,530 on the second (stock 231). The
  results of those runs are right. These stops are the rotation-axis defect patch E corrects (ninth registration,
  above).
- Patch C corrected without contact damping, on a cube that bounces at 1/64 of the step, stays stopped (25
  micrometres a second) and ends 3.2 mm back from where it first stopped.
- T05 still fails under this configuration: friction is one step late at the impact itself (patch F, eleventh
  registration, above).

**Reported about stock.** After two free cubes collide and separate, stock's solver stops without converging on
about half of the later steps at 1/16 of the step (184 of 800 on the registered cubes) while both cubes move
uniformly and nothing touches. The motion is right.

The patch of the fifth registration is kept as
[`superseded/senua_contact_registration5.patch`](superseded/senua_contact_registration5.patch). With
`SUPERDEX_STICK_DAMPING` unset the current patch reproduces its friction force and energy bit for bit (28 of 28 files in the probes; one play of Study 5, whose solver often fails, carries a last-bit change in the rounding of one Hessian term, [run 050](../validation/run_050_patch_c_trace/README.md)), so the
fifth registration's numbers below can be re-made. **Everything below this section is the fifth registration
as it was recorded; where it says "recommended configuration" it means the one this section replaces.**

## Patch D, eighth registration: a joint limit that cannot pull. Required and correct; one rule of six did not hold

[PREREGISTRATION_08.md](../preregistrations/PREREGISTRATION_08.md), run once:
[`../validation/run_019_limits/`](../validation/run_019_limits/).

**The defect, in stock SuperDex.** A joint's end stop can push a link back into range; it cannot hold a link that
is leaving. SuperDex's limit force is stiffness times depth plus damping times the rate of change of depth, with
no lower bound, so it is negative while the joint comes back into range. Released at rest inside a limit with
damping below critical, an arm is slowed inside the limit and leaves at 1,004,593 micro-radians a second where a
limit that can only push releases it at 1,434,131. With damping above critical it never leaves: after half a
second it is still inside and creeping. Lifted off its limit by twice the torque that held it there, it turns a
third of what it should in the first tenth of a second. Meta's three benchmark scenes all ship damped limits
(`ant` 1,000 and 50, `cart_pole` 1,000 and 2,500, `half_cheetah` damping 100).

**The correction.** [`senua_joint_limit.patch`](senua_joint_limit.patch) (97 added lines since library build 15, none removed; sha256 6faaa83202139795...; build 14's form, 96 lines, sha256 0b8446d24c3fd401..., and the form registered before it, 92 lines, sha256
80f4c8c28ffacf51..., are in `superseded/`), switched on by `SUPERDEX_LIMIT_UNILATERAL=1`: the force along a range constraint is the
shipped one, never below zero. It is the derivative of an energy, so the solver still minimises one.

| Rule | Result |
|---|---|
| **H0** safe when off | Held. 40 of 40 joint files and 38 of 38 registered benchmark streams byte-identical to stock |
| **H1** the limit at rest | Held. The spring's angle, stock and corrected alike |
| **H2** stock holds back a leaving joint | Held, as above |
| **H3** the correction | Held. It leaves at 1,423,016 and 367,995 micro-radians a second (answers 1,434,131 and 369,401) and lifts off as it should; no solver step stopped or diverged |
| **H4** nothing changes where there is no limit | Held. 30 of 30 runs byte-identical with the switch on |
| **H5** the benchmark's solver with the switch alone | **Did not hold.** `ant` stops without converging on 245 of 21,600 steps at the shipped step against stock's 206; the bound fixed in advance was 227. `half_cheetah` 2 and `cart_pole` 0, as stock. No step diverged |

**With the corrected contact configuration the cost is not there.** The decision fixed in advance was measured
once: with the switch added to the recommended configuration, `half_cheetah` and `ant` are both in order in 3
folds of 3, no step diverges, and 6 and 7 steps stop at the shipped step (7 and 11 without the switch). By that
rule the patch joins the recommended configuration. On stock contact it is not shown to be free: use it there
knowing `ant`'s count.

## Result: every rule held

| Rule | Result |
|---|---|
| **S0** safe when off | Held. 39 of 39 suite runs and 38 of 38 registered benchmark streams byte-identical to stock |
| **S1** required | Held. Stock fails four tests, and contact damping on stock code fails two more |
| **S2** correct | Held. Each correction passes the test it is for, and the recommended configuration passes 9 of 10 |
| **S3** nothing else gets worse | Held |
| **B1** the benchmark keeps its order | Held. `half_cheetah`'s time-step settings: stock in order in 0 folds of 3, recommended in 3 of 3 |
| **B2** the solver keeps converging | Held. No step diverged. Steps that stopped without converging at the shipped step: `half_cheetah` 2 with stock and 0 with the recommended configuration, `ant` 206 and 2 |

## What is in the ledger

| | What it does | How it is switched on | Status |
|---|---|---|---|
| Setting | Gives the contact a loss of its own: SuperDex's `normalViscousDampingCoefficient` at 5 (shipped: 0) | The scene's contact parameters | SuperDex's own parameter, no patch |
| Patch A | Friction on the full normal force | `SUPERDEX_FRICTION_FULL_NORMAL=1` | [`senua_contact.patch`](senua_contact.patch) |
| Patch B | Contact damping that cannot pull | `SUPERDEX_DAMPING_UNILATERAL=1` | [`senua_contact.patch`](senua_contact.patch) |
| Patch C | Anchored Coulomb friction: a contact holds at rest within a stick distance, 300 micrometres here, with a damped stick (seventh registration) | `SUPERDEX_STICK_DISTANCE=0.0003` and `SUPERDEX_STICK_DAMPING=1` | [`senua_contact.patch`](senua_contact.patch) |
| Patch D | A joint limit that cannot pull (eighth registration) | `SUPERDEX_LIMIT_UNILATERAL=1` | [`senua_joint_limit.patch`](senua_joint_limit.patch) |
| Patch E | The axis of a rotation smaller than 2e-9 rad (ninth registration) | `SUPERDEX_ROTATION_AXIS_EXACT=1` | [`senua_rotation_axis.patch`](senua_rotation_axis.patch) |
| Patch F | Friction on the normal force of the step being solved (eleventh registration) | `SUPERDEX_FRICTION_STEP_NORMAL=1` | [`senua_contact.patch`](senua_contact.patch) |
| Patch G | A link's translational inertial force projected at the right node, with SuperDex's Newton-Euler inertia (twelfth registration; its share by integrator from the fourteenth; its derived form under BDF2 since the twenty-second) | `SUPERDEX_INERTIA_TRANSPORT=1` | [`senua_inertia_transport.patch`](senua_inertia_transport.patch) |

**The recommended configuration is the setting and all seven patches together**, with `frictionFalloffVel` at 0.03 (it sets the damping of the stick, since the seventh registration), SuperDex's Newton-Euler inertia (since the twelfth), and since the fourteenth the solver's tolerances at 1e-4 and 1e-8, each mesh body's grid cell at 1/32 of its side and a smoothing half-distance of 1 mm on a mesh body resting on a point cloud, each on its own rules, which held in the fourteenth registration, whose decision that they join did not fire (I4a, I4c, D4 and D6 failed); in the fifteenth item 3's rule V3, on the point-cloud sheet, failed on one stopped step ([open](../docs/open-items.md)). The [recommended configuration](../docs/recommended-configuration.md) gives it in full.

`senua_contact.patch` applies with `git apply` from the root of a checkout of v1.0.0. It adds 1,126 lines (896 in the fifth registration's form, 957 in the ninth's, 1,017 in the fourteenth's, 1,054 in the fifteenth's, all kept in `superseded/`) and removes
none: SuperDex's shipped contact kernel is left exactly as it is, the corrected kernel is a separate copy, and the
library calls the copy only when a switch is set. The switches are environment variables, read once.

## The suite

The tests are played on the smallest contact scene SuperDex can be asked about: one rigid cube and the static
ground plane (`../tools/sdx_contact.cpp`, played by `../tools/contact_suite.sh`). Nothing else is in the scene, so
what happens at the ground is contact and nothing but contact. The measuring is arithmetic on what the cube did at
every step. The registered cube is 0.5 kg with half-size 0.03 m, and steps are 10 ms (the benchmark scenes' shipped
step) divided by 1, 2, 4, 8, 16, 32 and 64.

| Test | What is played | The right answer |
|---|---|---|
| T01 | Released high enough never to reach the ground, at seven step sizes | Each halving of the step halves the difference (a first-order integrator) |
| T02 | Sliding steadily on the ground | Friction force is the coefficient times the normal force |
| T03 | Resting on the ground | The ground carries the cube's weight |
| T04 | Dropped on the ground with no friction, at seven step sizes | The bounce is the same at every step |
| T05 | Dropped with sideways speed and friction, at seven step sizes | Over the impact, the horizontal momentum lost is the coefficient times the vertical momentum the ground gives (Coulomb's law) |
| T06 | Set down, then pushed with 0.6 of what friction can hold | It does not move |
| T07 | Set down, then pushed with 1.2 of what friction can hold | It accelerates at (push minus friction) over mass |
| T08 | The drop with sideways speed, each step against the next finer one | The differences fall at every step |
| T09 | Lifted off the ground, and on a fast rebound | The ground never pulls |
| T10 | As T05, over the impact and the 0.1 s after it | The same law, and friction is never more than it allows |

T01, T02 and T03 are controls: they check that the scene and the rig are what they are taken to be.

## Results on the suite

T01 to T10, 1 = passed (`validation/suite_<configuration>.txt` has every measured line).

| Configuration | T01 to T10 | Passed |
|---|---|---|
| Stock | 1110001011 | 6 of 10 |
| Patched library, no switch set | 1110001011 | 6 of 10, and all 39 runs byte-identical to stock |
| Contact damping 5 | 1111001100 | 6 |
| Contact damping 5 with patch A | 1111001101 | 7 |
| Contact damping 5 with patches A and B | 1111001111 | 8 |
| Patch C alone | 1110011011 | 7 |
| **Recommended: damping 5 with patches A, B and C** | **1111011111** | **9** |

### The setting: a contact loss

**Required.** With the shipped contact the bounce is decided by the time step (T04), and each step against the next
finer one differs by more as the step shrinks (T08).

| | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| T04 stock: rebound per 10,000 of the drop height | 0 | 22 | 237 | 921 | 2,370 | 4,455 | 6,502 |
| T04 with contact damping 5 | 0 | 0 | 0 | 7 | 29 | 48 | 61 |

| | 1 to 1/2 | 1/2 to 1/4 | 1/4 to 1/8 | 1/8 to 1/16 | 1/16 to 1/32 | 1/32 to 1/64 |
|---|---|---|---|---|---|---|
| T08 stock: summed height difference, micrometres | 31,719 | 26,846 | 80,682 | 312,072 | 932,307 | 1,706,997 |
| T08 with contact damping 5 | 30,248 | 15,573 | 8,348 | 4,744 | 2,999 | 1,850 |

**Correct.** With contact damping 5, T04 and T08 pass.

**What it costs.** Damping switched on with stock code breaks two other tests, which is why patches A and B are
required with it.

### Patch A: friction on the full normal force

**Required.** Coulomb's law is on the whole normal force. SuperDex computes friction from the penalty part alone,
so with contact damping on, friction over an impact and the 0.1 s after it is 6.5% to 34% more than the law allows
(T10).

| T10: friction impulse per 10,000 of the normal impulse (the law: 3,000) | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| Stock (no damping) | 2,881 | 2,937 | 2,979 | 3,000 | 2,999 | 3,000 | 2,999 |
| Contact damping 5, stock code | 3,284 | 3,612 | 3,996 | 4,021 | 3,675 | 3,379 | 3,195 |
| Contact damping 5 with patch A | 2,880 | 2,940 | 2,970 | 2,986 | 2,993 | 2,997 | 2,998 |

**Correct.** With patch A, friction is back to what stock gives without damping: never more than the law allows,
4% late at the shipped step and within 0.5% from 1/8 of the step on.

### Patch B: contact damping that cannot pull

**Required.** A contact pushes and never pulls. SuperDex's damping term multiplies the penalty force by one minus
the coefficient times the leaving speed, and nothing stops that factor going below zero.

| T09: the lowest force of the ground on the 0.5 kg cube | Lifted, 10 ms | Lifted, 0.625 ms | Fast rebound |
|---|---|---|---|
| Stock (no damping) | 0 | 0 | 0 |
| Contact damping 5, stock code | minus 3.2 N | minus 0.1 N | minus 90 N |
| Contact damping 5 with patches A and B | 0 | 0 | 0 |

**Correct.** With patch B the damping part can cancel the penalty force of the step and no more, and its derivative
cancels the penalty's derivative at that bound.

### Patch C: anchored Coulomb friction

**Required.** A cube at rest, pushed with 0.6 of what friction can hold, creeps at 3.67 mm/s (T06). SuperDex's
friction law is zero at zero slip speed, so it cannot hold a load. None of the seven settings tried changes that (fourth
registration).

**Correct.** With patch C at a stick distance of 300 micrometres the cube's mean speed is 0 and minus 2
micrometres a second at the two steps tested. Pushed above the friction limit it slips, 1.1% and 2.4% faster than
the right answer (T07, allowed 3%).

### What the recommended configuration does not fix

**T05, Coulomb's law over the impact alone.** SuperDex's friction uses the normal force of the start of the step,
so friction arrives one step late. Over the impact alone it delivers 61% to 96% of what the law requires. Over the
impact and the 0.1 s after it (T10) it delivers 96% at the shipped step and all of it at finer steps.

SuperDex has a setting that removes the delay, `implicitNormalForceForDissipation`. On the suite, the recommended
configuration with that setting added passes all 10 tests. It is not part of the recommendation, because on `ant`
at the shipped step it stops SuperDex's solver converging as soon as there is contact damping, with or without the
patches (`../validation/run_012_design_probes/`).

## Results on Meta's benchmark scenes

Fresh commands (seeds 4602 and 4603, 108 episodes, `../actions/05/`), the time step at 1, 1/2, 1/4, 1/8 and 1/16 of
the shipped step, stock against the recommended configuration (`../validation/run_013_counts/`).

**The time-step settings come into order.** Plain subtraction over each fold's 36 test episodes, from the coarsest
gap to the finest:

| half_cheetah | Fold 0 | Fold 1 | Fold 2 | In order |
|---|---|---|---|---|
| Stock | 4,100,695; 3,579,634; 4,509,987; 6,489,377 | 4,466,729; 3,585,208; 4,517,204; 6,247,164 | 3,797,639; 3,421,364; 4,617,447; 7,040,743 | 0 folds of 3 |
| Recommended | 3,662,040; 2,244,852; 1,315,956; 827,162 | 4,280,687; 2,432,003; 1,589,696; 1,092,304 | 3,409,236; 2,196,747; 1,485,127; 931,759 | 3 folds of 3 |

`ant` is in order in all three folds both ways.

**The solver works less hard, and converges more often.**

| At the shipped 10 ms step, of 21,600 steps | Stopped without converging | Diverged | Most iterations in one step | Wall time |
|---|---|---|---|---|
| `half_cheetah`, stock | 2 | 0 | 200 (the limit) | 85.0 s |
| `half_cheetah`, recommended | 0 | 0 | 59 | 84.6 s |
| `ant`, stock | 206 | 0 | 200 | 34.4 s |
| `ant`, recommended | 2 | 0 | 200 | 28.9 s |

At the finer steps the recommended configuration leaves no step unconverged on `half_cheetah`, where stock leaves 1
to 4, and takes up to 43% longer (299.8 s against 209.2 s at 1/16 of the step). On `ant` it leaves 0 to 7
unconverged, where stock leaves 0 to 57.

**SuperDex's implicit setting is not safe to add.** Reported, not deciding: the recommended configuration with
`implicitNormalForceForDissipation` added, at the shipped step, left 35 steps unconverged on `ant` and 121
diverged, with a worst residual of 2.6e11. On `half_cheetah` it left 6 unconverged.

## Safe when off

With the patch applied and no switch set:

- all 39 runs of the suite are byte-identical to stock;
- all 38 registered benchmark streams that were replayed reproduce byte for byte: all 18 of `cart_pole`, 13 of
  `ant` and 7 of `half_cheetah`.

The first build of the patch did not pass this check. It edited the corrections into SuperDex's shipped kernel, and
one benchmark stream in ten then differed in 3 of 21,600 readings by one count, although the logic with the
switches off was unchanged. SuperDex is compiled with `-ffp-contract=fast`, which lets the compiler fuse a multiply
and an add wherever it likes, so any edit to the kernel changes the rounding. The patch in this ledger leaves the
shipped kernel's text alone for that reason.

## Limits

- One cube and one ground for the suite, and Meta's `half_cheetah` and `ant` for the benchmark.
- The corrected kernel is reached from every contact path of SuperDex. It was played on rigid and articulated bodies
  from the fifth registration on, and on a point-cloud sheet, cloth and a soft body from the thirteenth.
- Contact damping 5 makes impacts nearly dead. A contact that should bounce needs SuperDex's own calibration of the
  coefficient, a higher-order integrator and a step near 0.1 ms, as SuperDex's own bounce test uses.
- As the fifth registration measured, on the suite's light cube the solver stopped without converging more often with the corrections than with stock:
  819 of 48,090 steps with the recommended configuration against 52, nearly all of them while the cube slides after
  landing, at the finer steps. Contact damping alone accounts for 324 and patch C alone for 428. No step diverged,
  and every test the configuration passes it passes with those steps included. On the benchmark scenes it is the
  other way round (above).
- A stick distance of 10 micrometres, which we used in September on a sled, is too stiff for `half_cheetah` at a
  10 ms step. 300 micrometres is not.
- Nothing here has been run against a real robot.

## Files

| File | What it is |
|---|---|
| `senua_contact.patch` | Patches A, B and C (with the seventh registration's correction and the later changes) and patch F, against SuperDex v1.0.0, with both code reviews' corrections: the file of library builds 15 and 16 (the file's sha256 05cfa0a011a0bcf6...) |
| `superseded/senua_contact_registration15.patch` | The contact file of library build 14, as the fifteenth registration used it (sha256 78a57a7657388d62...) |
| `superseded/senua_contact_registration14.patch` | The contact file as the tenth to fourteenth registrations used it (sha256 1baa6dfec5400d35...) |
| `superseded/senua_contact_registration9.patch` | The contact file as the seventh to ninth registrations used it (sha256 5cf3c66296270d0c...) |
| `superseded/senua_contact_registration5.patch` | The patch as the fifth registration recorded it (sha256 08b13968fe9c2a2b...) |
| `superseded/senua_joint_limit_registration15.patch` | The joint-limit file of library build 14, as the fifteenth registration used it (sha256 0b8446d24c3fd401...) |
| `superseded/senua_joint_limit_registration14.patch` | The joint-limit file as the eighth to fourteenth registrations used it (sha256 80f4c8c28ffacf51...) |
| `superseded/senua_rotation_axis_registration14.patch` | The rotation file as the ninth to fourteenth registrations used it (sha256 1ce1e2b97003929d...) |
| `superseded/senua_inertia_transport_registration14.patch` | The inertia file as the fourteenth registration used it (sha256 be36790a85e9119e...) |
| `superseded/senua_inertia_transport_registration22.patch` | The inertia file of library builds 14 and 15, with its share by integrator, as the fifteenth to twenty-second registrations used it (sha256 9807f00f6b543135...) |
| `superseded/senua_inertia_transport_registration12.patch` | The inertia file of library build 12, as the twelfth and thirteenth registrations used it (sha256 e39d71c153a3485e...) |
| `in_design/` | Candidates probed before a registration and never registered themselves, each with its library build; see [its README](in_design/README.md) |
| `senua_joint_limit.patch` | Patch D, a joint limit that cannot pull: the file of library builds 15 and 16 (the file's sha256 6faaa83202139795...; build 14's form 0b8446d24c3fd401... and the eighth to fourteenth registrations' form 80f4c8c28ffacf51... are in `superseded/`) |
| `senua_rotation_axis.patch` | Patch E, the axis of a rotation smaller than 2e-9 rad: the file of library builds 14 to 16 (sha256 279c951076464943...; the ninth to fourteenth registrations' form 1ce1e2b97003929d... is in `superseded/`) |
| `senua_inertia_transport.patch` | Patch G, the loss on joint motion, with its derived form under BDF2: the file of library build 16, 328 lines added, none removed (sha256 c3e1442befd6dee9...; library builds 14 and 15's form with the share, 9807f00f6b543135..., the fourteenth registration's be36790a85e9119e... and the twelfth's are in `superseded/`) |
| `../validation/run_021_rotation/` | The ninth registration: the rotations, two free cubes with the solver's trace, both suites with and without patch E, the identity checks, the benchmark |
| `LICENSE` | The Apache License 2.0, as SuperDex ships it. The patch files change SuperDex source and are offered under it |
| `../validation/run_019_limits/` | The eighth registration: one-joint limit runs, the identity check, the benchmark with the switch |
| `../validation/run_017_counts/` | The seventh registration: both suites under six configurations, the identity check, the benchmark under the corrected configuration |
| `validation/identity.txt` | The byte-identity check, stream by stream |
| `validation/suite_<configuration>.txt` | Every measured line of the suite under one configuration |
| `validation/stats_<configuration>.txt` | The solver's own status of every suite run |
| `validation/runs/<configuration>/` | The rig's raw output of every suite run under every configuration (39 runs each, with checksums), so the ledger can be re-made by measuring alone |
| `validation/ledger.txt` | The registered rules, decided |
| `../validation/run_013_counts/` | The benchmark on fresh commands: stock against the recommended configuration |
