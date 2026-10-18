# Run 047: safe when off for the benchmark streams on Linux

15 October 2026, 06:35 to 06:55 UTC (`started.txt`, `finished.txt`), on the Linux machine of runs 039 to 045 (AWS
EC2, Intel Xeon Platinum 8488C, Ubuntu 24.04, Clang 18). Not registered: a check for publication, by
[`play.sh`](play.sh), committed before it played.

## Why

[Run 040](../run_040_linux_identity/README.md) played the identity check's 38 benchmark streams (the third and fourth
studies' sources, no switch) on Linux with the patched library and found 4 that differ from the registered macOS
streams (`ant` s4, c1, c06 and c03). That left open whether the patches with no switch set are what changes them on
Linux, or Linux itself. Here the same 38 are played twice on the same machine: with the player built against the
stock library and with the player built against the patched library (library build 15) with no switch set.

## What was played

- The two libraries are the Linux builds of runs 039 and 045: stock (sha256 75def9201a45216a...) and library build 15
  (eee7cca1423650df...), each player loading its own (`rigs.txt`, from the loader).
- The 38 sources, settings and commands of the identity check's `bench` part, one stream after another, each with
  the stock player and then the patched player (`play.sh`).
- Each pair compared byte for byte, and each play with the registered stream; each pair's solver statistics (the
  rig's `STATS` line without its wall-clock field) compared with each other (`compare.txt`, `stats_stock.txt`,
  `stats_off.txt`).

## The result

| Comparison | Streams |
|---|---|
| Stock against patched with no switch, byte for byte | **38 of 38 the same** |
| Their solver statistics | 38 of 38 the same |
| Stock against the registered macOS stream | 34 of 38 |
| Patched with no switch against the registered macOS stream | 34 of 38 |

The four streams that differ from the registered ones (`ant` s4, c1, c06, c03) differ the same way with the stock
library: on Linux, stock and patched with no switch make the same bytes for each of them (`compare.txt`).

## What it shows

**On Linux the patches with no switch set are safe when off on the benchmark streams: 38 of 38 byte for byte against
stock built on the same machine.** The four streams that differ from the macOS record are Linux's own: SuperDex is
built with `-ffp-contract=fast`, and a different compiler and maths library may change the last digit, which on
`ant`'s long plays carries into a stream. They are not the patches.

The players' outputs are not kept, since each pair is the same; the statistics of every play are.
