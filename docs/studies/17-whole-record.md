# Study 17: the whole record made again on the library of record

| | |
|---|---|
| Registration | Seventeenth: [PREREGISTRATION_17.md](../../preregistrations/PREREGISTRATION_17.md) |
| Question | Does library build 15 make the whole registered record of Studies 3 to 13 again, byte for byte: every play made with no switch, and every play made under switches, under the same switches? And can every study be made again from this repository by its own scripts? |
| Outcome | **3 rules of 4 held.** 2,091 of 2,099 files the same. Every file made with no switch is the same (827 of 827, W0), the six runs changed on purpose differ (W2), and every study ran to the end by its own scripts (W3). W1 failed: 1,264 of the 1,266 files made under switches are the same, and the two that differ are one play, which Study 5 reported and did not decide on. It is made byte for byte on library build 4, kept from Study 5's time, and, by a probe after the decision, changed from build 5 on. So the decision that every registered result of Studies 5 and 7 to 13 stands for build 15 did not fire |
| Registered | 15 October 2026, before any run of this registration existed |
| Result | [Run 037](../../validation/run_037_whole_record/README.md), 15 October 2026 |
| Runs | 037, in a fresh clone of the repository |
| Played by | [`tools/plays/play_17.sh`](../../tools/plays/play_17.sh), running each study's own scripts; [`tools/plays/play_05.sh`](../../tools/plays/play_05.sh) for Study 5 |

Previous: [Study 16](16-second-review.md). Next: [Study 18](18-stock-plays.md). All studies: [index](README.md).

## Why it was asked

Study 16 found that the identity runs, which each new library build has had to pass since Study 10, make only part of
the record again: 1,130 distinct registered files, all but 28 on library build 15. Of the 2,099 registered play files of Studies
3 to 13, the identity list compares 406. Before the record is read as standing for the library of record, the rest
has to be made again. Each study is played by its own scripts, so the run also shows whether the record can be
made again from this repository alone.

## The rules and the result

| Rule | It holds when | Measured | |
|---|---|---|---|
| W0 | Every file played with no patch switch is the same on build 15 as registered | 827 of 827 | Held |
| W1 | Every file played under patch switches is the same on build 15 as registered | 1,264 of 1,266 | **Failed** |
| W2 | The six runs library build 13 changed on purpose differ, every one | 6 of 6 differ | Held |
| W3 | Every study's scripts run to the end, and no file of the inventory is missing | every part exit 0, none missing | Held |

Every study, file by file, is in [run 037](../../validation/run_037_whole_record/README.md). Its eleven parts took
25,249 seconds in all on the laptop, about 7 hours (`parts.txt`).

## The play that differs

Both files that differ belong to one play. It is Study 5's `ant` benchmark under the recommended configuration
(patches A, B and C with contact damping 5), with SuperDex's own `implicitNormalForceForDissipation` added, at the
shipped step. The two files are its stream and its line of run 013's statistics. The stream first differs at reading
1,706 of 21,600. Registered, the play left 35 steps stopped and 121 diverged; on build 15 it leaves 34 and 120.

The registration fixed in advance what to do with a file that differs: play it again, with the same rig and
settings, on the library it was registered on. The build kept from the fifth registration's time, library build 4,
makes the registered stream and statistics line byte for byte. Build 15 makes run 037's again, byte for byte. So
the library changed the play; the rig and the script did not.

Study 5 reported this play beside its recommended configuration and did not decide on it: "It is not safe to add."
This registration records the two files as measured, and what the play concerns stays open, as it says of a file
that differs.

A probe after the decision played it on every kept build between 4 and 15 (run 037's `bisect/`). Build 5, the first
built with the seventh registration's correction of patch C, and every kept build after it (6 and 8 to 14; there is
no build 7) make build 15's play. That
correction was to keep the recorded form of patch C bit for bit with its new switch unset. It does on every other
play made under the recorded form, here and in Study 7, but not on this one. The cause ([run 050](../../validation/run_050_patch_c_trace/README.md)): a three-line block of patch C's correction that never runs with its switch unset, yet changes how the compiler rounds one term of anchored friction's Hessian under SuperDex's -ffp-contract=fast; the algebra, the force and its energy are unchanged. Only a play whose solver often fails carries that last-bit change into its output.

## What it means

- **Library build 15 is safe when off over the whole registered record of Studies 3 to 13.** With runs 035 and 036,
  every registered play made with no switch has been made again on it, but for 25 stock plays of runs 032 and 034
  (W0: 827 files of 827 the same).
  Those 25 are made in [Study 18](18-stock-plays.md).
- **W1 failed, on one play's two files.** Its decision, that every registered result of Studies 5 and 7 to 13
  stands for library build 15, needed every one of the 1,266 files made under switches to be the same, and did not
  fire. What was measured: 1,264 of the 1,266 are the same; the two that differ are Study 5's reported `ant` play
  with SuperDex's implicit setting added, made byte for byte on build 4 and (by the probe after the decision)
  changed from build 5 on. On build 15 it leaves 34 steps stopped and 120 diverged, against 35 and 121 as
  registered. What it concerns stays open.
- **The comparison can fail.** It found every one of the six plays changed on purpose.
- **Every study can be made again from this repository by its own scripts.** That includes Study 5, whose play
  script was written for this registration from its record.
