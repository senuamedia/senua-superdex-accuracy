# Fourteenth pre-registration: the five open items, fixed, and the configuration end to end

Registered 14 October 2026, after design probes on throwaway cubes, arms, rods and commands
([run 030](../validation/run_030_design_probes/)). Registered before any run of this registration existed.

## The question

The thirteenth registration left five items open ([`docs/open-items.md`](../docs/open-items.md)). The probes found a
cause for each and a fix for each. Does each fix hold on parameters the probes did not use, and does the
configuration with every fix still pass every earlier test, end to end?

## The causes and the fixes

| Item | Cause, from the probes | Fix |
|---|---|---|
| 1. A light cube on a heavy one slipped 4% short | Each cube collides through SuperDex's grid distance field, which SuperDex sizes from the mesh: for a 12-triangle cube, 6 cells a side. Within the last cell before an edge the field rounds the edge, and the light cube had reached it | SuperDex's own `GridSdfParams`, the cell set explicitly to 1/32 of each mesh body's side |
| 2. Patch G left an error of one sign | The solver stops on its relative tolerance (1e-6 of the first residual) after one iteration, and with patch G the Newton matrix is not exact | SuperDex's own solver tolerances: absolute 1e-4 (shipped 1e-3), relative 1e-8 (shipped 1e-6) |
| 3. Point-cloud contact read 4% over the law | The body meeting the cloud is read through its own default grid (item 1's cause), and contact damping acts on sheet nodes its edges pass over inside SuperDex's contact smoothing distance (5 mm a side) | Item 1's cell, and a contact smoothing half-distance of 1 mm on a body that meets a point cloud |
| 4. A cantilever sagged short by half an element | The rig held the rod's first two nodes from x = 0, which makes it stiff to the middle of its first element | The held element placed across the clamp (`clampmid=1`): a correction to the rig, not to SuperDex |
| 5. Backward Euler damps a swing a force drives | Backward Euler's own damping, first order in the step. SuperDex's other integrators carry the defect patch G corrects, and patch G was derived for backward Euler alone | Patch G's correction scaled by each integrator's share (library build 13): 1 for backward Euler, unchanged; 1/3 for BDF2; 0 for the rest. And a second configuration, BDF2 at 1/16 of the step, where both a swing and an impact are right |

## Library and configurations

Library build 13 (sha256 dbd8cf9b7553e3d1...), built from the four patch files in [`patches/`](../patches/). Patch G's
file now carries its share by integrator (212 lines added, none removed; the twelfth registration's form is kept as
[`patches/superseded/senua_inertia_transport_registration12.patch`](../patches/superseded/senua_inertia_transport_registration12.patch));
the change on its own is
[`patches/in_design/build13_on_top_of_the_registered_patches.patch`](../patches/in_design/build13_on_top_of_the_registered_patches.patch)
(59 lines added and 3 changed on top of the registered files; against stock it only adds lines).

- **The final configuration** (the shipped step, 10 ms, backward Euler): patches A to G with SuperDex's Newton-Euler
  inertia, contact damping 5, a friction falloff of 0.03 m/s, solver tolerances of 1e-4 absolute and 1e-8
  relative, each mesh body's grid cell 1/32 of its side (`sdfdiv=32` on the cube rigs), and a smoothing
  half-distance of 1 mm on the cube that meets the point-cloud floor.
- **The accurate configuration**: the same with BDF2, at 1/16 of the step (0.625 ms; `sub=16` on Meta's scenes), and
  SuperDex's shipped solver tolerances. At this step they already hold a free arm and a swing within a few parts in
  10,000 under BDF2, and the tighter ones stall the held point-cloud sheet: its residual cannot go below about 1e-3
  (a check after the dry run below, on throwaway bodies).

Stock is played beside them wherever a rule compares with stock.

## The scenes, registered parameters

None of these numbers was used in the probes, except earlier registrations' own tests, which are their registered
parameters.

- **Item 1**: the eleventh registration's pair (block 3 kg, half-size 0.25 m; cube 0.5 kg, 0.03 m; friction 0.45;
  push 23.1525 N), the seventh's (4 kg, 0.3 m; 0.6 kg, 0.03 m; 0.4; 27.048 N), and a fresh pair (3.5 kg, 0.28 m;
  0.45 kg, 0.028 m; friction 0.42; push 24.3873 N, one and a half times what friction can carry). Laws: the cube at
  4,410, 3,920 and 4,116 mm/s2, the block at 6,982, 6,174 and 6,439. Pushed from 0.5 s, 0.9 s, steps 1 and 1/16.
  With SuperDex's own grid on the eleventh and the fresh pair; with the cell at 1/32 on all three; the box collider
  on the eleventh, reported.
