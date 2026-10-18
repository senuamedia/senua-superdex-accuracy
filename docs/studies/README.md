# The studies

These are the studies of the Senua AI Robotics Core's first deep dive, on Meta's SuperDex Physics.

Each study is one pre-registration. Its design, its claim and its rules were written down and committed before any
of its data existed, and it was run once. Nothing was re-run to pass, with one disclosed exception: in Study 13 the
registered play script gave the FR3 gripper the wrong assets folder, so its four plays did not run; with the path
set right and no rule or parameter changed, those four plays were made once, and the rules were measured again,
with the first reading kept beside the second
([run 029](../../validation/run_029_end_to_end/README.md), `reading_before_the_fr3_plays.txt`). Each page keeps the
outcome as it was recorded, the ones that did not hold in full beside the ones that did.

Elsewhere in this repository a study is called a registration: Study 5 is "the fifth registration" and its rules
are in `PREREGISTRATION_05.md`.

| | Study | What it asked | Outcome | Registered | Run |
|---|---|---|---|---|---|
| 1 | [What SuperDex's accuracy settings cost](01-accuracy-settings.md) | Can the cost of SuperDex's accuracy settings be read, in order, on Meta's three scenes? | 16 of 27 cells held | 13 Oct 2026 | [002](../../validation/run_002_instrument/README.md) |
| 2 | [The same, with independent calibration](02-independent-calibration.md) | The same, with the first study's two design weaknesses removed | 25 of 36 cells held | 13 Oct 2026 | [005](../../validation/run_005_instrument/README.md) |
| 3 | [Whose failure is it](03-whose-failure.md) | Is the disorder the instrument's, the rig's, the scene's or the engine's? | 5 rules of 6 held | 13 Oct 2026 | [008](../../validation/run_008_instrument/README.md) |
| 4 | [The cause, on one cube and the ground](04-one-cube-and-the-ground.md) | What in SuperDex's contact does it, on a case with a right answer? | Every rule held | 13 Oct 2026 | [010](../../validation/run_010_contact/README.md) and [011](../../validation/run_011_counts/README.md) |
| 5 | [One setting and three contact patches](05-contact-patches.md) | Is each correction required, correct and safe? | Every rule held | 14 Oct 2026 | [013](../../validation/run_013_counts/README.md) |
| 6 | [Joints and the integrator](06-joints.md) | Do joints behave, on one arm with nothing touching it? | Every rule held | 14 Oct 2026 | [015](../../validation/run_015_joints/README.md) |
| 7 | [A slide that ends, and two moving bodies](07-slide-and-two-bodies.md) | Does a slide end, and is contact right between two bodies that both move? | Every rule held | 14 Oct 2026 | [017](../../validation/run_017_counts/README.md) |
| 8 | [Joint limits](08-joint-limits.md) | Does a joint limit hold back a joint that is leaving it? | 5 rules of 6 held | 14 Oct 2026 | [019](../../validation/run_019_limits/README.md) |
| 9 | [The rotation vector of a small rotation](09-rotation-axis.md) | Why does the solver stop on steps where nothing is happening? | Every rule held | 14 Oct 2026 | [021](../../validation/run_021_rotation/README.md) |
| 10 | [Why the solver stops on ant](10-ant-stops.md) | Why does the solver stop on `ant`, and what does the joint limit patch add? | Every rule held: the nine rules, 38 rule lines of 38 | 14 Oct 2026 | [026](../../validation/run_026_ant_stops/README.md) |
| 11 | [Friction at an impact](11-friction-at-impact.md) | Can friction reach an impact on time without costing the solver? | 6 rules of 7 held (16 rule lines of 17), F3 failed; patch F joins | 14 Oct 2026 | [027](../../validation/run_027_friction/README.md) |
| 12 | [The loss on joint motion](12-joint-motion.md) | Can a free arm and a free chain keep their speed and momentum at the shipped step? | 8 of its 10 rules held (31 of 33 lines); patch G joins; G2's shortfall is SuperDex's shipped solver tolerance, G8's rule was posed against stock's value, and patch G has no defect under backward Euler (runs 030 and 049) | 14 Oct 2026 | [028](../../validation/run_028_joint_motion/README.md) |
| 13 | [The complete patch list, end to end](13-end-to-end.md) | Do the corrections hold together, and do they carry over to point clouds, deformable bodies and a gripper? | 65 rule lines of 68 held; J4, D6 and G2 each failed on one line | 14 Oct 2026 | [029](../../validation/run_029_end_to_end/README.md) |
| 14 | [The fixes for the five open items](14-open-items.md) | Does each fix hold on fresh parameters, and does the configuration with every fix pass every earlier test? | 142 rule lines of 150 held; 45 rules of 50, I4a, I4c, D4, D6 and A5 failed | 14 Oct 2026 | [032](../../validation/run_032_open_items/README.md) |
| 15 | [Replication, and the code review's corrections](15-replication.md) | Do the fixes replicate on fresh numbers, and do the review's corrections work? | 117 rule lines of 121 held; 7 rules of 10, V3, V6 and V8 failed; the fixes of items 1, 2, 4 and 5 held on fresh numbers, item 3 and the deformable bodies failed a rule each and stay open; the corrections validated; the accurate configuration not validated end to end; a limit of patch G under BDF2 on a chain found, its cause in stock SuperDex (run 049) | 15 Oct 2026, amended the same day before run 034 | [034](../../validation/run_034_replication/README.md) |
| 16 | [The second code review's corrections, and 32-bit](16-second-review.md) | Is build 15 safe when off in 64-bit and 32-bit, do its corrections work, and do the deformable bodies hold read right? | Every rule held as the registered runner reads them (10 rules, 26 rule lines of 26); the runner reads C3 over the correction plays, and read literally over every play made on build 15 it would fail, since build 15's replays of earlier studies include plays that stop by design; build 15 safe when off in 64-bit and 32-bit on every play it was given; the second review's teleport and viscous corrections validated; the identity runs found to hold only part of the record | 15 Oct 2026 | [036](../../validation/run_036_registration16/README.md) |
| 17 | [The whole record made again on the library of record](17-whole-record.md) | Does library build 15 make the whole record of Studies 3 to 13 again, and can every study be made again by its own scripts? | 3 rules of 4 held: 2,091 of 2,099 files the same, every file made with no switch among them; W1 failed on two files, one play Study 5 reported, changed by a later build | 15 Oct 2026 | [037](../../validation/run_037_whole_record/README.md) |
| 18 | [The stock plays of Studies 14 and 15 on the library of record](18-stock-plays.md) | Does build 15 make again the 25 stock plays of runs 032 and 034 that run 035 made on stock? | Both rules held: 391 of 391 and 225 of 225 files byte for byte, the 25 stock plays among them | 15 Oct 2026 | [038](../../validation/run_038_stock_plays_14_15/README.md) |
| 19 | [The two corrections no rig had played](19-two-corrections.md) | Does a play reach the anchor table's lifetime and a contact a mapped collider missed, does build 14 show them, and does build 15 remove them? | Every rule held: the lifetime defect shown in build 14 and gone in build 15; the missed contact played and safe when off, builds 14 and 15 ending at most 20 nm apart | 15 Oct 2026 | [043](../../validation/run_043_study19/README.md) |
| 20 | [The corrections in 32-bit](20-thirty-two-bit.md) | Do the corrections, switched on, do in SuperDex's shipped 32-bit precision what they do in 64-bit? | 6 rules of 7 held, as predicted: every test of what the contact corrections do passes in 32-bit; free flight and the refinement chain are 32-bit's own limits | 15 Oct 2026 | [044](../../validation/run_044_study20/README.md) |
| 21 | [Patches F and G and the recommended configuration on fresh numbers](21-recommended-configuration.md) | Under the recommended configuration, on fresh numbers, do patches F and G meet every rule of their registrations, and the configuration every backward-Euler end-to-end rule, the order test included? | 117 rule lines of 118 held; 44 rules of 45, F3 failed. Patch G recorded as required, correct and safe under backward Euler; F3 failed on the second suite's T16, whose cause is the measuring program's reading of each cube's mass in whole units of 10 g, so patch F's decision and the end-to-end decision did not fire | 15 Oct 2026 | [051](../../validation/run_051_study21/README.md) |
| 22 | [Patch G under BDF2 on a chain](22-bdf2-chain.md) | Under BDF2, on fresh numbers, does the derived form of patch G replace its current form? | Every rule held (11 rules, 66 rule lines of 66): a chain second order with the derived form, nothing changed with the switch off or under backward Euler; the derived form is patch G (library build 16) | 15 Oct 2026 | [052](../../validation/run_052_study22/README.md) |
| 23 | [Patches F and G and the recommended configuration on fresh numbers, on library build 16](23-recommended-configuration-again.md) | Under the recommended configuration, on fresh numbers and library build 16, with momentum between two cubes read by `pairg`, do patches F and G meet every rule, and does the configuration meet every end-to-end rule? | 117 rule lines of 118 held (44 rules of 45): patch F recorded as required, correct and safe, patch G's decision replicated; one line of P2 failed (the point-cloud floor's friction over a one-step impact at step 1/4), so the configuration is not recorded as validated end to end | 15 Oct 2026 | [055](../../validation/run_055_study23/README.md) |

Registered is the day a study's rules were written down, before any run of it existed; Run is the run that gave its
result, and its README gives the day it was made. Each registration states its order in its opening line; the
record's full history, which shows it commit by commit, is kept by Senua AI ([how to read a study
page](#how-to-read-a-study-page)).

## How one study led to the next

1. **Study 1** tried to read the cost of three of SuperDex's accuracy settings on Meta's benchmark scenes. It did
   not hold in full: its calibration readings were not independent, a weakness of its design, and three cells came
   out of order, which the run could not attribute (on `cart_pole`, an unstable scene or a reference that had not
   converged; on `ant`'s contact, no cause given). It did show, with no instrument, that the solver as shipped
   stops before it converges on most steps of two scenes.
2. **Study 2** gave every calibration reading its own noise and used references only where they converge. The
   finest time-step and contact settings came out of order. The raw streams show the time-step disorder with no
   instrument; the plain subtraction of its streams, made later in Study 3's design probe, shows the contact
   disorder too.
3. **Study 3** asked whose failure that is. The instrument orders every gap as plain arithmetic does, the rig
   repeats exactly, and the scenes do not amplify a tiny change. On `half_cheetah` the time-step chain is in order
   without the ground and out of order with it. The rule on the rig's stepping fired on `cart_pole`, in one fold, so
   the registered conclusion, that the failure belongs to ground contact, did not fire, and the rig's stepping was
   not cleared.
4. **Study 4** took it down to one cube and the ground, where the right answer is known, and found three things:
   the time step sets the bounce, friction is late at an impact, and nothing holds at rest.
5. **Study 5** turned the findings into one setting and three patches, each held to five checks.
6. **Study 6** took the same kind of test to joints and found the cost of the default integrator and a joint
   friction that creeps.
7. **Study 7** asked what Study 5 had not, and caught a fault in our own patch. The patch was withdrawn and
   corrected.
8. **Study 8** tested joint limits, found that a damped limit pulls, and corrected it.
9. **Study 9** looked inside the solver steps that stop without converging, found that SuperDex's quaternion gives
   the x axis to any rotation of 2e-9 rad or less, and corrected it. That closed two open items and cleared our own
   patches of a cost we had put on them.
10. **Study 10** asked why `ant`'s solver still stops on stock contact, and more often with patch D. It is SuperDex's
    default estimate of friction's normal force: SuperDex's own `explicitNormals` removes almost all of it, and patch
    D adds stops only of that kind.
11. **Study 11** put friction at an impact on time. Patch F gives friction the normal force of the step being solved
    with SuperDex's fitted Hessian, and the solver keeps converging. F3 failed: a light cube's slip on one pair
    falls short at 1/16 of the step with and without patch F, and at the shipped step patch F moves it out of its
    band; the cause is SuperDex's default grid distance field (run 030), not patch F, which needed no change
    (run 048): on the recommended configuration's grid the slip is right with patch F.
12. **Study 12** found the cause of the loss on joint motion, a link's inertial force projected at the wrong node,
    and corrected it with patch G and SuperDex's own Newton-Euler inertia, which joined the recommended
    configuration as its decision said. G2 (one fine-step arm play kept 9,987 per 10,000 of its speed, against
    9,990) and G8 (a slip that moved to its right answer) each failed on one reading, so the registration records
    patch G as measured; G2's cause is SuperDex's shipped solver tolerance (run 030), and a review of patch G found
    no defect in it under backward Euler (run 049).
13. **Study 13** played every earlier test under the final configuration, and took it to point-cloud contact,
    deformable bodies and a gripper. 65 rule lines of 68 held, every rule of point-cloud contact and of the
    gripper's final configuration among them, and on fresh commands `ant`'s solver stopped on no step. J4 (a slip
    that moved to its right answer, away from stock's value), D6 (a soft cube on a tilt moved 0.37 mm, past 0.3 mm)
    and G2 (stock's FR3 hand) each failed on one line, so the decision to record the patch list as validated end
    to end did not fire.
14. **Study 14** tested a fix for each of the five items Study 13 left open. Four held every rule of their own:
    items 1 to 3 with SuperDex's own settings (the grid cell, the solver's tolerances, the smoothing), and item 5
    with patch G's share by integrator (library build 13) and BDF2 at 1/16 of the step as an accurate
    configuration. Item 4's fix, a correction to our rig, failed (I4a, I4c); its cause is the shipped tolerance.
    With D4 and D6 failed under the final configuration and A5 under the accurate one, neither
    decision fired: items 1 to 4 did not join the recommended configuration by this registration, and the accurate
    configuration was not recommended by it. Its eight failed rule lines, in five rules, were probed after the run.
15. **Study 15** played the fixes again on fresh numbers and validated a first code review's corrections. The fixes
    of items 1, 2, 4 and 5 held every rule line; item 3 failed on one stopped step and the deformable bodies on two
    lines, so the decision that records every fix as replicated did not fire and those stay open. An amendment,
    pushed before run 034, moved the accurate configuration to the final tolerances; it held over 20 s, but failed
    on a chain's angular momentum, so it is not recorded as validated end to end. Under BDF2 patch G's earlier form
    loses a chain's angular momentum at first order; the cause is how stock SuperDex starts a jointed body's BDF2
    stage (run 049), and by Study 22's decision patch G under BDF2 takes a derived form.
16. **Study 16** validated two of a second code review's four corrections, the teleport and the viscous friction
    (Study 19 plays the other two), found library build 15 safe when off in SuperDex's
    shipped 32-bit build and in 64-bit on the first two studies, and read the deformable bodies as Study 15's failures
    said they should be. It also found that the identity runs hold only part of the record.
17. **Study 17** made the whole record of Studies 3 to 13 again on library build 15, each study by its own scripts in
    a fresh clone: 2,091 of 2,099 files the same, every file made with no switch among them. W1, on the files made
    under switches, failed on two files of 1,266: one play, which Study 5 reported and did not decide on, made byte
    for byte on the build of its time and changed by a later library build (34 steps stopped and 120 diverged,
    against 35 and 121). So its decision, that every result made under switches stands for build 15, did not fire.
18. **Study 18** made the stock plays of Studies 14 and 15 again on library build 15, byte for byte, which the identity runs had
    made on the stock library.
19. **Study 19** played the two corrections of library build 15 that no rig had played, and both held: the anchor table's lifetime,
    with the library loaded after the program's exit handler, and a contact a deforming soft body missed.
20. **Study 20** validated the contact corrections, switched on, in SuperDex's shipped 32-bit precision, on fresh cubes with 64-bit
    beside them; free flight and the refinement chain are 32-bit's own limits.
21. **Study 21** held patches F and G and the recommended configuration under backward Euler to every rule of their
    registrations again, on fresh numbers, with the order test played at the configuration's own tolerances. 117 rule
    lines of 118 held. Every rule of patch G held, so patch G is recorded as required, correct and safe under the
    recommended configuration. F3 failed on one line, momentum between two cubes, with and without patch F; its cause
    is the measuring program, which reads each cube's mass in whole units of 10 g, where the fresh pair's masses are
    not whole multiples of 10 g. So the decisions on patch F and on the configuration end to end did not fire; the
    measure `pairg` reads mass in grams.
22. **Study 22** put patch G's derived form under BDF2 head to head with its earlier form on fresh chains. Every rule
    held: with the derived form a chain's angular momentum and energy are second order, and nothing changes with the
    switch off or under backward Euler. By its decision the derived form is patch G under BDF2 (library build 16),
    which closes the open item on patch G under BDF2.
23. **Study 23** put Study 21's rules to library build 16 on fresh numbers, with momentum between two cubes read by
    `pairg`. 117 rule lines of 118 held. Every rule of patch F held, so patch F is recorded as required, correct and
    safe under the recommended configuration, and every rule of patch G held, replicating Study 21's decision. One
    line of P2 failed, the point-cloud floor's friction over a one-step impact at step 1/4 (5.1% above the law, bound
    4%), so the decision on the configuration end to end did not fire.

## How to read a study page

Every page opens with the table below and then has some of the parts after it, under headings that vary a little.
The pages of Studies 1 to 9 have all of them: Study 1 opens with "The question" in place of why it was asked, Study 5
gives what was played as "The suite", and Study 8 ends with "What it shows, and what it does not". The pages of
Studies 10 to 13 have no "What was played" and give the rules in short under "The rules"; their registrations carry
what was played and the rules in full. From Study 14 on the pages give why it was asked, the result, and the failures
with their causes, and the registration carries what was played and the rules; the pages of Studies 21 and 22 also say
in short what was played.

| Part | What it tells you |
|---|---|
| The table at the top | The registration, when it was registered, the run of its result, every run, the data, and which programs played and measured it |
| Why it was asked | What the study before it left open |
| What was played | The scene and its registered numbers, none of which was used in the design probes |
| The rules fixed in advance | What had to be true for the claim to hold. Each rule could fail |
| The result | Each rule as measured, with the numbers |
| What it means, and what it led to | What the result settles, what it does not, and the next question |

From Study 10 on, a run's reading judges each rule on one or more `RULE` lines (one a step, a scene or a
configuration, say), so the rules are counted two ways. The pages say "rules" when they count registered rules, such
as C3, and "rule lines" when they count those lines.

Every registration's rules are as registered (Study 15's as amended before its run); the file paths and links in the
registrations name the repository's folders as published.

Three things a registration may say that a reader should read with the record beside it:

- **"Patches A to D".** Where the identity script, Study 19's play script and the registrations and runs that name
  their parts say "patches A to D", the configuration sets the switches of patches A, B and C only (`AB` and `CD`;
  patch C has two switches), and the suites' "A to E" those and patch E's; the benchmark's "A to E" does set patch
  D's switch. Patch D acts only at a joint limit, which the contact suites and the hopping cube do not have. The
  pages and the run READMEs say patches A to C, and A to C and E.
- **A patch file named by its path.** The earlier registrations name `patches/senua_contact.patch` and the other
  patches by the paths of their day, with a checksum. The checksum names the form: the earlier forms are in
  [`patches/superseded/`](../../patches/superseded/), named for the registration that last used them, and
  [`patches/README.md`](../../patches/README.md) gives every form's checksum. The form the twenty-second registration
  names as `patches/in_design/senua_inertia_transport_bdf2_derived.patch` (c3e1442befd6dee9...) is
  `patches/senua_inertia_transport.patch`, by that registration's decision.
- **What a design probe was read to show.** A registration's background cites the design probes as they were read
  when it was written, and keeps its words. The probe's README gives only numbers that are in its kept files and
  readings those files bear out; where the two differ, the README is the reading of record.

The record is published as one snapshot; Senua AI keeps its full history, in which every registration was committed
before its run. Where a registration says "this commit", it means the commit that registered it. The checksums the record cites for an earlier state of a file (a registered play script, runner or
measure) are of the state committed in that history; [`measure/README.md`](../../measure/README.md) maps each
measuring file and runner the registrations cite to the published file and says what differs. In the recorded
outputs, paths under the home folder of the machine they were made on are shortened to `~`, and the outputs that
print a commit of this repository (run 038's `clone_commit.txt`, run 045's log, run 046's `rigs.txt`) name commits of that
history.

## The record behind each page

| What | Where |
|---|---|
| The design and rules, as registered | [`preregistrations/`](../../preregistrations/), `PREREGISTRATION_01.md` to `PREREGISTRATION_22.md` |
| Every run, as produced | [`validation/`](../../validation/), runs 001 to 044 and 051 to 053, each with its own README (run 053 is the probe for Study 21's order rule); [run 045](../../validation/run_045_fresh_clone/README.md) is not a study's run but the publication check of the whole record, and [run 046](../../validation/run_046_stock_rigs/README.md) a check for publication that the plays called stock on the chain, deformable and gripper rigs are stock, [run 047](../../validation/run_047_linux_bench_off/README.md) one that the benchmark streams are safe when off on Linux, [run 048](../../validation/run_048_patch_f_review/README.md) a review of patch F, [run 049](../../validation/run_049_patch_g_review/README.md) a review of patch G and the derivation of its form under BDF2, and [run 050](../../validation/run_050_patch_c_trace/README.md) the trace of one play of Study 5 |
| The patch ledger | [`patches/README.md`](../../patches/README.md) |
| The measuring programs | [`measure/`](../../measure/) |
