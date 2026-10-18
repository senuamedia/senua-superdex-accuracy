# Fifteenth pre-registration: every fix replicated on fresh numbers, and the code review's corrections tested

Registered 15 October 2026, before any run of this registration existed. Probes since the fourteenth registration:
the causes of its failed rules, in [run 032](../validation/run_032_open_items/)'s record and below.

## The question

The fourteenth registration held 142 rules of 150 ([run 032](../validation/run_032_open_items/)). Before the
record goes public every fix must hold again on numbers no earlier study used, every failed rule must have its
cause, and an independent review of the patch code found defects that are now corrected (library build 14). Do
the fixes replicate, do the failed rules hold once read as their causes say, and do the corrections work?

## What changed since the fourteenth registration, and why

- **Library build 14**, from the four patch files in [`patches/`](../patches/), after a code review by a reviewer
  given the code and the patches' stated purpose, not my conclusions. Three corrections:
  1. A switch set to `0` or to nothing is off (it used to be on whenever the variable existed).
  2. Creating or destroying a scene forgets only that scene's friction anchors (it used to forget every scene's).
  3. Restoring a scene's state forgets that scene's friction anchors, so a planner's trial rollout cannot leave
     its anchors behind. The anchors are not part of a captured state; after a restore each contact sticks afresh.
  Also: the open-contact check pads as the contact kernel pads, which changes nothing at the shipped padding of 0,
  and a comment that contradicted the code it described. None of these can change a registered play, which E0
  checks.
- **The cantilever (item 4).** Run 032's 0.1% over the textbook is SuperDex's shipped solver tolerance acting on a
  static elastic equilibrium: with the solve converged, the rods come within 0.005% to 0.013% of the textbook, and
  at the final configuration's tolerances within 1 in 1,000 (a probe after run 032, on throwaway and registered
  rods). Run 032 played the cantilever on stock settings. Here it is played at the final configuration's
  tolerances.
- **The deformable slides (D4, A5).** The soft cube slides to backward Euler's distance (within 0.02% on the probe)
  and then comes back about 0.5 mm: friction holds its base while the body, which leaned forward as it slowed,
  relaxes. Run 032 read the end of the play. Here a slide is read where it stopped, by a new measure (`deformstop`)
  added to the measuring program without changing any line of the measures already registered: the extended
  program re-makes the records of the fourth to the fourteenth registrations byte for byte. The end is reported.
- **The tilted floor at the fine step (D6).** The soft body's contact held; its end speed is its own elastic
  ringing, which backward Euler damps less at a finer step. Here the hold is ruled on its contact, as the
  fourteenth registration ruled it under BDF2, and the end speed is reported.

## The configurations

As in the fourteenth registration. **Final**: the shipped step, backward Euler, patches A to G with SuperDex's
Newton-Euler inertia, contact damping 5, a friction falloff of 0.03 m/s, solver tolerances of 1e-4 absolute and
1e-8 relative, each mesh body's grid cell 1/32 of its side, a smoothing half-distance of 1 mm on a body that meets
a point cloud. **Accurate**: the same with BDF2 at 1/16 of the step and SuperDex's shipped tolerances.

## The scenes, registered parameters

None of these numbers was used in a probe or an earlier study, except the thirteenth registration's rod, kept as
the item-4 rod that run 032 failed on.

- **Item 1**: pair A, block 2.6 kg and half-size 0.22 m, cube 0.35 kg and 0.025 m, friction 0.38, push 16.4787 N;
  pair B, 5 kg and 0.32 m, 0.8 kg and 0.035 m, friction 0.5, push 42.63 N. Laws: the cube 3,724 and 4,900 mm/s2,
  the block 5,837 and 7,742. Pushed from 0.5 s, 0.9 s, steps 1 and 1/16, final configuration.
- **Item 2**: an arm of 3 kg, half-size 0.06 m, 0.5 m, released at 2 and 4.5 rad/s for 1 s; a free chain of 1.5 kg
  and 0.9 kg, half-size 0.05 m, centres 0.3 m and 0.25 m, joints 0.6 m apart, the second joint at -0.7 rad, turning
  at 2 and -1 rad/s, 2 s; steps 1, 1/4, 1/16; final configuration.
