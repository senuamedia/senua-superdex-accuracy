# Run 038: the stock plays of runs 032 and 034 on library build 15 (Study 18)

15 October 2026, 03:42 to 04:39 UTC, under [`preregistrations/PREREGISTRATION_18.md`](../../preregistrations/PREREGISTRATION_18.md),
by [`play.sh`](play.sh) (the registration's command) on the laptop, under the host guard. It played in the fresh
clone run 037 played in (`clone_commit.txt`), with the same rigs: every rig, the `*_stock` names included, loads
library build 15 (sha256 471d5d5bd856f37c...; run 037's `rigs.txt`). No file of this run records a check of the rigs
after it. At the publication audit the library and every rig `rigs.txt` names in that clone, the `*_stock` ones
included, still had the checksums and the library folder `rigs.txt` gives. It stayed on the laptop because the
registration is about the macOS library of record.

## The result: both rules held

| Rule | It holds when | Measured | |
|---|---|---|---|
| **X0** | Every file of the two parts is byte-identical: 391 of 391 for run 032 and 225 of 225 for run 034 | 391 of 391 and 225 of 225 (`identity.txt`) | **Held** |
| **X1** | The 25 stock plays are among them, made on library build 15 with no switch set, and each is byte-identical | Made with the `*_stock` rigs, which load build 15; all identical | **Held** |

The run took 57 minutes (`play.txt`, `started.txt`, `finished.txt`; exit 0, `rc.txt`).

## What it shows

The 25 stock plays of runs 032 and 034, which run 035 had made on the stock library, are made byte for byte on
library build 15 with no switch set. With Study 17's W0 and runs 035 and 036, every registered play of Studies 1 to 16
made with no switch has been made again on the library of record, byte for byte.
