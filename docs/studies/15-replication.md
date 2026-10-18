# Study 15: the fixes on fresh numbers, and the code review's corrections tested

| | |
|---|---|
| Registration | Fifteenth: [PREREGISTRATION_15.md](../../preregistrations/PREREGISTRATION_15.md), amended before run 034 |
| Question | Do the fourteenth registration's fixes hold again on numbers no earlier study used, do its failed rules hold once read as their causes say, and do the corrections an independent code review asked for work? |
| Outcome | 117 rule lines of 121 held; 7 rules of 10 held (E0, V1, V2, V4, V5, V7, V9), and V3, V6 and V8 failed. Library build 14 is safe when off and replaces build 13 (E0). The three corrections are validated (V7). The fixes of items 1, 2, 4 and 5 held every rule line on fresh numbers (V1, V2, V4, V5). Item 3's rule failed on one stopped step (V3) and the deformable bodies' on two lines (V6), so the decision that records every fix as replicated, closes item 4 and records the deformable rules as corrected did not fire, and what V3 and V6 concern stays open. The accurate configuration, set at the final configuration's tolerances by the amendment, held V9 and 52 of V8's 53 lines; V8 failed on a chain's angular momentum, so it is not recorded as validated end to end. What lies behind each failed line was found after the run: a limit of patch G under BDF2 on a chain (its cause in stock SuperDex, run 049), two readings that do not test what they meant to, and one stopped step on the point-cloud sheet that did not reach the iteration limit |
| Registered | 15 October 2026, before any run of this registration existed. Amended the same day; the amendment was committed and pushed before run 034 began, while run 033 (E0), which plays nothing of the amendment, was already playing |
| Result | [Run 034](../../validation/run_034_replication/README.md), 15 October 2026 |
| Runs | [033](../../validation/run_033_identity/), safe when off and run 032 made again; [034](../../validation/run_034_replication/), the registered runs |
| Played by | the rigs in [`tools/`](../../tools/), [`tools/plays/play_15.sh`](../../tools/plays/play_15.sh), [`tools/play_identity.sh`](../../tools/play_identity.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx), `measure/runners/sx_study15_run.sh` |

Previous: [Study 14](14-open-items.md). Next: [Study 16](16-second-review.md). All studies: [index](README.md).

## Why it was asked

Before the record goes public, every fix should hold again on fresh numbers, and every failed rule should have its
cause measured. An independent review of the patch code found three defects outside what the studies played:
a switch set to `0` turned a correction on; creating or destroying any scene dropped every scene's friction
anchors; and restoring a captured state kept the anchors of whatever was played after the capture. They are
corrected in library build 14.

## The amendment, before run 034

The amendment was committed and pushed before run 034 began. Run 033, which decides E0, was already playing; it
plays nothing of the amendment. Probes after run 032 found a defect in the fourteenth registration's accurate configuration. At SuperDex's shipped
solver tolerances, BDF2 with patch G gains energy, and gains more the finer the step. An arm swinging for 20 s reaches
10,009, 10,038 and 10,589 per 10,000 a swing at 1/4, 1/16 and 1/64 of the step. At the final configuration's
tolerances it reads 9,994, 10,000 and 10,001. The amendment moved the accurate configuration to those tolerances. It
played the fourteenth registration's accurate plays again (V8) and a fresh 20 s arm (V9), and it read the pendulum's
turns between the steps too. A second review of the tests' right answers and rigs found no rig defect and no wrong
right answer; its notes on the measures' margins are in the amendment. The probes are in
[`validation/run_032_open_items/probes/`](../../validation/run_032_open_items/probes/).

## The result

117 rule lines of 121 held, 7 of the 10 rules ([run 034](../../validation/run_034_replication/)). Library build 14 is safe when off: 904 of
904 registered files byte-identical, including every switch set to `0` and the whole of run 032 made again (17 of its
files, its stock plays, made on the stock library as registered; [Study 18](18-stock-plays.md) made those on build
15) ([run 033](../../validation/run_033_identity/)).

| Rule | Rule lines held | What was measured |
|---|---|---|
| V1, item 1 | 4 of 4 | Two fresh pairs, each cube's cell at 1/32 of its side: the cube and the block measured within 1 in 1,000 of their laws at both steps (the bound: 1 in 100) |
| V2, item 2 | 4 of 4 | A fresh arm keeps its speed within 1 in 10,000 at 2 and 4.5 rad/s and every step; a fresh free chain its energy within 35 and its momentum within 16 parts per million |
| V3, item 3 | 18 of 19, failed | On the point-cloud sheet, final and accurate: the rest carries the weight, the hold does not creep, sliding friction and friction over the impact measured within 1 in 100 (the bounds: 1 in 100 for sliding friction, 1 in 25 over the impact), the slip at 99% of its speed (the bound: 95 in 100). Failed: one stopped step under the final configuration, below |
| V4, item 4 | 3 of 3 | Three rods within 0.009% of the textbook at the final configuration's tolerances (the bound: 1 in 1,000) |
| V5, item 5 | 10 of 10 | BDF2 with patch G: the pendulum's swings 9,990, 9,978 and 9,971 at the shipped step and 9,999 at 1/16, read at the steps (9,991, 9,978, 9,972 and 9,999 to 10,000 between them); the swinging chain within 43 parts per million at 1/16 |
| V6, deformable bodies | 12 of 14, failed | Slides read where they stopped, bodies at rest, stock's creep on the tilt at its law's speed, the final configuration's contacts within the stick distance. Failed: the soft cube's slide under the final configuration at 0.01 s, and its contact on the tilt under the accurate configuration, below |
| V7, the corrections | 6 of 6 | A second scene leaves a hold byte-identical; after a restore the cube moves 110 micrometres a second, against 410 on build 13. **The three corrections are validated** |
| V8, the fourteenth registration's accurate plays again | 52 of 53, failed | Every A rule but one, and every other rule reads as run 032 read it; no step stopped of 345,600 on any of Meta's scenes. Failed: the free chain's angular momentum, below |
| V9, the long plays | 6 of 6 | Over 20 s every swing between 9,999 and 10,001 under the accurate configuration at 1/16 and 1/64, none above 9,975 under the final configuration; at the shipped tolerances 10,037 |

