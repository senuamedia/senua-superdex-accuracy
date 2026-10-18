# Study 21: patches F and G and the recommended configuration, held to every rule again on fresh numbers

| | |
|---|---|
| Registration | Twenty-first: [PREREGISTRATION_21.md](../../preregistrations/PREREGISTRATION_21.md) |
| Question | Under the recommended configuration, on fresh numbers, do patches F and G meet every rule of their registrations, does the configuration keep `half_cheetah` and `ant` in order, and does it meet every backward-Euler end-to-end rule of the thirteenth to fifteenth registrations? |
| Outcome | **117 rule lines of 118 held (44 rules of 45; F3 failed).** Every rule of patch G held, so patch G is recorded as required, correct and safe under the recommended configuration, under backward Euler. F3 failed on one line, the second suite's T16 (momentum between two cubes), the same with and without patch F; found after the run, the cause is the measuring program, which reads each cube's mass in whole units of 10 g, not patch F or SuperDex. So the decisions that would record patch F as required, correct and safe and the configuration as validated end to end did not fire. Every other end-to-end rule held, the order test at the configuration's tolerances on fresh commands among them |
| Registered | 15 October 2026, before run 051 |
| Result | [Run 051](../../validation/run_051_study21/README.md), 15 October 2026 |
| Runs | [053](../../validation/run_053_order_probe/README.md) (a probe for its order rule), [051](../../validation/run_051_study21/README.md), and the diagnostic after it (`validation/run_051_study21/diagnostic/`), on the Linux machine of runs 039 to 047 |
| Played by | [`tools/plays/play_21.sh`](../../tools/plays/play_21.sh); measured by [`measure/runners/sx_study21_run.sh`](../../measure/runners/sx_study21_run.sh) |

Previous: [Study 20](20-thirty-two-bit.md). Next: [Study 22](22-bdf2-chain.md). All studies: [index](README.md).

## Why it was asked

Patches F and G joined the recommended configuration by their registered decisions, but Studies 11 and 12 record each
as required, correct and safe only if every one of its rules holds, and three did not: F3, G2 and G8. Studies 13 to 15
played the configuration end to end, and in each some rules failed, so no registered decision had recorded it as
validated end to end. By the time of this registration every one of those failures had its cause found in the record:
SuperDex's default grid for F3 ([run 048](../../validation/run_048_patch_f_review/README.md)), SuperDex's shipped
solver tolerance for G2 ([run 030](../../validation/run_030_design_probes/)), a rule posed against stock's value for G8
([run 049](../../validation/run_049_patch_g_review/README.md)), and readings that did not test what they meant to for
the deformable bodies (Study 16). This study put every rule to the configuration again, on numbers no earlier study
used.

## What was played

Under the recommended configuration (backward Euler at the shipped step, every switch of patches A to G, Newton-Euler
inertia, contact damping 5, friction falloff 0.03 m/s, tolerances 1e-4 and 1e-8, each mesh body's grid cell at 1/32 of
its side, 1 mm smoothing on the point cloud), with stock and two variants (without patch F, and without patch G and
Newton-Euler inertia) beside it where a rule compares: both contact suites on a fresh 1.75 kg cube and a fresh pair
(a 4.177 kg block and a 0.698 kg cube); item 1's two fresh pairs; a fresh arm, chain, limit and point-cloud cube; 40
rotations; three cantilevers; fresh deformable bodies on a fresh floor; both grippers on a fresh cube; Meta's three
scenes on fresh commands (seeds 21101 to 21103, `actions/21/`), and `half_cheetah` and `ant` at steps 1 to 1/16 for
the order; and the identity check's parts rotvec, flight, suites, joints, zero, fg, bench and benchrec on library
build 15. Every number was drawn from one seed; the registration gives them, their ranges and the right answers.

## The rules, and the result