- **Item 2**: the twelfth registration's arm (2.4 kg, half-size 0.05 m, 0.45 m) released at 1.5, 3.5 and 6 rad/s,
  and its free chain, at steps 1, 1/4 and 1/16, final configuration.
- **Item 3**: the thirteenth registration's cube (1.6 kg, half-size 0.035 m) on its sheet (a node every 10 mm), its
  six plays, stock, final configuration and accurate configuration.
- **Item 4**: the thirteenth registration's rod (0.12 kg/m, EA 150 N, EI 3 N m2, 0.6 m; textbook sag 6,350,400 nm)
  and a fresh rod (0.15 kg/m, EA 250 N, EI 1.2 N m2, 0.45 m; textbook 6,279,082 nm), at 32, 64 and 128 elements,
  held from x = 0 and across the clamp, stock, 0.01 s. The half-element prediction for the first clamp:
  1 - (1 - 1/(2n))^4 short, 6.105%, 3.089% and 1.553%.
- **Item 5**: a fresh arm (1.5 kg, half-size 0.05 m, 0.35 m) as a pendulum released level for 3 s and as a free spin
  at 4 rad/s for 1 s; a fresh chain (1 kg and 0.8 kg, half-size 0.04 m, centres 0.3 m and 0.25 m, joints 0.55 m
  apart) swinging from 0.5 and -0.6 rad for 2 s and free (2 and 1.2 rad/s, second joint at -0.8 rad) for 2 s;
  steps 1, 1/4 and 1/16; under BDF2 with patch G and without it, and under backward Euler with patch G.
- **End to end**, both configurations: both contact suites on the seventh registration's cubes; the sixth
  registration's arm; the eighth's limit runs; the ninth's rotations (final); the point-cloud floor; the deformable
  bodies (final at 0.01 s and 0.001 s, accurate at 0.000625 s; on the floor with fresh numbers: friction 0.45, a
  slide at 0.7 m/s, a tilt of 0.3 rad); the gripper (both grippers, 8 N and 0.9 N); and
  Meta's three scenes on fresh commands ([`actions/14/`](../actions/14/), seeds 14101 to 14103: `cart_pole`,
  `half_cheetah`, `ant`), stock and the final configuration at the shipped step, the accurate one at 1/16.

## The rules, fixed in advance

Every rule is judged by Simplex (`sx_contact rule`) from the measured numbers. "Within 1 in N" means the difference
is at most the right answer over N. A value the measuring cannot find stands as 999999999 and is counted.

