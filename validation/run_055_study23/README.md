# Run 055: patches F and G and the recommended configuration, held to every rule on fresh numbers, on library build 16 (Study 23)

15 October 2026, 12:01:14 to 12:21:34 UTC (`times.txt`), under
[`preregistrations/PREREGISTRATION_23.md`](../../preregistrations/PREREGISTRATION_23.md), by
[`tools/plays/play_23.sh`](../../tools/plays/play_23.sh) from its own copy of the record at the registration's commit, on
the Linux machine of runs 039 to 052 (AWS EC2, Intel Xeon Platinum 8488C, Ubuntu 24.04, Clang 18). Played once: each
part started and finished once (`times.txt`). After the part rigs (39 seconds), the parts ran side by side as separate
processes, as the registration allows: the identity check, the order, the benchmark, the point-cloud floor (then the
deformable bodies and the grippers) and the contact suites (then items, arm, chain, joints, limits and rotvec). The
longest was the order, 19 minutes 41 seconds.

The libraries were library build 16 and stock (75def9201a45216a...), built on that machine by
`validation/run_039_linux_replication/build.sh` from the four patch files as they stood at registration
(`build-patches.sha256`, the registration's checksums). Library build 16 built there reads b3a978949092a654...
(`build-patched16.sha256`). Run 052 built the same four files into a folder named `build-derived` and read
2dc292922b3fa4e5...: the two libraries are the same code. With the folder names written into each library made the
same, they differ in 20 bytes only, the GNU build ID the linker derives from those names. Every rig was built by the play
script from the sources in `tools/`, whose checksums are the registration's (`rigs.sha256`); the stock deformable and
gripper plays were made with rigs built against the stock library (`played.txt`). Every part played (`played.txt`).

Measured by [`measure/runners/sx_study23_run.sh`](../../measure/runners/sx_study23_run.sh) (`reading.txt`), with the
measuring program `measure/sx_contact.sx` with `pairg` beside it, and the order read by the instrument `sx_settings3`
(`counts.txt`). The plays are kept under `runs/`: the suites under `s1/` and `s2/`, the benchmark streams under
`bench/`, the order's streams and the stopped steps taken from their traces under `order/` (the traces were removed
after the counts were taken, as registered). The identity check's own plays are not kept here; its comparisons are
`identity.txt`, `identity_play.txt` and `identity_linux.txt`.

## The result: 117 rule lines of 118 held; one line of P2 failed

44 rules of 45 held. The one line that failed is P2's `P2_friction_at_the_impact_within_1_in_25`: on the point-cloud
floor under the configuration, friction over the impact read 4,030 and 4,173 per 10,000 at steps 1 and 1/4 against
the law's 3,970 and a bound of 1 in 25 (3,811.2 to 4,128.8); the step 1/4 reading is 5.1% above the law. The reading's
last line: `STUDY23 rule lines held 117 failed 1 ; patch F's (F1 to F6) held 14 failed 0 ; patch G's (G1 to G9) held
30 failed 0 ; values missing 0 ; measuring complete 1`.

