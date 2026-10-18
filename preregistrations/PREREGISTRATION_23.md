# Twenty-third pre-registration: patches F and G, and the recommended configuration end to end, held to every rule again on fresh numbers, the two cubes' momentum read in whole grams

Registered 15 October 2026, before any run of this registration existed. No probe was made for it: its plays are the
twenty-first registration's plays, on numbers no earlier study used.

## The question

The twenty-first registration held patches F and G and the recommended configuration to every rule of the eleventh to
fifteenth registrations on fresh numbers ([PREREGISTRATION_21.md](PREREGISTRATION_21.md), run
[051](../validation/run_051_study21/README.md)). 117 of its 118 rule lines held. The one that failed, F3's second line,
was found after the run to be the measuring program's: its `pair` measure took each cube's mass in whole units of 10 g,
cut down, and the fresh pair was not in whole multiples of 10 g. Under the recommended configuration, on fresh numbers,
with the momentum between the two cubes read with each mass in whole grams, do patches F and G meet every rule of
their registrations, does the configuration keep `half_cheetah` and `ant` in order as the eleventh and twelfth
registrations' decisions asked, and does it meet every backward-Euler end-to-end rule of the thirteenth to fifteenth
registrations?

## What the record has found since the twenty-first registration

- **Study 21's result** (run 051, `reading.txt`). 117 rule lines of 118 held, 44 rules of 45. E0 and G1 to G9 held, so
  patch G is recorded as required, correct and safe under the recommended configuration, under backward Euler. The
  line that failed was `F3_K2_second_suite_all_seven`: the second suite's code 1111101, its T16 (momentum between two
  cubes) reading 8,805 and 9,644 per million on the side play at steps 1 and 1/16, and 8,570 and 8,662 on the top play,
  against 500. So the decision on patch F did not fire, and the configuration is not recorded as validated end to end.
- **The cause** (run 051, README, "The diagnostic"; `diagnostic/`). The `pair` measure of `measure/sx_contact.sx` reads
  the momentum as each cube's mass in whole units of 10 g times its speed in whole units of 10 micrometres a second,
  each cut down. Every pair the second suite had played before had masses in whole multiples of 10 g. Study 21's fresh
  pair, 4,177 g and 698 g, read as 4,170 g and 690 g, so its momentum appeared to change by about 0.9% while the
  physics kept it: with the true masses, from the same plays' speeds, to about 1 in 600,000. Played again with one
  thing changed at a time (SuperDex's default grid, its shipped tolerances, no contact damping, the patched library with
  no switch), the pair read the same order of change; Study 11's pair, 3,000 g and 500 g, read 51 to 68 per million
  under the same configuration.
