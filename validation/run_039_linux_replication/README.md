# Run 039: the record replicated on Linux, byte for byte

15 October 2026. Not registered: a replication probe, away from the laptop every other run was played on. It decides
nothing until a study registers its rules.

**The result: SuperDex built on another machine, operating system and compiler plays the record's registered files
byte for byte: 134 of 134** (the seventh study's two contact suites, stock and with patches A to C), and its readings
are the record's, line for line.

## Step 1: SuperDex built on Linux ([`build.sh`](build.sh))

SuperDex v1.0.0 at the commit in `UPSTREAM_COMMIT`, stock and patched with library build 15's four patch files (their
checksums in `patches.sha256`, the same as `patches/`), 64-bit, as [`docs/reproduce.md`](../../docs/reproduce.md) says,
on an AWS EC2 c7i.2xlarge (Intel Xeon Platinum 8488C, Ubuntu 24.04.5, Clang 18.1.3, CMake 3.28.3; `machine.txt`,
which keeps all but the instance type). The laptop's builds were made with Apple's Clang on macOS. The first attempt,
with the system's gcc, stopped at configure: SuperDex refuses any compiler but Clang 17 or newer on Linux (its
`compiler.cmake`), as the reproduce page says. The libraries' checksums: `build-stock.sha256`,
`build-patched.sha256`; the rigs, built by `tools/build_player.sh` with the same Clang: `rigs.sha256`.

## Step 2: the suites' default scenes ([`play.sh`](play.sh); `reading.txt`)

Both suites on their default scenes, stock (`runs/s1/linux_stock`, `runs/s2/linux_stock`) and with every switch of the recommended
configuration and the rig settings of the record's `dry14_final` plays (`runs/s*/linux_final`). **A fault of this
step's design:** it compared these plays with the record's `id_off` and `dry14_final` plays, which were played on
other scenes (the seventh study's cubes, and Study 14's dry-run cube), so its byte comparison (0 of 67 each) and its
readings of those two labels compared different scenes and count for nothing. Its own readings stand, and give the
same verdicts as the record's published ones, which were read on another cube:

| | Linux, on the suite's default scenes | The record's published results, on the seventh study's cube (the recommended configuration's page) |
|---|---|---|
| Stock | 6 of 10; fails T04, T05, T06, T08; the hold creeps 3,670 um/s | 6 of 10; fails T04, T05, T06, T08; creeps 3.67 mm/s |
| Every switch, the final configuration's settings | **10 of 10** | 10 of 10 |

## Step 3: the seventh study's scenes, against its registered files ([`play3.sh`](play3.sh); `reading3.txt`)

Both suites played on the seventh study's cubes exactly as `tools/play_identity.sh` plays them (`runs/s*/linux_s7_*`), and each play file
compared with the seventh study's registered file in [run 017](../run_017_counts/), which Study 16 found library build
15 makes again byte for byte on the laptop:

| | Play files byte-identical to the registered ones | Suite 1 on Linux | Suite 1 registered |
|---|---|---|---|
| Stock, no setting and no switch | **67 of 67** | 6 of 10 | 6 of 10 |
| Patches A to C, contact damping 5, falloff 0.03 (the seventh study's recommended configuration) | **67 of 67** | 9 of 10 | 9 of 10 |

Every number of every test line is the same on both machines (read by the record's runner with the seventh study's
constants, friction 0.35 and a slip push of 4,234 mN).

## What it shows

- **The record replicates away from the laptop, to the byte.** SuperDex is built with `-ffp-contract=fast`, which
  lets a compiler fuse floating-point operations and so may change the last digit between compilers and processors.
  On these two machines, macOS with Apple's Clang and Linux with Clang 18, both Intel x86-64, it does not, on any of
  the 134 files compared.
- **The verdicts replicate on fresh plays too**: on the suites' default scenes the Linux builds give stock's 6 of 10,
  failing the same four tests with the same creep, and 10 of 10 with the recommended configuration's switches.
- The whole record on Linux, and an arm64 machine, are what a registered replication would add.
