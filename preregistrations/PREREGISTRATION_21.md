# Twenty-first pre-registration: patches F and G, and the recommended configuration end to end, held to every rule again on fresh numbers

Registered 15 October 2026, before any run of this registration existed. No probe was made for it: its plays are the earlier
registrations' plays, on numbers no earlier study used.

## The question

Patches F and G joined the recommended configuration by their registered decisions, but the eleventh and twelfth
registrations record a patch as required, correct and safe only if every one of its rules holds, and three did not:
F3, G2 and G8. Studies 13 to 15 played the configuration end to end, and in each some rules failed, so no registered
decision records it as validated end to end. Every one of those failures has since had its cause found in the record.
Under the recommended configuration, on fresh numbers, do patches F and G meet every rule of their registrations, does
the configuration keep `half_cheetah` and `ant` in order as the eleventh and twelfth registrations' decisions asked,
and does it meet every backward-Euler end-to-end rule of the thirteenth to fifteenth registrations?

## What the record has found since

| Rule | What it read | The cause, as the record has it |
|---|---|---|
| F3 (Study 11) | T15, a 0.5 kg cube slipping on a 3 kg block, 4,224 mm/s2 against Coulomb's 4,410 at the shipped step with patch F; the second suite's code 1111011 | SuperDex's default grid distance field rounds a box's edges within its last cell, which the light cube reached (Study 14, item 1). With each mesh body's cell at 1/32 of its side the same pair reads 4,410 and 4,409 at steps 1 and 1/16 (run 032, `reading.txt`, I1c), and V1 held on two fresh pairs (run 034, `reading.txt`) |
| G2 (Study 12) | One play of nine kept 9,987 per 10,000 of an arm's speed, against a band from 9,990 | SuperDex's shipped relative solver tolerance (run 030's probes): with patch G the Newton matrix is not exact and the solve stops early. At the configuration's tolerances (absolute 1e-4, relative 1e-8) the arm keeps its speed within 1 in 10,000 (Study 14 I2a, run 032; Study 15 V2 on a fresh arm, run 034) |
| G8 (Study 12), J4 (Study 13) | The joint-friction slip asked to stay within 1 in 100 of stock's value; with patch G it read 3,104,079 against stock's 3,032,560 | Stock is 2.3% short of the slip's right answer, (3 - 2)/0.3221333 = 3,104,305 (the record's 3,104,308 is 1 ppm above it; [run 049](../validation/run_049_patch_g_review/README.md)), and patch G moved it to within 1 in 10,000 of it (run 028, run 029, `reading.txt`). The rule was posed against stock, not against the law; Study 14's J4 asks for the right answer and held (run 032) |
| D4, A5 (Study 14), V6 (Study 15) | A deformable slide read at the end of the play, or at its first slow step | The soft body rocks back after its base stops, and a stop between two steps is missed. Read by its furthest point (`deformstop`), every slide held (Study 16, H1, run 036) |
| D6 (Studies 13, 14), V6 (Study 15) | The hold on the tilted floor read by the centre, by the end speed, or by the tracked node | The soft body's own lean and elastic ringing. Read by how far the centre moved between the second and the last quarter of the play (`deformdrift`), every hold held (Study 16, H2, run 036) |
| I4a, I4c (Study 14) | The cantilever 1 in 1,000 over the textbook at 64 and 128 elements | SuperDex's shipped tolerance on a static equilibrium; at the configuration's tolerances V4 held on three rods (Study 15, run 034) |
| V3 (Study 15) | Under the final configuration one step of 840 on the point-cloud sheet stopped, against no more than 1 in 1,000 | At the configuration's tolerances the sheet's steps stop on SuperDex's rule for an update too small to matter (the most iterations of any step of those plays: 19, against the limit of 200). Study 15's amendment allowed such stops for the accurate configuration (probe 31) but not for the final one |
| G2 (Study 13, the gripper) | Stock's FR3 hand: one finger carried 743,356 uN and the other 726,357, against 735,000 | A reading of stock. Study 14 registered G1 and G2 on the final configuration alone, where they held |
| V8 (Study 15) | Under BDF2 patch G loses a free chain's angular momentum at first order | Open. This registration plays nothing under BDF2 and decides nothing about it |

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
numbers, x(n+1) = (1103515245 x(n) + 12345) mod 2^31, from x(0) = 21. Each number gives its quantity the grid point
floor(count x(n) / 2^31) counted up from the range's lowest value, where count is the number of grid points in the
range. The ranges are the span of the values earlier registrations used for the same quantity, so that each test stays
in the regime it was written for; the grids are finer than any earlier registration's (a gram for a mass, a tenth of a
millimetre for a half-size and a millimetre for other lengths, a hundredth for a speed, a thousandth for a friction or
an angle). A value the record already used for a quantity of the same kind
(every setting of that kind in the record's play, probe and runner scripts, and the rigs' defaults where a
registration played them; the lists are in the draw), or one this draw had already given that kind, was drawn again:
six were (a mass of 0.698 kg and a friction of 0.392 already drawn, a length of 0.27 m and a friction of 0.38 in the
record, a bending stiffness of 4.2 already drawn, a speed of 0.87 already drawn). Two draws were repeated until a
condition held: each cantilever until its textbook sag lin x 9.8 x len^4 / (8 ei) was from 2 to 10 mm (the record's
cantilevers sag 3.1 to 9.4 mm; none was drawn again), and the floor's tilt until tan(tilt) / friction was from 0.60 to
0.75 (the record's span is 0.64 to 0.73; six tilts were drawn again). `bash tools/plays/play_21.sh <work folder> <out
folder> draw` prints the draw. Each value drawn was then looked for in the record's play, probe and runner scripts and
its registrations: none is a value the record used for a quantity of the same kind (the values it does find are of
other kinds, a rotation axis's component equal to a length, say).

The benchmark commands are new seeds of the record's generator (`measure/instrument/sx_actions.sx`, which re-makes
Study 14's commands byte for byte): 21101 for `cart_pole` (108 episodes of 100 control steps), 21102 for
`half_cheetah` and 21103 for `ant` (108 of 40), in [`actions/21/`](../actions/21/).

| What | The numbers | Drawn from |
|---|---|---|
| The first suite's cube | 1.75 kg, half-size 0.0388 m; dropped 0.081 m; the oblique impact at 3.45 m/s and the chain at 1.36 m/s with friction 0.341; the slide at 4.89 m/s; hold and slip with friction 0.471, pushed with 4.84659 N and 9.69318 N (0.6 and 1.2 of what friction holds); lifted with 51.45 N (three times the weight) | 0.8 to 2 kg; 0.03 to 0.045 m; 0.07 to 0.1 m; 2 to 4, 0.9 to 1.5, 2.5 to 5 m/s; frictions 0.3 to 0.45 and 0.4 to 0.5 |
| The second suite | The same cube, friction 0.449, set sliding at 1.04 m/s and dropped 0.058 m to land; a block of 4.177 kg, half-size 0.244 m, with a cube of 0.698 kg, half-size 0.0328 m, on it, friction 0.417 between them; the carry push 9.9610875 N (half of what friction can carry the cube at), the slip push 29.8832625 N (one and a half times it); the side run at 1.16 m/s, the top run at 0.87 m/s. Right answers: 40,935 and 6,840 mN carried at rest; slip accelerations 6,471 (block) and 4,087 (cube) mm/s2 | 0.3 to 0.45; 0.8 to 1.3 m/s; 0.05 to 0.08 m; 2.5 to 5 kg, 0.2 to 0.32 m; 0.35 to 0.8 kg, 0.025 to 0.035 m; 0.35 to 0.5; 1 to 1.5 and 0.7 to 1 m/s |
| Item 1's pairs | A: block 4.562 kg, 0.273 m; cube 0.436 kg, 0.0255 m; friction 0.392; push 28.8004752 N. B: 4.237 kg, 0.282 m; 0.352 kg, 0.0275 m; 0.492; 33.1894836 N (each one and a half times what friction can carry). Laws: cube 3,842 and 4,822, block 5,946 and 7,433 mm/s2 | as the second suite's pair |
| The arm | 1.556 kg, half-size 0.0449 m, centre 0.443 m from the joint (inertia 0.3074547 kg m2, gravity's torque level 6.7552 N m). Released at 1.56, 2.93 and 4.51 rad/s (the law's prediction for stock at the shipped step, speed / sqrt(1 + 2 (speed x step)^2 x 100): 1,523,368, 2,706,822 and 3,802,420 um/s). The sixth's tests: spin at 2.18 rad/s; torque 1.87 N m (right answer 6,082,196 um/s after 1 s); hold with joint friction 10.5381 N m (1.56 times gravity's torque); slip with friction 2.05 N m and torque 3.16 N m (right answer 3,610,288 um/s) | 1.5 to 3 kg; 0.04 to 0.06 m; 0.35 to 0.5 m; 1 to 2.5, 2.5 to 4.5, 4.5 to 6 rad/s; 2 to 4 rad/s; 1 to 2 N m; 1.3 to 1.8; 1.5 to 2.5 N m and 0.8 to 1.5 N m more |
| The limit | Lower limit -0.34 rad, stiffness 2,135, dampings 17 and 178 (a damping ratio of 0.33 and 3.5), released at rest 0.033 rad inside it, lifted with 13.5104368 N m (twice gravity's torque) from 1.5 s. Right answers, computed as the eighth registration computed them: at rest -342,980 urad (2,980 past the limit); leaving at 1,782,622 and 371,520 um/s (the law integrated at a step of 0.1 microseconds); with no limit the lift would turn 116,256 urad in the first 0.1 s, so the bound is -238,350 | -0.4 to -0.25 rad; 1,500 to 2,500; 15 to 30 and 120 to 180; 0.02 to 0.04 rad |
| The chain | 1.015 kg and 0.893 kg, half-size 0.0443 m, centres 0.296 m and 0.233 m from their joints, joints 0.501 m apart. Free: the second joint at -0.982 rad, speeds 2.53 and 0.84 rad/s, 2 s. Swinging: from 0.653 and -0.512 rad, at rest, 2 s | 1 to 1.5 and 0.6 to 0.9 kg; 0.04 to 0.05 m; 0.25 to 0.3, 0.2 to 0.25, 0.5 to 0.6 m; -1 to -0.6 rad; 2 to 3 and -1.5 to 1.5 rad/s; 0.3 to 0.7 and -0.8 to -0.4 rad |
| The rotations | Axes (0.75, -0.41, -0.5), (-0.59, 0.55, -0.4), (0.11, 1, -0.38), (0.27, -0.11, -0.97), (-0.08, -0.68, -0.15); angles 1.62e-4, 2.02e-7, 3.47e-9, 2.68e-9 (above 2e-9 rad) and 1.66e-9, 2.85e-10, 8.5e-12, 3.03e-14 (at or under it): 40 rotations | components -1 to 1; mantissas 1 to 9.99, with 3 to 9.99 and 2.01 to 2.99 at e-9 above it and 1 to 1.99 at e-9 under it |
| The point-cloud floor's cube | 1.157 kg, half-size 0.0316 m, on the held sheet (a node every 10 mm): an oblique landing at 3.09 m/s from 0.076 m with friction 0.391 (steps 1 and 1/4), a slide at 3.98 m/s, a rest, a hold and a slip with friction 0.406 pushed with 2.76208296 N and 5.52416592 N, a lift of 34.0158 N. Right answers: 3,910 per 10,000; 11,339 mN | 1 to 1.6 kg; 0.03 to 0.04 m; 0.06 to 0.08 m; 3 to 3.5 m/s; 0.35 to 0.42; 3.5 to 4 m/s; 0.4 to 0.5 |
| The deformable bodies | A rod of 0.116 kg/m, stretching stiffness 176 N, bending stiffness 4.5 N m2, 0.673 m; a strip of 0.84 kg/m2, membrane constants 565 and 0 N/m, 0.33 m; a bar of 884 kg/m3, Young's modulus 1.93 MPa, Poisson ratio 0, 0.482 m. Hanging, they stretch 1,456,451, 395,717 and 521,417 nm (rod and strip to St Venant-Kirchhoff's finite-strain tension, which re-makes the thirteenth registration's 1,404,624 and 936,416 nm within 1 nm; the bar to the uniaxial textbook value, as the thirteenth registered its bar) | 0.1 to 0.2 kg/m; 120 to 300 N; 1.2 to 5 N m2; 0.4 to 0.7 m; 0.8 to 1.5; 400 to 600; 0.3 to 0.5 m; 800 to 1,300; 1.5 to 3 MPa; 0.3 to 0.5 m |
| The cantilevers | Rod 1: 0.083 kg/m, 131 N, 2.2 N m2, 0.642 m (textbook sag w L^4 / (8 EI) 7,851,120 nm). Rod 2: 0.106, 281, 4.2, 0.594 (3,848,916 nm). Rod 3: 0.103, 299, 3.3, 0.548 (3,448,114 nm) | 0.08 to 0.2 kg/m; 120 to 300 N; 1.2 to 5 N m2; 0.45 to 0.7 m |
| The floor | Friction 0.544, a slide at 0.81 m/s, a tilt of 0.326 rad; the cloth patch 0.197 m a side at 1.16 kg/m2, the soft cube 0.099 m a side at 904 kg/m3. Backward Euler's distance v0^2 / (2 mu g) - v0 dt / 2: 57,483,989 nm at 0.01 s and 61,128,989 nm at 0.001 s. Stock's regularised creep on the tilt, falloff x (1 - sqrt(1 - tan(tilt) / mu)) with SuperDex's shipped falloff of 0.01 m/s: 3,847 um/s | 0.4 to 0.55; 0.6 to 1 m/s; 0.2 to 0.36 rad; 0.16 to 0.24 m, 0.8 to 1.2; 0.08 to 0.12 m, 800 to 1,200 |
| The gripper's cube | 0.167 kg, half-size 0.0112 m, friction 0.473, a grip of 9.1 N on each finger (and 0.67 N, reported). Right answers: 9,100,000 uN pressed, 818,300 uN carried by each finger | 0.1 to 0.2 kg; 0.01 to 0.016 m; 0.4 to 0.55; 6 to 10 N; 0.5 to 1 N |

## What is played

**Run 051**, on the Linux machine of runs 039 to 047 (AWS EC2, Ubuntu 24.04, Clang 18), by
[`tools/plays/play_21.sh`](../tools/plays/play_21.sh), from the root of a copy of this repository:

    bash tools/plays/play_21.sh <work folder of run 039 step 1> validation/run_051_study21

The libraries are built on that machine by [`validation/run_039_linux_replication/build.sh`](../validation/run_039_linux_replication/build.sh)
from SuperDex at the commit in `UPSTREAM_COMMIT`, stock and patched with the four patch files in
[`patches/`](../patches/) as they stand in this commit; the play script refuses to play if the patched library was not
built from them. The play script builds every rig it uses from `tools/*.cpp` with `tools/build_player.sh`, against the
patched library and, for the stock plays (contact, joint, player, deformable and gripper rigs), against the stock
library, and records their checksums (`rigs.sha256`). Its parts, each a process of its own if wanted:

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

The measuring is [`measure/runners/sx_study21_run.sh`](../measure/runners/sx_study21_run.sh), with the measures of
`measure/sx_contact.sx` as they stand (no measure is added): `suite` and `suite2` through `sx_contact_suite.sh`,
`stop`, `pair`, `accel`, `final`, `chain`, `creep`, `swing`, `swingq`, `leave`, `rotvec`, `impact`, `settle`, `rest`,
`slip`, `pull`, `deform`, `deformstop`, `deformdrift` and `grip`; the order by the record's instrument
`measure/instrument/sx_settings3.sx` as it stands, `time` and then `plain chain` over the five steps of each scene, as
`sx_study11_run.sh` and `sx_study12_run.sh` read runs 027 and 028 (its lines written to `counts.txt` beside the
reading); and every rule by `sx_contact rule`:

    sx_study21_run.sh validation/run_051_study21 validation/run_051_study21/reading.txt

## The rules, fixed in advance

Every rule is judged by Simplex (`sx_contact rule`). "Within 1 in N" means the difference is at most the right answer
over N. A value the measuring cannot find stands as 999999999 and is counted. "The configuration" is the recommended
configuration above; steps are fractions of 10 ms.

| Rule | Carries | It holds when |
|---|---|---|
| **E0** | F0 and G0 (Studies 11, 12), E0 (Studies 13, 14) | Every file of the identity check's parts rotvec, flight, suites, joints, zero, fg, bench and benchrec (eleven parts as the script counts them, 513 files) is byte-identical to its registered file, made on the library of this registration with no switch and under each registered configuration's switches. The exception is the twelve plays [run 040](../validation/run_040_linux_identity/README.md) found Linux makes differently from the laptop (a joint swing at 1/64 in joints and in zero; four of fg; `ant` s4, c1, c06 and c03 in bench, which [run 047](../validation/run_047_linux_bench_off/README.md) found stock's own on Linux; `half_cheetah` y1 and y4 in benchrec): each of those is byte-identical to the Linux file run 040 kept from library build 15, and the six made with every switch off (unset, or set to 0 in zero) also to the same play made on the stock library on this machine |
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
| **G8** | G8; J2, J3, J4 (Studies 13, 14) | The sixth registration's tests on the fresh arm under the configuration: JT1 at the shipped step keeps at least 9,900 per 10,000 of its speed (2,158,200 um/s); the driven arm within 1 in 100 of 6,082,196 um/s at the shipped step; the hold creeps within 10 micro-radians a second of stock's creep; the slip within 1 in 100 of its right answer, 3,610,288 um/s, at steps 1 and 1/16 (changed, below) |
| **G9** | G9 | Meta's three scenes at the shipped step on the fresh commands, under the configuration: no step diverges, and no more stop than without patch G and Newton-Euler inertia plus 21 |
| **J1** | J1 (Study 14) | The free arm keeps at least 999 in 1,000 of its speed after 1 s at the shipped step (2,177,820 um/s) |
| **J5** | J5 | No step of the sixth registration's tests under the configuration stops or diverges |
| **L1** | L1 | The arm rests on the limit within 1 in 100 of the depth, from -343,009 to -342,951 urad, at steps 1 and 1/16 |
| **L2** | L2 | At 1/64 the speed at leaving within 2 in 100 of 1,782,622 (damping 17) and 371,520 um/s (damping 178); at steps 1 and 1/16 it has left by the end (an angle of -339,000 urad or more, 1,000 past the limit) at a tenth of the answer's speed or more (178,263 and 37,152 um/s) |
| **L3** | L3 | 0.1 s after the lift starts the angle is -238,350 urad or more, at steps 1 and 1/16 |
| **L4** | L4 | No step of the limit plays stops or diverges |
| **R1** | R1 | All 40 rotation vectors are right (within 1 millionth of the angle): 20 at or under 2e-9 rad and 20 above it |
| **P1** | P1 (Study 14), V3's stock lines (Study 15) | Stock on the point-cloud floor: friction over the impact at the shipped step more than 1.2 times the law (4,692 per 10,000), and the slip under 8 tenths of its predicted speed |
| **P2** | P2 (Study 14), V3's final lines (Study 15) | Under the configuration on the floor: the rest carries the weight within 1 in 100 (11,339 mN); the lift never pulls; the hold does not creep (10 micrometres a second); sliding friction within 1 in 100 of the law (3,910); the slip reaches 95 in 100 of its predicted speed; friction over the impact within 1 in 25 at steps 1 and 1/4; no step diverges, and no step stops at the iteration limit, each play's most iterations under 200 (changed, below) |
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
| **GR1** | G1 (Studies 13, 14, the gripper) | Under the configuration, both grippers: each finger presses with the grip, 9,100,000 uN, within 1 in 100 |
| **GR2** | G2 (Studies 13, 14, the gripper) | Under the configuration, both grippers: each finger carries half the weight, 818,300 uN, within 1 in 100 |
| **GR3** | G3 (Studies 13, 14, the gripper) | Stock lets the cube creep out of both grippers (faster than 10 micrometres a second) |
| **GR4** | G4 (Studies 13, 14, the gripper) | Under the configuration the cube does not creep (under 1 micrometre a second) and slips less than 0.1 mm, both grippers |
| **GR5** | G5 (Studies 13, 14, the gripper) | No step of the configuration's 9.1 N grips stops or diverges |
| **B1, B2** | B1, B2 | Under the configuration on the fresh commands: no step diverges, and no more than 1 in 1,000 stop, on each of the three scenes |
| **B3** | The eleventh and twelfth registrations' decisions (the order) | Under the configuration on the fresh commands, `half_cheetah` and `ant` at steps 1, 1/2, 1/4, 1/8 and 1/16 are in order in 3 folds of 3 (in each fold of 36 episodes, each halving of the step changes the motion less than the halving before it), read by the instrument `sx_settings3` (`time`, then `plain chain` over the five steps) exactly as runs 027 and 028 read it; and no step of the ten plays diverges. Their stopped steps are reported, not ruled |

That is 45 rules, judged on 118 rule lines. Reported, not deciding: every measured line; stock's and the two variants'
counts on the fresh commands; the second suite without patch F; stock's spin; the pendulum; the stock grips' forces;
the weak grip; the cantilevers' and the 20 s swing's stopped steps; where each deformable slide ends; the end speeds on
the tilt; the solver-converged chain's stopped steps; the order's gaps (`counts.txt`), its chains' stopped steps and
whether each was at the iteration limit, and whether each scene's stream at step 1 is the same as the benchmark's
under the configuration; the time each part took.

## How the rules are carried

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
  21,600 in a play, none below the limit, none diverging).
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

**The four changes, each made before any run and each shown by the record:**

1. **The joint-friction slip against its right answer (G8, J4).** The twelfth registration's G8 and the thirteenth's
   J4 asked for the slip within 1 in 100 of stock's value. Stock is short of the right answer, and patch G moved the
   slip to it (run 028 and run 029, `reading.txt`: 3,104,079 against stock's 3,032,560; the right answer is
   (3 - 2)/0.3221333 = 3,104,305, and the record's 3,104,308 is 1 ppm above it,
   [run 049](../validation/run_049_patch_g_review/README.md)). Here, as the fourteenth registration's J4 asked: within
   1 in 100 of (torque - friction) x 1 s / inertia, at steps 1 and 1/16, the inertia taken exact, the mass times the
   sum of the square of the centre's distance and two thirds of the square of the half-size (0.3074547 kg m2; here
   3,610,288 um/s).
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
   F1). The clause measures stock on a given cube, not patch F; that patch F is required is T05 failing without it,
   which is kept. The fraction is reported.

**Not carried, and why.** The eleventh and twelfth registrations' decisions themselves (whether each patch joins the
recommended configuration) fired; their test is carried as B3, a rule on the configuration as it stands. The
thirteenth's C0 (which patches its decisions admitted) is settled. The fourteenth's I1a, I1b and I4b are the causes of items 1 and 4, shown there, and not about the
configuration. Everything under BDF2 is out: the fourteenth's I5 and A1 to A7, the fifteenth's V5, V8 and V9's lines
on the accurate configuration. The fifteenth's V7 compares library build 14 with build 13; build 15's corrections were
put to Studies 16 and 19. The identity check's parts r032 and r034 make the whole of runs 032 and 034 again, BDF2
plays among them, which a reviewed patch G may change on purpose; E0 plays the other eight parts.

## Decisions fixed in advance

- **If E0 and F1 to F6 hold**, patch F is recorded as required, correct and safe under the recommended configuration.
- **If E0 and G1 to G9 hold**, patch G is recorded as required, correct and safe under the recommended configuration,
  under backward Euler.
- **If every rule of this registration holds**, the recommended configuration, backward Euler at the shipped step, is
  recorded as validated end to end.
- A rule that fails is recorded as measured, and what it concerns stays open.
- Nothing about BDF2 or the accurate configuration is decided.

## Known risks, stated before the run

- **E0 rests on the machine.** The twelve plays named for Linux are compared with the files run 040 kept from that
  machine. Another machine, or another instance type, may make them differently again; a play that differs for that
  reason fails E0 and is recorded as measured. If the reviews of patches F and G change a patch file, the library is a
  new build, and anything it changes under the registered configurations' switches (the suites with patches A to C and
  E, fg, benchrec) fails E0, as it should.
- **F3 on the second suite's pair.** By 0.9 s the light cube's leading face is about 20 mm from the block's edge, where
  the block's cell at 1/32 of its side is 15.25 mm. The eleventh registration's pair came within 14 mm and held at
  1/32 (run 032, I1c).
- **G1, G3** at the lower speeds: the loss the law predicts for stock, and the free chain's loss, shrink with the
  speed, against bands that do not (1 in 100 of the prediction; a tenth of the energy). The speeds are inside the span
  of the twelfth registration's, whose chain lost 30% of its energy at 2.5 and 1.5 rad/s.
- **L2**: the release speed at 1/64 within 2 in 100, on a limit with a lower damping ratio (0.33) than the eighth's
  (0.39).
- **P2**: friction over a one-step impact on a discrete floor moved by up to 3% with where the cube landed among the
  nodes; the bound is 4%. The cube's side faces are 1.6 mm from a row of nodes.
- **D2**: the right answers are the material laws' own as the thirteenth registration took them; the neo-Hookean
  bar's finite-strain term, about 0.07% here, is inside the band.
- **D4**: a soft body's centre leads its base as it slows (up to 0.7 mm on the fourteenth's floor), which is 1.2% of
  this floor's 57.5 mm at 0.01 s.
- **Stopped steps**: at the configuration's tolerances the small-update rule may stop a step somewhere the record has
  not met it (the suites, the arm, the limits, the deformable bodies, the grips); every rule there still asks for no
  stopped step.
- **Linux rigs**: the deformable and gripper rigs are played on Linux in a registered run here for the first time
  (before it, only in the dry run below).
- **B2** on fresh commands: `half_cheetah` at the configuration's tolerances stopped 9 steps of 21,600 in Study 14,
  against a bound of 21.
- **B3** on fresh commands: the order at the configuration's tolerances has been played only on the fifth
  registration's commands, the ones every order decision of the record was made on
  ([run 053](../validation/run_053_order_probe/README.md), a probe: both scenes in order in 3 folds of 3 with and
  without patch F and patch G, no step diverging; the largest ratio of a gap to the gap before it 0.65 on
  `half_cheetah` and 0.71 on `ant`). On other commands `ant` has been in order in only 2 of 3 folds: the eighth
  registration's design probes, on throwaway commands, found its chain in order in 2 of 3 folds under the recommended
  configuration of that time with the limit correction added (3 of 3 without it) and in 2 of 3 on stock
  ([run 018](../validation/run_018_design_probes/README.md), whose output was not kept), which
  [PREREGISTRATION_08.md](PREREGISTRATION_08.md) stated as a risk before its run ("2 of 3 on other commands"). The
  chains' stopped steps are reported, not ruled: under the configuration run 053's stopped at most 5 of 21,600 in a
  play, every one at the iteration limit.

## The dry run, before registering

Every part was played once on the laptop (library build 15 and the rigs in `tools/`, macOS) with throwaway numbers:
every mass, size, speed, friction and material changed, the commands two episodes a scene, the long swing 2 s, the
identity check's parts rotvec and flight alone (9 of 9 files); its other numbers and the right answers computed for them
by the formulas above. Nothing of it decides anything. Every part played, in about five minutes; the runner wrote all 116
rule lines and they held. The cantilevers stopped 6 steps of 3,600 at the configuration's tolerances, at the noise floor
V4's known risk names, which is why D8 counts the other deformable plays. The runner's count of rule lines missed I1d
(a lower-case letter in its name) and was corrected. After it two things changed: the stock deformable and gripper
plays, which Studies 13 to 16 made on the patched library with no switch, are made on Linux with rigs built against the
stock library, and the two parts were played again and read again; and F1's second clause became a reported line
(change 4), which left 115 rule lines. The Linux-only part of E0, the twelve named plays, cannot play on the laptop;
the runner was checked on a written copy of its output: a named play the same as run 040's kept file and as stock
passes, a play that differs and is not named fails.

After the part order and B3 were added, the whole play was played once on the Linux machine (library build 15 as run
039's `build.sh` built it there, only read; Clang 18; the machine's Linux builds of `sx_contact` and `sx_settings3`) by
copies of the play script and the runner holding the laptop dry run's throwaway numbers and answers, throwaway commands
from seeds 61101 to 61103 (two episodes of `cart_pole`, three of `half_cheetah` and `ant`, so that each of the order's
three folds holds one), the long swing 2 s, and the identity check whole. Nothing of it decides anything. All thirteen
rigs built, the deformable and gripper rigs on Linux for the first time; every part played (the identity check in
24 minutes on a machine other jobs shared, each other part in under two minutes, the order in 38 s); the runner wrote
all 118 rule lines and they held. E0 held as registered: 501 of the 513 files identical to their registered files, and
the twelve that differ exactly the twelve named for Linux, each the same as run 040's kept file and, the six with no
switch, as the same play on the stock library. Both order chains read in order in 3 folds of 3, and each scene's stream
at step 1 was the same as the benchmark's under the configuration. Two things in the play script's part rigs were then
corrected, and the part played again: it wrote its link to the compiler into the libraries' work folder, and now uses
a folder of its own; and `rigs.sha256` carried the address at which `ldd` found each library loaded, which changes from
run to run, and now leaves it out (two runs of the part then wrote the same file, with the rigs the dry run played).

## What this does and does not say

If the rules hold, patches F and G are recorded as required, correct and safe under the recommended configuration, and
the configuration as validated end to end under backward Euler at the shipped step, on numbers no earlier study used,
on every test of the eleventh to fifteenth registrations it can be put to there. It says nothing about BDF2 or the
accurate configuration, where patch G's loss of a chain's angular momentum stays open; nothing about 32-bit (every play
here is 64-bit); nothing about the order on `cart_pole` or on commands other than these, or without patch F or patch G
at the configuration's tolerances, which is not played here (run 053 probed the last on the fifth registration's
commands);
nothing about the gripper or Meta's scenes with the grid cell set, which their rigs do not offer; nothing about
gradients; and nothing against a real robot.

If a rule fails, it is recorded as measured.

## As registered

Play script `tools/plays/play_21.sh` 60384e64db0fd267...; runner `measure/runners/sx_study21_run.sh` 0133b2bafbd9ff4a..., with
`measure/runners/sx_contact_suite.sh` 161586e543ba6e69...; measuring program `measure/sx_contact.sx` as run 87e921cd4d2c03bf... (published
4779c518d77ee09e...); instrument `measure/instrument/sx_settings3.sx` as run 93a2a71d4c8c13a7... (published c4379446c9f6d2d7...). Patch files:
`patches/senua_contact.patch` 05cfa0a011a0bcf6..., `patches/senua_joint_limit.patch` 6faaa83202139795...,
`patches/senua_rotation_axis.patch` 279c951076464943..., `patches/senua_inertia_transport.patch` 9807f00f6b543135.... The libraries, built on
the Linux machine by `validation/run_039_linux_replication/build.sh` 1a98c75155d7bed6... from those files: stock 75def9201a45216a..., patched
eee7cca1423650df... (library build 15). Identity: `tools/play_identity.sh` bb1f52e8fdae023f.... Suites: `tools/contact_suite.sh` 5c0db0f1c0e78718...,
`tools/contact_suite2.sh` 13fb4706d780ea06.... Rigs: `tools/build_player.sh` b6daae9c807f3a3e... and the sources `tools/sdx_contact.cpp` 9ce3b6f33cdf705e..., `sdx_pair.cpp` ad80834cecbaccdb..., `sdx_joint.cpp` 4cd5a6f600f139ca..., `sdx_chain.cpp` fd52b61041ab80de..., `sdx_deform.cpp` 4956a1bf50e50fa5..., `sdx_grip.cpp` a95525e8658a4ea0..., `sdx_rotvec.cpp` cfffbfaf9fb72b25... and `sdx_player.cpp` e7328fcff80a0856...;
the built rigs' checksums are written by the play script to `rigs.sha256`. Commands:
`actions/21/ant.txt` ec9aae54c27d5e5e..., `cart_pole.txt` 4d68edebacefa27f..., `half_cheetah.txt` 92427b5156ac2d7c....
