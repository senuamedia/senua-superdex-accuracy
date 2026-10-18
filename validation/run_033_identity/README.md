# Run 033: safe when off on library build 14, and run 032 made again

15 October 2026. Rule E0 of the fifteenth registration. Library build 14 (sha256 af70e149901c628a...) was built clean
from a fresh clone of SuperDex at the commit in [`UPSTREAM_COMMIT`](../../UPSTREAM_COMMIT), with only the four patch
files as registered with the fifteenth registration applied. It makes the registered plays on the identity list again, and each file is compared byte for
byte with its registered copy ([`tools/play_identity.sh`](../../tools/play_identity.sh)). The rigs were rebuilt
against build 14, with every new setting left unset; the `*_stock` rigs, with which run 032's play script makes its
stock plays, load the stock library. Played from the repository root with the SuperDex assets given
by a relative path.

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
| zero | New in this run: every switch set to `0`, which build 14 reads as off. Both contact suites and the 40 one-joint runs, against stock | 107 of 107 |
| fg | The registered plays with patch G: the twelfth registration's arm and chain under its two corrections, and the thirteenth's arm and limit runs under its final configuration | 44 of 44 |
| bench | The third and fourth registrations' 38 benchmark streams, no switch, against stock | 38 of 38 |
| benchrec | The ninth registration's 7 benchmark streams under its switches | 7 of 7 |
| r032 | New in this run: the whole of [run 032](../run_032_open_items/) made again from a copy of its play script that writes elsewhere. Every file is compared: the solver traces registered compressed are compared decompressed, and the benchmark's statistics without their wall-clock time | 391 of 391 |

Every file of every part is identical: 904 of 904. Build 14 made all of them but 17: run 032's stock plays on the
point-cloud sheet (`runs/cloud_stock/`, 8 files) and on Meta's scenes (`runs/bench/*_stock*`, 9 files) were made with
the `*_stock` rigs on the stock library, as run 032 had made them
([`tools/plays/play_14.sh`](../../tools/plays/play_14.sh), its `cloud` and `bench` parts), and run 032's benchmark
statistics file holds their lines beside the others'.
[Study 18](../../docs/studies/18-stock-plays.md) later made them on library build 15
([run 038](../run_038_stock_plays_14_15/)). Build 14 changes nothing in the plays it made. This holds with no switch
set, with every switch set to `0`, and under the switches of each registered configuration on the list. That includes
the fourteenth registration's final and accurate configurations, every play of run 032 but its stock plays. Of its
corrections, a switch set to `0` is played here (the zero part, 107 of 107 the same as stock); the others reach only
what no play on the list did: a second scene, a restored state. Rule E0 holds: build 14 replaces build 13 as the
library of record, and every result of runs 031 and 032 stands for it.

`identity.txt` is its own output.
