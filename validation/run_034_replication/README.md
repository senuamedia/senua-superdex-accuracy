# Run 034: the fifteenth registration, every fix played again on fresh numbers

15 October 2026. The second run of [PREREGISTRATION_15.md](../../preregistrations/PREREGISTRATION_15.md) as amended;
the first, [run 033](../run_033_identity/), is its rule E0. The registration was committed before any of it was
played. The amendment was committed before this run began, while run 033 was already playing; run 033 plays nothing
of the amendment, as the amendment says. Library build 14 (sha256 af70e149901c628a...), safe when off by
[run 033](../run_033_identity/), with library build 13 beside it for the review part. Played by
[`tools/plays/play_15.sh`](../../tools/plays/play_15.sh) from the repository root (`items deform review long
accurate14`), one play after another; measured by `measure/runners/sx_study15_run.sh`,
every rule judged by Simplex.

**Result: 117 rule lines of 121 held, 4 failed; no value was missing.** Seven rules of ten held: E0, V1, V2, V4, V5,
V7 and V9. V3 failed on one rule line, V6 on two and V8 on one. Each failure's cause is measured below.

A first launch failed before any play: the play script was called without its execute bit. Nothing was played or
measured. The run was launched again with `bash`. No file keeps the first launch, the times of the two launches or how
long the plays took.

## By rule

| Rule | Held | What was measured |
|---|---|---|
| E0 | 2 of 2 | [Run 033](../run_033_identity/): 904 of 904 files identical in 12 parts |
| V1, item 1 | 4 of 4 | Both fresh pairs with each cube's cell at 1/32: the cubes 3,724 and 3,723 (law 3,724) and 4,900 and 4,899 (4,900) mm/s2, the blocks 5,836 and 5,836 (5,837) and 7,741 and 7,742 (7,742), at the shipped step and 1/16 |
| V2, item 2 | 4 of 4 | The fresh arm keeps 1,999,997 to 2,000,000 of 2,000,000 and 4,499,846 to 4,500,000 of 4,500,000 micro-radians a second at steps 1, 1/4 and 1/16; the fresh free chain its energy within 35 parts per million and its angular momentum within 16 |
| V3, item 3 | 18 of 19 | Stock: friction over the impact 3.1 times the law, the slip at 43% of its speed. Final and accurate: the rest carries the weight within 1 mN of 9,800, the lift never pulls, the hold does not creep, sliding friction 4,216 and 4,214 against 4,200, the slip at 99.0% and 99.5% of its speed, friction over the impact 4,196, 4,241 and 4,218 against 4,200, no step diverged. Failed: one stopped step under the final configuration, below |
| V4, item 4 | 3 of 3 | At the final configuration's tolerances all three rods within 0.009% of the textbook at 64 and 128 elements. Item 4 is not closed by this registration: its decision needed V1 to V6 to hold, and V3 and V6 failed |
| V5, item 5 | 10 of 10 | BDF2 with patch G at the final configuration's tolerances: a free spin keeps 3,498,314 to 3,499,994 of 3,500,000; the pendulum's first three swings 9,990, 9,978, 9,971 at the shipped step, 9,999 to 9,998 at 1/4, 9,999 at 1/16 (with the turns placed between the steps: 9,991, 9,978, 9,972; 9,999 to 9,998; 9,999 to 10,000); the swinging chain loses 0.38% at 1/4 and 43 parts per million at 1/16; backward Euler loses 6.1% at 1/4 |
| V6, deformable bodies | 12 of 14 | Every slide stopped within 1 in 100 of its distance, read where it stopped (backward Euler's for stock and the final configuration, Coulomb's for the accurate configuration), but for the soft cube under the final configuration at 0.01 s, below. Bodies set down come to rest; stock creeps at 4,798 to 4,825 micrometres a second against its law's 4,804; the final configuration's contacts held within the stick distance. Failed: that slide, and the soft cube's contact under the accurate configuration, below |
| V7, the corrections | 6 of 6 | On build 14 the hold holds; with a second scene made and destroyed it is byte-identical to the hold alone; after a rollout and a restore the cube moves 110 micrometres a second over the next second. On build 13 the second scene changes the hold and the restored cube moves 410. No step stopped or diverged. **The three corrections are validated** |
| V8, the fourteenth registration's accurate plays again | 52 of 53 | Every other rule reads exactly as run 032 read it. Every A rule holds but one: the twelfth registration's free chain keeps its energy to 4 parts per million but loses 1,540 parts per million of its angular momentum, against 1,000 allowed, below. Meta's scenes: no step stopped of 345,600 on any. On the point-cloud floor 3,945 steps stopped on SuperDex's small-update rule, none at the iteration limit (reported, as the amendment says). The slides stopped at Coulomb's distance within 0.16% |
| V9, the long plays | 6 of 6 | The fresh arm over 20 s, every swing between 9,999 and 10,000 at 1/16 and 10,000 and 10,001 at 1/64 under the accurate configuration; under the final configuration none above 9,975. Item 5's chain at 1/64 within 42 parts per million. Required, the cause: at SuperDex's shipped tolerances the last swing reads 10,037 at 1/16 |

