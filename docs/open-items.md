# What is open

This is the open list. Everything on it gets the same treatment as the studies: a rule written first, one run, the
result recorded as it falls. Nothing here is hidden in a footnote.

Back to the [documentation index](README.md).

## At a glance

| | Item | What is known |
|---|---|---|
| Open | The recommended configuration end to end, on fresh numbers | [Study 23](studies/23-recommended-configuration-again.md) held 117 rule lines of 118 on library build 16: every rule of patches F and G held, and both are recorded as required, correct and safe (closed, below). One line of P2 failed: on the point-cloud floor, friction over a one-step impact read 4,173 per 10,000 at step 1/4 against the law's 3,970, 5.1% above where the bound is 4% (item 2). So the configuration end to end is not recorded as validated |
| Open, and a known cost | The point-cloud ripple's fix (item 2), and the sheet at the tighter tolerances | The ripple came from the cube's own grid and contact damping at its edges. With the cell at 1/32 and 1 mm smoothing, friction and the slip read within 1 in 100 on the sheet, and the fix held its rules in [Study 14](studies/14-open-items.md) (P1, P2 and A4, 16 lines of 16). But the sheet's solve cannot reach an absolute tolerance of 1e-4, so its steps stop on SuperDex's rule for an update too small to matter: 1 in 840 under the final configuration, a third under BDF2 at 1/16. That one step failed Study 15's V3, so what V3 concerns stays open. Friction, hold and slip read as at the shipped tolerances to the last digit, and the rest within 9 mN of it ([Study 15](studies/15-replication.md)). In [Study 23](studies/23-recommended-configuration-again.md) no step stopped at the iteration limit, but friction over a one-step impact read 5.1% above the law at step 1/4 (1.5% at the shipped step), against a bound of 4%, so its P2 failed on that line |
| A known cost | A soft body rocks back after a slide | On SuperDex's compliant deformable contact a soft cube pitches forward as it slows, and its centre comes back 0.3 to 0.9 mm after the stop, with or without the patches ([probes after run 032](../validation/run_032_open_items/probes/), [run 036](../validation/run_036_registration16/)) |
| Recorded as limits of 32-bit SuperDex, as Study 20 decided | Free flight, and the refinement chain with the corrections | In SuperDex's shipped 32-bit precision, free flight (T01) reads 10266 2433 5000 5000 21465840 per 10,000 against 5,000, the same with and without the corrections. The refinement chain (T08) fails both ways: without the corrections it rises from 1/4 of the step on, as stock does in 64-bit; with them it falls to 1/16, rises once and falls again, where in 64-bit it falls at every step. In 64-bit both pass under the corrections ([Study 20](studies/20-thirty-two-bit.md)) |
| Not testable in software | Anything against a real robot | Every result is the engine against a right answer or against itself |

Closed, each by a registered decision that fired (the last four rows by later checks, not registered):