The registration carries 45 rules from the eleventh to fifteenth registrations, with the four changes it made before
any run (G8 and J4 against the slip's right answer, the deformable slide and hold read as Study 16 read them, stopped
steps on the point-cloud sheet ruled at the iteration limit, F1's second clause reported). 44 of them held, on 117 of
the 118 rule lines ([run 051](../../validation/run_051_study21/README.md)).

| Rules | Rule lines held | Measured |
|---|---|---|
| E0, safe when off | 2 of 2 | 501 of 513 identity files byte-identical to their registered files; the other 12 exactly the plays named for Linux, each the same as run 040's kept file |
| F1 to F6, patch F | 13 of 14, F3 failed | Without patch F, T05 fails (the shipped step 81.0% of the law, reported); with it, friction over the impact 3,409 or 3,410 per 10,000 at every step against the law's 3,410, and T10 passes; the first suite 10 of 10; no suite step stopped or diverged; on Meta's scenes 5, 1 and 0 steps stopped against 10, 25 and 0 without patch F, none diverged; the other tests unchanged. **F3 failed** on the second suite: 1111101, T16 failing |
| G1 to G9, patch G | 30 of 30 | Stock at the law's prediction at the three speeds; with patch G the arm keeps at least 9,999.6 per 10,000 of its speed in all nine plays; a free chain with no switch loses 30.5% of its kinetic energy and 10.6% of its angular momentum at the shipped step, and with patch G keeps both at every step (energy within 132 per million, momentum within 14 parts per million); a swinging chain loses 27.5%, 13.3% and 11.5% of what it loses with no switch; JT1, the driven arm, the hold and the slip (at its right answer, within 6 parts per million) all held; on Meta's scenes 5, 1 and 0 steps stopped against 5, 0 and 0 without patch G |
| J1, J5, L1 to L4, R1 | 11 of 11 | The free arm, the limit at rest, leaving and lifted, and 40 rotation vectors of 40, all at their right answers; no step stopped or diverged |
| P1, P2 | 10 of 10 | Stock on the point-cloud floor 3.1 times the law over the impact and the slip at 49%; the configuration within 1 in 100 of the law sliding and within 1% over the impact, holding, the slip at 99.3%, no step stopped |
| V1, I1d, V2, V4, V9 | 19 of 19 | Item 1's pairs within 1 in 3,800 of their laws; the arm and chain within their bounds; the cantilevers within 0.025% of the textbook at 64 and 128 elements; a 20 s swing never above 9,976 per 10,000 |
| D1 to D8 | 15 of 15 | Falls, hangs, slides, rests and the creep on the tilt at their right answers, stock and the configuration; under the configuration the hold on the tilt moved 85 nm at most |
| GR1 to GR5 | 8 of 8 | Both grippers press and carry within 1 in 15,000 of their right answers under the configuration and hold; stock lets the cube creep out |
| B1 to B3 | 9 of 9 | On the fresh commands 5, 1 and 0 steps stopped of 21,600 (stock 0, 223 and 0), none diverged; **`half_cheetah` and `ant` in order in 3 folds of 3 at the configuration's tolerances**, the largest ratio of a gap to the one before 0.82 and 0.66; 7 steps of the ten order plays stopped, every one at the iteration limit, none diverged |

## What the decisions record

- **Patch G is recorded as required, correct and safe under the recommended configuration, under backward Euler**:
  E0 and G1 to G9 held, every one of patch G's 30 rule lines.
- **Patch F's decision did not fire**, because F3 failed: patch F is not recorded as required, correct and safe by
  this study. F3 is recorded as measured, and what it concerns stays open.
- **The decision that would record the configuration as validated end to end did not fire**, because F3 failed.
- Nothing about BDF2 or the accurate configuration was decided; [Study 22](22-bdf2-chain.md) decided patch G there.

## The rule line that failed, and its cause

**F3, the second suite's T16.** T16 asks that the momentum of two cubes, one driven into the side of the other and one
sliding on top of the other, change by no more than 500 parts per million. It read 8,805 and 9,644 on the side play at
steps 1 and 1/16, and 8,570 and 8,662 on the top play; without patch F the side play read the same numbers.

What follows was found after the run, from plays made again for it, and changes no verdict
([run 051](../../validation/run_051_study21/README.md), "The diagnostic", and its `diagnostic/`):

- **The measuring program reads each cube's mass in whole units of 10 g.** Its `pair` measure takes each mass in
  units of 10 g and each speed in units of 10 micrometres a second, truncated. Every pair played in the second suite
  before this study had masses in whole multiples of 10 g (Study 11's was 3,000 and 500 g); this study's fresh pair is
  4,177 g and 698 g, read as 4,170 and 690. As the momentum passes from the cube to the block the two truncation errors
  differ, so the read momentum appears to change by about 0.9%: the measure's own arithmetic on the side play gives
  exactly the reading's 8,805 per million.
- **The physics keeps the momentum.** From the side play's final speeds, 4.177 x 172,601 + 0.698 x 127,115 = 809,681
  kilogram-micrometres a second, against 0.698 x 1,160,000 = 809,680 at release; the top play reads 607,259 against
  607,260.
- **The patches and the settings do not explain it.** The suite played again with SuperDex's default grid, at its
  shipped tolerances, with no contact damping and with the patches off reads 8,453 to 9,644 per million (13,122 on one
  play with no contact damping); Study 11's pair under the same configuration reads 51 to 68.

So F3 failed on the measure, not on patch F or on SuperDex. F3 stays failed as registered.

## What it means, and what follows

- **Patch G is validated under backward Euler**, the recommended configuration's integrator, on fresh numbers. Study
  12's G2 and G8 stay failed as registered, and their causes lie outside patch G.
- **The configuration keeps Meta's scenes in order at its own tolerances**: the order test the decisions of Studies 11
  and 12 were made on, at SuperDex's shipped tolerances, held on fresh commands at the configuration's tighter ones.
- **Every end-to-end rule of the thirteenth to fifteenth registrations that it could be put to under backward Euler
  held but K2**, which is F3's second line: point clouds, deformable bodies, grippers, the cantilevers, limits,
  rotations and Meta's scenes.
- **Patch F held 13 of its 14 rule lines**, and the one that failed, F3's second, fell short on the measure. Patch F
  and the configuration end to end are not recorded as validated by this study. A measure that reads each mass in whole
  grams, `pairg`, stands beside `pair`, which is unchanged ([`measure/`](../../measure/README.md)). [Study 23](23-recommended-configuration-again.md)
  repeated this study's protocol on fresh numbers with it and recorded patch F as required, correct and safe.
- It says nothing about BDF2 or the accurate configuration, about 32-bit, about `cart_pole`'s order or about gradients,
  and nothing against a real robot.
