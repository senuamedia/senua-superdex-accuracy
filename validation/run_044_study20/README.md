# Run 044: the corrections switched on in 32-bit (Study 20)

15 October 2026, under [`preregistrations/PREREGISTRATION_20.md`](../../preregistrations/PREREGISTRATION_20.md), by
[`tools/plays/play_20.sh`](../../tools/plays/play_20.sh) on the Linux machine of runs 039 to 043 (AWS EC2, Ubuntu
24.04, Clang 18), played once: seven configurations side by side, 12 seconds of plays after the 32-bit rigs were built
(`started.txt`, `finished.txt`); 23 seconds in all with the building of those rigs (`play.txt`).
The 64-bit contact rigs were run 042's, checked against its checksums before any play (`rigs_check.txt`, empty). The
64-bit pair rigs were not in that check; the checksums this run recorded for them (`rigs.sha256`) are those of run
042's first step (`../run_042_two_corrections/rigs.sha256`). The 32-bit rigs were built from the sources of the
registration's commit (`rigs.sha256`). Every play exited 0 (`played.txt`, `log_*.txt`).
Measured by [`measure/runners/sx_study20_run.sh`](../../measure/runners/sx_study20_run.sh) (`reading.txt`). The plays
are kept under `runs/s1/` and `runs/s2/`.

## The result: six rules of seven held, as predicted

| Rule | It holds when | Measured | |
|---|---|---|---|
| **S0** | The 32-bit rigs built here make run 041's 32-bit plays again | 134 of 134 (`identity.txt`) | **Held** |
| **Z0** safe when off | In 32-bit, patched with no switch is byte-identical to stock on both suites | 39 of 39 and 28 of 28 | **Held** |
| **Z1** | In 32-bit under the final configuration, all ten tests of the first suite pass | 8 of 10: T01 and T08 fail | **Failed** |
| **Z2** | In 32-bit under the final configuration, T02 to T07, T09 and T10 pass | 8 of 8 | **Held** |
| **Z3** | In 32-bit, T01's reading under the final configuration is stock's, gap by gap | 10266 2433 5000 5000 21465840, both | **Held** |
| **Z4** | In 32-bit under the final configuration, T11 to T17 pass | 7 of 7 | **Held** |
| **Z5** | The 64-bit control on the fresh cubes: all ten and T11 to T17 | 10 of 10 and 7 of 7 | **Held** |

The predictions registered from the probe were the same: Z1 failing on T01 and T08, every other rule holding.

## The codes (`reading.txt`)

| | First suite, T01 to T10 | Second suite, T11 to T17 |
|---|---|---|
| 32-bit stock | 0110000011 | 0110111 |
| 32-bit patched, no switch | 0110000011 | (byte-identical to stock) |
| 32-bit, final configuration | 0111111011 | 1111111 |
| 64-bit stock | 1110001011 | 1110111 |
| 64-bit, final configuration | 1111111111 | 1111111 |

## What it shows

- **The corrections do in 32-bit what they do in 64-bit, for contact, friction and the ground, on fresh cubes.** Under
  the final configuration in 32-bit: the ground carries the weight, the bounce does not depend on the step (spread
  83 per 10,000 against an allowed 500), friction at an impact is Coulomb's (3,998 to 4,003 per 10,000 against
  4,000), a held cube does not move (0 um/s), a pushed one slips at the law, the ground never pulls, friction over the
  impact holds at every step, and a slide stops and stays stopped, a carried cube rides, slips at the law, and keeps
  momentum. 32-bit stock fails six of the first suite's tests and two of the second's.
- **Two limits are 32-bit SuperDex's own, with or without the corrections, as the registration decided to record
  them.** Free flight (T01): each gap between the drops of successive steps reads 10266 2433 5000 5000 21465840 per
  10,000 of the one before, the same under stock and under the final configuration (64-bit: 5000 5000 5000 5001 5002);
  no contact is involved. The refinement chain (T08): under the final configuration it falls from step 1 to 1/16
  (20,001 10,437 5,821 3,231) and then rises once (3,628), and falls again (1,666); in 64-bit it falls at every step.
- The joint, limit, rotation and benchmark corrections are not played in 32-bit here, as the registration said.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the twentieth registration) changes in 36 numbers: the distance slid by
at most 0.30% (127,467 to 127,849 um), the distance come back by at most 6 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
