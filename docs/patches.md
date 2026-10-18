# The patches

Seven corrections to SuperDex Physics v1.0.0, in four patch files, each found by Senua AI's measurement and held to
its five checks. This page says what each one corrects, how, and what it was held to. Every number behind it is in a
run or probe in `validation/`, and each patch's forms and checksums are in the [patch ledger](../patches/README.md).

Back to the [documentation index](README.md).

## The five checks

A correction is proposed only after the same five checks, each fixed before its runs.

| Check | What it means |
|---|---|
| Required | Stock SuperDex fails a test whose right answer is known from physics and does not depend on the time step |
| Correct | With the correction on, that test passes |
| Nothing else gets worse | No other test in the suite fails that passed before |
| Safe when off | With the patch applied and no switch set, SuperDex's output is byte-identical to stock |
| The solver keeps converging | On Meta's benchmark scenes no solver step diverges, and no more steps stop without converging than stock's count plus 1 in 1,000 of the steps (the fifth to twelfth registrations, for each patch); from the thirteenth registration on, for the whole configuration, no more than 1 in 1,000 of the steps. At the configurations' tighter tolerances `half_cheetah` stops 9 steps of 21,600 where stock stops 3 ([Study 14](studies/14-open-items.md)) |

## At a glance

| Patch | Corrects | Switch | Required | Correct | Safe when off | Solver | Status |
|---|---|---|---|---|---|---|---|
| A | Friction ignores the damping part of the normal force | `SUPERDEX_FRICTION_FULL_NORMAL=1` | Yes | Yes | Yes | Yes | Validated |
| B | The ground can pull | `SUPERDEX_DAMPING_UNILATERAL=1` | Yes | Yes | Yes | Yes | Validated |
| C | Nothing holds at rest | `SUPERDEX_STICK_DISTANCE=0.0003` with `SUPERDEX_STICK_DAMPING=1` | Yes | Yes, in its corrected form | Yes | Yes on the benchmark | Validated. The first form is withdrawn |
| D | A joint limit can pull | `SUPERDEX_LIMIT_UNILATERAL=1` | Yes | Yes | Yes | Not when used alone on `ant` | Required and correct. Part of the recommended configuration |
| E | The rotation vector of a small rotation points along x | `SUPERDEX_ROTATION_AXIS_EXACT=1` | Yes | Yes | Yes | Yes | Validated. Part of the recommended configuration |
| F | Friction is one step late at an impact | `SUPERDEX_FRICTION_STEP_NORMAL=1` | Yes | Yes; no defect in its code ([run 048](../validation/run_048_patch_f_review/README.md)) | Yes | Yes | Validated. Recorded as required, correct and safe under the recommended configuration by [Study 23](studies/23-recommended-configuration-again.md)'s decision, on fresh numbers and library build 16: every rule F1 to F6 held, 14 rule lines of 14. Part of the recommended configuration by [Study 11](studies/11-friction-at-impact.md)'s decision. Studies 11 and 21 recorded it as measured because F3 failed in each: a carried cube's slip whose cause is SuperDex's default grid (run 048), then momentum between two cubes whose cause is the measuring program's reading of the cubes' masses ([run 051](../validation/run_051_study21/README.md)), neither patch F |
| G | A free joint loses speed: its inertial force is projected at the wrong node | `SUPERDEX_INERTIA_TRANSPORT=1`, with SuperDex's own Newton-Euler inertia | Yes | Yes: under backward Euler at the configurations' solver tolerances ([Study 21](studies/21-recommended-configuration.md)), and under BDF2 in its derived form ([Study 22](studies/22-bdf2-chain.md)); no defect in its code under backward Euler ([run 049](../validation/run_049_patch_g_review/README.md)) | Yes | Yes | Validated. Part of the recommended configuration by [Study 12](studies/12-joint-motion.md)'s decision. Recorded as required, correct and safe under backward Euler by Study 21's decision, every rule G1 to G9 holding on fresh numbers (Study 12 records it as measured: G2's cause is SuperDex's shipped relative solver tolerance, and G8 was posed against stock's value, run 049). Under BDF2 it takes its derived form, in place of the share of 1/3, by Study 22's decision (library build 16) |

Patches A, B, C and F are in [`patches/senua_contact.patch`](../patches/senua_contact.patch) (1,126 lines added in
ten files, none removed). Patch D is in [`patches/senua_joint_limit.patch`](../patches/senua_joint_limit.patch)
(97 lines added, none removed). Patch E is in [`patches/senua_rotation_axis.patch`](../patches/senua_rotation_axis.patch)
(19 lines added, none removed). Patch G is in
[`patches/senua_inertia_transport.patch`](../patches/senua_inertia_transport.patch) (328 lines added, none removed).
The four apply together to v1.0.0 and are the files of library build 16. Build 14 added the first code review's
corrections to build 13, build 15 added the second review's (below, validated in [Study 16](studies/16-second-review.md)), and build 16 replaces patch G's file with its derived form under BDF2 ([Study 22](studies/22-bdf2-chain.md)); the contact, joint-limit and rotation files are build 15's. Earlier forms are kept in [`patches/superseded/`](../patches/superseded/). The "Safe when off" column is measured on library build 15, in 64-bit and in SuperDex's shipped 32-bit build, on the plays it was given ([Study 16](studies/16-second-review.md)), and on library build 16 in 64-bit on the identity list and Study 22's own plays (Study 22).

## How the patches are built

- **They only add lines.** SuperDex's shipped contact kernel is left exactly as it is. The corrected kernel is a
  separate copy, and the library calls the copy only when a switch is set.
- **Why.** SuperDex is compiled with `-ffp-contract=fast`, which lets the compiler fuse a multiply and an add
  wherever it likes. Any edit to the shipped kernel changes the rounding, even where the logic is unchanged. Our
  first build edited the kernel, and one benchmark stream in ten then differed in 3 of 21,600 readings by one count
  with every switch off. A patch that changes a user's results when it is switched off is not safe to merge.
- **The switches are environment variables**, read once. A user who sets none gets stock SuperDex's output, byte for byte, on every play compared (below).
- **Scope.** The contact corrections sit in the kernel that every contact path of SuperDex calls. They have been
  played on rigid and articulated bodies, on a point-cloud sheet and on deformable bodies (Studies 13 and 14).

Safe when off, as measured on library build 15 ([run 035](../validation/run_035_identity/)): every registered play on
the identity list made again is byte-identical to its registered file, 1,129 of 1,129. That holds with no switch set, with every
switch set to `0`, and under the switches of each registered configuration on the list. It includes the whole of runs
032 and 034. Build 15 made all of them but 28: 25 files of the stock plays of runs 032 and 034 were made with the
`*_stock` rigs on the stock library, and 3 plays of run 034's review part on library build 13, as those runs had them;
[Study 18](studies/18-stock-plays.md) made the 25 again on build 15.
[Run 036](../validation/run_036_registration16/) made every stream of the first two studies again on build 15,
byte-identical, 108 of 108: the 48 that are 32-bit in SuperDex's shipped 32-bit build, the rest in 64-bit, and six
of the 32-bit ones again with every switch set to `0`. Those are 1,130 distinct registered files, all made on build 15 but for 28 that runs 032 and 034 play on another library, as registered: their 25 stock plays, made on the stock library, and 3 plays of the review part on library build 13. The 25 stock plays are put to [Study 18](studies/18-stock-plays.md).
[Study 17](studies/17-whole-record.md) made the rest of the record of Studies 3 to 13 again on build 15, each study
by its own scripts: 2,091 of 2,099 files the same (the other 6 changed on purpose by library build 13, as rule W2 asked), every play made with no switch among them (827 of 827), and
1,264 of the 1,266 made under switches. The two that differ are one play Study 5 reported and did not decide on,
`ant` under the recommended configuration with SuperDex's implicit normal force. Library build 4, kept from Study 5's
time, makes it byte for byte, so a later library build changed it. Its conclusion, not safe to add, holds.
On library build 16, [Study 22](studies/22-bdf2-chain.md) made the identity list's plays again on Linux: every file the
same as registered but the twelve plays Linux makes differently from the laptop, each the same as the Linux file run 040
kept (and the six of them with no switch the same as stock on that machine), and its own 48 plays with no switch the
same as stock ([run 052](../validation/run_052_study22/README.md)).

## The setting the contact patches go with

Three of the patches matter because of one of SuperDex's own settings. The shipped contact has no loss of its own,
so the time step sets how much a body bounces ([finding 1](findings.md)). SuperDex has a parameter for a contact
loss, `normalViscousDampingCoefficient`, shipped at 0. Set to 5 it makes the bounce the same at every step. But
switched on with stock code it breaks two other tests, and that is what patches A and B correct.

## Patch A: friction on the full normal force

**What is wrong.** Coulomb's law is on the whole normal force. SuperDex computes friction from the penalty part of
the normal force alone. With contact damping on, the normal force has a damping part too, and friction ignores it.
Friction over an impact and the 0.1 s after it is then 6.5% to 34% more than the law allows.

**The correction.** With the switch set, friction is proportional to the penalty part plus the damping part.

**The evidence.** Test T10: with patch A, friction is back to what stock gives without damping, never more than the
law allows, 4% late at the shipped step and within 0.5% from 1/8 of the step on.
[Study 5](studies/05-contact-patches.md).

## Patch B: contact damping that cannot pull

**What is wrong.** A contact pushes and never pulls. SuperDex's damping term multiplies the penalty force by one
minus the coefficient times the leaving speed, and nothing stops that factor going below zero. On a 0.5 kg cube
the ground pulls with 3.2 N when the cube is lifted and with 90 N on a fast rebound.

**The correction.** With the switch set, the damping part can cancel the penalty force of the step and no more, and
its derivative cancels the penalty's derivative at that bound, so the solver sees a consistent force.

**The evidence.** Test T09: the lowest force of the ground on the cube is 0 in two lifts and a fast rebound.
[Study 5](studies/05-contact-patches.md).

## Patch C: anchored Coulomb friction

**What is wrong.** SuperDex's friction law is zero at zero slip speed, so it cannot hold a load. A cube pushed with
0.6 of what friction can hold creeps at 3.67 mm a second, and none of the seven settings tried removes it ([finding 4](findings.md#4-nothing-holds-at-rest)).

**The correction.** A contact keeps an anchor: the place where it last stuck. Friction acts on the offset from the
anchor, so a contact holds at rest within a stick distance, 300 micrometres here. Pushed past the friction limit,
the anchor is dragged along and the contact slides at the friction coefficient times the normal force, as before.

**The first form, and its fault.** As recorded in Study 5, the stick was a spring with no loss of its own, and it
kept its anchor while the contact was open. A cube that slid to a stop came back by the stick distance and rang.
The integrator hid the ringing at the shipped step, and it grew as the step was refined: 12,857 micrometres a
second left at 1/64 of the step, where stock leaves 0. That form is withdrawn.

**The corrected form**, switched on by `SUPERDEX_STICK_DAMPING=1`:

- *A damped stick.* Friction acts on the offset from the anchor over the stick distance plus the sliding speed over
  SuperDex's own `frictionFalloffVel`, inside the one saturation. At rest it holds as before, while sliding it is
  the friction coefficient times the normal force as before, and in between the speed term is the loss. This is the
  bristle damping of the LuGre friction law (Canudas de Wit and others 1995).
- *A fresh anchor when the contact is open.* A contact that carries no normal force at the start of a step holds no
  stick.

`frictionFalloffVel` sets the damping of the stick. At the shipped 0.01 the stick is stiffer than shipped friction
and costs `half_cheetah`'s solver in the design probes. At 0.03, with a 300 micrometre stick, the registered run
stayed inside the bound fixed in advance: 7 steps of 21,600 stopped, against stock's 2.

**The evidence.** The cube's speed over the last third of a slide is 0 at every step from 10 ms to 1/64 of it. A
cube rides on a gently pushed cube (0 where stock falls behind at 2,919 micrometres a second). Pushed above the
friction limit, it slips at Coulomb's value to within 0.3%.
[Study 7](studies/07-slide-and-two-bodies.md).

**What it costs.** A cube that slides to a stop comes back about 0.3 mm, once, and then stays. Stock does not come
back at all. This is the elastic part of any friction law that can hold a load. A smaller stick distance makes it
smaller and costs the solver.

The withdrawn form is kept as
[`patches/superseded/senua_contact_registration5.patch`](../patches/superseded/senua_contact_registration5.patch).
With `SUPERDEX_STICK_DAMPING` unset the current patch reproduces it bit for bit on every play of Studies 5 and 7
made under it but one, so Study 5's numbers can be re-made, all but one. The one, found by
[Study 17](studies/17-whole-record.md), is `ant` under the recommended configuration with SuperDex's implicit normal
force, which every kept build since this correction plays with one fewer stopped step and one fewer diverged step (35
and 121 registered, 34 and 120 on those builds). Study 5 reported that play and did not decide on it. [Run 050](../validation/run_050_patch_c_trace/README.md) found why: a three-line block of the correction that never runs with the switch unset changes how the compiler rounds one term of anchored friction's Hessian under `-ffp-contract=fast`; the force and its energy are bit for bit, and only a play whose solver often fails carries the last-bit change into its output.

## Patch D: a joint limit that cannot pull

**What is wrong.** A joint's end stop can push a link back into range. It cannot hold a link that is leaving.
SuperDex's limit force is stiffness times depth plus damping times the rate of change of depth, with no lower
bound, so it is negative while the joint comes back into range. With damping below critical an arm leaves its limit
30% slower than it should. With damping above critical it never leaves.

**The correction.** With the switch set, the force along a range constraint is the shipped one, never below zero.
It is the derivative of an energy, so the solver still minimises one.

**The evidence.** The arm leaves at 1,423,016 and 367,995 micro-radians a second where the right answers are
1,434,131 and 369,401. Nothing changes where there is no limit: 30 of 30 runs byte-identical with the switch on.
[Study 8](studies/08-joint-limits.md).

**What it costs.** Used alone on stock contact, `ant`'s solver stops without converging on 245 of 21,600 steps
where stock stops on 206. The bound fixed in advance was 227, so that rule did not hold. Inside the recommended
configuration the cost is not there: 7 steps.

## Patch E: the axis of a small rotation

**What is wrong.** SuperDex's `Quaternion::ToAxisAngle` takes the axis of a rotation as the quaternion's vector part
over its length only when that length is above 1e-9. Otherwise it returns the x axis. So the rotation vector of any
rotation of 2e-9 rad or less points along x, whatever its own axis is. SuperDex uses the function in its rigid
rotation constraints, its articulated bodies and its time integration.

A body whose rotation is held has a rotation of about a nano-radian once something has touched it. The constraint's
error then jumps between the true axis and x, by the constraint's stiffness times a few nano-radians, which sits on
the solver's tolerance. The solver runs to its iteration limit on steps whose answer it already has.

**The correction.** [`patches/senua_rotation_axis.patch`](../patches/senua_rotation_axis.patch) adds 19 lines and
removes none. With `SUPERDEX_ROTATION_AXIS_EXACT` set, the axis is the vector part over its own length whenever that
length is not zero.

**The evidence.** All 16 failing rotations come back exact. Two free cubes after they part, at 1/64 of the step:
930 of 3,079 steps at the iteration limit and 203,419 iterations with stock, 0 and 3,080 with the patch. Both
contact suites: 0 stopped steps where there were 36 and 231 with stock contact, and 551 and 728 with the
recommended configuration. Every test passes or fails as before, and the cubes end within 4 nm of where stock
leaves them. [Study 9](studies/09-rotation-axis.md).

**What it costs.** Nothing that was measured. On the benchmark streams and the one-joint runs played with it, it never acts: all 13
benchmark streams and all 40 one-joint files are byte-identical with it on.

**What it showed about our own patches.** The extra stopped steps Study 7 measured for the corrected contact
configuration on the one-cube suites are this defect, not a cost of patch C.

## Patch F: friction on the normal force of the step being solved

**What it corrects.** SuperDex scales Coulomb friction by the penalty force at the start-of-step distance. Over the
step in which a body lands that distance is still open, so friction is given a force that is zero or small while the
step's own normal impulse is the whole impact. It arrives one step late (finding 5).

**How.** Lines added to the Senua contact kernel in [`patches/senua_contact.patch`](../patches/senua_contact.patch),
off unless `SUPERDEX_FRICTION_STEP_NORMAL` is set. Coulomb friction alone takes the whole normal force of the step
being solved, the penalty force at the current distance plus the damping part as it is applied to the body, never
below zero. Contact damping and viscous friction keep the start-of-step force, so their derivatives stay exact.
Friction's Hessian is SuperDex's own fitted one: in the probes, with anchored friction's exact Hessian `ant` diverged
on 4 steps of 21,600, and with the fitted one no step stopped ([Study 11](studies/11-friction-at-impact.md)). Why the
exact one fails was not measured.

**What it was held to.** [Study 11](studies/11-friction-at-impact.md): on cubes it had not seen, friction over an impact
went from 60% of Coulomb's law at the shipped step to within 1 in 1,000 of it at every step (2,999 or 3,000 per 10,000, against 3,000); the first contact suite
passed 10 of 10; no suite step stopped; on the benchmark `ant`'s stopped steps went from 7 to 0, and with it added
`half_cheetah` and `ant` stayed in order in 3 folds of 3. One rule did not hold, F3, the second suite on cubes it had
not seen: its T15, a carried cube's slip, falls short of the law at 1/16 of the step with and without the patch, and at
the shipped step with the patch it reads outside its band of 2 in 100: 4,224 against the law's 4,410 (4.2% short; 4,392
without it). The cause is SuperDex's default grid distance field, not patch F, which needed no change, which rounds the block's edge within its last cell ([run 030](../validation/run_030_design_probes/), [run 048](../validation/run_048_patch_f_review/README.md)): stock's friction there runs up to 55% above Coulomb's law and hides the shortfall at the shipped step. With the grid cell at 1/32 of a body's side, as the recommended configuration sets it, the same pair reads the law at every step with patch F (4,409 to 4,410). Run 048 also read patch F's code line by line and found no defect, and on probe numbers under the recommended configuration it held every rule of Study 11 but one clause, which measures how short stock falls on a given cube. Safe when off: [run 025](../validation/run_025_identity/).

[Study 21](studies/21-recommended-configuration.md) held patch F to Study 11's rules again under the recommended
configuration, on numbers no earlier study used: 13 of its 14 rule lines held. Without patch F the shipped step read
81.0% of the law over an impact (reported), with it 3,409 or 3,410 per 10,000 at every step against 3,410; the first
suite passed 10 of 10, no suite step stopped, and on Meta's scenes 5, 1 and 0 steps stopped against 10, 25 and 0 without
it. F3 failed on the second suite's T16, momentum between two cubes, the same with and without patch F. The cause is
the measuring program: its `pair` measure takes each cube's mass in whole units of 10 g, and the fresh
pair's 4,177 g and 698 g read as 4,170 and 690, so the read momentum appears to change by about 0.9% while the final
speeds keep it (809,681 against 809,680 at release; [run 051](../validation/run_051_study21/README.md)). So the decision
that would record patch F as required, correct and safe did not fire again. The measure `pairg` reads mass in grams,
beside the old one. On fresh numbers and on library build 16, [Study 23](studies/23-recommended-configuration-again.md)
held every rule of patch F, F1 to F6, 14 rule lines of 14: without it T05 fails; with it friction over an impact is
3,879 or 3,880 per 10,000 at every step against the law's 3,880; both suites pass, T16 reading 83 to 111 parts per
million against 500; no suite step stops; Meta's scenes are no worse. **By its decision patch F is recorded as
required, correct and safe under the recommended configuration** ([run 055](../validation/run_055_study23/README.md)).

**What it costs.** With patch F a slide that ends stops at backward Euler's own distance at the shipped step, 3% short of the
law, where without it the first step's missing friction made it 2% long. About a fifth more solver iterations on
`ant` than without it (21% in [run 023](../validation/run_023_design_probes/)'s `probe_13_ant_together.txt`).

## Patch G: the inertial force of a link, projected at the right node

**What it corrects.** A free arm loses the square of the angle it turns in a step (finding 8). SuperDex gives every
link of an articulated body the inertial energy of a free rigid body, whose target is a straight line, and projects
the resulting force onto the joints with the Jacobian of the current position. The inertial force is the centred
second difference of the link's position, which belongs to the start of the step.

**How.** [`patches/senua_inertia_transport.patch`](../patches/senua_inertia_transport.patch): lines added to
`mochi_rigid.cpp` and `mochi_articulated_body.cpp`, off unless `SUPERDEX_INERTIA_TRANSPORT` is set. Under backward
Euler the translational inertial force of each link is projected with the Jacobian of the start of the step: the
discrete null space method of Betsch and Leyendecker. Under BDF2 it takes its derived form (below). The rotation of each link about its own centre is left to SuperDex's own experimental
Newton-Euler inertia (`EnableNewtonEulerInertia`), which corrects that part. The two are used together.

**What it was held to.** [Study 12](studies/12-joint-motion.md): stock lost what the law says, within 0.1%; with both, a free
arm kept 9,999 of every 10,000 of its speed at the shipped step, a free two-link chain its energy (100.02%) and its
angular momentum (to 6 parts in a million), and with the solver converged the momentum drift was 0 at every step.
Under gravity the loss fell to 38% of stock's at the shipped step. With both added `half_cheetah` and `ant` stayed in
order in 3 folds of 3. Two rules did not hold, each on one reading: one fine-step play kept 9,987 per 10,000 (the
solver's tolerance, below), and the joint-friction slip test moved to its right answer, away from stock's value.
[Run 049](../validation/run_049_patch_g_review/README.md), a review of patch G for publication, read its code line by
line and found no defect under backward Euler, the integrator of Study 12 and of the recommended configuration. It
re-made Study 12's reading from run 028's files byte for byte, and on probe numbers under the recommended configuration
patch G met every rule G1 to G9, G8 read against the slip's right answer (against stock's value, as registered, G8's
shipped step fails again). G2's shortfall is SuperDex's shipped relative tolerance: with patch G's Newton matrix not
exact, the solve meets that tolerance after one iteration a step and leaves an error of one sign
([run 030](../validation/run_030_design_probes/), and below). Study 12's
registration records patch G as measured, because G2 and G8 failed as registered.
[Study 21](studies/21-recommended-configuration.md) decided it on fresh numbers, under the recommended configuration:
every rule G1 to G9 held, 30 rule lines of 30, G8 read against the slip's right answer (3,610,270 and 3,610,268 against
3,610,288) and G2 at the configuration's tolerances (the lowest of nine plays 9,999.66 per 10,000), and the identity
check held. **Patch G is recorded as required, correct and safe under backward Euler.**

**Its share by integrator (library builds 13 to 15).** The start of the step is the right node for
backward Euler's stencil only. For a body turning freely about a joint, each scheme's stage force is radial at its
own angle; projecting there keeps the speed. From the fourteenth registration to the twenty-second, patch G scaled its
correction by that share: 1 for backward Euler, whose arithmetic is unchanged; 1/3 for BDF2, where the Jacobian of the
step's start weighs 1/3 and the current one 2/3; and 0 for every other SuperDex integrator, for which it was not
derived and validated. Under BDF2 with it a pendulum keeps 99.6% to 99.9% of each of its first three swings at the
shipped step ([Study 14](studies/14-open-items.md)). That file is kept as
[`patches/superseded/senua_inertia_transport_registration22.patch`](../patches/superseded/senua_inertia_transport_registration22.patch).

**Under BDF2 on a chain, and the derived form (library build 16).** The share was right for one joint and first order
for a chain: a free two-link chain kept its energy and lost angular momentum at first order
([Study 15](studies/15-replication.md), V8).
[Run 049](../validation/run_049_patch_g_review/README.md) found the cause in stock SuperDex. Its BDF2 combines the two
previous states with weights 4/3 and -1/3 over a stage of 2h/3, and for a jointed body it sets each link's
stage-start pose from the forward kinematics of the combined joint angles, X(q_s), where BDF2 for a constrained system
combines each link's own centres, x_s = X_n + (-1/3)(X_{n-1} - X_n) (Gear, Leimkuhler and Gupta 1985; Brenan, Campbell
and Petzold 1996, chapter 3). A linear multistep combination commutes only with a linear map, so X(q_s) - x_s =
(2/9) h^2 Jdot qd to leading order: the velocity kept at the end of the stage is short by (h/3) Jdot qd, and the
residual carries an error of first order. The share of 1/3 cancels it for one joint only; for a chain a part of the
angular momentum's error remains that no scalar share cancels. The derived form,
[`patches/senua_inertia_transport.patch`](../patches/senua_inertia_transport.patch), adds the force m D/h_s^2 with
D = X(q_s) - x_s, adds D/h_s to the link velocity kept at the end of the stage, uses the current Jacobian under BDF2 and
keeps the transport for backward Euler alone; no constant is tuned. Under backward Euler it gives library build 15's
output byte for byte on every play compared (Study 22).

[Study 22](studies/22-bdf2-chain.md) put the two forms head to head under BDF2 on three fresh free chains, one of them
moving in three dimensions, and every rule held (66 rule lines of 66). With the share the momentum drift fell about
twice a halving of the step (1.99 to 2.08 with the solve converged); with the derived form the momentum and the energy
fell 3.56 to 4.59 times on every halving ruled, second order, and the momentum drift at 1/16 of the step under the
accurate configuration was 5 or 6 parts per million, where the share's was 615 to 1,137. Under the accurate
configuration on Meta's scenes no step of 345,600 stopped, and with the switch off or under backward Euler every play
compared was the same as library build 15's. **By its decision the derived form, in place of the share, is patch G
under BDF2: library build 16.**

Its cost is on a single joint at coarse steps: a loss of about (omega h)^2 of the speed once, at the step that starts
BDF2, which SuperDex plays as backward Euler. In Study 22 a free spin at 3.8 rad/s kept 9,985.5 per 10,000 at the
shipped step against 9,994.2 with the share ((omega h)^2 = 14.4 per 10,000), and 9,999.95 against 9,999.98 at 1/16 of
the step; a pendulum's first three swings at the shipped step read 9,989, 9,971 and 9,962 against 9,991, 9,978 and
9,972, and from 1/8 of the step on the two read the same.

**What it costs.** The Newton matrix is not exact with it, so the solver approaches the answer from one side. At
SuperDex's shipped tolerances (absolute 1e-3, relative 1e-6) the solve stops early, and the error grows as the step
shrinks. Under backward Euler on a light arm it was 0.13% of the speed over 1,600 steps at 1/16 of the step. Under
BDF2, with the share of library builds 13 to 15, it was an energy gain: an arm released level and swinging for 20 s reaches 10,009, 10,038 and 10,589 per 10,000 by its
28th swing at 1/4, 1/16 and 1/64 of the step ([probe 30](../validation/run_032_open_items/probes/)). Tightening the relative tolerance
alone does not remove it at the fine steps, where the absolute tolerance stops the solve. The configurations'
tolerances (absolute 1e-4, relative 1e-8) remove it: 9,994, 10,000 and 10,001 at the same steps. They cost 15% to 24%
more solver iterations a step on Meta's scenes under backward Euler ([run 030](../validation/run_030_design_probes/),
`probe_23_benchmark.txt`).