- **The measure `pairg`** (`measure/sx_contact.sx`, added after run 051). It is `pair` with each cube's mass taken in
  whole grams from the rig's header; its line holds the same numbers in the same places. `pair` is unchanged, so every
  earlier reading is made again by it. On Study 21's own plays, under the configuration, `pairg` reads 51 and 54 per
  million on the side play at steps 1 and 1/16, and 75 and 73 on the top play, where `pair` read 8,805, 9,644, 8,570
  and 8,662 (this registration's dry run, below, read them again on the Linux machine).
- **Study 22's result** (run [052](../validation/run_052_study22/README.md)). Every rule held, 66 rule lines of 66, so
  the derived form of patch G replaced the share of 1/3 under BDF2: it is now `patches/senua_inertia_transport.patch`,
  the share's file is kept as `patches/superseded/senua_inertia_transport_registration22.patch`, and the four patch
  files are library build 16. With patch G's switch unset the derived library made every file of the identity check's
  parts rotvec, flight, suites, joints, zero, bench and benchrec as registered (the plays Linux makes differently from
  the laptop as run 040 kept them) and its own plays with no switch as stock; under backward Euler with the switch set
  it made the identity part fg as registered (four plays as run 040 kept them), and its own 84 plays and Meta's scenes
  under the recommended configuration byte for byte as library build 15 (E1, E2).
- The causes the twenty-first registration listed for the earlier failures (its section "What the record has found
  since") stand as stated there and are not repeated here.

## What differs from the twenty-first registration, and why

This registration is the twenty-first registration's protocol again: its configuration, its parts and their plays, its
45 rules and 118 rule lines with their bounds, the order rule B3 among them, its four changes to how earlier rules are
played (below, carried unchanged), what it reports and what it does not carry. Exactly these things differ, each
stated here before any data of this registration existed:

1. **Fresh numbers, from seed 23, and fresh commands.** Every mass, size, speed, friction, angle, torque and material
   constant is drawn by the twenty-first registration's procedure, from the same stream and over the same ranges and
   grids, from x(0) = 23 in place of 21; a value the record already used for the same kind of quantity, Study 21's
   and Study 22's drawn values and the probe numbers of runs 048, 049 and 053 among them, is drawn again (below).
   Meta's three scenes are played on new seeds of the record's generator, 23101 to 23103, in
   [`actions/23/`](../actions/23/). *Why:* Study 21's numbers have been played and read, and its one failure is known
   to read differently with the corrected measure; a registration that decides must be made on numbers whose readings
   no one has seen, as the twenty-first's were.
2. **T16 read by `pairg`.** Wherever the second suite's momentum between the two cubes is read, the side and top plays
   at steps 1 and 1/16, under the configuration and without patch F, the runner reads it with `pairg` in place of
   `pair`. Nothing else in T16 or any other test changes: the same plays, the same numbers taken from the same places
   of the measure's line, the same bound of 500 per million, and the rest and carry plays still read by `pair`, where
   T14 and T17 read speeds and forces that no mass enters. *Why:* run 051's diagnostic found that `pair`'s units of
   10 g, cut down, made a pair whose masses are not whole multiples of 10 g appear to change a momentum the physics kept.
   The masses here are drawn on a gram grid, as Study 21's were, and are not restricted to whole multiples of 10 g:
   the second suite's pair is 4,855 g and 465 g. The rigs write each mass in whole grams in their files' headers, and
   `pairg` reads it so. No other measure the runner uses takes a mass in units of 10 g (`rest` and `slip` take it in
   grams).
3. **The patch files: library build 16.** The four patch files as they stand at registration:
   `patches/senua_contact.patch`, `patches/senua_joint_limit.patch`, `patches/senua_rotation_axis.patch` and
   `patches/senua_inertia_transport.patch` (patch G's derived form, by Study 22's decision), their checksums below. The
   patched library is library build 16, built on the Linux machine by
   [`validation/run_039_linux_replication/build.sh`](../validation/run_039_linux_replication/build.sh) from the patch
   files in [`patches/`](../patches/); the stock library is built by the same script. *Why:* library build 16 is the
   library the record now recommends. The derived form changes patch G under BDF2 only: with its switch unset it made
   every play Study 22 compared as registered or as stock, and under backward Euler with it set every play compared as
   library build 15 (run 052, E1 and E2), and every play of this registration is under backward Euler or has no switch
   set. So E0 compares the same files as Study 21's E0 did, the twelve plays named for Linux with the files run 040
   kept from library build 15.
4. **The run and the measuring program.** The run is run 055, written to `validation/run_055_study23/`. On the Linux
   machine the measuring program is the build of `measure/sx_contact.sx` with `pairg`, installed there as
   `~/sxbuild/sx_contact_pg`; it is copied beside the runner as `sx_contact`, with `sx_contact_suite.sh` and
   `sx_settings3`. *Why:* the record's next run number, and the program the second difference needs.
5. **The decisions read as the twenty-first's.** If E0 and F1 to F6 hold, patch F is recorded as required, correct and
   safe under the recommended configuration. If E0 and G1 to G9 hold, patch G is recorded so under backward Euler: the
   twenty-first registration already recorded it so (run 051), and this registration replicates that decision on fresh
   numbers and on library build 16. If every rule holds, the recommended configuration (backward Euler at the shipped
   step) is recorded as validated end to end. *Why:* the question is the twenty-first's; only the measure of one test,
   the numbers and the library differ.

What follows is the twenty-first registration's text with these differences applied: the fresh numbers and the right
answers computed for them by the formulas it states, the run, the patch files and the measuring program. Its known
risks are restated for these numbers.

## The configuration

The recommended configuration, which Studies 14 to 16 called the final configuration: the shipped step of 10 ms,
backward Euler, every switch of patches A to G (`SUPERDEX_FRICTION_FULL_NORMAL=1`, `SUPERDEX_DAMPING_UNILATERAL=1`,
`SUPERDEX_STICK_DISTANCE=0.0003`, `SUPERDEX_STICK_DAMPING=1`, `SUPERDEX_LIMIT_UNILATERAL=1`,
`SUPERDEX_ROTATION_AXIS_EXACT=1`, `SUPERDEX_FRICTION_STEP_NORMAL=1`, `SUPERDEX_INERTIA_TRANSPORT=1`), SuperDex's
Newton-Euler inertia on every articulated body (`newtoneuler=1`), contact damping 5 and friction falloff 0.03 m/s
(`ndamp=5 falloff=0.03`), solver tolerances of 1e-4 absolute and 1e-8 relative (`abstol=1e-4 reltol=1e-8`), each
mesh body's grid cell at 1/32 of its side (`sdfdiv=32`, on the contact and pair rigs), and a smoothing half-distance
of 1 mm on the cube that meets the point-cloud floor (`smooth=0.001`). The refinement steps are those the earlier rules
use. The gripper rig and Meta's scenes have no setting for the grid cell and keep SuperDex's own, as in Studies 13 and
14; the deformable bodies meet a plane. Two variants are played beside it for the rules that compare: without patch F
(`nof`), and without patch G and Newton-Euler inertia (`nog`).

## The fresh numbers, and how they were drawn

Every mass, size, speed, friction, angle, torque and material constant of the plays was drawn from one stream of whole
numbers, x(n+1) = (1103515245 x(n) + 12345) mod 2^31, from x(0) = 23. Each number gives its quantity the grid point
floor(count x(n) / 2^31) counted up from the range's lowest value, where count is the number of grid points in the
range. The ranges and grids are the twenty-first registration's, quantity for quantity (the span of the values earlier
registrations used for the same quantity, so that each test stays in the regime it was written for; a gram for a mass,
a tenth of a millimetre for a half-size and a millimetre for other lengths, a hundredth for a speed, a thousandth for a
friction or an angle), and the quantities are drawn in its order.

A value the record already used for a quantity of the same kind, or one this draw had already given that kind, was
drawn again. The lists hold, for each kind: every setting of that kind in the record's play, probe, dry-run and runner
scripts, among them the probe numbers of runs 048 and 049 (run 053 played the fifth registration's commands and set no
number of its own); the axes and angles of the record's rotations, each axis component and each angle's mantissa; the
ratio of joint friction to gravity's torque of the record's holds (1.53 on the sixth registration's arm, 1.56 on the
twenty-first's); the rigs' defaults where a registration played them; and every value the twenty-first and
twenty-second registrations drew. The lists are in the draw. Fifteen values were drawn again for being on a list:
speeds of 3.45 (Study 21's), 4.89 (Study 21's), 3.1 (run 049's) and 1 m/s (the record's); frictions of 0.42 (the
record's), 0.471 (Study 21's) and 0.446 (this draw's); lengths of 0.251 m (this draw's), 0.37 m (run 049's) and
0.09 m (the record's); axis components of -0.08 and 0.55 (Study 21's); a bending stiffness of 2.2 N m2 (Study 21's);
a tilt of 0.326 rad (Study 21's); and a grip of 9.1 N (Study 21's). Two draws were repeated until a condition held, as
the twenty-first registration's were: each cantilever until its textbook sag lin x 9.8 x len^4 / (8 ei) was from 2 to
10 mm (none was drawn again), and the floor's tilt until tan(tilt) / friction was from 0.60 to 0.75 (ten tilts were
drawn again; the tilt drawn gives 0.71). `bash tools/plays/play_23.sh <work folder> <out folder> draw` prints the draw.

Each value drawn was then looked for, as a whole number, in the record's play, probe, dry-run and runner scripts, its
rig and probe sources, its registrations, its runs' READMEs and its pages. None is a value the record used for a
quantity of the same kind. The values it does find are of other kinds: readings and percentages in the runs' READMEs
and the pages, and values of Studies 21 and 22 of another kind (a speed of 0.97 m/s here where Study 21 has an axis
component of -0.97; a mantissa of 1.04 here where Study 21 has a speed of 1.04 m/s; a linear density of 0.167 kg/m
here where Study 21 has a mass of 0.167 kg; a limit's depth of 0.038 rad here where run 048 has a half-size of
0.038 m; an axis component of -0.27 here where Study 22 has a speed of -0.27 rad/s).

The benchmark commands are new seeds of the record's generator (`measure/instrument/sx_actions.sx`, which re-makes
Study 21's and Study 22's commands byte for byte): 23101 for `cart_pole` (108 episodes of 100 control steps), 23102
for `half_cheetah` and 23103 for `ant` (108 of 40), in [`actions/23/`](../actions/23/), made as Study 21 made
`actions/21/`. None is the same as any earlier command file of the record (54 compared).

| What | The numbers | Drawn from |
|---|---|---|
| The first suite's cube | 1.783 kg, half-size 0.0394 m; dropped 0.082 m; the oblique impact at 2.89 m/s and the chain at 1.17 m/s with friction 0.388; the slide at 3.05 m/s; hold and slip with friction 0.47, pushed with 4.9274988 N and 9.8549976 N (0.6 and 1.2 of what friction holds); lifted with 52.4202 N (three times the weight) | 0.8 to 2 kg; 0.03 to 0.045 m; 0.07 to 0.1 m; 2 to 4, 0.9 to 1.5, 2.5 to 5 m/s; frictions 0.3 to 0.45 and 0.4 to 0.5 |
| The second suite | The same cube, friction 0.387, set sliding at 1.26 m/s and dropped 0.064 m to land; a block of 4.855 kg, half-size 0.306 m, with a cube of 0.465 kg, half-size 0.0293 m, on it, friction 0.363 between them; the carry push 9.462684 N (half of what friction can carry the cube at), the slip push 28.388052 N (one and a half times it); the side run at 1.08 m/s, the top run at 0.97 m/s. Right answers: 47,579 and 4,557 mN carried at rest; slip accelerations 5,506 (block) and 3,557 (cube) mm/s2 | 0.3 to 0.45; 0.8 to 1.3 m/s; 0.05 to 0.08 m; 2.5 to 5 kg, 0.2 to 0.32 m; 0.35 to 0.8 kg, 0.025 to 0.035 m; 0.35 to 0.5; 1 to 1.5 and 0.7 to 1 m/s |
| Item 1's pairs | A: block 3.699 kg, 0.251 m; cube 0.736 kg, 0.0265 m; friction 0.446; push 29.076747 N. B: 4.195 kg, 0.231 m; 0.385 kg, 0.0329 m; 0.353; 23.766078 N (each one and a half times what friction can carry). Laws: cube 4,371 and 3,459, block 6,991 and 5,348 mm/s2 | as the second suite's pair |
| The arm | 2.056 kg, half-size 0.0407 m, centre 0.371 m from the joint (inertia 0.2852604 kg m2, gravity's torque level 7.4752 N m). Released at 1.93, 3.37 and 5.38 rad/s (the law's prediction for stock at the shipped step, speed / sqrt(1 + 2 (speed x step)^2 x 100): 1,861,892, 3,042,168 and 4,281,605 um/s). The sixth's tests: spin at 3.62 rad/s; torque 1.8 N m (right answer 6,310,024 um/s after 1 s); hold with joint friction 13.3059 N m (1.78 times gravity's torque); slip with friction 1.64 N m and torque 2.82 N m (right answer 4,136,571 um/s) | 1.5 to 3 kg; 0.04 to 0.06 m; 0.35 to 0.5 m; 1 to 2.5, 2.5 to 4.5, 4.5 to 6 rad/s; 2 to 4 rad/s; 1 to 2 N m; 1.3 to 1.8; 1.5 to 2.5 N m and 0.8 to 1.5 N m more |
| The limit | Lower limit -0.354 rad, stiffness 2,037, dampings 18 and 122 (a damping ratio of 0.37 and 2.53), released at rest 0.038 rad inside it, lifted with 14.9504096 N m (twice gravity's torque) from 1.5 s. Right answers, computed as the eighth registration computed them: at rest -357,438 urad (3,438 past the limit); leaving at 1,990,591 and 574,988 um/s (the law integrated at a step of 0.1 microseconds); with no limit the lift would turn 139,305 urad in the first 0.1 s, so the bound is -232,063 | -0.4 to -0.25 rad; 1,500 to 2,500; 15 to 30 and 120 to 180; 0.02 to 0.04 rad |
| The chain | 1.017 kg and 0.636 kg, half-size 0.0492 m, centres 0.29 m and 0.215 m from their joints, joints 0.523 m apart. Free: the second joint at -0.765 rad, speeds 2.66 and -0.91 rad/s, 2 s. Swinging: from 0.327 and -0.607 rad, at rest, 2 s | 1 to 1.5 and 0.6 to 0.9 kg; 0.04 to 0.05 m; 0.25 to 0.3, 0.2 to 0.25, 0.5 to 0.6 m; -1 to -0.6 rad; 2 to 3 and -1.5 to 1.5 rad/s; 0.3 to 0.7 and -0.8 to -0.4 rad |
| The rotations | Axes (-0.45, -0.2, -0.32), (0.43, 0.3, -0.67), (-0.27, -0.42, 0.05), (0.08, 0.98, 0.14), (-0.73, 0.15, 0.12); angles 1.96e-4, 7.37e-7, 3.77e-9, 2.16e-9 (above 2e-9 rad) and 1.04e-9, 9.85e-10, 8.41e-12, 6.73e-14 (at or under it): 40 rotations | components -1 to 1; mantissas 1 to 9.99, with 3 to 9.99 and 2.01 to 2.99 at e-9 above it and 1 to 1.99 at e-9 under it |
| The point-cloud floor's cube | 1.154 kg, half-size 0.0303 m, on the held sheet (a node every 10 mm): an oblique landing at 3.32 m/s from 0.066 m with friction 0.397 (steps 1 and 1/4), a slide at 3.99 m/s, a rest, a hold and a slip with friction 0.405 pushed with 2.7481356 N and 5.4962712 N, a lift of 33.9276 N. Right answers: 3,970 per 10,000; 11,309 mN | 1 to 1.6 kg; 0.03 to 0.04 m; 0.06 to 0.08 m; 3 to 3.5 m/s; 0.35 to 0.42; 3.5 to 4 m/s; 0.4 to 0.5 |
| The deformable bodies | A rod of 0.122 kg/m, stretching stiffness 259 N, bending stiffness 4.7 N m2, 0.481 m; a strip of 1.17 kg/m2, membrane constants 531 and 0 N/m, 0.311 m; a bar of 929 kg/m3, Young's modulus 1.54 MPa, Poisson ratio 0, 0.461 m. Hanging, they stretch 532,826, 520,388 and 628,193 nm (rod and strip to St Venant-Kirchhoff's finite-strain tension, which re-makes the thirteenth registration's 1,404,624 and 936,416 nm within 1 nm; the bar to the uniaxial textbook value, as the thirteenth registered its bar) | 0.1 to 0.2 kg/m; 120 to 300 N; 1.2 to 5 N m2; 0.4 to 0.7 m; 0.8 to 1.5; 400 to 600; 0.3 to 0.5 m; 800 to 1,300; 1.5 to 3 MPa; 0.3 to 0.5 m |
| The cantilevers | Rod 1: 0.192 kg/m, 196 N, 4.6 N m2, 0.477 m (textbook sag w L^4 / (8 EI) 2,646,994 nm). Rod 2: 0.167, 164, 4.8, 0.694 (9,886,651 nm). Rod 3: 0.146, 216, 3.7, 0.667 (9,567,326 nm) | 0.08 to 0.2 kg/m; 120 to 300 N; 1.2 to 5 N m2; 0.45 to 0.7 m |
| The floor | Friction 0.516, a slide at 0.79 m/s, a tilt of 0.351 rad; the cloth patch 0.238 m a side at 1.18 kg/m2, the soft cube 0.091 m a side at 1,135 kg/m3. Backward Euler's distance v0^2 / (2 mu g) - v0 dt / 2: 57,758,986 nm at 0.01 s and 61,313,986 nm at 0.001 s. Stock's regularised creep on the tilt, falloff x (1 - sqrt(1 - tan(tilt) / mu)) with SuperDex's shipped falloff of 0.01 m/s: 4,611 um/s | 0.4 to 0.55; 0.6 to 1 m/s; 0.2 to 0.36 rad; 0.16 to 0.24 m, 0.8 to 1.2; 0.08 to 0.12 m, 800 to 1,200 |
| The gripper's cube | 0.125 kg, half-size 0.0118 m, friction 0.474, a grip of 7 N on each finger (and 0.86 N, reported). Right answers: 7,000,000 uN pressed, 612,500 uN carried by each finger | 0.1 to 0.2 kg; 0.01 to 0.016 m; 0.4 to 0.55; 6 to 10 N; 0.5 to 1 N |

## What is played

**Run 055**, on the Linux machine of runs 039 to 052 (AWS EC2, Ubuntu 24.04, Clang 18), by
[`tools/plays/play_23.sh`](../tools/plays/play_23.sh), from the root of a copy of this repository:

    bash tools/plays/play_23.sh <work folder of library build 16> validation/run_055_study23

The libraries are built on that machine by [`validation/run_039_linux_replication/build.sh`](../validation/run_039_linux_replication/build.sh)
from SuperDex at the commit in `UPSTREAM_COMMIT`, stock and patched with the four patch files in
[`patches/`](../patches/) as they stand in this commit (library build 16); the play script refuses to play if the
patched library was not built from them. The play script is `play_21.sh` with the numbers, the draw's seed and
lists, the commands and its labels changed (its part draw prints the numbers above from the seed). It builds every
rig it uses from `tools/*.cpp` with `tools/build_player.sh`, against the patched library and, for the stock plays
(contact, joint, player, deformable and gripper rigs), against the stock library, and records their checksums
(`rigs.sha256`). Its parts, each a process of its own if wanted:

- **identity**: `tools/play_identity.sh`, parts rotvec, flight, suites, joints, zero, fg, bench and benchrec (E0).
- **suites**: both contact suites on the fresh cube, under the configuration and without patch F.
- **items**: item 1's two pairs, steps 1 and 1/16; the three cantilevers held across the clamp, 32, 64 and 128
  elements, at 0.01 s.
- **arm**: one arm, no gravity, the three release speeds, 1 s, steps 1, 1/4 and 1/16: stock, and the configuration.
- **chain**: free and swinging, 2 s, steps 1, 1/4 and 1/16: no switch at SuperDex's shipped tolerances, the
  configuration, and the configuration with the solver converged (absolute 1e-9, relative 1e-12; free only).
- **joints**: the sixth registration's tests on the fresh arm under the configuration (spin, torque and swing at steps
  1, 1/4, 1/16 and 1/64; hold and slip at 1 and 1/16), stock's spin, hold and slip beside them, and the arm released
  level and swinging for 20 s at steps 1 and 1/16.
- **limits**: the eighth registration's tests on the fresh arm and limit under the configuration: rest and lift at
  steps 1 and 1/16, the release at both dampings at 1, 1/16 and 1/64.
- **rotvec**: the 40 rotations under the configuration.
- **cloud**: the fresh cube on the held sheet, stock and the configuration.
- **deform**: at 0.01 s and 0.001 s, stock falls and hangs of the rod, strip and bar; the cloth patch and the soft cube
  at rest, sliding and on the tilt, stock and the configuration.
- **grip**: both grippers, the grip and the weak grip, stock and the configuration.
- **bench**: Meta's three scenes at the shipped step on the fresh commands: stock, the configuration, without patch F,
  and without patch G and Newton-Euler inertia.
- **order**: `half_cheetah` and `ant` on the fresh commands under the configuration at steps 1, 1/2, 1/4, 1/8 and 1/16
  (B3), as the eleventh and twelfth registrations played their chains; the solver's stopped and diverged steps are
  taken from each play's trace, which is then removed.

The measuring is [`measure/runners/sx_study23_run.sh`](../measure/runners/sx_study23_run.sh), which is
`sx_study21_run.sh` with the right answers above and the one change of measure (difference 2), with the measures of
`measure/sx_contact.sx` as they stand: `suite` and `suite2` through `sx_contact_suite.sh`, `stop`, `pair`, `pairg`,
`accel`, `final`, `chain`, `creep`, `swing`, `swingq`, `leave`, `rotvec`, `impact`, `settle`, `rest`, `slip`, `pull`,
`deform`, `deformstop`, `deformdrift` and `grip`; the order by the record's instrument `measure/instrument/sx_settings3.sx`
as it stands, `time` and then `plain chain` over the five steps of each scene, as `sx_study11_run.sh` and
`sx_study12_run.sh` read runs 027 and 028 (its lines written to `counts.txt` beside the reading); and every rule by
`sx_contact rule`. On the Linux machine `sx_contact` is the build with `pairg` (difference 4):

    sx_study23_run.sh validation/run_055_study23 validation/run_055_study23/reading.txt

## The rules, fixed in advance

Every rule is judged by Simplex (`sx_contact rule`). "Within 1 in N" means the difference is at most the right answer
over N. A value the measuring cannot find stands as 999999999 and is counted. "The configuration" is the recommended
configuration above; steps are fractions of 10 ms. Every rule reads as the twenty-first registration registered it,
with its right answers computed for the fresh numbers; one measure differs, T16's, part of F3's second line, which is
read by `pairg` (difference 2).

| Rule | Carries | It holds when |
|---|---|---|
| **E0** | F0 and G0 (Studies 11, 12), E0 (Studies 13, 14) | Every file of the identity check's parts rotvec, flight, suites, joints, zero, fg, bench and benchrec (eleven parts as the script counts them, 513 files) is byte-identical to its registered file, made on the library of this registration (library build 16) with no switch and under each registered configuration's switches. The exception is the twelve plays [run 040](../validation/run_040_linux_identity/README.md) found Linux makes differently from the laptop (a joint swing at 1/64 in joints and in zero; four of fg; `ant` s4, c1, c06 and c03 in bench, which [run 047](../validation/run_047_linux_bench_off/README.md) found stock's own on Linux; `half_cheetah` y1 and y4 in benchrec): each of those is byte-identical to the Linux file run 040 kept from library build 15, and the six made with every switch off (unset, or set to 0 in zero) also to the same play made on the stock library on this machine |
| **F1** | F1 | Without patch F, the first suite's T05 fails. How far short of the law the shipped step reads without it is reported (the eleventh registration's 8 tenths; change 4 below) |
| **F2** | F2 | Under the configuration, the friction impulse over the impact is within 1 in 100 of the law at each of the seven steps, and T10 passes |
| **F3** | F3; K1 and K2 (Studies 13, 14) | Under the configuration the first suite's code is 1111111111 and the second's 1111111 |
| **F4** | F4; K3 (Studies 13, 14) | Under the configuration no step of either suite stops and none diverges |
| **F5** | F5 | Meta's three scenes at the shipped step on the fresh commands, under the configuration: no step diverges, and no more stop than without patch F plus 21 (1 in 1,000 of 21,600) |
| **F6** | F6 | T01 to T04 and T06 to T09 pass or fail under the configuration as they do without patch F |
| **G1** | G1 | Stock, one arm, shipped step: the speed after 1 s within 1 in 100 of the law's prediction at each of the three release speeds |
| **G2** | G2 | Under the configuration, the speed after 1 s between 9,990 and 10,010 per 10,000 of the release speed in all nine plays |
| **G3** | G3 | No switch, free chain, shipped step: more than a tenth of the kinetic energy and more than 3 in 100 of the angular momentum about the first joint gone after 2 s |
| **G4** | G4 | The configuration with the solver converged, free chain: at every step the angular momentum ends within 100 per million of its start; the largest energy drift no more than 5,000 per million at the shipped step, 1,000 at 1/4 and 500 at 1/16 |
| **G5** | G5 | Under the configuration, free chain: at every step the kinetic energy ends between 990,000 and 1,010,000 per million of its start, and the angular momentum within 5,000 per million |
| **G6** | G6 | Swinging chain: at every step the energy lost under the configuration is no more than 6 tenths of the loss with no switch, and it falls from each step to the next finer one |
| **G7** | G7 | In the nine one-arm plays and the six chain plays under the configuration, no step stops and none diverges |
| **G8** | G8; J2, J3, J4 (Studies 13, 14) | The sixth registration's tests on the fresh arm under the configuration: JT1 at the shipped step keeps at least 9,900 per 10,000 of its speed (3,583,800 um/s); the driven arm within 1 in 100 of 6,310,024 um/s at the shipped step; the hold creeps within 10 micro-radians a second of stock's creep; the slip within 1 in 100 of its right answer, 4,136,571 um/s, at steps 1 and 1/16 (changed, below) |
| **G9** | G9 | Meta's three scenes at the shipped step on the fresh commands, under the configuration: no step diverges, and no more stop than without patch G and Newton-Euler inertia plus 21 |
| **J1** | J1 (Study 14) | The free arm keeps at least 999 in 1,000 of its speed after 1 s at the shipped step (3,616,380 um/s) |
| **J5** | J5 | No step of the sixth registration's tests under the configuration stops or diverges |
| **L1** | L1 | The arm rests on the limit within 1 in 100 of the depth, from -357,472 to -357,404 urad, at steps 1 and 1/16 |
| **L2** | L2 | At 1/64 the speed at leaving within 2 in 100 of 1,990,591 (damping 18) and 574,988 um/s (damping 122); at steps 1 and 1/16 it has left by the end (an angle of -353,000 urad or more, 1,000 past the limit) at a tenth of the answer's speed or more (199,060 and 57,499 um/s) |
| **L3** | L3 | 0.1 s after the lift starts the angle is -232,063 urad or more, at steps 1 and 1/16 |
| **L4** | L4 | No step of the limit plays stops or diverges |
| **R1** | R1 | All 40 rotation vectors are right (within 1 millionth of the angle): 20 at or under 2e-9 rad and 20 above it |
| **P1** | P1 (Study 14), V3's stock lines (Study 15) | Stock on the point-cloud floor: friction over the impact at the shipped step more than 1.2 times the law (4,764 per 10,000), and the slip under 8 tenths of its predicted speed |
| **P2** | P2 (Study 14), V3's final lines (Study 15) | Under the configuration on the floor: the rest carries the weight within 1 in 100 (11,309 mN); the lift never pulls; the hold does not creep (10 micrometres a second); sliding friction within 1 in 100 of the law (3,970); the slip reaches 95 in 100 of its predicted speed; friction over the impact within 1 in 25 at steps 1 and 1/4; no step diverges, and no step stops at the iteration limit, each play's most iterations under 200 (changed, below) |
| **V1** | V1 (Study 15), I1c (Study 14) | Each cube's cell at 1/32 of its side, both pairs: the cube and the block within 1 in 100 of their laws at steps 1 and 1/16 |
| **I1d** | I1d (Study 14) | No step of the pairs' plays stops or diverges |
| **V2** | V2 (Study 15), I2a and I2b (Study 14) | Under the configuration the arm keeps its speed within 1 in 10,000 at the three speeds and the three steps; the free chain keeps its kinetic energy within 1 in 1,000 and its angular momentum within 100 parts per million (the largest drift), at all three steps |
| **V4** | V4 (Study 15), I4a and I4c (Study 14), which replaced D3 (Study 13) | The three cantilevers held across the clamp, under the configuration: within 1 in 1,000 of the textbook sag at 64 and 128 elements, and within 1 in 200 at 32. Their stopped steps are reported, not ruled, as V4 registered |
| **V9** | V9's lines on the final configuration (Study 15, as amended) | The arm released level and swinging for 20 s under the configuration at steps 1 and 1/16: no swing above 10,000 per 10,000 (each turn placed between the steps, `swingq`); no step diverges or stops at the iteration limit |
| **D1** | D1 | Stock falls are backward Euler's own: within 1 micrometre for the rod and the strip, 50 micrometres for the bar, at both steps |
| **D2** | D2 | Stock's hanging rod, strip and bar stretch within 1 in 200 of their right answers, at both steps |
| **D4** | D4; V6 (Study 15); read as H1 (Study 16) | Every slide's furthest point within 1 in 100 of backward Euler's distance, stock and the configuration, at both steps (changed, below) |
| **D5** | D5; V6's and H2's stock creep | Stock creeps on the tilt at its regularised law's speed, within 1 in 10, both bodies, both steps |
| **D6** | D6; V6 (Study 15); read as H2 (Study 16) | On the tilt, stock's centre moves more than 1 mm between the second and the last quarter of the play after the load, and under the configuration less than the stick distance (0.3 mm), both bodies, both steps (changed, below) |
| **D7** | D7; V6's and H3's rests | Bodies set down come to rest (no speed above 10 micrometres a second over the last tenth), stock and the configuration |
| **D8** | D8; V6's and H3's stops | No step of the falls, hangs, rests, slides and holds, stock or the configuration, stops or diverges |
| **GR1** | G1 (Studies 13, 14, the gripper) | Under the configuration, both grippers: each finger presses with the grip, 7,000,000 uN, within 1 in 100 |
| **GR2** | G2 (Studies 13, 14, the gripper) | Under the configuration, both grippers: each finger carries half the weight, 612,500 uN, within 1 in 100 |
| **GR3** | G3 (Studies 13, 14, the gripper) | Stock lets the cube creep out of both grippers (faster than 10 micrometres a second) |
| **GR4** | G4 (Studies 13, 14, the gripper) | Under the configuration the cube does not creep (under 1 micrometre a second) and slips less than 0.1 mm, both grippers |
| **GR5** | G5 (Studies 13, 14, the gripper) | No step of the configuration's 7 N grips stops or diverges |
| **B1, B2** | B1, B2 | Under the configuration on the fresh commands: no step diverges, and no more than 1 in 1,000 stop, on each of the three scenes |
| **B3** | The eleventh and twelfth registrations' decisions (the order) | Under the configuration on the fresh commands, `half_cheetah` and `ant` at steps 1, 1/2, 1/4, 1/8 and 1/16 are in order in 3 folds of 3 (in each fold of 36 episodes, each halving of the step changes the motion less than the halving before it), read by the instrument `sx_settings3` (`time`, then `plain chain` over the five steps) exactly as runs 027 and 028 read it; and no step of the ten plays diverges. Their stopped steps are reported, not ruled |

That is 45 rules, judged on 118 rule lines. Reported, not deciding: every measured line; stock's and the two variants'
counts on the fresh commands; the second suite without patch F; stock's spin; the pendulum; the stock grips' forces;
the weak grip; the cantilevers' and the 20 s swing's stopped steps; where each deformable slide ends; the end speeds on
the tilt; the solver-converged chain's stopped steps; the order's gaps (`counts.txt`), its chains' stopped steps and
whether each was at the iteration limit, and whether each scene's stream at step 1 is the same as the benchmark's
under the configuration; the time each part took.

## How the rules are carried

As the twenty-first registration carried them, word for word but for the numbers of the fresh arm in its first change.

**What the configuration changes in how a rule is played.** No bound changes.

- A play "with the correction" or "with both corrections" is a play under the recommended configuration, every other
  part of it included. G2, G5 and G7, which the twelfth registration played at SuperDex's shipped tolerances, the
  configuration of its time, are played at the configuration's. G4 keeps its own tolerances, 1e-9 and 1e-12, since its
  subject is the solver converged.
- The eleventh's and twelfth's decisions on the order (each patch joins the recommended configuration if, with it
  added, `half_cheetah` and `ant` at steps 1 to 1/16 are in order in 3 folds of 3 and no step diverges) are carried as
  one rule, B3, on the configuration as it now stands, both patches in it: the same scenes and steps, the same
  iteration limit (200), the same instrument read the same way, on the fresh commands and at the configuration's
  tolerances, where the decisions played SuperDex's shipped ones. Like the decisions, of the solver's counts it rules
  only that no step diverges, and reports the stopped steps: at the configuration's tolerances such chains stop a few
  steps at the iteration limit
  ([run 053](../validation/run_053_order_probe/README.md), a probe on the fifth registration's commands: at most 5 of
  21,600 in a play, none below the limit, none diverging; run 051 on Study 21's commands: 7 in all, every one at the
  limit).
- A comparison "without the correction" is with the configuration less that correction: F1, F5 and F6 without patch
  F; G9 without patch G and Newton-Euler inertia. The eleventh and twelfth registrations compared with the
  configuration as it then stood.
- What was stock or no switch stays so: G1 on the stock library, G3 and G6's comparison with no switch at the shipped
  tolerances; P1, D1, D2, D5 and GR3 are stock.
- Where the thirteenth and fourteenth registrations ruled the same test differently, the fourteenth's form is carried:
  J1 at 999 in 1,000, P2's bounds, the gripper's G1 and G2 under the final configuration only (the thirteenth's stock
  lines are reported), and the cantilever by I4a and I4c in place of D3, as the fifteenth's V4 played it.
- Where two registrations' rules are the same reading of the same plays, they are one rule here, named in the table:
  F3 with K1 and K2, F4 with K3, G8 with J2, J3 and J4, and E0 with F0 and G0.

**The twenty-first registration's four changes, each made before its run and each shown by the record, carried
unchanged:**

1. **The joint-friction slip against its right answer (G8, J4).** The twelfth registration's G8 and the thirteenth's
   J4 asked for the slip within 1 in 100 of stock's value. Stock is short of the right answer, and patch G moved the
   slip to it (run 028 and run 029, `reading.txt`: 3,104,079 against stock's 3,032,560; the right answer is
   (3 - 2)/0.3221333 = 3,104,305, and the record's 3,104,308 is 1 ppm above it,
   [run 049](../validation/run_049_patch_g_review/README.md)). Here, as the fourteenth registration's J4 asked: within
   1 in 100 of (torque - friction) x 1 s / inertia, at steps 1 and 1/16, the inertia taken exact, the mass times the
   sum of the square of the centre's distance and two thirds of the square of the half-size (0.2852604 kg m2; here
   4,136,571 um/s).