| Item | Closed by | What it was |
|---|---|---|
| The solver at the finest steps with the corrected contact | [Study 9](studies/09-rotation-axis.md), patch E | A defect in SuperDex's quaternion, not a cost of our patches. 551 and 728 stopped steps on the suites became 0 |
| Stock's solver after two free bodies separate | [Study 9](studies/09-rotation-axis.md), patch E | The same defect. 930 steps at the iteration limit became 0 |
| Why `ant`'s solver stops, and more often with patch D | [Study 10](studies/10-ant-stops.md) | SuperDex's default estimate of friction's normal force. Its own `explicitNormals` removes 95% to 98% of the stops, and patch D adds stops only of that kind. With patches A to F, no step of 86,400 stopped |
| Soft bodies and cloth | [Study 13](studies/13-end-to-end.md), where D6 failed; [Study 16](studies/16-second-review.md)'s decision records the deformable bodies as right under every configuration, read by their furthest point and their drift | As shipped they fall, hang, rest and slide to their answers; a creep on a tilted floor is stopped by the corrections. The cantilever, a rod, is below |
| Three defects found by the first code review | Library build 14, [Study 15](studies/15-replication.md) | A switch set to `0` was on; a scene's creation or destruction dropped every scene's anchors; a restored state kept stale anchors. Corrected and validated |
| Two of the second code review's defects: anchors kept through a teleport, and viscous friction under patch F | Library build 15, [Study 16](studies/16-second-review.md) | On build 15 a body set to a new pose from outside forgets its anchors (a held cube moved 2 mm goes on with the push; on build 14 it is pulled back); viscous friction keeps the start-of-step force (the landing is byte-identical with and without patch F) |
| Two readings that did not test what they meant to | [Study 16](studies/16-second-review.md) | Read by its furthest point, every slide lands within 0.03% of its law; read by its drift between the second and the last quarter, the hold on the tilt does not creep |
| Safe when off in SuperDex's shipped 32-bit build | [Study 16](studies/16-second-review.md) | The first study's 45 streams and the second's 3 in 32-bit, byte for byte on library build 15, and 6 with every switch set to `0` |
| 25 stock plays of runs 032 and 034 not yet made on build 15 | [Study 18](studies/18-stock-plays.md) | Run 035 had made them on the stock library, as those runs had them; made again with every stock rig loading build 15, byte for byte (391 of 391 and 225 of 225 files, the review part's 3 plays on library build 13 as registered). Every registered play of Studies 1 to 16 made with no switch has been made again on build 15 |
| Two of the second code review's defects, corrected and not played: a contact a mapped collider missed, and the anchor table's lifetime | [Study 19](studies/19-two-corrections.md) | Both reached by a play ([run 042](../validation/run_042_two_corrections/README.md)). The table's lifetime: a use-after-free in build 14 when the library is loaded with `dlopen` after the program's exit handler (120 valgrind errors), none in build 15. The missed contact: played on a soft block that deforms under a hopping cube, safe when off; builds 14 and 15 end at most 20 nm apart (198 nm at most during a play, in the design probe) |
| The corrections switched on in 32-bit arithmetic | [Study 20](studies/20-thirty-two-bit.md) | The design probe (run 041), then on fresh cubes: every test of what the contact corrections do passes in 32-bit (T02 to T07, T09, T10 and T11 to T17), safe when off, with 64-bit beside them as the control. The joint, limit, rotation and benchmark corrections were not played in 32-bit |
| The integrator's loss on joint motion, under backward Euler | [Study 21](studies/21-recommended-configuration.md)'s decision on patch G, after [Study 12](studies/12-joint-motion.md)'s did not fire (G2 and G8 failed) | Each link's inertial force was projected at the wrong node. Patch G with SuperDex's Newton-Euler inertia is recorded as required, correct and safe under the recommended configuration: on fresh numbers every rule G1 to G9 held, 30 rule lines of 30; a free arm keeps at least 9,999.6 of every 10,000 of its speed, a free chain its energy within 132 per million and its angular momentum within 14 parts per million |
| Patch G under BDF2 on a chain | [Study 22](studies/22-bdf2-chain.md)'s decision: the derived form, in place of the share of 1/3, is patch G under BDF2 (library build 16) | With the share a free two-link chain lost angular momentum at first order under BDF2 (1,540 parts per million over 2 s at 1/16 of the step, [Study 15](studies/15-replication.md)), because stock SuperDex starts a jointed body's BDF2 stage from the kinematics of the combined joint angles ([run 049](../validation/run_049_patch_g_review/README.md)). With the derived form, on three fresh chains, momentum and energy fall 3.56 to 4.59 times a halving of the step on every halving ruled (second order), the momentum drift at 1/16 is 5 or 6 parts per million, and nothing changes with the switch off or under backward Euler on every play compared. Its cost: a single joint loses about (omega h)^2 of its speed once, at the step that starts BDF2 |
| Friction one step late at an impact | [Study 23](studies/23-recommended-configuration-again.md)'s decision on patch F, after [Study 11](studies/11-friction-at-impact.md)'s and [Study 21](studies/21-recommended-configuration.md)'s did not fire (F3 failed in each: a carried cube's slip, whose cause is SuperDex's default grid, [run 048](../validation/run_048_patch_f_review/README.md); then momentum between two cubes, whose cause is the measuring program, [run 051](../validation/run_051_study21/README.md)) | Friction took the normal force from the start of the step, so it met an impact one step late. With patch F it takes the normal force of the step being solved, and is recorded as required, correct and safe under the recommended configuration: on fresh numbers every rule F1 to F6 held, 14 rule lines of 14; over an impact friction is within 1 in 1,000 of Coulomb's law at every step (3,879 or 3,880 per 10,000 against 3,880), and the momentum between two cubes is kept within 111 parts per million as `pairg` reads it |
| The chain, deformable-body and gripper plays called stock were made with rigs built against the patched library, no switch set | [Run 046](../validation/run_046_stock_rigs/README.md), a check for publication, not registered | All 116 such plays of runs 028, 029, 032, 034 and 036 made again with the rigs built against the stock library itself: 136 of 136 files byte for byte the same as registered, with a positive control |
| Whether the patches with no switch set change the benchmark streams on Linux, where four `ant` streams differ from the macOS record | [Run 047](../validation/run_047_linux_bench_off/README.md), a check for publication, not registered | Stock and patched with no switch, built on the same Linux machine, make the same bytes on all 38 streams of the identity check, statistics included; the four that differ from the macOS record differ with stock too |
| Study 11's F3: a light cube slipping on a heavy one read 4.2% short of Coulomb's law with patch F at the shipped step (0.4% without it) | [Run 048](../validation/run_048_patch_f_review/README.md), a review of patch F for publication, not registered | Not patch F, which needed no change: SuperDex's default grid distance field rounds the block's edge within its last cell (run 030), the same with and without the patch, and stock's friction there runs up to 55% above the law, which hid it at the shipped step. Patch F's code has no defect. On the recommended configuration's grid the slip reads the law at every step with and without patch F (4,409 to 4,413) |
| One play of Study 5 that every library build after build 4 makes with one fewer stopped step and one fewer diverged step ([Study 17](studies/17-whole-record.md)) | [Run 050](../validation/run_050_patch_c_trace/README.md), a trace for publication, not registered | Not a logic difference: a three-line block of patch C's correction that never runs with its switch unset, yet changes how the compiler rounds one term of anchored friction's Hessian under SuperDex's -ffp-contract=fast; the algebra, the force and its energy are unchanged. Only a play whose solver often fails carries that last-bit change into its output; Study 5's conclusion on it holds. Build 5's form also corrected, on a path no registered play reaches, viscous friction under the recorded form, which it applies as stock does |

Corrected on their own rules, where the registered decision that would close them did not fire:

| Item | Studies, and the decision that did not fire | What it was |
|---|---|---|
| Contact on point clouds | [Study 13](studies/13-end-to-end.md). Every point-cloud rule held (P1, P2); J4, D6 and G2 failed on other tests, so the same decision did not fire | As shipped, friction over an impact is 3.8 times Coulomb's law and a pushed cube creeps; corrected, within 5% and holding |
| A two-finger gripper holding a cube | [Study 13](studies/13-end-to-end.md). Every rule of the final configuration held; G2 failed on stock's FR3 hand, and with J4 and D6 the same decision did not fire | A gripper, hand-built and the FR3 hand: as shipped each finger presses right, the FR3 hand splits the weight 1.1% and 1.2% off even, and the cube creeps out; corrected, the forces are within 1 in 100 and it holds. Manipulation in the hand was not played |
| A light cube slipping short on a heavy one | [Study 14](studies/14-open-items.md) (I1) and, on fresh numbers, [Study 15](studies/15-replication.md) (V1). Study 14's decision that items 1 to 4 join did not fire (I4a, I4c, D4 and D6 failed), nor Study 15's that records every fix as replicated (V3 and V6 failed) | SuperDex's default grid distance field rounds a box's edges within its last cell. Each mesh body's cell at 1/32 of its side: the cube and the block within 1 in 1,000 of their laws on two fresh pairs |
| Patch G's error at SuperDex's shipped tolerances | Studies 14 (I2) and 15 (V2). The same two decisions did not fire | The solver stopped short with patch G's inexact Newton matrix. At 1e-4 and 1e-8 a fresh arm keeps its speed within 1 in 10,000 and a fresh chain its energy and momentum |
| A cantilever short by half an element | Study 14, where I4a and I4c failed at SuperDex's shipped tolerances, and Study 15, where V4 held at the final configuration's; Study 15's decision that closes item 4 did not fire (V3 and V6 failed) | The rig's clamp, then SuperDex's shipped tolerance on a static equilibrium. Held across the clamp at the final configuration's tolerances, three rods within 0.009% of the textbook |
| Backward Euler's damping of a swing a force drives | Studies 14 (I5) and 15 (V5, V9). Study 14's decision to recommend the accurate configuration did not fire (A5 failed), nor Study 15's to record it, at the final configuration's tolerances, as validated end to end (V8 failed) | The accurate configuration, BDF2 with patch G at 1/16 of the step and the final configuration's tolerances: over 20 s every swing between 9,999 and 10,001 per 10,000. Its chain limit is closed by Study 22's decision (above) |
| BDF2 with patch G gaining energy at the shipped tolerances | The amendment to Study 15. V9 held, its required line at the shipped tolerances (10,037) among them; V8 failed, so the decision that records the accurate configuration at the final configuration's tolerances as validated end to end, and withdraws the shipped-tolerance form, did not fire | Found by the probes after run 032; corrected by the accurate configuration at the final configuration's tolerances |

## Open

### 1. The recommended configuration end to end, on fresh numbers

**What is measured.** [Study 23](studies/23-recommended-configuration-again.md) held patches F and G and the
recommended configuration under backward Euler to every rule of their registrations, on numbers no earlier study used
and on library build 16, with the momentum between two cubes read by `pairg`. 117 rule lines of 118 held. Every rule
of patch F held (14 of 14) and every rule of patch G (30 of 30), so both are recorded as required, correct and safe
under the recommended configuration (closed, above). `half_cheetah` and `ant` stayed in order in 3 folds of 3.

**The line that failed.** P2 asks that, under the configuration on the point-cloud floor, friction over a one-step
impact be within 1 in 25 of the law (3,970 per 10,000) at steps 1 and 1/4. It read 4,030 and 4,173: 1.5% above at
the shipped step and 5.1% above at step 1/4. Stock on the same cube reads 14,219 and 4,669, and over the 0.1 s after
the impact the configuration reads 4,011. The registration named the risk before the run: on a discrete floor this
reading moves by up to 3% with where the cube lands among the floor's nodes. Its cause has not been traced
([run 055](../validation/run_055_study23/README.md)). So the decision that would record the configuration as
validated end to end did not fire.

**Before it.** [Study 21](studies/21-recommended-configuration.md) held 117 rule lines of 118 on library build 15;
its one failure, F3's T16 (momentum between two cubes), was the measuring program's, whose `pair` measure reads each
mass in whole units of 10 g ([run 051](../validation/run_051_study21/README.md), "The diagnostic"). `pairg` reads
whole grams, and Study 23 read T16 at 83 to 111 parts per million against 500.

**What decides it.** A registration that traces how the point-cloud floor's nodes move friction over a one-step impact
at the finer steps, then puts the configuration to every rule again on fresh numbers.

### 2. The point-cloud ripple's fix

[Study 14](studies/14-open-items.md) tested the fix for the ripple on point-cloud contact (each mesh body's grid cell
at 1/32 of its side and 1 mm smoothing), and its rules held, 16 lines of 16. [Study 15](studies/15-replication.md)
played it again on a fresh cube: every reading held, but under the final configuration one step of 840, at 1/4 of
the step, stopped, against 1 in 1,000 allowed, so V3 failed and what it concerns stays open. The step did not reach
the iteration limit (the play's most iterations were 8), so it stopped on SuperDex's rule for an update too small to
matter. No trace was kept of that step; the run's README reads it as the sheet's residual floor below the absolute
tolerance of 1e-4. [Study 21](studies/21-recommended-configuration.md) held every point-cloud line on a fresh cube, the
impact 3,912 and 3,938 per 10,000 against the law's 3,910. [Study 23](studies/23-recommended-configuration-again.md)
held every point-cloud line but one on another fresh cube: friction over a one-step impact read 4,173 at step 1/4
against the law's 3,970, 5.1% above where the bound is 4% (item 1).

### 3. Anything against a real robot

Every result here is the engine against a known right answer, or against its own finer settings. That is the right
place to start, because a simulator that departs from physics on one cube will not agree with a real machine. But
it is not a measurement of the gap to a real machine. Reading a recorded machine against its simulation is where
this work goes next.

## Other limits of what is here

- One sensor channel a scene in Studies 1 to 3: one joint's encoder.
- The gripper is a two-finger gripper holding and slipping a cube; manipulation in the hand was not played.
- The benchmark commands are random actions, not a trained policy.
- The known-answer tests use one cube, two cubes, one arm, a two-link chain, rods, cloth, a soft cube, a point-cloud sheet and a two-finger gripper. The registered sizes, masses and speeds are stated
  on each study page.
- A different compiler or processor can change the last digit of SuperDex's output, because it is compiled with
  `-ffp-contract=fast`. Results are byte-identical within a build.
