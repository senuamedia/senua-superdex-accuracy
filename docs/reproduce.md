# Reproduce it

Everything that touches SuperDex is open: the rigs, the play scripts, the patches, the commands and the checksums
of every run. This page takes you from a clean checkout of SuperDex to byte-for-byte comparison with the runs kept
here.

Back to the [documentation index](README.md).

## What you can and cannot re-make

| Part | Can you re-make it? |
|---|---|
| Every run of SuperDex: encoder streams, one-cube runs, one-arm runs, solver status | Yes, with the open rigs and each study's play scripts (Study 5's was written for Study 17), and compare byte for byte |
| The readings of the known-answer suites | The rules and right answers are in [`measure/sx_contact.sx`](../measure/sx_contact.sx), and the arithmetic can be redone with any tool from the raw runs. The record's own measuring programs re-make every reading byte for byte from the record's files (`measure/runners/remake.sh`), but they are Simplex and need the Senua AI engine, which is not distributed, to build |
| The gap instrument's readings in Studies 1 to 3 | No. The Senua AI engine is proprietary and is not distributed. Its readings are published as records beside every stream it read, and Study 3 checks them against plain subtraction |

## 1. Build SuperDex

You need SuperDex v1.0.0 at the commit in [`UPSTREAM_COMMIT`](../UPSTREAM_COMMIT), with HDF5 on, because the
published benchmark scenes keep their meshes in `.mochi.h5` files. On Linux SuperDex accepts only Clang 17 or newer
(`export CC=clang CXX=clang++` before configuring), and the rigs are then built with the same Clang (put `clang++` on
the path as `c++` for `tools/build_player.sh`). Built this way on Linux, every contact play of the identity check
replicates byte for byte ([runs 039](../validation/run_039_linux_replication/README.md) and
[040](../validation/run_040_linux_identity/README.md)). Five long joint and chain plays differ in the last printed
digit on one to four lines, with every reading of them the same, and 6 of the 45 benchmark streams differ, the
solver's own counts by 0 to 9 steps (run 040).

```
git clone --branch stable https://github.com/facebookresearch/project_superdex "$SUPERDEX_SRC"
git -C "$SUPERDEX_SRC" checkout "$(cat UPSTREAM_COMMIT)"
cmake -S "$SUPERDEX_SRC/superdex_physics" -B "$SUPERDEX_BUILD" -DCMAKE_BUILD_TYPE=Release \
      -DMOCHI_USE_PYBIND=OFF -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON \
      -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF -DMOCHI_USE_DOUBLE_PRECISION=ON
cmake --build "$SUPERDEX_BUILD" --target mochi_physics
```

Four base builds are used, and beside them library builds 13, 14 and 15 from the forms kept in `patches/superseded/` (Studies 15 to 22, and the identity check), as below.

| Build | How | Needed for |
|---|---|---|
| Stock, 64-bit | As above | Every study from 2 on but 17 and 18, which gave the stock rig names library build 15 |
| Stock, 32-bit | The same without `-DMOCHI_USE_DOUBLE_PRECISION=ON` | Studies 1, 2 and 20 |
| Patched, 64-bit | A second checkout with the patches applied, built as the first | Studies 5 and 7 to 22 |
| Patched, 32-bit | The patched checkout built without `-DMOCHI_USE_DOUBLE_PRECISION=ON` | Studies 16 and 20 |

To make the patched tree, from the root of a second SuperDex checkout at the same commit:

```
git apply <this repository>/patches/senua_contact.patch <this repository>/patches/senua_joint_limit.patch \
          <this repository>/patches/senua_rotation_axis.patch <this repository>/patches/senua_inertia_transport.patch
```

The files in `patches/` are library build 16. A study registered on an earlier build is made again on that build:
apply the forms kept in [`patches/superseded/`](../patches/superseded/) instead, each named for the registration that
last used it (for library build 15, the current contact, joint-limit and rotation files with
`senua_inertia_transport_registration22.patch`; for library build 14, the `_registration15` files with the current
rotation file and `senua_inertia_transport_registration22.patch`; for build 13, the `_registration14` files).
[`patches/README.md`](../patches/README.md) gives every form's checksum.