2. **The deformable slide and hold read as the sixteenth registration read them (D4, D6).** A slide is read by its
   furthest point (`deformstop`), not where the play ends; the hold on the tilt by how far the centre moved between the
   second and the last quarter of the play after the load (`deformdrift`), with the sixteenth's line that stock's
   centre moves more than 1 mm, not by the end speed or the tracked node; the end speed is reported. The record: run 032
   and run 034, `reading.txt` (D4, D6, A5 and V6 failed as first read), and run 036, `reading.txt` (H1 and H2 held).
3. **Stopped steps under the configuration where the record has met SuperDex's small-update rule.** On the point-cloud
   sheet, P2's "no step stops" (Study 14) and V3's "no more than 1 in 1,000 stop" (Study 15) become: no step diverges,
   and none stops at the iteration limit, each play's most iterations under 200; stopped steps are reported. That is
   the fifteenth registration's amendment, made there for the accurate configuration alone (run 034, `reading.txt`:
   one step of 840 stopped under the final configuration, its play's most iterations 19). The cantilevers at rest,
   where the record met the same rule, are reported and not ruled, as V4 registered them, and D8 counts the other
   deformable plays. Every other rule on stopped steps reads as it was registered.
4. **F1 keeps "T05 fails without patch F" and reports its second clause.** The eleventh registration also asked
   that without patch F the shipped step read at most 8 tenths of the law. How far below the law stock's friction
   over an impact falls at the shipped step depends on the cube: on four probe cubes under the recommended
   configuration it read 80.3%, 80.5%, 77.2% and 81.4% of the law ([run 048](../validation/run_048_patch_f_review/README.md),
   F1), and on Study 21's cube 81.0% (run 051). The clause measures stock on a given cube, not patch F; that patch F is
   required is T05 failing without it, which is kept. The fraction is reported.