| Rule | It holds when |
|---|---|
| **E0** safe when off | Every file of all ten parts of `tools/play_identity.sh` is byte-identical on build 13 with the new rigs, the new part `fg` (the registered plays with patch G) included |
| **I1a** required | SuperDex's own grid, the eleventh pair: the cube's acceleration from 0.7 s to 0.9 s at 1/16 is at least 1 in 50 below 4,410 mm/s2 (at most 4,322) |
| **I1b** the cause | The same play from 0.55 s to 0.75 s, before the cube reaches the last cell: within 1 in 100 of 4,410, at both steps |
| **I1c** correct | Each cube's cell at 1/32 of its side: the cube and the block within 1 in 100 of their laws at both steps, on the eleventh, the seventh and the fresh pair |
| **I1d** | No step of these plays stops or diverges |
| **I2a** correct | Final configuration: the twelfth registration's arm keeps its speed within 1 in 10,000 at 1.5, 3.5 and 6 rad/s, at steps 1, 1/4 and 1/16 (nine plays) |
| **I2b** | Its free chain keeps its kinetic energy within 1 in 1,000 and its angular momentum within 100 parts per million, at all three steps |
| **I4a** correct | Held across the clamp, both rods within 1 in 1,000 of the textbook sag at 64 and 128 elements and within 1 in 200 at 32 |
| **I4b** the cause | Held from x = 0, each rod's shortfall is within 1 in 10 of the half-element prediction, at 32 and 64 elements |
| **I4c** | The end-to-end cantilever (the thirteenth's rod, across the clamp) within 1 in 1,000 at 64 and 128 elements |
| **I5a** required | The fresh arm under BDF2 without patch G: the free spin at 4 rad/s keeps less than 99 in 100 of its speed after 1 s at the shipped step |
| **I5b** correct | With patch G's BDF2 share: the free spin keeps at least 999 in 1,000 at steps 1, 1/4 and 1/16; the pendulum's first three swings each between 9,950 and 10,010 per 10,000 at the shipped step, between 9,990 and 10,010 at 1/4, between 9,995 and 10,005 at 1/16 |
| **I5c** | The fresh chain swinging: energy over 2 s within 1 in 100 at 1/4 and 1 in 200 at 1/16; backward Euler with patch G loses more at 1/4 than BDF2's drift either way; free at 1/16, energy within 1 in 100 and momentum within 1,000 parts per million |
| **I5d** the trade | Under BDF2 the first suite's dropped cube rebounds at least 500 per 10,000 of its drop at the shipped step or at 1/2 |
| **K1, K2, K3** | Final configuration: the first contact suite passes all ten tests and the second all seven; no step of either stops or diverges |
| **J1, J2** | The sixth registration's free arm keeps at least 999 in 1,000 of its speed after 1 s at the shipped step; the driven arm within 1 in 100 of 4,656,457 |
| **J3, J4, J5** | Joint friction holds as stock does (within 10 micro-radians a second); the slip within 1 in 100 of its right answer, 3,104,308, at both steps (the thirteenth registration's J4 asked for stock's value, which was 2.3% short); no step stops or diverges |
| **L1 to L4** | The eighth registration's limit tests, as the thirteenth registration ruled them |
| **R1** | All 40 rotation vectors are right |
| **P1** | Stock on the point-cloud floor: friction over the impact more than 1.2 times the law; a slip under 8 tenths of its speed |
| **P2** | Final configuration on the floor: the rest carries the weight within 1 in 100; the lift never pulls; the hold does not creep (10 micrometres a second); sliding friction within 1 in 100 of the law; a slip reaches 95 in 100 of its speed; friction over the impact within 1 in 25 at both steps; no step stops or diverges |
| **D1, D2, D7, D8** | As the thirteenth registration ruled them, the final configuration in the corrected configuration's place |
| **D4, D5** | On the fresh floor: slides stop within 1 in 100 of backward Euler's distance, v0^2 / (2 mu g) - v0 dt / 2 = 52,055,556 nm at 0.01 s and 55,205,556 nm at 0.001 s, stock and final configuration; stock creeps on the tilted floor at its regularised law's speed, 4,409 micrometres a second, within 1 in 10 |
| **D6** | Final configuration on the tilted floor: no speed above 10 micrometres a second at the end, and the body's contact (its tracked bottom node) moved no more than the stick distance, 0.3 mm. The thirteenth registration measured the centre, which a soft body's lean under the tilted load moves without any slip; the centre is reported |
| **G1, G2** | Final configuration, both grippers: each finger presses with 8 N and carries half the weight, within 1 in 100 |
| **G3, G4, G5** | Stock lets the cube creep out of both grippers; the final configuration holds it (under 1 micrometre a second, slipped under 0.1 mm); no step of the 8 N grips stops or diverges. The weak grip's stops are reported: there the cube slides out of the fingers, and the tighter tolerances stall it (6 steps of 200 in the dry run, 1 at the shipped tolerances) |
| **B1, B2** | Final configuration on the fresh commands: no step diverges, no more than 1 in 1,000 stop, on each scene |
| **A1** | Accurate configuration, both contact suites read at 1/16: sliding friction, rest, friction over the impact and over the 0.1 s after it within 1 in 100; the hold does not creep; the slip within 2 in 100 of its prediction; the lift and the rebound never pull; the bounce at 1/16 within 100 per 10,000 of the bounce at 1/64; the slide and the landing stay stopped (100 micrometres a second) and come back no more than 330 micrometres; the slide stops within 1 in 100 of Coulomb's distance, 118,076 micrometres; each contact of the pair carries its weight within 1 in 100; the carried cube rides; the slip of block and cube within 2 in 100; momentum within 500 per million; the top cube ends with the lower; no step stops or diverges |
| **A2** | The sixth registration's arm at 1/16: the free spin keeps 9,999 in 10,000; the driven arm within 1 in 1,000; the pendulum's first three swings between 9,990 and 10,010 per 10,000; joint friction holds as stock (within 10 micro-radians a second); the slip within 1 in 100 of its right answer. The twelfth's chain at 1/16: free, energy within 1 in 200 and momentum within 1,000 parts per million; swinging, energy within 1 in 200. No step stops or diverges |
| **A3** | The eighth registration's limit tests at 1/16 and 1/64 |
| **A4** | The point-cloud floor at 1/16, by P2's bounds |
| **A5** | Deformable bodies at 0.000625 s on the fresh floor: slides stop within 1 in 100 of Coulomb's distance, 55,555,556 nm; on the tilted floor the contact moves no more than the stick distance; bodies set down come to rest; no step stops or diverges. The end speed on the tilted floor is reported, not ruled: BDF2 leaves a soft body's own elastic ringing, which backward Euler damps (about 30 micrometres a second in the check, the contact holding as under backward Euler) |
| **A6** | Both grippers at 1/16, by G1, G2, G4 and G5's bounds (G5: the 8 N grips) |
| **A7** | Meta's scenes at 1/16 on the fresh commands: no step diverges, no more than 1 in 1,000 stop, on each scene |

Reported, not deciding: every measured line; stock's counts on the fresh commands; iterations; the weak grip; the
box collider; the accurate configuration's readings at the shipped step and at 1/4.

## Decisions fixed in advance

- **Items 1 to 4 join the recommended configuration** if their rules (I1 to I4) hold and every rule of the final
  configuration end to end (E, K, J, L, R, P, D, G, B) holds.
- **The accurate configuration is recommended** where a swing a force drives must keep its energy and impacts must
  be right in the same scene, if I5 and every A rule hold.
- A rule that fails is recorded as measured, and its item stays open.

## Known risks, stated before the run

- **I1**: the fresh pair's cube reaches SuperDex's own last cell only at about 0.87 s, so its own-grid reading is
  reported, not ruled on.
- **I2**: the tolerances were chosen on one benchmark command set; on fresh commands `half_cheetah` may stall more.
- **I3**: friction over a one-step impact on a discrete floor moved by up to 3% in the probes with where the cube
  landed among the nodes.
- **I5**: patch G's BDF2 share was derived for one joint; on two links the free chain's momentum drifted 2.6% at the
  shipped step in the probes. The rules are at 1/4 and 1/16.
- **A**: BDF2's first step after a reset is not corrected; the benchmark resets every episode.
- **The dry run.** Before registering, every part was played once with throwaway numbers to check the scripts and
  the runner. The throwaway copy changed the cubes, arms, rods, pairs and the gripper's cube, but not the deformable
  bodies on the floor, so those plays ran with the thirteenth registration's floor numbers under both configurations.
  The floor plays here use fresh numbers for that reason. The dry run also found the stalls that led to the shipped
  tolerances for the accurate configuration and to G5 counting the 8 N grips; the bounds were changed before this
  registration, never after a run of it.

## As registered

The patch files: `senua_contact.patch` 1baa6dfec5400d35..., `senua_joint_limit.patch` 80f4c8c28ffacf51..., `senua_rotation_axis.patch` 1ce1e2b97003929d..., `senua_inertia_transport.patch` be36790a85e9119e...; library build 13, dbd8cf9b7553e3d1.... Measuring program: `measure/sx_contact.sx`, as run d18cbf6fc9dfd08e..., unchanged since the tenth registration. Runner: `measure/runners/sx_study14_run.sh` eb020cfe6bfbaf9d.... Plays: `tools/plays/play_14.sh` 9dc53967a6fa9dd5.... Identity: `tools/play_identity.sh` 8201012a7d96b03d.... Commands: ant.txt 4d042a909eec464a... cart_pole.txt 1690989f394c439d... half_cheetah.txt 191fd83333c7efae...