| Rules | Rule lines held | What was measured |
|---|---|---|
| E0, safe when off | 2 of 2 | 513 files of the identity check's parts rotvec, flight, suites, joints, zero, fg, bench and benchrec: 501 byte-identical to their registered files, and the 12 that differ exactly the 12 plays named for Linux, each byte-identical to the file run 040 kept, and the six with no switch also to the same play on the stock library on this machine (`identity.txt`, `identity_linux.txt`) |
| F1 | 1 of 1 | Without patch F, T05 fails: 2,601 to 3,741 per 10,000 at the seven steps against the law's 3,880. Reported: the shipped step's 3,084 is 79.5% of the law |
| F2 | 2 of 2 | Under the configuration, friction over the impact 3,879 or 3,880 per 10,000 at every step against 3,880; T10 passes |
| F3 | 2 of 2 | The first suite 1111111111; the second suite 1111111. T16, read by `pairg`: 89 and 83 parts per million on the side play at steps 1 and 1/16, 110 and 111 on the top play, against 500 |
| F4 | 2 of 2 | No step of either suite stopped or diverged under the configuration |
| F5 | 6 of 6 | Meta's scenes at the shipped step: stopped steps of 21,600, under the configuration and without patch F, `half_cheetah` 5 and 4, `ant` 1 and 15, `cart_pole` 0 and 0; none diverged |
| F6 | 1 of 1 | The first suite's other tests pass or fail as they do without patch F |
| G1 | 3 of 3 | Stock, one arm, shipped step: 1,862,193, 3,043,280 and 4,284,070 micro-radians a second against the law's 1,861,892, 3,042,168 and 4,281,605 |
| G2 | 3 of 3 | Under the configuration, all nine plays between 9,990 and 10,010 per 10,000; the lowest 3,369,964 of 3,370,000 |
| G3 | 2 of 2 | No switch, free chain, shipped step: 758,203 per million of the kinetic energy kept, angular momentum -97,350 parts per million |
| G4 | 4 of 4 | The solve converged: momentum drift 0 at every step; largest energy drift 491, 31 and 2 per million at steps 1, 1/4 and 1/16 (bounds 5,000, 1,000 and 500) |
| G5 | 2 of 2 | Under the configuration, free chain: energy at the end 1,000,094, 1,000,012 and 1,000,012 per million of its start; momentum 1, 2 and 3 parts per million |
| G6 | 4 of 4 | Swinging chain: the configuration loses 307,421, 68,363 and 19,370 per million against no switch's 838,660, 652,510 and 163,769, falling with the step |
| G7 | 2 of 2 | No step of the arm and chain plays stopped or diverged |
| G8 | 4 of 4 | JT1 3,619,948 (at least 3,583,800); the driven arm 6,309,984 against 6,310,024; the hold creeps -338 as stock does (-338); the slip 4,136,544 and 4,136,549 against its right answer 4,136,571 |
| G9 | 6 of 6 | Meta's scenes: stopped steps under the configuration and without patch G and Newton-Euler inertia, `half_cheetah` 5 and 9, `ant` 1 and 1, `cart_pole` 0 and 0; none diverged |
| J1, J5 | 2 of 2 | The free arm keeps 3,619,948 of 3,620,000; no step of the joint tests stopped or diverged |
| L1 to L4 | 8 of 8 | At rest on the limit -357,438 micro-radians at both steps (band -357,472 to -357,404); leaving at 1/64 at 1,973,899 and 572,448 against 1,990,591 and 574,988; at the coarser steps left and moving; lifted to -205,830 and -217,174 (bound -232,063); no step stopped or diverged |
| R1 | 1 of 1 | 40 rotation vectors of 40 right, 20 at or under 2e-9 rad and 20 above |
| P1 | 2 of 2 | Stock on the point-cloud floor: friction over the impact 14,219 per 10,000 against the law's 3,970, the slip 369,600 of 793,000 micrometres a second |
| P2 | 7 of 8, failed | Under the configuration: rest 11,309 mN against 11,309, the lift never pulls, the hold 0, sliding friction 3,980 against 3,970, the slip 783,900 of 793,000, no step diverged, most iterations 19. **The impact 4,030 and 4,173 at steps 1 and 1/4 against 3,970 within 1 in 25: failed at step 1/4** |
| V1, I1d | 5 of 5 | Item 1's two fresh pairs: the cubes 4,371 and 4,370 and 3,459 mm/s2 against 4,371 and 3,459, the blocks 6,990 and 6,991 and 5,347 against 6,991 and 5,348, at both steps; no step stopped or diverged |
| V2 | 5 of 5 | The arm within 1 in 10,000 at every speed and step; the free chain's energy within 94 per million, its largest momentum drift 2, 3 and 4 parts per million |
| V4 | 6 of 6 | The three cantilevers at 64 and 128 elements within 0.01% of the textbook (2,646,777 and 2,647,027 nm against 2,646,994; 9,886,400 and 9,887,382 against 9,886,651; 9,566,417 and 9,567,346 against 9,567,326), and at 32 within 1 in 200. Reported: 2 stopped steps, most iterations 3 |
| V9 | 3 of 3 | The arm swinging 20 s: its largest swing 9,614 and 9,974 per 10,000 at steps 1 and 1/16; no step diverged, most iterations 2 |
| D1 to D8 | 15 of 15 | Falls, hangs and slides at their right answers, stock and the configuration; stock creeps on the tilt at 4,606 to 4,688 micrometres a second against 4,611 and drifts 2,303,058 to 2,306,932 nm, and under the configuration the hold moves 0 to 8,221 nm, inside the stick distance; every rest at 0; no step stopped or diverged |
| GR1 to GR5 | 8 of 8 | Both grippers under the configuration: the grip 6,999,999 to 7,000,001 uN against 7,000,000, each finger carries 612,332 to 612,595 against 612,500, the cube does not creep and slips 32,281 and 31,430 nm; stock lets the cube creep out at 1.00 and 0.60 mm a second; no step stopped or diverged |
| B1 to B3 | 9 of 9 | Under the configuration on the fresh commands: stopped steps of 21,600, `half_cheetah` 5, `ant` 1, `cart_pole` 0, none diverged. `half_cheetah` and `ant` in order in 3 folds of 3 at steps 1 to 1/16 (`counts.txt`), no step of the ten plays diverged |

Reported, not deciding (`reading.txt`):

- Stock on the fresh commands: `half_cheetah` 4 stopped, `ant` 235, `cart_pole` 0; none diverged.
- The order's chains: 16 stopped steps in all (`half_cheetah` 5, 5 and 4 at steps 1, 1/2 and 1/4; `ant` 1 at step 1
  and 1 at 1/4), every one at the iteration limit; none diverged.
- The point-cloud floor over the 0.1 s after the impact, at the shipped step: 4,011 per 10,000 under the
  configuration (1.0% above the law), and stock 12,877.
- The second suite without patch F: 1111111, as with it; the first suite without patch F 1111011111 (T05 fails).

## What the decisions record

- **E0 and F1 to F6 held, so patch F is recorded as required, correct and safe under the recommended configuration**,
  as the registration decided in advance.
- **E0 and G1 to G9 held, so patch G is recorded as required, correct and safe under the recommended configuration,
  under backward Euler**, the twenty-first registration's decision replicated on fresh numbers and on library build 16.
- **One line of P2 failed, so the recommended configuration is not recorded as validated end to end** by this
  registration. The line is recorded as measured, and what it concerns, friction over a one-step impact on the
  point-cloud floor at step 1/4, stays open.
- Nothing about BDF2 or the accurate configuration is decided here.

## On the line that failed

The registration named this reading as a known risk before the run: friction over a one-step impact on a discrete
floor moves by up to 3% with where the cube lands among the floor's nodes, and this study's cube had its side faces
0.3 mm outside a row of nodes. On this cube it read 1.5% above the law at the shipped step and 5.1% above at step 1/4,
where stock reads 3.6 and 1.2 times the law. Over the 0.1 s after the impact the configuration reads 1.0% above. No
play was made again for it, and its cause has not been traced; it is on the open list.

## Note

The wall-clock times in `reading.txt` (`wall_s`) were taken with other parts of this run playing on the machine; they
are reported, not ruled.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the twenty-third registration) changes in 20 numbers: the distance slid by
at most 0.17% (209,080 to 209,442 um), the distance come back by at most 4 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