Studies 21 and 22 were registered on library build 15, and their play scripts check the patch files in `patches/`
against the ones the libraries were built from. To make them again, play them from a copy of this repository in which
`patches/senua_inertia_transport.patch` is `patches/superseded/senua_inertia_transport_registration22.patch`, and, for
Study 22, `patches/in_design/senua_inertia_transport_bdf2_derived.patch` is the current
`patches/senua_inertia_transport.patch` (the same file, sha256 c3e1442befd6dee9..., which the twenty-second
registration names by that path).

## 2. Build the rigs

[`tools/build_player.sh`](../tools/build_player.sh) builds one rig against one SuperDex build. It compiles the rig
with the library's own flags, taken from the build directory, so the parameter structures match.

| Variable | Meaning |
|---|---|
| `SUPERDEX_SRC`, `SUPERDEX_BUILD` | The SuperDex checkout and its build directory |
| `SRC` | The rig's source file (default `sdx_player.cpp`) |
| `OUT` | The name of the binary |
| `LIB` | `mochi_physics` for the 32-bit build, `mochi_physics_double` for the 64-bit build |

The binaries the play scripts expect:

| Binary | Source | Built against |
|---|---|---|
| `tools/sdx_player` | `sdx_player.cpp` | Stock, 32-bit |
| `tools/sdx_player32` | `sdx_player.cpp` | Patched, 32-bit |
| `tools/sdx_player64_stock`, `sdx_contact64_stock`, `sdx_pair64_stock`, `sdx_joint64_stock` | The four rigs | Stock, 64-bit |
| `tools/sdx_player64`, `sdx_contact64`, `sdx_pair64`, `sdx_joint64` | The four rigs | Patched, 64-bit |
| `tools/sdx_rotvec64_stock`, `tools/sdx_rotvec64` | `sdx_rotvec.cpp` | Stock and patched, 64-bit |
| `tools/sdx_chain64`, `sdx_deform64`, `sdx_grip64` | `sdx_chain.cpp`, `sdx_deform.cpp`, `sdx_grip.cpp` | Patched, 64-bit (with no switch set they play the registered stock plays: Study 17 found them the same on build 15, and [run 046](../validation/run_046_stock_rigs/README.md) made all 116 again with the rigs built against the stock library, byte for byte) |

For example:

```
SRC=sdx_contact.cpp OUT=sdx_contact64 LIB=mochi_physics_double SUPERDEX_BUILD=<the patched 64-bit build> tools/build_player.sh
```

The scripts of Studies 2 to 4 call `tools/sdx_player64` and `tools/sdx_contact64`. They were first played on the
stock 64-bit build, before the patches existed. Built against the patched library with no switch set, those rigs
give the same bytes on every file compared, and that is itself one of the registered checks: Study 17 found every
play made with no switch the same, 827 of 827.

## 3. Play a study

Run each script from the root of this repository. The top of each script says what it needs and what it writes.

