# Run 051: patches F and G and the recommended configuration, held to every rule again on fresh numbers (Study 21)

15 October 2026, 10:08:30 to 10:57:26 UTC (`times.txt`), under
[`preregistrations/PREREGISTRATION_21.md`](../../preregistrations/PREREGISTRATION_21.md), by
[`tools/plays/play_21.sh`](../../tools/plays/play_21.sh) from its own copy of the record at the registration's commit (Study 22 played beside it from another), on
the Linux machine of runs 039 to 047 (AWS EC2, Intel Xeon Platinum 8488C, Ubuntu 24.04, Clang 18). Played once: each part started and finished
once (`times.txt`). After the part rigs (65 seconds), the parts ran side by side as separate processes, as the
registration allows: the identity check, the order, the benchmark, the point-cloud floor (then the deformable bodies and
the grippers) and the contact suites (then items, arm, chain, joints, limits and rotvec). The longest was the order,
47 minutes 51 seconds. Run 052 played on the same machine at the same time (its `times.txt` also starts at 10:08:30).

The libraries were library build 15 (sha256 eee7cca1423650df...) and stock (75def9201a45216a...), built on that
machine by `validation/run_039_linux_replication/build.sh` from the four patch files as they stood at registration
(`rigs.sha256` gives the four files' checksums, the registration's). Every rig was built by the play script from the
sources in `tools/`, whose checksums are the registration's (`rigs.sha256`); the stock deformable and gripper plays
were made with rigs built against the stock library (`played.txt`). Every part played (`played.txt`).

Measured by [`measure/runners/sx_study21_run.sh`](../../measure/runners/sx_study21_run.sh) (`reading.txt`), with the
order read by the instrument `sx_settings3` (`counts.txt`). The plays are kept under `runs/`: the suites under `s1/`
and `s2/`, the benchmark streams under `bench/`, the order's streams and the stopped steps taken from their traces under
`order/` (the traces were removed after the counts were taken, as registered). The identity check's own plays are not
kept here; its comparisons are `identity.txt`, `identity_play.txt` and `identity_linux.txt`.

## The result: 117 rule lines of 118 held; F3 failed