- **Item 3**: a cube of 1 kg and half-size 0.03 m on the held sheet (a node every 10 mm): an oblique landing at
  3 m/s from 0.06 m with friction 0.42, a slide at 3.5 m/s, a rest, a hold and a slip with pushes of 2.4696 N and
  4.9392 N (0.6 and 1.2 of what friction holds), a lift of 29.4 N; stock and final at the shipped step (the landing
  also at 1/4), accurate at 1/16.
- **Item 4**: as cantilevers held across the clamp, at the final configuration's tolerances, 64 and 128 elements,
  0.01 s: the thirteenth registration's rod (textbook sag 6,350,400 nm); rod A, 0.2 kg/m, EA 300 N, EI 5 N m2,
  0.5 m (3,062,500 nm); rod B, 0.08 kg/m, EA 120 N, EI 2.5 N m2, 0.7 m (9,411,920 nm).
- **Item 5**: an arm of 2.2 kg, half-size 0.045 m, 0.42 m, as a pendulum released level for 3 s and as a free spin
  at 3.5 rad/s; a chain of 1.4 kg and 0.7 kg, half-size 0.04 m, centres 0.27 m and 0.22 m, joints 0.52 m apart,
  swinging from 0.6 and -0.5 rad for 2 s; steps 1, 1/4, 1/16; BDF2 with patch G, and the chain also under
  backward Euler with patch G.
- **Deformable bodies** on a fresh floor, friction 0.5: a rest, a slide at 0.9 m/s, a hold on a floor tilted by
  0.35 rad; the cloth and the soft cube; stock and final at 0.01 s and 0.001 s, accurate at 0.000625 s. Backward
  Euler's distance v0^2 / (2 mu g) - v0 dt / 2: 78,153,061 nm and 82,203,061 nm; Coulomb's 82,653,061 nm. Stock's
  regularised creep on the tilt: 4,804 micrometres a second.
- **The corrections**: a cube of 1.1 kg, half-size 0.04 m, friction 0.48, held on the plane for 2 s by a push of
  3.10464 N (0.6 of what friction holds), final configuration: alone; with a second scene made, played one step and
  destroyed before 1 s; and with a planner's rollout before 1 s (the state captured, 10 steps pushed with 5.69184 N,
  1.1 of what friction holds, the state restored). On build 14, and on build 13 beside it.

## The rules, fixed in advance

Every rule is judged by Simplex (`sx_contact rule`). "Within 1 in N" means the difference is at most the right
answer over N. A value the measuring cannot find stands as 999999999 and is counted.

| Rule | It holds when |
|---|---|
| **E0** | Every file of all twelve parts of `tools/play_identity.sh` is byte-identical on build 14: the ten parts of run 031; `zero` (every switch set to 0, against stock's registered files); and `r032` (the whole of run 032 made again, compared file by file, the benchmark's wall-clock time excepted) |
| **V1** | Item 1: both fresh pairs, the cube and the block within 1 in 100 of their laws at both steps |
| **V2** | Item 2: the fresh arm keeps its speed within 1 in 10,000 at both speeds and all three steps; the fresh free chain keeps its energy within 1 in 1,000 and its angular momentum within 100 parts per million |
| **V3** | Item 3: stock's friction over the impact is more than 1.2 times the law and its slip under 8 tenths of its speed; final and accurate: the rest carries the weight within 1 in 100, the lift never pulls, the hold does not creep (10 micrometres a second), sliding friction within 1 in 100 of the law, the slip reaches 95 in 100 of its speed, friction over the impact within 1 in 25, no step diverges and no more than 1 in 1,000 stop |
| **V4** | Item 4: all three rods within 1 in 1,000 of the textbook at 64 and 128 elements |
| **V5** | Item 5: the free spin keeps 999 in 1,000 at every step; the pendulum's first three swings between 9,950 and 10,010 per 10,000 at the shipped step, 9,990 and 10,010 at 1/4, 9,995 and 10,005 at 1/16; the swinging chain's energy within 1 in 100 at 1/4 and 1 in 200 at 1/16; backward Euler loses more at 1/4 |
| **V6** | Deformable bodies: a slide stops within 1 in 100 of backward Euler's distance (stock and final, both steps) and of Coulomb's (accurate); bodies set down come to rest (10 micrometres a second); stock creeps on the tilt at its law's speed within 1 in 10; final and accurate hold the contact within the stick distance (0.3 mm); no step stops or diverges |
| **V7** | The corrections, on build 14: the hold holds (10 micrometres a second); the hold with a second scene made and destroyed is byte-identical to the hold alone; after a rollout and a restore the cube moves less than the stick distance over the next second (a mean speed under 300 micrometres a second); no step stops or diverges. Required, on build 13: the second scene changes the hold, and the restored state is carried back towards the rollout (300 micrometres a second or more) |