| Study | Script | Roughly how long |
|---|---|---|
| 1 | `tools/plays/play_01.sh <superdex assets>` | About an hour on a laptop, one thread |
| 2 | `tools/plays/play_02.sh <superdex assets>` | About an hour |
| 3 | `tools/plays/play_03.sh <superdex assets>` | Longer: 84 sources, some at 1/64 of the step |
| 4 | `tools/contact_all.sh`, then `tools/plays/play_04.sh <superdex assets>` | Under a second a play for the cube |
| 5 | `bash tools/plays/play_05.sh suites`, then `SUPERDEX_ASSETS=<assets> bash tools/plays/play_05.sh bench` (the script was written for the seventeenth registration from the fifth's record) | Under a second a suite play; the benchmark part is the long one |
| 6 | `tools/joint_all.sh` | Under a second a play |
| 7 | `SUPERDEX_ASSETS=<assets> tools/plays/play_07.sh suites`, then `identity`, then `bench` | The benchmark part is the long one |
| 8 | `tools/limit_all.sh`, then `SUPERDEX_ASSETS=<assets> tools/plays/play_08.sh identity`, then `bench` | A second or two a play for the arm |
| 9 | `SUPERDEX_ASSETS=<assets> tools/plays/play_09.sh rotvec`, then `flight`, `joints`, `suites`, `identity`, `bench` | About 50 minutes in all |
| 10 | `SUPERDEX_ASSETS=<assets> tools/plays/play_10.sh 0 1 2 3` | `ant`'s four sets of commands, each played several ways |
| 11 | `SUPERDEX_ASSETS=<assets> tools/plays/play_11.sh suites`, then `bench` | The benchmark part is the long one |
| 12 | `SUPERDEX_ASSETS=<assets> tools/plays/play_12.sh arm`, then `chain`, `joints`, `bench with_f` (the registered benchmark: patch F had joined; `without_f` was the alternative and was not played) | The benchmark part is the long one |
| 13 | `SUPERDEX_ASSETS=<assets> tools/plays/play_13.sh yes yes suites joints limits rotvec cloud deform grip bench` (stock is played beside, where a rule compares with it) | About an hour |
| 14 | `SUPERDEX_ASSETS=<assets> tools/plays/play_14.sh items suites joints limits rotvec cloud deform grip bench` | About 70 minutes |
| 15 | `SUPERDEX_ASSETS=<assets> SUPERDEX_BUILD13=<library build 13's folder> tools/plays/play_15.sh items deform review long accurate14` (run with `bash`) | About 25 minutes |
| 16 | `SUPERDEX_ASSETS=<assets> SUPERDEX_BUILD14=<library build 14's folder> bash tools/plays/play_16.sh bits32 corrections deform` | About 80 minutes |
| 17 | In a fresh clone, never in the record: `SUPERDEX_ASSETS=<assets> bash tools/plays/play_17.sh <the record> <out> list clear s03 s04 s05 s06 s07 s08 s09 s10 s11 s12 s13 compare`, with the `*_stock` rig names given the library under test | Six to eight hours |
| 18 | In run 037's clone, with the same rigs: `SUPERDEX_ASSETS=<assets> SUPERDEX_BUILD13=<library build 13's folder> tools/play_identity.sh <out file> r032 r034` | About an hour |
| 19 | On Linux with valgrind, after building library build 14 (`validation/run_042_two_corrections/build14.sh`) and run 042's rigs (`probe4.sh` builds them): `bash tools/plays/play_19.sh <work folder of run 039> <out>` | A few minutes |
| 20 | On Linux, after building the 32-bit libraries (`validation/run_041_corrections_32bit/build32.sh`): `bash tools/plays/play_20.sh <work folder of run 039> <out>` | Under a minute of plays |
| 21 | On Linux, from a folder made by `validation/run_039_linux_replication/build.sh`: `bash tools/plays/play_21.sh <that folder> validation/run_051_study21`, then `measure/runners/sx_study21_run.sh validation/run_051_study21 <out>` with the measuring programs beside it | About an hour of plays, spread over parts |
| 22 | On Linux, from the same folder: `bash tools/plays/play_22.sh <that folder> validation/run_052_study22`, then `measure/runners/sx_study22_run.sh validation/run_052_study22 <out>` with `sx_contact` beside it | About an hour |
| 23 | On Linux, from a folder made by `validation/run_039_linux_replication/build.sh` from the current patch files: `bash tools/plays/play_23.sh <that folder> validation/run_055_study23`, then `measure/runners/sx_study23_run.sh validation/run_055_study23 <out>` with the measuring programs beside it | About an hour |
| Safe when off | `SUPERDEX_ASSETS=<assets> SUPERDEX_BUILD13=<library build 13's folder> tools/play_identity.sh <out file>`: the registered plays on its list made again and compared | About 70 minutes |

For Study 5, the settings and switches of each configuration are in the `CONFIG` file of its folder under
[`patches/validation/runs/`](../patches/validation/runs/).

The suite scripts write to `suites/1/<label>/` and `suites/2/<label>/`. For Studies 5, 7 and 9 the record's copies were
made from there by hand: `suites/1/v5_<configuration>/` is `patches/validation/runs/<configuration>/` (its `stats.txt` also
`patches/validation/stats_<configuration>.txt`), `suites/<1|2>/v7_<configuration>/` is
`validation/run_017_counts/runs/s<1|2>/<configuration>/`, and `suites/<1|2>/v9_<configuration>/` is
`validation/run_021_rotation/runs/s<1|2>/<configuration>/`. The scripts of Studies 11 and 13 copy their own.
[`tools/plays/play_17.sh`](../tools/plays/play_17.sh) holds the whole map.

A source that has already been played is skipped, so an interrupted run can be started again.

## 4. Compare

The raw-run folders, `actions/`, `streams/` and the suite runs of Studies 5, 7 and 9 have a `SHA256SUMS` file; the study runs from run 026 on are compared file by file.

```
cd streams/03 && shasum -a 256 -c SHA256SUMS
```

| Folder | Study |
|---|---|
| `streams/01/`, `streams/02/`, `streams/03/` | 1, 2, 3 |
| `contact/`, `streams/04/` | 4 |
| `patches/validation/runs/`, `streams/05/` | 5 |
| `joints/` | 6 |
| `validation/run_017_counts/runs/`, `streams/07/` | 7 |
| `limits/`, `streams/08/` | 8 |
| `rotation/`, `validation/run_021_rotation/runs/`, `streams/09/` | 9 |
| `validation/run_026_ant_stops/` to `validation/run_034_replication/` | 10 to 15: no checksum file; compare each play file with `cmp`, as `tools/play_identity.sh` does, and re-make each `reading.txt` with its runner |
| `validation/run_035_identity/` to `validation/run_044_study20/` | 16 to 20 and the replications on Linux: compare each play file with `cmp`; Studies 19 and 20 re-make their `reading.txt` with `measure/runners/sx_study19_run.sh <run folder> <out>` and `sx_study20_run.sh <root> <run folder> <out>`, where `<root>` holds `1` and `2` pointing at the run's `runs/s1` and `runs/s2` |

**What to expect.** SuperDex is deterministic within a build, and every source replayed here was byte-identical to
its first play. Across machines it is not guaranteed. SuperDex is compiled with `-ffp-contract=fast`, which lets
the compiler fuse a multiply and an add wherever it likes, so a different compiler or processor can change the last
digit. If your checksums differ, compare the numbers: the registered rules have tolerances, and each study page
gives the measured value beside the pass line.

## 5. Check a rule by hand

Every rig writes whole numbers in plain text, so a rule can be checked with a spreadsheet. For example, the bounce
(Study 4, rule K1): in [`contact/`](../contact/), `drop_shipped_1.txt` and `drop_shipped_64.txt` are the dropped
cube at the shipped step and at 1/64 of it. The header gives the drop height in nanometres, and the second column
of each line is the height of the cube's lowest face. The highest it reaches after first touching the ground, over
the drop height, is the rebound.

The format of every file is at the top of the rig that writes it, in [`tools/`](../tools/). The right answer and
the pass line of every test are on its study page and in [`measure/sx_contact.sx`](../measure/sx_contact.sx).

## The machine these runs were made on

One laptop, an Intel Mac, with one worker thread. On macOS with the Command Line Tools only, the build needs:

```
export EXTRA_FLAGS="-isysroot $(xcrun --show-sdk-path) -isystem $(xcrun --show-sdk-path)/usr/include/c++/v1"
```

and `-DCMAKE_CXX_FLAGS="$EXTRA_FLAGS"` on the `cmake` line.

Runs 039 to 045 and 047 were made on Linux: an AWS EC2 machine (Intel Xeon Platinum 8488C, Ubuntu 24.04) with Clang 18
(SuperDex accepts only Clang 17 or newer on Linux; `export CC=clang CXX=clang++` before configuring); run 039's
`machine.txt` records the compiler, the system and the processor. Each run folder records its
builds' checksums; `validation/run_039_linux_replication/build.sh` builds stock and patched in 64-bit, run 041's
`build32.sh` both in 32-bit, and run 042's `build14.sh` library build 14.
