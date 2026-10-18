# Run 037: the whole record played again (Study 17)

15 October 2026, 07:14 to 14:16 AEDT (UTC+11), under [`preregistrations/PREREGISTRATION_17.md`](../../preregistrations/PREREGISTRATION_17.md),
by [`tools/plays/play_17.sh`](../../tools/plays/play_17.sh) on the laptop, under the host guard. No file keeps those two
times: 07:14 is when the registration was committed, and the parts' own times are in `parts.txt`. The plays were made in
a fresh clone of the record at the commit that registered Study 17 and compared with a clean reference clone of it. The
rigs were built against library build 15 (sha256 471d5d5bd856f37c...), and every `*_stock` rig name was given build
15 too (`rigs.txt`). Each study was played by its own scripts.

The first start of this run used the main working copy as the reference. Its inventory held 6 files the repository
does not track, so it was stopped before any part played and restarted against the clean reference clone (2,099
files, `inventory.txt`). That first inventory is not kept.

## The result: three rules of four held

| Rule | It holds when | Measured | |
|---|---|---|---|
| **W0** | Every file played with no patch switch is the same on build 15 as registered | 827 of 827 | **Held** |
| **W1** | Every file played under patch switches is the same on build 15 as registered | 1,264 of 1,266 | **Failed** |
| **W2** | The six runs changed on purpose by library build 13 differ, every one | 6 of 6 differ | **Held** |
| **W3** | Every study's scripts run to the end, and no file of the inventory is missing | every part exit 0; 0 missing | **Held** |

By study (`compare.txt`, whose last lines are the totals of each study, the files made with no switch, under
switches and changed on purpose counted apart; it has no overall total line, and the All row below is their sum):

| Study | No switch | Under switches | Changed on purpose | Seconds |
|---|---|---|---|---|
| 3 | 90 of 90 | | | 5,103 |
| 4 | 96 of 96 | | | 2,005 |
| 5 | 178 of 178 | **222 of 224** | | 2,331 |
| 6 | 31 of 31 | | | 10 |
| 7 | 143 of 143 | 214 of 214 | | 2,752 |
| 8 | 24 of 24 | 27 of 27 | | 3,548 |
| 9 | 99 of 99 | 244 of 244 | | 3,391 |
| 10 | 48 of 48 | 44 of 44 | | 1,302 |
| 11 | | 244 of 244 | | 1,744 |
| 12 | 64 of 64 | 128 of 128 | 0 of 6 the same | 2,574 |
| 13 | 54 of 54 | 141 of 141 | | 489 |
| **All** | **827 of 827** | **1,264 of 1,266** | **6 of 6 differ** | 25,249 |

The eleven parts took 25,249 seconds, 7 hours and 1 minute (`parts.txt`; their output is in `log_s03.txt` to
`log_s13.txt`); the inventory, the clearing and the comparison are not timed.

## The one play that differs

The two files that differ are one play. It is Study 5's `ant` benchmark under the recommended configuration (patches
A, B and C, with contact damping 5) with SuperDex's own `implicitNormalForceForDissipation` added, at the shipped
step: source `qi1`. The two files are its stream (`streams/05/ant/qi1_enc.pcm`) and its line of run 013's statistics
(`validation/run_013_counts/stats_ant.txt`). Every other line of that statistics file is the same.

- **Where it first differs.** At byte 3,411 of the stream: reading 1,706 of 21,600, the 106th reading of the ninth of
  108 episodes.
- **What differs in the statistics.** Registered: 21,444 steps converged, 35 stopped, 121 diverged. On build 15: 21,446,
  34 and 120. In both, SuperDex's own solver reports explosions, and the worst residual is 2.56e+11.

**The decision fixed in advance** was to play the file again, with the same rig and settings, on the library it was
registered on ([`replay_differs.sh`](replay_differs.sh), `replay/verdict.txt`). The record does not give the checksum
of the fifth registration's patched library, as the registration said. The build kept from that time is library
build 4, sha256 77708fa8b023ed18.... It was built at 02:55 on 14 October, before the fifth registration's commit
(03:00) and run 013 (committed 04:01). The library each play loaded was read from the loader, not assumed
(`replay/*/library.txt`).

| Library | Stream against the registered | Statistics line against the registered | Against run 037 |
|---|---|---|---|
| Build 4, kept from the fifth registration's time | **the same** | **the same** | differs |
| Build 15, played again | differs at byte 3,411 | differs | the same, both files |

**The library changed this play, not the rig or the script.** The same rig and settings make the registered files on
build 4 and run 037's files on build 15, each byte for byte. Build 15 makes the same play twice.

**What the play was used for.** Study 5 reported it beside the recommended configuration, not deciding: "the
recommended configuration with SuperDex's implicit setting added left 35 steps unconverged on `ant` and 121
diverged. It is not safe to add." On build 15 the same play leaves 34 and 120, each count one lower. What the play
concerns stays open, as the registration said; what in the library changed it is below.

**A probe after the decision, not registered** ([`bisect_builds.sh`](bisect_builds.sh), `bisect/verdict.txt`): the
same play on every kept build between 4 and 15, to find the build that changed it. Library build 5 (9a10f0dcd4a5f781...),
the first built with the seventh registration's correction of patch C, and every build after it (6, 8 to 14) make
run 037's stream and statistics, byte for byte. Build 4 makes the registered ones. So the change came with that
correction. The seventh registration said that with `SUPERDEX_STICK_DAMPING` unset the anchored friction is the
recorded one, bit for bit, and Study 7 found it so on 28 of 28 suite files. Study 17 finds it so on every other play
made under the recorded form: Study 5's suites under `stick`, `recommended` and `recommended_implicit`, its benchmark
under the recommended configuration at five steps, and Study 7's `rec_old` and `stick` suites. It does not hold on
this play. [Run 050](../run_050_patch_c_trace/README.md) found which line of the correction changes it: a three-line block of patch C's correction that never runs with its switch unset, yet changes how the compiler rounds one term of anchored friction's Hessian under SuperDex's -ffp-contract=fast; the algebra, the force and its energy are unchanged.

## What it shows

- **W0: library build 15 is safe when off over the whole registered record of Studies 3 to 13.** All 827 files made
  with no switch are the same. The eighteenth registration makes the 25 stock plays of runs 032 and 034 on build 15,
  which no run had yet done ([Study 18](../../docs/studies/18-stock-plays.md)).
- **W1 failed, so its decision did not fire.** The decision that every registered result of Studies 5 and 7 to 13
  stands for build 15 needed all 1,266 files made under switches to be the same; 1,264 are. The two that differ are
  one play that Study 5 reported and did not decide on, which leaves 34 steps stopped and 120 diverged on build 15
  against 35 and 121 as registered. What it concerns stays open.
- **W2: the comparison can fail.** It found every one of the six plays library build 13 changed on purpose.
- **W3: every study can be made again from this repository by its own scripts.** Every part exited 0 and no file was
  missing. That includes Study 5, played by `tools/plays/play_05.sh`, written for this registration from Study 5's
  record.