## What the decisions record

- **E0 held:** library build 14 replaces build 13 as the library of record, and every result of runs 031 and 032
  stands for it.
- **V7 held:** the three corrections are recorded as validated.
- **V1 to V6 did not all hold:** V3 and V6 failed, so the decision that records every fix of the fourteenth
  registration as replicated, closes item 4 and records the deformable rules as corrected did not fire. What was
  measured: the fixes of items 1, 2, 4 and 5 held every rule line on fresh numbers (V1, V2, V4, V5), item 4's rods
  within 0.009% of the textbook (two fresh rods and the thirteenth registration's, kept as the rod run 032 failed on); item 3's fix held 18 of its 19 lines; the deformable bodies held 12 of
  14. What V3 and V6 concern stays open, as the registration says of a rule that fails.
- **V8 failed and V9 held:** the decision that records the accurate configuration at the final configuration's
  tolerances as validated end to end, and withdraws the shipped-tolerance form, needed both, and did not fire. What
  was measured: over 20 s that configuration kept every swing between 9,999 and 10,001, and at SuperDex's shipped
  tolerances the same play gained (10,037, V9's required line); every A rule held but the free chain's angular
  momentum.

## The four rule lines that failed

They are three rules: V8, V3 and V6 (two lines). What follows was found after the run, from the run's play files
and probes.

- **BDF2 with patch G loses a free chain's angular momentum at first order (V8).** The twelfth registration's free
  chain kept its energy to 4 parts per million but lost 1,540 parts per million of its angular momentum over 2 s at
  1/16 of the step, against 1,000 allowed. After the run, probe 33 played it at three steps. Backward Euler with
  patch G keeps it to 6 parts per million at every step. BDF2 with patch G loses 6,270, 1,540 and 372 at 1/4, 1/16 and 1/64, a
  quarter for each quartering of the step, and the same with the solve converged. Without patch G, BDF2 loses three
  times as much. Patch G's share for BDF2 was derived for one joint. [Study 22](22-bdf2-chain.md)'s decision closes
  this (below).
- **One stopped step on the point-cloud sheet under the final configuration (V3).** One step of 840, at 1/4 of the
  step, stopped, against 1 in 1,000 allowed. It did not reach the iteration limit (the play's most iterations were 8), so it stopped on SuperDex's rule for an update too small to matter. Every reading held. No trace was kept of that step; the run's README reads it as the sheet's residual floor below the absolute tolerance of 1e-4, which the amendment's probes found under BDF2 at 1/16. It stays open.
- **The slide-stop measure misses a stop between two steps (V6).** At 0.01 s the soft cube's speed went from +18 to
  -17 millimetres a second in one step as it reached its furthest point. That point is within 0.005% of backward
  Euler's distance. The measure took the first step slower than a hundredth of the speed given, five steps later,
  after the cube had rocked back 1 mm.
- **A load applied at once, on a rocking corner (V6).** Under BDF2 the soft cube on the tilted floor rocks on its
  contact and settles without creeping. The tracked uphill corner, lifted off the floor, swung as far as 491
  micrometres while the tilt loaded it and ended at 319, against the 300 allowed. Backward Euler damps the loading.

The play files behind each are in [`validation/run_034_replication/probes/`](../../validation/run_034_replication/probes/).

## What it does not show

The corrections switched on in 32-bit arithmetic: every reading of them is 64-bit. Gradients through the patches:
none were tested (see [what the patches do not cover](../patches.md#what-the-patches-do-not-cover)). The two
readings that did not test what they meant to are put to [Study 16](16-second-review.md).

## The review of patch G

[Run 049](../../validation/run_049_patch_g_review/README.md), a review of patch G for publication, not registered,
re-derived V8 from this run's own file (`accurate14/runs/joints_accurate/chainfree_16.txt`): the largest momentum
drift is 1,540.9 parts per million against 1,000, failed, as recorded. It found the cause in stock SuperDex. Its
BDF2 combines the two previous states with weights 4/3 and -1/3 over a stage of 2h/3, and for a jointed body it sets
each link's stage-start pose from the forward kinematics of the combined joint angles, where BDF2 for a constrained
system combines each link's own centres. The two differ by (2/9) h^2 Jdot qd to leading order, so the velocity kept at
the end of a stage is short at first order. Patch G's share of 1/3 cancels that for one joint (V5's pendulum and free
spin held); on a chain part of the angular momentum's error remains, and no scalar share cancels it. The measure reads SuperDex's link velocities, which carry that bias: read from the joint speeds, the same chain
drifts 1,272.4 parts per million.

A derived form that makes a chain second order, and changes nothing under backward Euler or with the switch off, was
put to [Study 22](22-bdf2-chain.md), whose decision made it patch G under BDF2 (library build 16). Played on this
study's numbers it would take V8's chain from 1,540 to 7 parts per million, and would fail V5's free spin at the
shipped step (3,495,765 against 3,496,500): its one-time loss at the start of BDF2 on a coarse step (run 049). V8's
verdict, and the decision that did not fire, stand as recorded.