The one change of measure this registration makes, T16 by `pairg`, is difference 2 above.

**Not carried, and why.** The eleventh and twelfth registrations' decisions themselves (whether each patch joins the
recommended configuration) fired; their test is carried as B3, a rule on the configuration as it stands. The
thirteenth's C0 (which patches its decisions admitted) is settled. The fourteenth's I1a, I1b and I4b are the causes of
items 1 and 4, shown there, and not about the configuration. Everything under BDF2 is out: the fourteenth's I5 and A1
to A7, the fifteenth's V5, V8 and V9's lines on the accurate configuration (the twenty-second registration decided
patch G under BDF2). The fifteenth's V7 compares library build 14 with build 13; build 15's corrections were put to
Studies 16 and 19. The identity check's parts r032 and r034 make the whole of runs 032 and 034 again, BDF2 plays among
them, which library build 16 changes on purpose (Study 22); E0 plays the other eight parts.

## Decisions fixed in advance

- **If E0 and F1 to F6 hold**, patch F is recorded as required, correct and safe under the recommended configuration.
- **If E0 and G1 to G9 hold**, patch G is recorded as required, correct and safe under the recommended configuration,
  under backward Euler. The twenty-first registration already recorded it so (run 051); this registration replicates
  that decision on fresh numbers and on library build 16.
