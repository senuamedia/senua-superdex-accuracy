# Eighteenth pre-registration: the stock plays of runs 032 and 034 made again on library build 15

Registered 15 October 2026, before any run of this registration existed.

## The question

Run 035 made runs 032 and 034, Studies 14 and 15, again whole and found every file byte-identical. The identity
script makes them with the play scripts of those studies, and the play scripts make their stock plays with the
`*_stock` rigs, which load the stock library. So 25 of those files were made again on the stock library, as runs 032
and 034 had made them, and not on library build 15. A documentation check after run 036 found this. Every other file
the identity runs compare was made on build 15, but for 3 plays of run 034's review part, which are made on library
build 13 by design.

Does library build 15, with no switch set, make those 25 stock plays again byte for byte? With the seventeenth
registration's rule W0, that would make every registered play of Studies 1 to 16 that was made with no switch, made
again on build 15.

The 25 files:

| Run | Files |
|---|---|
| 032 | `runs/cloud_stock/`: the thirteenth registration's cube on the held point-cloud sheet, 7 plays and their statistics (8) |
| 032 | `runs/bench/`: `half_cheetah`, `ant` and `cart_pole` on stock, each its stream, its solver trace and its rig output (9) |
| 034 | `runs/items/cloud_stock/`: item 3's fresh cube on the held sheet, 7 plays and their statistics (8) |

The benchmark's statistics file of run 032 holds the stock plays' lines beside the other configurations'; it is
compared too.

## What changed since the seventeenth registration

Nothing. Library build 15, the rigs and every script are as the seventeenth registration registered them.

## What is played

**Run 038**, after run 037 has finished, in the same fresh clone with the same rigs, whose `*_stock` names are given
library build 15. From the clone's root:

    SUPERDEX_ASSETS=<assets> SUPERDEX_BUILD13=<library build 13's folder> tools/play_identity.sh <out file> r032 r034

The two parts make runs 032 and 034 again whole and compare every file with the registered one, as in run 035: the
solver traces registered compressed are compared decompressed, and the benchmark's statistics and rig output
without their wall-clock time.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **X0** | Every file of the two parts is byte-identical: 391 of 391 for run 032 and 225 of 225 for run 034 |
| **X1** | The 25 stock plays above are among them, made on library build 15 with no switch set, and each is byte-identical |

## Decisions fixed in advance

- If X0 and X1 hold, the stock plays of Studies 14 and 15 are made again on library build 15. With the seventeenth
  registration's W0, every registered play of Studies 1 to 16 made with no switch is then made again on build 15.
- A file that differs is recorded as measured, played again on the stock library with the same rig to tell the
  library from the rig, and stays open.

## Known risks

- Run 035 made these parts on build 15 with the stock rigs and found them identical, so every file but the 25 is
  expected to be identical again. The 25 were made on build 15 by no run yet.
- Time: run 035's two parts took most of its 66 minutes.

## As registered

Library build 15 in 64-bit, 471d5d5bd856f37c.... `tools/play_identity.sh` unchanged since the sixteenth registration
(bb1f52e8fdae023f...). The rigs as run 037 records them in its `rigs.txt`: every rig, the `*_stock` names included,
loads library build 15.
