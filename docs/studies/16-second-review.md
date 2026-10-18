# Study 16: the second code review's corrections, and safe when off in 32-bit

| | |
|---|---|
| Registration | Sixteenth: [PREREGISTRATION_16.md](../../preregistrations/PREREGISTRATION_16.md) |
| Question | Is library build 15, with the second code review's corrections, safe when off in 64-bit and in SuperDex's shipped 32-bit build; do its teleport and viscous corrections work; and do the deformable bodies hold once read as the fifteenth registration's failures said they should be? |
| Outcome | Every rule held as the registered runner reads them: 26 rule lines of 26, the 10 rules E0 to H3. The runner reads C3 over the correction plays, and none of their steps stopped or diverged; read literally over every play made on build 15, C3 would fail, since build 15's replays of earlier studies include plays that stop by design (see C3 below). Library build 15 is safe when off on every play it was given, in 64-bit and in SuperDex's shipped 32-bit build, and replaces build 14 as the library of record. The teleport and viscous corrections are validated. The deformable bodies are right under every configuration, read by their furthest point and their drift |
| Registered | 15 October 2026, committed and pushed before any run of this registration existed |
| Result | [Run 036](../../validation/run_036_registration16/README.md), 15 October 2026 |
| Runs | [035](../../validation/run_035_identity/), safe when off on build 15 in 64-bit with runs 032 and 034 made again; [036](../../validation/run_036_registration16/), the first two studies' streams in 32-bit and 64-bit, the corrections and the deformable bodies |
| Played by | the rigs in [`tools/`](../../tools/), [`tools/plays/play_16.sh`](../../tools/plays/play_16.sh), [`tools/play_identity.sh`](../../tools/play_identity.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx), `measure/runners/sx_study16_run.sh` |

Previous: [Study 15](15-replication.md). Next: [Study 17](17-whole-record.md). All studies: [index](README.md).

## Why it was asked

A second review of the patch code, by a reviewer given the code and the patches' stated purpose but not our
conclusions, found nothing that differs from stock with the switches off. With them on, it found four defects that, as it read the code, no
play of the record reaches:

- Patch C anchored contacts that a mapped (deformable) collider missed at the stage start. Stock leaves those contacts
  without friction.
- Patch C's anchors survived a body set to a new pose from outside (`SetRootTransform` and the other pose setters), so
  a contact within 5 mm of where it last stuck was pulled back towards it.
- Patch F gave viscous friction the step's normal force while its energy kept the start-of-step force.
- Patch C's anchor table was a static object that a scene destroyed while the process exits could find already
  destroyed.

Library build 15 corrects them, with added lines only. Every reading of the patches in the earlier studies was 64-bit, while
SuperDex builds in 32-bit unless told otherwise. And two of the fifteenth registration's deformable rules read
something other than what they meant: a slide's stop between two steps, and a corner that rocks while a load is
applied at once.

## The result

All 26 rule lines of the 10 rules held, as the registered runner reads them ([run
036](../../validation/run_036_registration16/)); no value was missing.