- **If every rule of this registration holds**, the recommended configuration, backward Euler at the shipped step, is
  recorded as validated end to end.
- A rule that fails is recorded as measured, and what it concerns stays open. A rule of patch G that fails here is
  recorded beside run 051's reading, which stands as it was measured.
- Nothing about BDF2 or the accurate configuration is decided.

## Known risks, stated before the run

- **E0 rests on the machine and on the library.** The twelve plays named for Linux are compared with the files run 040
  kept from that machine. Another machine, or another instance type, may make them differently again; a play that
  differs for that reason fails E0 and is recorded as measured. The library is build 16, which no registered run has
  played through E0 under that name: Study 22's derived library, the same four patch files built with the same
  settings by its play script's part build, made every file of the identity check as registered (run 052, E1 and E2),
  and this registration's dry run played E0 on that library (below). A build of the same files by run 039's script that
  made any of them differently fails E0, as it should.
- **T16 by `pairg`**, its first registered use. On Study 21's plays it reads 51 to 75 per million against T16's bound
  of 500. It reads the largest change of the two cubes' momentum over the play, contact included, in whole grams and
  whole units of 10 micrometres a second.
- **V1 on item 1's pair A.** By 0.9 s the light cube's leading face is about 15 mm from the block's edge, where the
  block's cell at 1/32 of its side is 15.7 mm: inside the last cell, where the fourteenth registration found SuperDex's
  default grid rounds a box's edges (item 1). The eleventh registration's pair came within 14 mm and held at 1/32
  (run 032, I1c). Pair B's cube stays about 47 mm from the edge, and the second suite's about 121 mm (its block's cell
  19.1 mm).