Reported, not deciding: every measured line; where the deformable slides end; the end speeds on the tilt; the
time each scene took.

## Decisions fixed in advance

- If E0 holds, build 14 replaces build 13 as the library of record, and every result of runs 031 and 032 stands
  for it.
- If V1 to V6 hold, every fix of the fourteenth registration is recorded as replicated, item 4 is closed, and the
  deformable rules are recorded as corrected.
- If V7 holds, the three corrections are recorded as validated.
- A rule that fails is recorded as measured, and what it concerns stays open.

## The dry run, before registering

Every part was played once with throwaway numbers (masses, lengths and friction changed) to check the scripts and
the runner; nothing of it decides anything. It showed the review part working on the throwaway cube: on build 14
the hold with a second scene was byte-identical to the hold alone and the restored cube moved 104 micrometres a
second over the next second; on build 13 the second scene changed the hold and the restored cube moved 404. It
also found one stopped step in 3,200 on the point-cloud hold under BDF2, after two iterations at a residual of
0.0065, where no update could lower it further: the held sheet's own residual floor (the median over the play was
0.0005). So the point-cloud rules ask what Meta's scenes are asked: no step diverges, no more than 1 in 1,000
stop.

## Known risks, stated before the run

- **V3**: friction over a one-step impact on a discrete floor moved by up to 3% in the probes with where the cube
  landed among the nodes; the bound is 4%.
- **V4**: at the final configuration's tolerances a cantilever at rest sometimes stops a step at the noise floor
  (one or two in the probe). Steps stopped are reported for V4, not ruled.
- **V5**: patch G's BDF2 share was derived for one joint; the chain's rules are at 1/4 and 1/16.
- **V7**: the restored state sticks afresh, so it moves while its stick loads, up to 0.6 of the stick distance
  under this push.

## As registered

Library build 14, af70e149901c628a..., built clean from a fresh clone of SuperDex at the commit in `UPSTREAM_COMMIT` with only the four patch files applied: `senua_contact.patch` 78a57a7657388d62..., `senua_joint_limit.patch` 0b8446d24c3fd401..., `senua_rotation_axis.patch` 279c951076464943..., `senua_inertia_transport.patch` 9807f00f6b543135.... Library build 13, dbd8cf9b7553e3d1..., beside it for V7. Measuring program: `measure/sx_contact.sx`, as run a9e9e2134cf0fa26.... Runner: `measure/runners/sx_study15_run.sh` ea0ab61c1511fb1b.... Plays: `tools/plays/play_15.sh` e196e680574706a7...; identity: `tools/play_identity.sh` 2b97112fd2b8b4e6...; rig `tools/sdx_contact.cpp` 4be828cf13cb6d52....

## Amendment, before any run (15 October 2026)

Committed and pushed before run 034 began. Run 033 (E0) was already playing and is not affected: it plays nothing of
this amendment. Two things were found after registering, by probes and by a second review, of the tests' right
answers and rigs, given the code and not my conclusions. The probes are in
[`validation/run_032_open_items/probes/`](../validation/run_032_open_items/probes/).

**1. The accurate configuration's tolerances were wrong.** At SuperDex's shipped tolerances BDF2 with patch G gains
energy, and gains more the finer the step. An arm swinging for 20 s reaches 10,009, 10,038 and 10,589 per 10,000 a
swing at 1/4, 1/16 and 1/64 of the step. At the final configuration's tolerances it reads 9,994, 10,000 and 10,001
(probe 30). The cause is the absolute tolerance: patch G's Newton matrix is not exact, and a solve stopped by a fixed
absolute tolerance leaves an error that weighs more at a finer step (probe 32). The fourteenth registration's plays
of 2 s and 3 s were too short to show it. So:

- The **accurate configuration** is BDF2 at 1/16 of the step **at the final configuration's tolerances** (1e-4
  absolute, 1e-8 relative). Every accurate play of this registration takes them: item 3, item 5, the deformable
  bodies.