Against the fourteenth registration's accurate configuration (run 032), the final configuration's tolerances took
the twelfth registration's free chain from a gain of 0.47% of its energy to 4 parts per million. They took its
swinging chain from +0.15% to -0.014%, and its pendulum from 10,000, 10,001 and 10,003 to 9,999 on every swing.

## The four rule lines that failed

The play files behind each are in [`probes/`](probes/).

- **V3, the final configuration's stopped steps (1 of 840, against 1 in 1,000).** On the oblique landing at 1/4 of
  the step, one step stopped. The play's most iterations were 8, so it did not stop at the iteration limit: it stopped on SuperDex's rule for an update too small to matter (no trace was kept of that step), not at the
  iteration limit. Every reading of the item held, the impact at 4,241 against 4,200. It is the sheet's residual
  floor below the absolute tolerance of 1e-4, which the amendment found under BDF2 at 1/16
  (`probe_34_run034_failed_rules.txt`).
- **V6, the soft cube's slide under the final configuration at 0.01 s.** The measure `deformstop` takes the stop as
  the first step slower than a hundredth of the speed given. At the shipped step the cube's speed went from +18
  millimetres a second to -17 within one step, as it reached its furthest point and began to rock back. No step fell
  under the threshold, and the first that did came five steps later, after it had rocked back 1 mm. Its furthest
  point is 78,156,644 nm against backward Euler's 78,153,061, within 0.005%. Stock's soft cube shows the same: its
  furthest point is 78,153,414, and its rule passed only because it rocked back less. The measure's definition of
  the stop is wrong when the speed changes sign between two steps.
- **V6, the soft cube's contact on the tilted floor under the accurate configuration (319 micrometres, against 300).**
  The tilt is applied in one step. Under BDF2 the soft cube rocks on its contact and the rocking decays slowly: its
  centre swings 736, 632, 708, 641, ... 679 micrometres about a fixed place, with no creep. The tracked node is the
  uphill bottom corner, lifted 0.4 mm off its resting depth. While the cube rocked in the first 0.25 s of loading its x
  swung as far as 491 micrometres; from 0.5 s on it stayed between 309 and 328, and it ended at 319. Backward Euler damps that loading, and under the final configuration
  the same corner moved 162 and 210 micrometres. The rule read a corner that rocks, during a load applied at once.