- **G1, G3** at the lower speeds: the loss the law predicts for stock, and the free chain's loss, shrink with the
  speed, against bands that do not (1 in 100 of the prediction; a tenth of the energy). The speeds are inside the span
  of the twelfth registration's, whose chain lost 30% of its energy at 2.5 and 1.5 rad/s; Study 21's chain, at 2.53
  and 0.84 rad/s, lost 30% of its energy and 11% of its angular momentum (run 051).
- **L2**: the release speed at 1/64 within 2 in 100, on a limit with a lower damping ratio (0.37) than the eighth's
  (0.39); Study 21's, at 0.33, held (run 051: 0.8% under at damping 17).
- **P2**: friction over a one-step impact on a discrete floor moved by up to 3% with where the cube landed among the
  nodes; the bound is 4%. The cube's side faces are 0.3 mm outside a row of nodes (Study 21's cube: 1.6 mm).
- **V4**: two of the cantilevers sag 9.9 and 9.6 mm, above the record's largest (9.4 mm) and inside the draw's 10 mm.
  The textbook sag is the linear one; Study 21's rod that sagged 7.9 mm over 0.642 m read 0.015% short of it at 128
  elements (run 051), about the square of the sag over the length. For these rods that square is up to 0.02%, inside
  1 in 1,000.
