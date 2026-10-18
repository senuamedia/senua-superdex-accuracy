# Run 035: safe when off on library build 15, and runs 032 and 034 made again

15 October 2026. Rule E0 of the sixteenth registration. Library build 15 (sha256 471d5d5bd856f37c...) was built
clean from a fresh clone of SuperDex at the commit in [`UPSTREAM_COMMIT`](../../UPSTREAM_COMMIT), with only the four
patch files as registered with the sixteenth registration applied. It makes the registered plays on the identity list again, and each file is compared byte
for byte with its registered copy ([`tools/play_identity.sh`](../../tools/play_identity.sh)). The rigs were rebuilt
against build 15, with every new setting left unset; the `*_stock` rigs, with which the play scripts of runs 032 and
034 make their stock plays, load the stock library
([PREREGISTRATION_18.md](../../preregistrations/PREREGISTRATION_18.md)). Played from the repository root with the
SuperDex assets given by a relative path, and library build 13 given for run 034's review part, as that run had it.

The plays on the identity list hold a part of the record; [Study
16](../../docs/studies/16-second-review.md#what-the-registration-overstated) says which part.

| Part | What was played | Identical |
|---|---|---|
| rotvec | The ninth registration's 40 rotations, no switch, against stock | 1 of 1 |
| flight | The ninth registration's two free cubes at four steps, no switch, against stock | 8 of 8 |
| suites_off | Both contact suites on the seventh registration's cubes, no switch, against stock | 67 of 67 |
| suites_abcd | The same under patches A to C, against the seventh registration's recommended files | 67 of 67 |
| suites_e | The same with patch E alone, against the ninth registration's files | 67 of 67 |
| suites_abcde | The same under patches A to C and E, against the ninth registration's files | 67 of 67 |
| joints | The sixth and eighth registrations' 40 one-joint runs, no switch, against stock | 40 of 40 |
| zero | Every switch set to `0`: both contact suites and the 40 one-joint runs, against stock | 107 of 107 |
| fg | The registered plays with patch G, under the twelfth and thirteenth registrations' configurations | 44 of 44 |
| bench | The third and fourth registrations' 38 benchmark streams, no switch, against stock | 38 of 38 |
| benchrec | The ninth registration's 7 benchmark streams under its switches | 7 of 7 |
| r032 | The whole of [run 032](../run_032_open_items/) made again and compared file by file | 391 of 391 |
| r034 | New in this run: the whole of [run 034](../run_034_replication/) made again and compared file by file: its items, deformable bodies, long plays and the fourteenth registration's accurate plays at the final tolerances, and its review part with library build 13 beside it. The copy of the fourteenth registration's play script it writes, its difference and its log name the folder they were written to and are not compared | 225 of 225 |

Every file of every part is identical: 1,129 of 1,129. Build 15 made all of them but 28: 25 files of the stock plays
of runs 032 and 034 were made with the `*_stock` rigs on the stock library, and 3 plays of run 034's review part on
library build 13, as those runs had them ([PREREGISTRATION_18.md](../../preregistrations/PREREGISTRATION_18.md));
[Study 18](../../docs/studies/18-stock-plays.md) later made the 25 on build 15
([run 038](../run_038_stock_plays_14_15/)). Build 15 changes nothing in the plays it made. That holds with no switch
set, with every switch set to `0`, and under the switches of each registered configuration on the list,
including the final and accurate configurations of runs 032 and 034. Its corrections reach only what no
play on the list did: a contact a mapped collider missed, a body set to a new pose, viscous friction under patch F, and the anchor
table's lifetime. Rule E0 of the sixteenth registration holds.

`identity.txt` is its own output.
