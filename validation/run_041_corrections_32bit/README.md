# Run 041: the corrections switched on in 32-bit (design probe)

15 October 2026, on the Linux machine of runs 039 and 040 (AWS EC2, Ubuntu 24.04, Clang 18). Not
registered: a design probe for the open item "the corrections switched on in 32-bit arithmetic". Every reading of the
corrections before it was 64-bit; SuperDex ships 32-bit. It decides nothing until a study registers its rules.

What was played ([`build32.sh`](build32.sh), [`play.sh`](play.sh), [`measure.sh`](measure.sh), all pushed before any
build or play):

1. SuperDex built in its shipped 32-bit precision, stock and patched, from the source trees of run 039 (11 minutes 52
   seconds, `build32.txt`; the libraries' sha256, 5cda843a4cf2ba2e... stock and 3366a7bf36fae858... patched, recorded
   in `build-stock32.sha256` and `build-patched32.sha256`).
2. Both contact suites on the seventh study's cubes, in 32-bit and in 64-bit on the same machine, under five
   configurations: stock, off (patched, no switch), patches A to C with contact damping 5 and falloff 0.03 (the
   seventh study's recommended configuration), A to C and E (the ninth study's), and every switch with the final
   configuration's tolerances (abstol 1e-4, reltol 1e-8). The ten plays ran side by side, every one exiting 0
   (`played.txt`, `log_*.txt`). The plays are kept under `runs/s1/` and `runs/s2/`.
3. The record's own runner and measure read each (`suite1_*.txt`, `suite2_*.txt`, `verdicts.txt`). A first measuring
   pass found the runner missing from the machine and measured nothing but the identity (`first_measure_no_runner.txt`);
   the runner was copied and the measuring run again (`measure.txt`). `rc.txt` reads rc=1. No file says which command
   it is the exit code of. It matches the first measuring pass, whose last command, printing `verdicts.txt` before
   any verdict was made, failed (the last line of `first_measure_no_runner.txt`); `play.sh` ends by writing
   `finished.txt`, and every play exited 0 (`played.txt`).

## Safe when off in 32-bit, and the 64-bit plays replicate (`identity.txt`)

| Comparison | Byte-identical |
|---|---|
| 32-bit patched with no switch against 32-bit stock, both suites | 67 of 67 |
| 64-bit on Linux against the registered files: stock, off, A to C, A to C and E, both suites | 268 of 268 |
| 32-bit against 64-bit, any configuration | 0 (a different arithmetic; compared by reading below) |

## The first suite's ten tests (`verdicts.txt`)

| Configuration | 64-bit | 32-bit | The 32-bit tests that fail |
|---|---|---|---|
| Stock | 6 of 10 | 4 of 10 | T01, T04, T05, T06, T07, T08 |
| Off (patched, no switch) | 6 of 10 | 4 of 10 | the same, byte for byte |
| Patches A to C | 9 of 10 | 6 of 10 | T01, T05, T08, T10 |
| Patches A to C and E | 9 of 10 | 6 of 10 | T01, T05, T08, T10 |
| Final configuration | 10 of 10 | 8 of 10 | T01, T08 |

T05 under patches A to C, and A to C and E, fails in 64-bit too: friction at an impact is patch F's, which those
configurations leave out.

## What it shows

- **The corrections carry over to 32-bit on eight of the ten tests.** Under the final configuration in 32-bit the
  ground carries the weight (7,839 and 7,844 mN against 7,840), a held cube does not move (0 um/s), a pushed one slips
  at the law within 3 in 100, the bounce does not depend on the step (spread 68 against an allowed 500), friction at an
  impact is Coulomb's (3,499 to 3,503 per 10,000 against 3,500), and the ground never pulls.
- **T01, free flight, fails in 32-bit with and without the corrections, with the same reading.** Each gap between the
  drops of successive steps, in parts of 10,000 of the one before, reads 10270 2433 5000 5000 21465842 against 5,000
  (64-bit: 5000 5000 5000 5001 5002). No contact is involved, so it is 32-bit SuperDex's own. The likely cause is
  32-bit rounding over thousands of steps being as large as the gaps compared; not yet shown. Under patches A to C
  the seven free-flight files are byte-identical to stock's; under the final configuration two of them differ in the
  sideways speed, at the shipped step on 50 of its 100 steps by 1 to 3 um/s (at most 900,003 against 900,000) and at
  1/2 of it on 51 of its 200 by 1 to 6 um/s (at most 900,012 against 900,006), and each ends as stock's does. No play
  here tells whether the configuration's switches or its tighter tolerances make that difference (in 64-bit the same
  files are byte-identical to stock's). The reading is the same.
- **T08, the refinement chain, falls from step 1 to 1/16 in 32-bit and then rises once.** Under the final
  configuration: 24,217 13,564 7,111 4,197 4,577 1,773 (64-bit: 24,218 13,525 7,246 4,272 2,676 1,637). Under patches
  A to C the same rise. It falls at every step in 64-bit.
- **T10 under patches A to C in 32-bit is 1.0% under the law at the finest step** (3,464 per 10,000 against 3,500;
  64-bit 3,498); with patch F, in the final configuration, it holds.
- **The second suite under the final configuration reads in 32-bit as in 64-bit at the shipped step; at 1/16 of it
  some readings move apart** (`suite2_32_final.txt`, `suite2_64_final.txt`). A slide stops and stays stopped at every
  step, sliding within 0.01% of the 64-bit distance at steps 1 and 1/4, 0.032% shorter at 1/16 (117,896 against
  117,934 um) and 0.34% further at 1/64 (118,349 against 117,949 um); it comes back 294 to 299 um in both. At the
  shipped step a carried cube rides at the same speed (2,939,868 against 2,940,000 um/s). At 1/16 it rides 1.8%
  slower (2,887,344 against 2,940,000), the upward contact force on each of the resting pair reads 39,341 and 5,910
  mN against 64-bit's 39,200 and 5,880 (their weights), and momentum changes by up to 180 and 170 per million in the
  side and top collisions against 55 and 87.

A study of the corrections in 32-bit can be registered on fresh cubes from this. Its rules are not set by these
numbers: T01 and T08 are put to it as they are.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). This
run's play files were read again by the corrected program: 483 readings of the distance slid change, by at most 0.18%
on the long slides (the largest, 1,525 um on a slide of 898,424 um) and by 4 um on the shortest, a slide of 107 um; 72
of the distance come back change, by at most 40 um. Its findings stand. Corrected, the
second suite's slide under the final configuration, 32-bit against 64-bit: within 0.01% at steps 1 and 1/4 (113,752
against 113,758 um and 117,093 against 117,100 um), 0.031% shorter at 1/16 (117,911 against 117,948 um) and 0.34%
further at 1/64 (118,560 against 118,159 um); it comes back 293 to 300 um in both. The text above stays as it was
written, from the readings as printed.