- **D2**: the right answers are the material laws' own as the thirteenth registration took them; the neo-Hookean
  bar's finite-strain term, about 0.09% here, is inside the band.
- **D4**: a soft body's centre leads its base as it slows (up to 0.7 mm on the fourteenth's floor), which is 1.2% of
  this floor's 57.8 mm at 0.01 s.
- **Stopped steps**: at the configuration's tolerances the small-update rule may stop a step somewhere the record has
  not met it (the suites, the arm, the limits, the deformable bodies, the grips); every rule there still asks for no
  stopped step.
- **B2** on fresh commands: `half_cheetah` at the configuration's tolerances stopped 9 steps of 21,600 in Study 14 and
  5 on Study 21's commands (run 051), against a bound of 21.
- **B3** on fresh commands: the order at the configuration's tolerances has been played on the fifth registration's
  commands ([run 053](../validation/run_053_order_probe/README.md), a probe) and on Study 21's (run 051): both scenes in
  order in 3 folds of 3 each time, no step diverging; the largest ratio of a gap to the gap before it 0.65 on
  `half_cheetah` and 0.71 on `ant` in run 053, 0.82 and 0.66 in run 051. On other commands `ant` has been in order in
  only 2 of 3 folds: the eighth registration's design probes, on throwaway commands, found its chain in order in 2 of 3
  folds under the recommended configuration of that time with the limit correction added (3 of 3 without it) and in 2
  of 3 on stock ([run 018](../validation/run_018_design_probes/README.md), whose output was not kept), which
  [PREREGISTRATION_08.md](PREREGISTRATION_08.md) stated as a risk before its run ("2 of 3 on other commands"). The
  chains' stopped steps are reported, not ruled.

