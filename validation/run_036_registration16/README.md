# Run 036: the sixteenth registration, library build 15 in 32-bit, its corrections, and the deformable bodies read again

15 October 2026. The second run of [PREREGISTRATION_16.md](../../preregistrations/PREREGISTRATION_16.md), registered
and committed before any of it was played. Library build 15 (sha256 471d5d5bd856f37c... in 64-bit, 450e137d07b1d62d...
in 32-bit), with library build 14 (af70e149901c628a...) beside it for the corrections. Played by
[`tools/plays/play_16.sh`](../../tools/plays/play_16.sh) from the repository root (`bits32 corrections deform`), one
play after another, straight after [run 035](../run_035_identity/); measured by `measure/runners/sx_study16_run.sh`,
every rule judged by Simplex.

**Result: all 26 rules held; no value was missing.** E0 is run 035's: 1,129 of 1,129 files identical in 13 parts.

## By rule

| Rule | Held | What was measured |
|---|---|---|
| E0 | 2 of 2 | [Run 035](../run_035_identity/): every file of all thirteen parts identical |
| F0 | 1 of 1 | The first study's 45 streams, all 32-bit, made again on library build 15 in 32-bit (`tools/sdx_player32`) with no switch set: 45 of 45 byte-identical to the streams stock SuperDex made |
| F1 | 1 of 1 | The second study's 63 streams (3 in 32-bit, 60 in 64-bit), made again on library build 15: 63 of 63 byte-identical |
| F2 | 1 of 1 | Six of the first study's streams (`base` and `s1` on each scene) with every switch set to `0`, in 32-bit: 6 of 6 byte-identical |
| C1 | 3 of 3 | On build 15 the hold holds (0 micrometres a second). Over the second after the cube is moved 2 mm by `SetRootTransform`, it moves 110 micrometres a second, forward with the push. On build 14 the same cube is pulled back against the push at 189 |
| C2 | 2 of 2 | With no Coulomb friction and viscous friction 0.2, the landing with patch F is byte-identical to the landing without it on build 15, at the shipped step and at 1/4. On build 14 they differ at both |
| C3 | 1 of 1 | No step of build 15's correction plays stopped or diverged |
| H1 | 5 of 5 | Every slide's furthest point within 0.03% of its distance (rule: 1%). Stock: 75,881,746 and 75,872,086 nm (shell and soft cube) against 75,885,315 at 0.01 s; 79,708,432 and 79,711,015 against 79,710,315 at 0.001 s. Final: 75,906,958 and 75,873,296; 79,709,618 and 79,686,576. Accurate: 80,132,797 and 80,127,638 against Coulomb's 80,135,315 |
| H2 | 4 of 4 | On the tilt, stock creeps at 4,473, 4,471, 4,485 and 4,468 micrometres a second against its law's 4,490, its centre moving 2.24 to 2.25 mm between the second and the last quarter. Final: the centre moves 0, 0, -78 and -2,153 nm between the quarters; accurate 0 and -3,937 (rule: under 300,000) |
| H3 | 6 of 6 | Every body set down comes to rest (0 micrometres a second on every axis). No step of stock or final stopped or diverged (most iterations 22 and 24). Under the accurate configuration none diverged and none stopped at the iteration limit (most iterations 14) |

## What the decisions say

- E0 to F2 held. **Library build 15 replaces build 14 as the library of record.** It is safe when off in 64-bit and
  in SuperDex's shipped 32-bit build, on every play it was given: runs 035 and 036 made 1,130 distinct registered
  files again, byte for byte, all on build 15 but for 25 stock plays of runs 032 and 034 made on the stock library and 3 review plays on library build 13, as those runs had them. The corrections stay validated in 64-bit only. The registration's decision says
  that every registered stream of the record has then been made again on build 15. It overstates: 138 of the 183
  benchmark streams of Studies 3 to 12 in `streams/`, and much of the record besides, are not on the identity list ([Study
  16](../../docs/studies/16-second-review.md#what-the-registration-overstated)). The seventeenth registration is to
  make them again.
- C1 to C3 held. **The teleport and viscous corrections are validated.** The mapped-collider correction and the
  table's lifetime are played by no rig: they are corrected and not played.
- H1 to H3 held. **The deformable bodies are right under every configuration**, read where the fifteenth
  registration's rules meant to read: the slides by their furthest point, the hold on the tilt by its drift.

## Reported, not ruled

- **The teleport, as a check on the two readings.** Both cubes settle within 0.12 s of the move and stand still for
  the rest of the second, so each reading is a settled offset. On build 15 the cube's fresh anchor starts unloaded,
  and the cube moves forward until its stick holds the push. On build 14 the stale anchor is dragged to within the
  stick distance of the cube, which is pulled back until its stick holds the push. If both settle at the same offset,
  the two moves add to the stick distance. They do: 110 and 189 micrometres add to 299, the stick distance of 300
  within the readings' rounding. On that reading both moves depend only on the push's share of the limit and the stick
  distance, not on the cube or on the size of the move. The dry run's cube (1 kg, friction 0.5, moved 3 mm, pushed at
  the same 0.6 of the limit) also read 110 and 189, though its play differs step by step (the first step after the
  move: 4,484 micrometres a second, against 4,377 here).
- **The viscous landings.** On build 15 the horizontal speed the landing loses is 407,154 micrometres a second at the
  shipped step and 363,017 at 1/4, with and without patch F. On build 14, patch F's step normal force raised them to
  513,459 and 488,763.
- **The deformable bodies.** Under the accurate configuration one step of 1,600 stopped, in the soft cube's rest,
  on SuperDex's rule for an update too small to matter: that play's most iterations were 4, far from the limit of 200.
  H3 allows it. On the tilt the accurate soft cube still rocks at the end (its centre's speed 160 micrometres a
  second) about a place that does not move. `deformstop`'s first slow step falls 0 to 0.06% short of the furthest
  point on every slide.
- Every measured line is in `reading.txt`.

## Checks after the run

- The runner made the reading again from the run's files, byte-identical to `reading.txt`.
- The measuring program as run (d22b1d5de8ade342...), the runner (88d6665cbaa8c0d1...), the play script
  (348d0bd00539a9a7...), the identity script (bb1f52e8fdae023f...) and the contact rig (b3a58877714da37d...) had, when
  played, the checksums the registration gives. The published measuring program and runner differ from those in their
  comments only (published as `measure/registered/sx_contact_registration16.sx` 11e4170ecef88fe9... and
  6261899af1b89392...; [`measure/README.md`](../../measure/README.md) gives each checksum as cited and as published).
  The published contact rig, `tools/sdx_contact.cpp` (9ce3b6f33cdf705e...), adds the settings `floor=soft` and
  `exitscene` for Study 19, which leave every play made without them byte-identical
  ([run 042](../run_042_two_corrections/README.md); [run 043](../run_043_study19/README.md), rule S0).

## The dry run

[`dry_run/`](dry_run/) is the registration's dry run, played before the registration was committed, with throwaway numbers. Nothing in it
decides anything. `play_dry16.sh` is the script as played, with placeholders for the local folders it named;
`runs/` is what it wrote; `reading.txt` is made again from those files by the script's own reading lines (the
plays are not repeated), and gives the figures the registration cites.

## Files

`reading.txt`; `runs/identity32.txt` (the bits32 part's own output); `runs/corrections/` and `runs/deform_*/` (every
play, with each folder's `stats.txt`); `dry_run/`. The bits32 part's streams are compared and deleted as they are made;
the registered streams are in [`streams/01/`](../../streams/01/) and [`streams/02/`](../../streams/02/).