## How to use them

1. In a checkout of SuperDex at the commit in [`UPSTREAM_COMMIT`](../UPSTREAM_COMMIT), run
   `git apply patches/senua_contact.patch patches/senua_joint_limit.patch patches/senua_rotation_axis.patch
   patches/senua_inertia_transport.patch` from the root of the tree.
2. Build SuperDex as usual. With no switch set, its output is stock SuperDex's, byte for byte, on every play compared.
3. Set the switches you want before the process starts, each to `1` (the stick distance to a length in metres). A
   switch that is unset, empty or `0` is off. The combination this record recommends, with the
   registered decision behind each part, is [the recommended configuration](recommended-configuration.md).

## What the patches do not cover

Two independent reviews of the patch code, each given the code and each patch's stated purpose but not the study
results, read every patched line. Neither found anything that runs with the switches off and differs from stock.
The first found three defects with the switches on, corrected in library build 14 and validated in
[Study 15](studies/15-replication.md). The second found four more that, as the reviewer read the code, no play of the record reaches. They are
corrected in library build 15 ([Study 16](studies/16-second-review.md)): patch C anchoring contacts a mapped collider
missed at the start of a step, patch C's anchors surviving a body set to a new pose from outside, patch F giving
viscous friction a force its energy does not use, and patch C's table being destroyed at process exit before a
scene that uses it. Study 16 validated the teleport and viscous corrections against build 14; no rig then played a contact a
mapped collider misses or a scene destroyed while the process exits. [Study 19](studies/19-two-corrections.md) played
both: the table's lifetime is a use-after-free in build 14 when the library is loaded with `dlopen` after the program's
exit handler, and none in build 15; the missed contact is played on a deforming soft block, safe when off, and build
14's anchor left the cube at most 20 nm from where build 15 left it at the end of a play (198 nm at most during a play,
in the design probe). The
limits that stand:

- **Forward simulation only.** SuperDex can also assemble derivatives with respect to the previous state, for
  differentiable simulation. Patches B, C and F are not carried consistently into those derivatives, and patch G
  has no counterpart there. SuperDex's backward pass restores states, so with patch C on, computing a gradient also
  forgets the scene's anchors and changes the forward play that follows. Nothing in this record tests gradients.
  Leave the switches off for differentiable simulation.
- **Anchored friction (patch C) keeps its anchors outside SuperDex's captured state.** A restore forgets the scene's
  anchors, so each contact sticks afresh where the restored state puts it (since build 14); so does a body set to a
  new pose from outside (since build 15). Setting a body's speed does not: a speed given to a resting body keeps its
  stick. Creating or destroying a scene forgets only that scene's anchors. A contact absent at the start of a step
  and back within 5 mm of where it was last seen, and still closed, keeps its anchor; further away, it sticks afresh.
- **Patch C's table** holds one entry per contact (sample and collider feature) a scene has had, until the scene is
  destroyed, a state is restored or a body is placed. It is not pruned as contacts open, and every contact's lookup
  takes one lock shared by the process. A long-lived scene that spawns many bodies grows it.
- **Patch C uses the exact tangential friction Hessian** whatever SuperDex's `fittedSaturationHessian.contactFriction`
  says, because the anchored friction law needs it; with patch F on, SuperDex's fitted one is kept, as patch F says.
