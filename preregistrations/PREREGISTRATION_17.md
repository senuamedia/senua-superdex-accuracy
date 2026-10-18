# Seventeenth pre-registration: the whole record of Studies 3 to 13 made again on library build 15

Registered 15 October 2026, before any run of this registration existed.

## The question

Study 16 found that the identity runs make only part of the record again. Runs 035 and 036 made 1,130 distinct
registered files again on library build 15, byte for byte: the plays on the identity list
(`tools/play_identity.sh`) and every stream of the first two studies. Runs 032 and 034, Studies 14 and 15, are made
again whole on that list. Most of Studies 3 to 13 is not: of their 2,099 registered play files, the list compares
406.

Does library build 15 make the whole registered record of Studies 3 to 13 again, byte for byte? That is every play
made with no patch switch set (safe when off over the whole record), and every play made under patch switches,
played under the same switches (so the registered results stand for the library of record). And can every study be
made again from this repository by its own scripts?

## What changed since the sixteenth registration

Nothing in the library. Library build 15 is as the sixteenth registration registered it.

- **`tools/plays/play_05.sh`, new.** The fifth registration was played from the command line and has no play script.
  This one was written from its record: the cube of `PREREGISTRATION_05.md`, the settings and switches in each
  configuration's `CONFIG` file, and the sources, their order and their settings in run 013's statistics. Stock is
  played with the stock rigs and the rest with the patched rigs (rule S0 of the fifth registration compares the stock
  library with the patched one with no switch set).