## The dry run, before registering

Every part was played once on the Linux machine, 15 October 2026 (11:32 to 11:53 UTC), in a work folder of its own
(the libraries and the measuring programs read, not written), from a copy of the record with this registration's
play script, runner and commands, by copies of the play script and the runner with only their blocks of numbers and
answers replaced and the play script's root set to that copy. The throwaway numbers were the twenty-first
registration's dry run's (none of this registration's numbers; every value was compared), with the second suite's
pair changed to 3,817 g and 553 g so that T16 was read on a pair not in whole multiples of 10 g; the commands two
episodes of `cart_pole` and three of `half_cheetah` and `ant` from throwaway seeds 61101 to 61103 (so that each of the
order's three folds holds one); the long swing 2 s; the identity check whole. The patched library was library build
16 as the twenty-second registration's part build made it on that machine from the same four patch files
(2dc292922b3fa4e5...), the stock library run 039's; the play script's check that the patched library was built from
the patch files in `patches/` ran against what that build recorded, and passed. Clang 18; the machine's Linux builds
of `sx_contact` with `pairg` and of `sx_settings3`, copied beside the runner. Nothing of it decides anything.

- All thirteen rigs built, in 39 seconds, each loading the library it was meant to (`rigs.sha256`). Every part played,
  in four processes side by side: the identity check in 16 minutes, every other part in under 90 seconds.
- The runner wrote all 118 rule lines, none missing, and every one held: `STUDY23 rule lines held 118 failed 0 ;
  patch F's (F1 to F6) held 14 failed 0 ; patch G's (G1 to G9) held 30 failed 0 ; values missing 0 ; measuring
  complete 1`.
- E0 held as registered: 501 of the 513 files identical to their registered files, and the twelve that differ exactly
  the twelve named for Linux, each the same as run 040's kept file and, the six with no switch, as the same play on the
  stock library.
- T16: under the configuration `pairg` read 24 and 53 per million on the side play at steps 1 and 1/16, and 85 and 92
  on the top play (without patch F 24, 53, 91 and 92), and the second suite's code was 1111111 with and without patch
  F. On the same plays `pair`, which reads the pair as 3,810 g and 550 g, read 3,152 to 3,532 per million.
- On the twenty-first registration's own plays (run 051, `runs/s2/`), `pairg` read 51, 54, 75 and 73 per million under
  the configuration and 51, 54, 74 and 75 without patch F; `pair` read them as run 051 did (8,805, 9,644, 8,570 and
  8,662 under the configuration).
- Both order chains read in order in 3 folds of 3, and each scene's stream at step 1 was the same as the benchmark's
  under the configuration. The cantilevers stopped 6 steps, reported, as in the twenty-first registration's dry run.
- The part draw printed the same numbers on the laptop and on the Linux machine.

Nothing in the rules or the play script changed after it. One comment of the runner was reworded, and the runner as
it stands then made the same reading and `counts.txt` byte for byte.

## What this does and does not say

If the rules hold, patches F and G are recorded as required, correct and safe under the recommended configuration, and
the configuration as validated end to end under backward Euler at the shipped step, on library build 16 and on numbers
no earlier study used, on every test of the eleventh to fifteenth registrations it can be put to there. It says nothing
about BDF2 or the accurate configuration, which the twenty-second registration decided for patch G; nothing about
32-bit (every play here is 64-bit); nothing about the order on `cart_pole` or on commands other than these, or without
patch F or patch G at the configuration's tolerances, which is not played here (run 053 probed the last on the fifth
registration's commands); nothing about the gripper or Meta's scenes with the grid cell set, which their rigs do not
offer; nothing about earlier readings of the second suite's momentum, which `pair` reads as it did; nothing about
gradients; and nothing against a real robot.

If a rule fails, it is recorded as measured.

## As registered

Play script `tools/plays/play_23.sh` 41f412818901978c...; runner `measure/runners/sx_study23_run.sh` 25c6636d219b3a1d..., with
`measure/runners/sx_contact_suite.sh` 161586e543ba6e69...; measuring program `measure/sx_contact.sx` (with `pairg`) as run d0abd0c601f83a37...
(published ecd668a4ebb8d0dc...); instrument `measure/instrument/sx_settings3.sx` as run 93a2a71d4c8c13a7... (published c4379446c9f6d2d7...). Patch files
(library build 16): `patches/senua_contact.patch` 05cfa0a011a0bcf6..., `patches/senua_joint_limit.patch` 6faaa83202139795...,
`patches/senua_rotation_axis.patch` 279c951076464943..., `patches/senua_inertia_transport.patch` c3e1442befd6dee9.... The libraries, built on
the Linux machine by `validation/run_039_linux_replication/build.sh` 1a98c75155d7bed6... from those files: stock 75def9201a45216a... (the folders of runs 039 and 045), patched
(library build 16) with its checksum written to the run's build file. Identity: `tools/play_identity.sh` bb1f52e8fdae023f.... Suites: `tools/contact_suite.sh` 5c0db0f1c0e78718...,
`tools/contact_suite2.sh` 13fb4706d780ea06.... Rigs: `tools/build_player.sh` b6daae9c807f3a3e... and the sources `tools/sdx_contact.cpp` 9ce3b6f33cdf705e...,
`sdx_pair.cpp` ad80834cecbaccdb..., `sdx_joint.cpp` 4cd5a6f600f139ca..., `sdx_chain.cpp` fd52b61041ab80de..., `sdx_deform.cpp` 4956a1bf50e50fa5...,
`sdx_grip.cpp` a95525e8658a4ea0..., `sdx_rotvec.cpp` cfffbfaf9fb72b25... and `sdx_player.cpp` e7328fcff80a0856...; the built rigs' checksums are written
by the play script to `rigs.sha256`. Commands: `actions/23/ant.txt` fc179bd56c454812..., `cart_pole.txt` f73d8c3f42fb5b91...,
`half_cheetah.txt` 7fcb3d2498187924.... Command generator `measure/instrument/sx_actions.sx` as run a739e224c820e163....
