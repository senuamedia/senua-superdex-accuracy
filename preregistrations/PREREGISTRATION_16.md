# Sixteenth pre-registration: the second code review's corrections, safe when off in 32-bit and 64-bit, and the deformable readings put again

Registered 15 October 2026, before any run of this registration existed.

## The question

A second review of the patch code, by a reviewer given the code and the patches' stated purpose and not our
conclusions, found nothing that differs from stock with the switches off. With them on, it found four defects that
no play of the record reaches:

- Patch C anchors contacts that a mapped (deformable) collider misses at the stage start. Stock leaves those contacts
  without friction.
- Patch C's anchors survive a body set to a new pose from outside (`SetRootTransform` and the other pose setters), so
  a contact within 5 mm of where it last stuck is pulled back towards it.
- Patch F gives viscous friction the step's normal force while its energy keeps the start-of-step force.
- Patch C's table is a static object that a scene destroyed while the process exits could find already destroyed.

Library build 15 corrects them, as below. Is build 15 safe when off, in 64-bit and in SuperDex's shipped 32-bit
build, on every registered play and stream? Do its corrections do what they say? And do the fifteenth registration's
two misread deformable rules hold once read as they meant to read?

## What changed since the fifteenth registration, and why

**Library build 15**, from the four patch files with these additions (all added lines; stock code is untouched):

1. **Mapped colliders.** A contact the collider missed at the stage start is given no anchor and no stick, so it
   carries no friction, as in stock.
2. **Teleports.** A body set to a new pose from outside forgets its anchors and its contacts' anchors. These are
   `SetRootTransform` (rigid, static and articulated), an articulated body's pose, and a soft body's displacements and
   node positions. Velocity setters do not, so a speed given to a resting body keeps its stick.
3. **Viscous friction under patch F** keeps the start-of-step normal force, as its energy and the documentation say.
4. **The anchor table** is made once and never destroyed. Patch D no longer copies rows of a Jacobian that is not
   filled when only the objective is asked for (the copy was never read).

The second review's documentation notes are corrected in the documentation, not here.

**The measures.**
- `deformdrift` is added to the measuring program, changing no line of the others. It gives the centre's mean place
  over the second and the last quarter of the play after the load, and how far it moved between them. A body that
  rocks about one place moves little between them; a body that creeps moves its speed times half the play.
- `swingq` and `deformdrift` re-make the records of the fourth to the fifteenth registrations byte for byte.
- A slide is read by its furthest point (`deformstop`'s `furthest_nm`), not its first slow step, which misses a stop
  between two steps.

**The rigs.** `sdx_contact` takes `teleport` and `teleportdx`: before that step the cube is moved along x by
SuperDex's `SetRootTransform`, its rotation and speed kept. Nothing changes when they are unset.

## The configurations

As in the fifteenth registration as amended. **Final**: the shipped step, backward Euler, patches A to G with
SuperDex's Newton-Euler inertia, contact damping 5, a friction falloff of 0.03 m/s, solver tolerances of 1e-4 absolute
and 1e-8 relative, each mesh body's grid cell 1/32 of its side. **Accurate**: the same with BDF2 at 1/16 of the step.

## What is played

- **Run 035, safe when off** on library build 15 in 64-bit: `tools/play_identity.sh`, all thirteen parts. That is the
  twelve parts of run 033 and `r034`: the whole of run 034 made again and compared file by file, its review part on
  library build 13 as before.
- **Run 036** (`tools/plays/play_16.sh bits32 corrections deform`):
  - **bits32.** Every stream of the first study (45, all 32-bit) and of the second (63: 3 in 32-bit, 60 in 64-bit),
    made again on library build 15 with no switch set. The 32-bit streams are played on `tools/sdx_player32`, built
    from the current `sdx_player.cpp` against library build 15 in 32-bit. Six of the first study's streams are also
    made with every switch set to `0`.
  - **corrections**, on build 15 and on build 14 beside it. A fresh cube (0.9 kg, half-size 0.045 m, friction 0.44)
    on the plane under the final configuration, held by a push of 2.32848 N (0.6 of what friction holds) from 0.5 s.
    It is played alone, and moved 2 mm along x by `SetRootTransform` before the step at 1 s, both for 2 s. An oblique
    landing (from 0.05 m at 2.5 m/s) on a floor with no Coulomb friction and a viscous friction coefficient of 0.2, with
    patch F and without it, at the shipped step and at 1/4.
  - **deform.** The cloth and the soft cube on a fresh floor (friction 0.46): a rest, a slide at 0.85 m/s, and a hold
    on a floor tilted by 0.31 rad. Stock and final at 0.01 s and 0.001 s, accurate at 0.000625 s. Backward Euler's
    distance v0^2 / (2 mu g) - v0 dt / 2 is 75,885,315 nm and 79,710,315 nm; Coulomb's is 80,135,315 nm. Stock's
    regularised creep on the tilt is falloff x (1 - sqrt(1 - tan(tilt) / mu)) = 4,490 micrometres a second.

## The rules, fixed in advance

Every rule is judged by Simplex (`sx_contact rule`). A value the measuring cannot find stands as 999999999 and is
counted.

| Rule | It holds when |
|---|---|
| **E0** | Every file of all thirteen parts of run 035 is byte-identical on library build 15 |
| **F0** | Every stream of the first study, 45, is byte-identical on library build 15 in 32-bit |
| **F1** | Every stream of the second study, 63, is byte-identical on library build 15 |
| **F2** | The six streams made with every switch set to `0` in 32-bit are byte-identical |
| **C1** | On build 15 the hold holds (10 micrometres a second), and over the second after the teleport the cube moves only with the push, never back towards where it stuck, and less than the stick distance: a mean speed of 0 or more and under 300 micrometres a second. Required, on build 14: over that second it is pulled back against the push (a mean speed below 0) |
| **C2** | On build 15 the viscous landing with patch F is byte-identical to the one without it, at both steps. Required, on build 14: at one step at least they differ |
| **C3** | No step of build 15's plays stops or diverges |
| **H1** | Every slide's furthest point is within 1 in 100 of backward Euler's distance (stock and final, both steps) and of Coulomb's (accurate) |
| **H2** | On the tilt, stock creeps at its law's speed within 1 in 10 and its centre moves more than 1 mm between the quarters; final and accurate: the centre moves less than the stick distance (0.3 mm) between the second and the last quarter |
| **H3** | Bodies set down come to rest (10 micrometres a second); no step of stock or final stops or diverges; under the accurate configuration no step diverges or stops at the iteration limit |

Reported, not deciding: every measured line; where `deformstop` places each slide's stop; the contact node's move on
the tilt; the viscous landings' friction; the time each part took.

## Decisions fixed in advance

- If E0 to F2 hold, library build 15 replaces build 14 as the library of record and is recorded as safe when off in
  64-bit and in SuperDex's shipped 32-bit build. Every registered stream of the record has then been made again on
  it. The corrections stay validated in 64-bit only.
- If C1 to C3 hold, the teleport and viscous corrections are recorded as validated. The mapped-collider correction and
  the table's lifetime are not played by any rig: they are recorded as corrected and not played.
- If H1 to H3 hold, the deformable bodies are recorded as right under every configuration, read where the fifteenth
  registration's rules meant to read.
- A rule that fails is recorded as measured, and what it concerns stays open.

## Known risks, stated before the run

- **F0.** `sdx_player.cpp` has gained settings since the first study, each unset by default. A stream that differs
  can be played on the stock 32-bit library with the same rig to tell whether the rig or the patches changed it.
- **C1.** Build 14's pull-back needs the 2 mm move to fall within its 5 mm re-entry length, as it does here. It is bounded by the stick distance: the stale anchor is dragged to within 0.3 mm of the body, so the pull is at most friction's limit and the move back at most 0.3 mm. That is why the rule reads the direction.
- **C2.** If patch F changes anything else of a contact with no Coulomb friction, the pair differs on build 15 too.
- **H1.** A soft body's centre leads its base as it slows (up to 0.7 mm on the fourteenth registration's floor), so
  its furthest point sits that much past where its base stops.