- At those tolerances the point-cloud sheet's steps stop on SuperDex's rule for an update too small to matter.
  Probe 31 found 67 to 2,583 a play, none at the iteration limit, with the readings identical. For the accurate
  configuration, V3's and V6's rules on stopped steps become: no step diverges, and no step stops at the iteration
  limit (every play's most iterations under 200). Stopped steps are reported.
- **V8**: the fourteenth registration's accurate plays are made again at these tolerances: its play script is copied
  with only the accurate configuration played and the tolerances added (`play_15.sh accurate14`; the copy's
  difference from the registered script is kept with the run). They are judged by the fourteenth registration's
  runner, unchanged, reading run 032's record with only the accurate configuration's files replaced.
- **V9**: a fresh arm (1.7 kg, half-size 0.045 m, 0.38 m), released level and swinging for 20 s.

| Rule | It holds when |
|---|---|
| **V8** | Every rule on the other configurations reads exactly as run 032 read it, and every A rule holds, with two changes. The rules that count stopped steps are replaced as above. A5's slides are read where they stopped, within 1 in 100 of Coulomb's distance, as V6 reads them |
| **V9** | Under the accurate configuration at 1/16 and 1/64, every swing of the 20 s is between 9,990 and 10,005 (turns placed between the steps). Under the final configuration at the shipped step and at 1/16, no swing is above 10,000. Item 5's chain under the accurate configuration at 1/64 keeps its energy within 1 in 1,000. No step diverges or stops at the iteration limit. Required, the cause: BDF2 with patch G at the shipped tolerances at 1/16, the last swing above 10,010 |

If V8 and V9 hold, the accurate configuration at the final configuration's tolerances is recorded as validated end
to end, and the shipped-tolerance form is withdrawn. If the required line fails, the stated cause is not shown on
this arm.

**2. The review of the tests' right answers and rigs.** It found no rig defect and no wrong right answer. It did
find the following, stated here before the run:

- The swing measure reads each turn at a step, so a turn that falls between two steps reads up to about half a
  step's travel short: at the shipped step, up to about 9 in 10,000 over a swing. V5 is also read with each turn
  placed between the steps, by a new measure, `swingq`. The extended measuring program re-makes the records of the
  fourth to the fourteenth registrations byte for byte, so no registered measure changed. V5 holds only when both
  readings are within its bounds.
- Backward Euler's slide distance v0^2 / (2 mu g) - v0 dt / 2 is exact only when v0 / (mu g dt) is a whole number.
  Otherwise the discrete answer is up to mu g dt^2 / 8 further: 0.05% to 0.07% on these floors at 0.01 s. The
  accurate slides are judged against Coulomb's continuum distance, of which the step alone is worth about 0.3%. Both
  leave most of the 1 in 100.
- Item 3's cube (half-size 0.03 m) has its side faces over rows of the sheet's nodes, which are every 10 mm. The
  earlier cubes did not sit that way. V3's impact bound has less margin than the probes suggested.
- V7's 300 micrometres a second cannot tell a correct restore from a carry-back under 0.3 mm. What shows that the
  anchors are forgotten is the comparison with build 13.
- The rig sets the 1 mm smoothing on both the cube and the sheet. SuperDex takes a pair's parameters from the body
  whose distance field is queried, here the cube. The deformable bodies meet a plane, not a point cloud, and are
  played without it.
- Two corrections to the text above:
  - Item 4's "0.005% to 0.013%" is the range at 128 elements. At 64 the converged rods read 0.014% to 0.023%
    (probe 25).
  - The soft cube comes back 0.4 to 0.9 mm, not about 0.5 mm. As it slows it pitches forward on SuperDex's
    compliant deformable contact, and after the stop it rocks back while its base stays (probe 27).

Known risks of the amendment: at 1/64 the absolute tolerance may let a small gain through (10,001 in probe 30), and
the required line depends on the arm.

As amended: `tools/plays/play_15.sh` 7fb745bf24c3aaa5...; `measure/runners/sx_study15_run.sh` 4545e3780e6ab762...;
`measure/sx_contact.sx` as run cbc6a401dc305836... (published c553426611b6fe08...); the probes in
`validation/run_032_open_items/probes/`.