- **With SuperDex's `explicitNormals` on**, contacts it appends at the start of a step get a fresh anchor only when
  that collider already has contacts in the step; otherwise the stick distance acts as a plain smoothing width. With
  the colliding body's normal used for friction (`frictionWithColliderNormal` off), contact damping acts along that
  normal while the penalty acts along the distance gradient, so patch B's "never pulls" and its derivative hold only
  approximately. None of these settings is part of the recommended configuration, and none was studied with the
  patches.
- **Patch B's derivative at its bound** cancels the penalty stiffness exactly only where the distance gradient is
  of unit length along the contact normal, so near the rounded edges of a grid distance field the Newton matrix can
  lose positive definiteness (read from the code, not measured). It shapes only the solver's path, not its answer; the studies count every stopped and
  diverged step.
- **Patch D** leaves a range constraint that SuperDex marks saturated as stock computes it.
- **Patch G** follows how an integrator runs each step: its transport acts on a step formed as backward Euler, its
  BDF2 term (since library build 16) on a step formed as BDF2, and nothing on any other. SuperDex runs the first steps
  of BDF3, and the first step after a reset, as backward Euler and then BDF2, and those steps take the transport and
  the BDF2 term. The derived form costs a single joint about (omega h)^2 of its speed once, at the backward-Euler step
  that starts BDF2 ([Study 22](studies/22-bdf2-chain.md)). Patch G's Jacobians are not pruned when a scene is
  destroyed.