- **`tools/plays/play_17.sh`, new.** The replay: `list` (the inventory), `clear`, one part a study (`s03` to `s13`,
  each running that study's own scripts as `docs/reproduce.md` gives them), and `compare`.
- **`docs/reproduce.md`.** Study 5 is played by `play_05.sh`. Study 10 needs `SUPERDEX_ASSETS`. Study 12's benchmark
  is `bench with_f` only: the `bench without_f` the guide listed was never registered, and it would rewrite
  `bench_base.txt`. The suite runs of Studies 5, 7 and 9 were copied into the record by hand from `suites/`, and the
  guide now says so.
- **`measure/runners/sx_study15_run.sh`**, corrected: it now makes the record's root absolute. The measure gate
  found, after run 036, that it failed when the root was given as a relative path. Run 034's reading re-makes byte for
  byte with it. Nothing in this registration uses it.

## What is played

**Run 037**, in a fresh clone of this repository at the commit of this registration. The rigs are built against
library build 15, and the `*_stock` rig names are given build 15 too, so every stock play is made on the library of
record with no switch set. From the clone's root, under the host guard:

    SUPERDEX_ASSETS=<assets> bash tools/plays/play_17.sh <the record> <out> list clear s03 s04 s05 s06 s07 s08 s09 s10 s11 s12 s13 compare

The inventory holds 2,099 registered files of Studies 3 to 13:

| Study | Played with no switch | Played under switches | Changed on purpose after registration | Registered on |
|---|---|---|---|---|
| 3 | 90 | | | Stock, 5a213c925bc86b61... |
| 4 | 96 | | | Stock |
| 5 | 178 | 224 | | The fifth registration's patch file |
| 6 | 31 | | | Stock |
| 7 | 143 | 214 | | The seventh registration's library, 675522c786608721... |
| 8 | 24 | 27 | | The eighth registration's library, c37eee7140cce9da... |
| 9 | 99 | 244 | | The ninth registration's library, 92bb9315d8a8a196... |
| 10 | 48 | 44 | | Library build 12, ccb1aefeb3fc91f1... |
| 11 | | 244 | | Library build 12 |
| 12 | 64 | 128 | 6 | Library build 12 |
| 13 | 54 | 141 | | Library build 12 |
| **All** | **827** | **1,266** | **6** | |

The class of each file is in the inventory `play_17.sh list` writes. Newton-Euler inertia, contact damping, the
integrator, the tolerances and every other SuperDex setting are not patch switches. A statistics file that holds
plays of both kinds is counted as played under switches.

Left out, each for a stated reason:

- `patches/validation/identity.txt` was assembled by hand. No script writes its suite line, and its other lines are run 017's identity check, which is in the inventory.
- Run 025's `identity.txt` is the identity script's own output on library build 12, not a play.
- The `SHA256SUMS` files are rewritten by the scripts from the files they list.
- Readings and counts are measuring output; the runners in `measure/runners/` re-make them.

**How files are compared.** Byte for byte, with three exceptions:

- Files that carry the wall-clock time of a play are compared without that field (`wall_s`). These are the statistics files and the benchmark rig's output.
- Run 029's two FR3 gripper statistics files are compared without the two error lines of the first, failed invocation, which run 029's README records.
- The statistics of the twelfth registration's one-joint tests are compared without the lines of the six runs listed below.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **W0** | Every file played with no patch switch, 827, is the same on library build 15 as registered |
| **W1** | Every file played under patch switches, 1,266, is the same on library build 15 as registered |
| **W2** | The six runs changed on purpose differ, every one. These are the twelfth registration's one-joint tests under BDF2 and SuperDex's DIRK33 with patch G and Newton-Euler inertia (spin, torque and swing for each). In library build 13 (registered with the fourteenth registration), patch G's share for BDF2 became 1/3 of the step start's Jacobian, and for DIRK33 0 |
| **W3** | Every study's scripts run to the end (exit code 0 for every part), and no file of the inventory is missing |

Reported, not deciding: the time each study took; for a file that differs, where it first differs.

## Decisions fixed in advance

- **If W0 holds**, library build 15 is safe when off over the whole registered record. With runs 035 and 036, every
  registered play of Studies 1 to 16 made with no switch has then been made again on it.
- **If W1 holds**, every registered result of Studies 5 and 7 to 13 stands for library build 15, as it stood for the
  build it was played on.
- **If W2 holds**, the one change a later build made on purpose to a registered play is seen by the comparison: the
  comparison can fail.
- **If W3 holds**, every study can be made again from this repository by its own scripts.
- **A file that differs** is recorded as measured, with where it first differs. After the run it is played again,
  with the same rig and settings, on the library it was registered on (the seventh, eighth and ninth registrations'
  libraries and library build 12 are kept, and
  stock for the plays with no switch). If it differs there too, the rig or the script changed, not the library. What
  it concerns stays open.

## Known risks, stated before the run

- **Patch C changed after Studies 5 and 7 to 9.** It was keyed by the collider's feature as well as the sample in
  library build 12. Library build 14 changed the open-contact check's padding, made anchors per scene and made
  restores forget them. Library build 15 made teleports and mapped colliders forget them. Runs 033 and 035 found these
  unchanged on build 15: the suites under patches A to D and A to E, the benchmark under A to E, and the whole of
  runs 032 and 034. But the first form of patch C (Study 5's `stick`, `recommended` and `recommended_implicit`;
  Study 7's `rec_old` and `stick`) was last checked against the current file in Study 7's probes (28 of 28).
- **Patches D and E**: library build 14 changed how their switches are read, and build 15 has patch D read a
  Jacobian's rows only when they are used. Neither should change a play with its switch at `1`.
- **Patch F**: library build 15 keeps viscous friction's start-of-step force. The only registered play with viscous
  friction is Study 4's, on stock.
- **The rigs** have gained settings since the earlier studies, each unset by default. A file that differs on build 15
  and on the library it was registered on was changed by the rig.
- **`play_05.sh` is new.** If Study 5's stock files differ on build 15 and on the stock library, the script does not
  play what was played. The record does not give the checksum of the fifth registration's patched library; if one of
  its patched files differs, the build kept from that time is named when it is used.
- **Statistics files** are compared line by line in the order the scripts append them. No README of Studies 3 to 13
  records an interrupted or resumed run, which could give another order.
- **Time**: the registered statistics give about five hours of benchmark plays; with everything else, six to eight.

## The dry run, before registering

No play was made. The inventory and the comparison were checked by running `play_17.sh list compare` from the record
against a fresh clone at the record's last commit before this registration (the documentation after run 036), which is the record itself. Every one of the 2,099 files compared the same, the
suite folders of Studies 5, 7 and 9 included, compared with the local `suites/` folders the record's copies came from.
The two exceptions are the FR3 gripper statistics files, whose registered copies keep the two error lines that the
comparison leaves out of that side only. The fresh clone's 24 `SHA256SUMS` files all verify. A first inventory took
in run 026's `reading.txt`, a measuring output; it was left out before registering.

## As registered

Library build 15 in 64-bit, 471d5d5bd856f37c..., as in the sixteenth registration. Play scripts: `tools/plays/play_17.sh`
(a0746d8e2cb029e5...) and `tools/plays/play_05.sh` (06de2c5adc1bb41b...) as in this commit, with every earlier play
script unchanged. The rigs, rebuilt against build 15 for run 035, unchanged.