| Rule | Rule lines held | What was measured |
|---|---|---|
| E0, safe when off in 64-bit | 2 of 2 | [Run 035](../../validation/run_035_identity/): 1,129 of 1,129 registered files byte-identical in 13 parts, with no switch set, every switch set to `0`, and under the registered configurations on the identity list, including the whole of runs 032 and 034 made again. Build 15 made all but 28 of them: 25 files of the stock plays of runs 032 and 034 were made on the stock library and 3 of run 034's review part on library build 13, as those runs had them; [Study 18](18-stock-plays.md) made the 25 on build 15 |
| F0 to F2, the first two studies again | 3 of 3 | The first study's 45 streams on build 15 in 32-bit, byte-identical to the streams stock SuperDex made; the second study's 63 (3 in 32-bit, 60 in 64-bit); six streams with every switch set to `0` in 32-bit |
| C1, a body placed from outside | 3 of 3 | Over the second after a held cube is moved 2 mm by `SetRootTransform`, build 15's moves 110 micrometres a second, forward with the push; build 14's is pulled back against it at 189 |
| C2, viscous friction under patch F | 2 of 2 | With no Coulomb friction, the landing with patch F is byte-identical to the landing without it on build 15, at both steps; on build 14 they differ at both |
| C3, no step of build 15's plays stops or diverges | 1 of 1 | No step of build 15's correction plays stopped or diverged. The registered runner (`measure/runners/sx_study16_run.sh`, as committed with the registration) reads C3 over the correction plays only, those named `b15_`. Read literally over every play made on build 15, C3 would fail: build 15's replays of earlier studies include plays that stop by design, such as the first study's iteration limits as low as 1 (on `ant`, limit 1 stops on all 21,600 steps, [run 001](../../validation/run_001_counts/), `stats_ant.txt`) in run 036's 32-bit part, and the point-cloud sheet under the accurate configuration (3,744 steps stopped of 11,520 in [run 034](../../validation/run_034_replication/reading.txt), line 55, whose plays run 035 made again on build 15 byte for byte). Among run 036's own deformable plays, one step under the accurate configuration stopped, in the soft cube's rest (`deform accurate \| stopped 1` in the [reading](../../validation/run_036_registration16/reading.txt), line 86), on SuperDex's rule for an update too small to matter; H3 allows that stop |
| H1, the slides | 5 of 5 | Every slide's furthest point within 0.03% of backward Euler's distance (stock and final, both steps) and of Coulomb's (accurate) |
| H2, the hold on a tilt | 4 of 4 | Stock creeps at 4,468 to 4,485 micrometres a second against its law's 4,490 and drifts 2.2 mm; under the final and accurate configurations the centre moves at most 3,937 nm between the second and the last quarter, against 300,000 allowed |
| H3, rests and steps | 6 of 6 | Every body set down comes to rest; no step of stock or final stopped or diverged; under the accurate configuration none diverged or stopped at the iteration limit |

The two readings of the teleport check each other. Both cubes settle within 0.12 s, so each reading is a settled
offset, and the moves (110 forward on build 15, 189 back on build 14) add to 299 micrometres. That is the stick
distance of 300 within the readings' rounding, as it should be if both cubes settle where their stick holds the push.

## What it means

- **Library build 15 replaces build 14 as the library of record.** Runs 035 and 036 made 1,130 of the files the record's plays wrote
  again on it, byte for byte: the identity list and every stream of the first two studies, in 64-bit and in
  SuperDex's shipped 32-bit build. All were made on build 15 but for 28 that runs 032 and 034 play on another library, as registered: 25 stock plays, made on the stock library ([Study 18](18-stock-plays.md) makes them on build 15), and 3 review plays on library build 13.
- **The teleport and viscous corrections are validated**, in 64-bit. The mapped-collider correction and the table's
  lifetime are not played by any rig of this study: they are corrected and not played here. [Study
  19](19-two-corrections.md) plays both.
- **The deformable bodies are right under every configuration.** The fifteenth registration's two failed deformable
  rules were readings, not the bodies: read by its furthest point, every slide lands within 0.03% of its law, and
  read by its drift, the hold on the tilt does not creep.

## What the registration overstated

Its decision says that if E0 to F2 hold, every registered stream of the record has then been made again on build
15. That is not what its runs play. Runs 035 and 036 made 1,130 distinct registered files again: the plays on the
identity list ([`tools/play_identity.sh`](../../tools/play_identity.sh)) and every stream of the first two studies.
Much of the record is not on that list: 138 of the 183 benchmark streams of Studies 3 to 12 in `streams/`, the 50 that Studies 10 and 13 keep with their runs, Study 4's one-cube runs,
Study 5's suite runs, and most of the runs of Studies 7 to 13. The
[seventeenth registration](../../preregistrations/PREREGISTRATION_17.md) makes the rest of the record again on build 15.

## What it does not show

The plays of the record outside the identity list (above), made again on build 15: [Study 17](17-whole-record.md)
and [Study 18](18-stock-plays.md) make them. The corrections switched on in 32-bit: safe when off is measured in
32-bit, the corrections themselves in 64-bit only; [Study 20](20-thirty-two-bit.md) measures the contact corrections
in 32-bit. A contact a mapped collider misses at the stage start, and a scene destroyed while the process exits: no
rig of this study plays them; [Study 19](19-two-corrections.md) plays both. Gradients through the patches: none were
tested (see
[what the patches do not cover](../patches.md#what-the-patches-do-not-cover)).
