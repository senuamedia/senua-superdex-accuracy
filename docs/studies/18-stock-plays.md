# Study 18: the stock plays of Studies 14 and 15 made again on the library of record

| | |
|---|---|
| Registration | Eighteenth: [PREREGISTRATION_18.md](../../preregistrations/PREREGISTRATION_18.md) |
| Question | Does library build 15, with no switch set, make again byte for byte the 25 stock plays of runs 032 and 034 that run 035 made on the stock library? |
| Outcome | **Both rules held.** Every play file of runs 032 and 034 made again byte for byte on library build 15 (391 of 391 and 225 of 225), the 25 stock plays among them, made with no switch set. The files compared are those of run 032's `runs/` tree and of run 034's `runs/` and `accurate14/runs/` trees, as the identity script's parts `r032` and `r034` compare them; the runs' `dry_run/` and `probes/` folders are not among them |
| Registered | 15 October 2026, before any run of this registration existed |
| Result | [Run 038](../../validation/run_038_stock_plays_14_15/README.md), 15 October 2026 |
| Runs | 038, in the same fresh clone as run 037 |
| Played by | [`tools/play_identity.sh`](../../tools/play_identity.sh), parts `r032` and `r034` |

Previous: [Study 17](17-whole-record.md). Next: [Study 19](19-two-corrections.md). All studies: [index](README.md).

## Why it was asked

Run 035 made runs 032 and 034 again whole, with the play scripts of Studies 14 and 15. Those scripts make their stock
plays with the `*_stock` rigs, which load the stock library, so 25 files were made again on stock, not on build 15. A
documentation check after run 036 found it. Study 17 gives the `*_stock` names library build 15; this study plays the
two parts again that way, so that every registered play made with no switch has been made on the library of record.

## The result

| Rule | It holds when | Measured | |
|---|---|---|---|
| X0 | Every file of the two parts is byte-identical | 391 of 391 and 225 of 225 | Held |
| X1 | The 25 stock plays are among them, made on library build 15 with no switch set, and each is byte-identical | Made with the `*_stock` rigs, which load build 15, as the record's rigs file gives them with the library's checksum, 471d5d5bd856f37c... ([`rigs.txt`](../../validation/run_037_whole_record/rigs.txt) of run 037, in whose clone run 038 played); all identical | Held |

[Run 038](../../validation/run_038_stock_plays_14_15/README.md) took 57 minutes on the laptop.

## What it means

With [Study 17](17-whole-record.md)'s W0 and runs 035 and 036, every registered play of Studies 1 to 16 made with no
switch has been made again on library build 15, byte for byte.