- **The switches** are on when set to anything but nothing or `0`: `00`, `0.0` and `false` are on.
  `SUPERDEX_STICK_DISTANCE` is read as a number in the C locale's form; a negative value or one that is not a number
  is off.
- **Safe when off is measured on the builds named.** Every patch file adds lines inside functions SuperDex itself
  runs, some of which run with every switch unset (patch C's anchor bookkeeping when a scene is made, destroyed or
  restored and when a body is placed from outside; patches D, E and G inside the solver's own functions), and SuperDex
  is compiled with `-ffp-contract=fast`, so another compiler could in principle schedule the
  stock arithmetic around them differently. Byte identity is measured, build by build: 64-bit in runs 031, 033,
  035 and 037 on the laptop, and in runs 039 and 040 on Linux against the laptop's registered files (every contact
  play the same to the byte; five long joint plays and 6 of 45 benchmark streams differ in their last digits across
  the two machines), and in SuperDex's shipped 32-bit build in runs 036, 041 and 044; library build 16 in 64-bit on
  Linux in run 052 (Study 22), and not in 32-bit. The contact corrections switched
  on are measured in 32-bit too ([Study 20](studies/20-thirty-two-bit.md)); the joint, limit, rotation and benchmark
  corrections in 64-bit only.

## Licence

SuperDex is Apache-2.0 by Meta Platforms, Inc. and affiliates. The patch files change SuperDex source and are
offered under Apache-2.0. A copy is in [`patches/LICENSE`](../patches/LICENSE).