- **V8, the twelfth registration's free chain under BDF2 with patch G: its angular momentum (1,540 parts per
  million over 2 s, against 1,000).** Probe 33 (`probe_33_chain_momentum.txt`) shows the cause: backward Euler with
  patch G keeps this chain's momentum exactly (0 to 6 parts per million at every step), while BDF2 with patch G
  loses 6,270, 1,540 and 372 at 1/4, 1/16 and 1/64 of the step (6,270, 1,542 and 383 converged). The loss quarters as the step quarters, and is the
  same with the solve converged. Without patch G, BDF2 loses three times as much. Patch G's share for BDF2 was
  derived for one joint (stated as a risk in the fourteenth registration). On a chain it leaves an error of the
  first order in angular momentum, while the energy is kept. A share fitted to the reading would be a tuned constant;
  the derivation for a chain is in [run 049](../run_049_patch_g_review/README.md), below.

## What was reported, not ruled

- The rules of the fourteenth registration that the amendment replaced read: the cloud floor's 3,945 stopped steps,
  the slides at the end of the play (rocked back), and one stopped step of the soft cube at rest, all under BDF2.
- Every measured line, the slides' ends, the end speeds on the tilt, and the time of each benchmark scene.

## A correction to the runner, after the run

The runner as registered printed the name of its temporary folder in two reported lines, and the same label for both
contact suites' statistics. Those lines could not be made again byte for byte. The corrected runner prints fixed
labels. No measured value, no rule and no other line changed: `reading_as_run.txt` is the reading as the run wrote
it, and `reading.txt` is the corrected runner's, which differs from it in those four lines only and re-makes byte for
byte. The runner as registered is `measure/runners/sx_study15_run.sh` as committed with the registration's amendment
(4545e3780e6ab762...); as corrected c34f448a87d0a008.... That form fails when the record's root is given as a
relative path, because the V8 tree's links are made from it; the form that takes the root as absolute
(fec190adf8c03203...) re-makes `reading.txt` byte for byte. The published runner, d9df7ecd2919a77b..., differs from
that form in its comments only ([`measure/README.md`](../../measure/README.md); [`docs/changelog.md`](../../docs/changelog.md)).

## Files

`reading.txt` and `reading_as_run.txt`, `runs/` (items, deformable bodies, the review part, the long plays),
`accurate14/` (the fourteenth registration's play script as copied, `play_14_accurate.diff` its difference from the
registered one, and its plays, the solver traces compressed with gzip), `probes/` (after the run). In the copied
script and its difference the home-directory paths in their two folder lines are shortened to `~` for publication.
Inside double quotes that `~` does not expand, so the published copy does not run as it stands; the run's copy named
the full paths.

## V8's cause, from run 049

- [Run 049](../run_049_patch_g_review/README.md), a review of patch G for publication, re-derived V8 from
  `accurate14/runs/joints_accurate/chainfree_16.txt`: the largest momentum drift 1,540.9 parts per million against
  1,000, failed, as recorded. The measure reads SuperDex's link velocities; read from the joint speeds the same chain
  drifts 1,272.4.
- It found the cause of the first-order loss in stock SuperDex. For a jointed body SuperDex sets each link's pose at
  the start of a BDF2 stage from the forward kinematics of the combined joint angles, where BDF2 for a constrained
  system combines each link's own centres; the two differ at second order in the step, so the velocity kept at the
  end of a stage is short at first order. Patch G's share of 1/3 cancels that for one joint only. The derivation for
  a chain is in run 049, with the references it cites.
- A derived form of patch G under BDF2 makes the chain second order and changes nothing under backward Euler or with
  the switch off; on this run's numbers it would take V8's chain from 1,540 to 7 parts per million and would fail
  V5's free spin at the shipped step (3,495,765 against 3,496,500). Study 22 adopted it as library build 16.

Every rule line of this run reads as recorded.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the fifteenth registration) changes in 7 numbers: the distance slid by
at most 0.01% (117,934 to 117,948 um), and the grip's creep by 0.05%, the distance come back by at most 1 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).

Read again with the corrected program, the accurate replay's swings (`accurate14/`) change in 3 readings, each by 1
urad on a release angle of about 100,000,000 urad.