44 rules of 45 held. The one line that failed is F3's second line, `F3_K2_second_suite_all_seven`: under the
configuration the second suite's code is 1111101 against 1111111, its T16 (momentum between two cubes) failing. The
reading's last line: `STUDY21 rule lines held 117 failed 1 ; patch F's (F1 to F6) held 13 failed 1 ; patch G's (G1 to
G9) held 30 failed 0 ; values missing 0 ; measuring complete 1`.

| Rules | Rule lines held | What was measured |
|---|---|---|
| E0, safe when off | 2 of 2 | 513 files of the identity check's parts rotvec, flight, suites, joints, zero, fg, bench and benchrec: 501 byte-identical to their registered files, and the 12 that differ exactly the 12 plays named for Linux, each byte-identical to the file run 040 kept, and the six with no switch also to the same play on the stock library on this machine (`identity.txt`, `identity_linux.txt`) |
| F1 | 1 of 1 | Without patch F, T05 fails: 2,369 to 3,288 per 10,000 at the seven steps against the law's 3,410. Reported (change 4): the shipped step's 2,761 is 81.0% of the law, above 8 tenths (2,728) |
| F2 | 2 of 2 | Under the configuration, friction over the impact 3,409 or 3,410 per 10,000 at every step against 3,410; T10 passes |
| F3 | 1 of 2, failed | The first suite 1111111111 (held). The second suite 1111101 (failed): T16 read 8,805 and 9,644 per million on the side play at steps 1 and 1/16, and 8,570 and 8,662 on the top play, against 500. Without patch F the same code, and the side play reads the same numbers (8,805 and 9,644) |
| F4 | 2 of 2 | No step of either suite stopped or diverged under the configuration |
| F5 | 6 of 6 | Meta's scenes at the shipped step: stopped steps of 21,600, under the configuration and without patch F, `half_cheetah` 5 and 10, `ant` 1 and 25, `cart_pole` 0 and 0; none diverged |
| F6 | 1 of 1 | The first suite's other tests pass or fail as they do without patch F |
| G1 | 3 of 3 | Stock, one arm, shipped step: 1,523,537, 2,707,654 and 3,804,186 micro-radians a second against the law's 1,523,368, 2,706,822 and 3,802,420 |
| G2 | 3 of 3 | Under the configuration, all nine plays between 9,990 and 10,010 per 10,000; the lowest 4,509,845 of 4,510,000 |
| G3 | 2 of 2 | No switch, free chain, shipped step: 695,226 per million of the kinetic energy kept, angular momentum -106,031 parts per million |
| G4 | 4 of 4 | The solve converged: momentum drift 0 at every step; largest energy drift 1,178, 73 and 4 per million at steps 1, 1/4 and 1/16 (bounds 5,000, 1,000 and 500) |
| G5 | 2 of 2 | Under the configuration, free chain: energy at the end 1,000,132, 1,000,010 and 1,000,005 per million of its start; momentum 13, 0 and 0 parts per million |
| G6 | 4 of 4 | Swinging chain: the configuration loses 226,952, 65,346 and 17,618 per million against no switch's 825,411, 489,846 and 153,817 (27%, 13% and 11%), falling with the step |
| G7 | 2 of 2 | No step of the arm and chain plays stopped or diverged |
| G8 | 4 of 4 | JT1 2,179,996 (at least 2,158,200); the driven arm 6,082,162 against 6,082,196; the hold creeps -401 as stock does (-401); the slip 3,610,270 and 3,610,268 against its right answer 3,610,288 |
| G9 | 6 of 6 | Meta's scenes: stopped steps under the configuration and without patch G and Newton-Euler inertia, `half_cheetah` 5 and 5, `ant` 1 and 0, `cart_pole` 0 and 0; none diverged |
| J1, J5 | 2 of 2 | The free arm keeps 2,179,996 of 2,180,000; no step of the joint tests stopped or diverged |
| L1 to L4 | 8 of 8 | At rest on the limit -342,980 micro-radians at both steps (band -343,009 to -342,951); leaving at 1/64 at 1,767,568 and 370,154 against 1,782,622 and 371,520; at the coarser steps left and moving (at least 318,677); lifted to -216,211 and -226,118 (bound -238,350); no step stopped or diverged |
| R1 | 1 of 1 | 40 rotation vectors of 40 right, 20 at or under 2e-9 rad and 20 above |
| P1, P2 | 10 of 10 | Stock on the point-cloud floor: friction over the impact 12,188 per 10,000 against the law's 3,910, the slip 391,300 of 796,000 micrometres a second. Under the configuration: rest 11,338 mN against 11,339, the lift never pulls, the hold 0, sliding friction 3,919 against 3,910, the slip 790,800 of 796,000, the impact 3,912 and 3,938 at steps 1 and 1/4; no step stopped or diverged (most iterations 19) |
| V1, I1d | 5 of 5 | Item 1's two fresh pairs: the cubes 3,841 and 4,821 mm/s2 against 3,842 and 4,822, the blocks 5,945 and 7,432 against 5,946 and 7,433, at both steps; no step stopped or diverged |
| V2 | 5 of 5 | The arm within 1 in 10,000 at every speed and step; the free chain's energy within 132 per million, its largest momentum drift 14, 6 and 1 parts per million |
| V4 | 6 of 6 | The three cantilevers at 64 and 128 elements within 0.03% of the textbook (7,849,203 and 7,849,959 nm against 7,851,120; 3,848,081 and 3,848,443 against 3,848,916; 3,447,584 and 3,447,908 against 3,448,114), and at 32 within 1 in 200. Reported: 7 stopped steps, most iterations 3 |
| V9 | 3 of 3 | The arm swinging 20 s: its largest swing 9,645 and 9,976 per 10,000 at steps 1 and 1/16; no step diverged, most iterations 2 |
| D1 to D8 | 15 of 15 | Stock falls within 691 nm (rod and strip) and 3,128 nm (soft); hangs within 1 in 200 of 1,456,451, 395,717 and 521,417 nm; every slide's furthest point within 1 in 100 of 57,483,989 and 61,128,989 nm, stock and the configuration; stock creeps on the tilt at 3,796 to 3,845 micrometres a second against 3,847, its centre moving 1,918,177 to 1,929,467 nm between the second and last quarter, and under the configuration 0 to 85 nm; every rest at 0; no step stopped or diverged |
| GR1 to GR5 | 8 of 8 | Both grippers under the configuration: each finger presses 9,099,999 and 9,100,002 uN against 9,100,000, carries 818,248 to 818,256 against 818,300, does not creep and slips 31,789 and 32,248 nm; stock lets the cube creep out at 1.57 and 0.61 mm a second; no step stopped or diverged |
| B1 to B3 | 9 of 9 | Under the configuration on the fresh commands: stopped steps of 21,600, `half_cheetah` 5, `ant` 1, `cart_pole` 0, none diverged. `half_cheetah` and `ant` in order in 3 folds of 3 at steps 1 to 1/16 (`counts.txt`), no step of the ten plays diverged |

Reported, not deciding (`reading.txt`):

- Stock on the fresh commands: `half_cheetah` 0 stopped, `ant` 223, `cart_pole` 0; none diverged.
- The order's chains (`counts.txt`): the largest ratio of a gap to the gap before it, over the three folds, 0.82 on
  `half_cheetah` and 0.66 on `ant`. Their stopped steps: 7 in all (`half_cheetah` 5 at step 1 and 1 at 1/4, `ant` 1 at
  step 1), every one at the iteration limit. Each scene's stream at step 1 is the same as the benchmark's under the
  configuration.
- The second suite without patch F: 1111101, as with it.

## What the decisions record

- **E0 and G1 to G9 held, so patch G is recorded as required, correct and safe under the recommended configuration,
  under backward Euler**, as the registration decided in advance.
- **F3 failed, so the decision on patch F did not fire**: patch F is not recorded as required, correct and safe by
  this registration, and what F3 concerns stays open.
- **Not every rule held, so the recommended configuration is not recorded as validated end to end** by this
  registration.
- Nothing about BDF2 or the accurate configuration is decided here.

## The diagnostic, after the run, changing no verdict

What follows was found after the run and the reading, from plays made again for it (`diagnostic/`). It changes no
verdict: F3 failed as registered, and the decisions above stand.

**What was played.** [`diagnostic/t16diag.sh`](diagnostic/t16diag.sh) played the second suite again with one thing
changed at a time: as registered; with SuperDex's default grid (no `sdfdiv`); at SuperDex's shipped solver tolerances;
the patched library with no switch set; with no contact damping; and with Study 11's pair (3 kg and 0.5 kg, half-sizes
0.25 m and 0.03 m) in place of the fresh one. It also played two stock variants, which the table does not read.
[`diagnostic/t16table.sh`](diagnostic/t16table.sh) read each with the record's `pair` measure. The plays were made in a
work folder of the machine and are not kept; their reading is
[`diagnostic/t16_table.txt`](diagnostic/t16_table.txt):

| Variant | Side, step 1 | Side, 1/16 | Top, step 1 | Top, 1/16 |
|---|---|---|---|---|
| As registered | 8,805 | 9,644 | 8,570 | 8,662 |
| SuperDex's default grid | 8,805 | 9,644 | 8,570 | 8,662 |
| SuperDex's shipped tolerances | 8,805 | 9,644 | 8,568 | 8,654 |
| No contact damping | 8,991 | 13,122 | 8,570 | 8,657 |
| Patched library, no switch | 8,805 | 9,644 | 8,453 | 8,477 |
| Study 11's pair | 51 | 51 | 68 | 68 |

The change of momentum per million that T16 reads, against its bound of 500. The as-registered row is the run's own
reading.

**The cause: the measuring program, not patch F or SuperDex.** The `pair` measure of `measure/sx_contact.sx`
(`xc_mom` and `xc_pair`) reads the momentum as each cube's mass in whole units of 10 g times its speed in whole units
of 10 micrometres a second, each truncated. Every pair the second suite had played before this study had masses in
whole multiples of 10 g (Study 11's, for one, 3,000 and 500 g). This study's fresh pair is 4,177 g and 698 g, which the
measure reads as 417 and 69 units, 4,170 and 690 g: the block 0.17% light and the cube 1.15% light. In the side play
all the momentum is the cube's at release and most of it the block's at the end, so the read momentum appears to
change though the physics keeps it. With the measure's own units, from the side play's line at step 1: 69 x 116,000 =
8,004,000 at release, and 417 x 17,260 + 69 x 12,711 = 8,074,479 at the end, a change of 70,479, 8,805 per million, the
reading's `largest_change` and `per_million`.

With the true masses, from the same plays' final speeds (`reading.txt`), in kilograms times micrometres a second:

- side, step 1: 4.177 x 172,601 + 0.698 x 127,115 = 809,681, against 0.698 x 1,160,000 = 809,680 at release;
- side, step 1/16: 4.177 x 189,234 + 0.698 x 27,580 = 809,681;
- top, both steps: (4.177 + 0.698) x 124,566 = 607,259, against 0.698 x 870,000 = 607,260 at release.

So the momentum is kept to within about 1 in 600,000, and every variant reads the same order of change, between 8,453
and 9,644 per million (13,122 for the side play at 1/16 with no contact damping), with patch F, without it, with the
patches off, on the default grid and at the shipped tolerances; Study 11's pair, in whole multiples of 10 g, reads 51 to
68 per million under the same configuration.

## What follows

- A corrected measure, `pairg`, which reads each mass in whole grams, stands beside `pair`, which is unchanged so that
  every earlier reading can be made again ([`measure/README.md`](../../measure/README.md)).
- A twenty-third registration (Study 23, [run 055](../run_055_study23/README.md)) repeated this registration's protocol on fresh
  numbers with that measure for T16: every rule of patch F held, and patch F is recorded as required, correct and safe
  under the recommended configuration.

## Note

The wall-clock times in `reading.txt` (`wall_s`) were taken with other parts of this run and run 052 playing on the
machine; they are reported, not ruled.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the twenty-first registration) changes in 19 numbers: the distance slid by
at most 0.18% (122,886 to 123,102 um), the distance come back by at most 4 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