- **H2.** Under BDF2 the soft cube rocks on the tilt and the rocking decays slowly. The quarters' means take most of it
  out.

## The dry run, before registering

Played with throwaway numbers on build 15 and build 14: a cube of 1 kg, half-size 0.04 m, friction 0.5, pushed with
2.94 N and teleported 3 mm; a viscous landing from 0.04 m at 2 m/s, coefficient 0.3, at steps 1 and 1/2. On build 15
the viscous landings with and without patch F were byte-identical at both steps, and on build 14 they differed. After
the teleport build 15's cube moved with the push at 110 micrometres a second while its fresh stick loaded. Build 14's
was pulled back at 189. No step of either build stopped or diverged. One 32-bit benchmark source with a setting no study used (`cart_pole` with an iteration limit of 3) gave the same bytes on `tools/sdx_player32` and build 15 in 32-bit as on the stock 32-bit rig and library.

The dry run changed one rule before registering. C1 first asked build 14 to move back at 300 micrometres a second or
more. The dry run showed that a stale anchor is dragged to within the stick distance, so the pull-back is bounded by
it. The rule now reads the direction.

## As registered

Library build 15 in 64-bit, 471d5d5bd856f37c..., and in 32-bit, 450e137d07b1d62d..., each built clean from a fresh
clone of SuperDex at the commit in `UPSTREAM_COMMIT` with only the four patch files applied:
`senua_contact.patch` 05cfa0a011a0bcf6..., `senua_joint_limit.patch` 6faaa83202139795...,
`senua_rotation_axis.patch` 279c951076464943... and `senua_inertia_transport.patch` 9807f00f6b543135... (the last two
unchanged since build 14). Library build 14, af70e149901c628a..., beside it for C1 and C2; library build 13,
dbd8cf9b7553e3d1..., for run 034's review part made again. Measuring program: `measure/sx_contact.sx`, as run
d22b1d5de8ade342... (published e4eaffefa238d296...). Runner: `measure/runners/sx_study16_run.sh` 88d6665cbaa8c0d1....
Plays: `tools/plays/play_16.sh` 348d0bd00539a9a7...; identity: `tools/play_identity.sh` bb1f52e8fdae023f...; rigs
`tools/sdx_contact.cpp` b3a58877714da37d... and `tools/sdx_player.cpp` (unchanged), the 64-bit rigs rebuilt against
build 15 and `tools/sdx_player32` against build 15 in 32-bit.
