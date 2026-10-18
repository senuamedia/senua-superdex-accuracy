# Twenty-second pre-registration: patch G under BDF2, its current form and its derived form head to head on fresh numbers

Registered 15 October 2026, before any run of this registration existed. Its design probes are run 049's
([`validation/run_049_patch_g_review/`](../validation/run_049_patch_g_review/README.md)); none of its numbers is used
here.

## The question

Patch G is in the recommended configuration under backward Euler, where run 049 found no defect in it. Under BDF2,
the integrator of the accurate configuration, its current form scales its correction by a share of 1/3, derived for
one joint. There it is right: a pendulum keeps every swing within 1 in 10,000 over 20 s (Study 15, V9). On a chain it
is not: a free two-link chain keeps its energy and loses angular momentum at first order, 1,540 parts per million over
2 s at 1/16 of the step, against 1,000 allowed (Study 15, V8). Run 049 found the cause in stock SuperDex and derived a
form of patch G that makes a chain second order. Under BDF2, on numbers no earlier study used, does the derived form
replace the current one?

## What the record has found

- **The loss.** The twelfth registration's free chain under BDF2 with patch G loses 6,270, 1,540 and 372 parts per
  million of its angular momentum over 2 s at 1/4, 1/16 and 1/64 of the step: a quarter for each quartering of the
  step, first order, and the same with the solve converged. Backward Euler with patch G keeps it to 6 parts per
  million (run 034, `probes/probe_33_chain_momentum.txt`).
- **The cause** (run 049, README, "BDF2: the cause, in stock SuperDex, and the derived form"). SuperDex's BDF2 combines
  the two previous states with weights 4/3 and -1/3 over a stage of 2h/3. For a jointed body it sets each link's
  stage-start pose from the forward kinematics of the combined joint angles, X(q_s) (`mochi_articulated_body.cpp` at
  the upstream commit, around lines 3291 to 3319), while BDF2 for a constrained system combines each link's own
  centres, x_s = X_n + (-1/3)(X_{n-1} - X_n), with the constraint force removed by the null-space matrix at the node
  where the equation is written (Gear, Leimkuhler and Gupta 1985; Lotstedt and Petzold 1986; Brenan, Campbell and
  Petzold 1996, chapter 3; Hairer and Wanner, Solving ODEs II, chapter VII; Betsch 2005; Betsch and Leyendecker 2006).
  A linear multistep combination commutes only with a linear map, so X(q_s) - x_s = (2/9) h^2 Jdot qd + O(h^3): the
  velocity kept at the end of the stage is short by (h/3) Jdot qd and the residual carries an error of first order.
  The share of 1/3 cancels it for one joint only. For a chain a secular part of the angular momentum's error remains,
  (h/3) sum m_i Xd_i x (J_i qdd), and no scalar share cancels it.
- **The derived form** ([`patches/in_design/senua_inertia_transport_bdf2_derived.patch`](../patches/in_design/senua_inertia_transport_bdf2_derived.patch),
  run 049's `g3`). It adds the force m D/h_s^2 with D = X(q_s) - x_s, adds D/h_s to the link velocity kept at the end
  of the stage, uses the current Jacobian under BDF2 and keeps the transport for backward Euler alone. No constant is
  tuned. A one-step stage (backward Euler, or the step that starts or restarts BDF2) is left as it is.
- **Its probes** (run 049, on probe numbers). With the solve converged, a free chain's angular momentum falls four
  times a halving of the step with the derived form and twice with the current one, on a planar chain and on a chain
  whose second joint's axis is tilted; at the accurate configuration's tolerances the orders hold with no step
  stopped; on Meta's scenes under the accurate configuration no step of 345,600 stopped or diverged. With the switch
  off it gives stock's files and under backward Euler library build 15's, on every play compared, the identity list
  among them.
- **Its cost** (run 049). A single joint loses about (omega h)^2 of its speed once, at the backward-Euler step that
  starts BDF2. Played on the registered numbers of Studies 14 and 15 it would improve V8, I5c's chain momentum and A2,
  and would fail four lines that held at coarse steps: I5b's free spin and pendulum at the shipped step, I5c's chain
  at 1/4 and V5's free spin at the shipped step.

## The two forms, and the configuration

- **The current form** (`cur`): library build 15, built on the Linux machine from the four patch files in
  [`patches/`](../patches/) by [`validation/run_039_linux_replication/build.sh`](../validation/run_039_linux_replication/build.sh).
- **The derived form** (`der`): the same SuperDex checkout with the contact, joint-limit and rotation files of library
  build 15 and the derived file in place of `patches/senua_inertia_transport.patch`, built by the play script's part
  `build` with run 039's settings. The play script refuses to play if either library was not built from these files.
- **The accurate configuration**, as Studies 14 and 15 played it at the final configuration's tolerances: BDF2, every
  switch of patches A to G (`SUPERDEX_FRICTION_FULL_NORMAL=1`, `SUPERDEX_DAMPING_UNILATERAL=1`,
  `SUPERDEX_STICK_DISTANCE=0.0003`, `SUPERDEX_STICK_DAMPING=1`, `SUPERDEX_LIMIT_UNILATERAL=1`,
  `SUPERDEX_ROTATION_AXIS_EXACT=1`, `SUPERDEX_FRICTION_STEP_NORMAL=1`, `SUPERDEX_INERTIA_TRANSPORT=1`), SuperDex's
  Newton-Euler inertia (`newtoneuler=1`), the solver's tolerances at 1e-4 absolute and 1e-8 relative, at 1/16 of the
  shipped step; on Meta's scenes also contact damping 5 and friction falloff 0.03 m/s (`ndamp=5 falloff=0.03`) and 16
  sub-steps a step. The chains and the arm touch nothing, so of the switches only patch G's acts on them.
- **The solve converged**: the same at 1e-9 absolute and 1e-12 relative, so that the method's own order shows.
- **The steps**: 1, 1/2, 1/4, 1/8, 1/16, 1/32 and 1/64 of the shipped 10 ms.

## The scenes

- **Three free chains** (two arms on two joints, no gravity, 2 s): A and B planar; T with its second joint's axis
  tilted from z towards the first arm's x, so that it moves in three dimensions. The chain rig takes the tilt as
  `tilt2`, an option added for this registration (`tools/sdx_chain.cpp`; with it unset the rig is unchanged, and the
  identity check's part fg plays it). For T the rig's file carries each arm's x, y, velocity along x and y and spin
  about z: the angular momentum about the first joint's axis whole, since a cube's inertia is the same about every
  axis, but only the part of the kinetic energy in the x-y plane. So for T only the angular momentum is read.
- **A swinging chain**: two arms on two joints under gravity, released at rest, 2 s.
- **One arm on one joint**: a free spin (no gravity, 1 s) and a pendulum released level (3 s), and the pendulum
  released level for 20 s at 1/16 of the step.
- **Meta's three scenes** on fresh commands (108 episodes each): the accurate configuration at 1/16, and the
  recommended configuration (backward Euler at the shipped step).

## The fresh numbers, and how they were drawn

Every mass, size, length, angle and speed was drawn from one stream of whole numbers, x(n+1) = (1103515245 x(n) +
12345) mod 2^31, from x(0) = 22. Each number gives its quantity the grid point floor(count x(n) / 2^31) counted up
from the range's lowest value, where count is the number of grid points in the range: a gram for a mass, a tenth of a
millimetre for a half-size, a millimetre for a length, a thousandth of a radian for an angle, a hundredth of a radian
a second for a speed. The ranges are the span of the values the twelfth to fifteenth registrations and the
twenty-first's draft used for the same quantity, so that each test stays in the regime it was written for; the tilt,
which no registration has used, is from 0.3 to 0.9 rad (far enough from 0 for the motion to be three-dimensional, short
of a right angle), and the free spin's speed from 3 to 4 rad/s (the span of the record's free spins under BDF2, 3, 3.5
and 4 rad/s). A value the record already used for a quantity of the same kind (play_21.sh's lists, which hold every
setting of that kind in the record's play, probe and runner scripts), one the twenty-first registration's draft draws,
one of run 049's probes, or one this draw had already given that kind, was drawn again: one was (chain T's second arm,
0.244 m, the twenty-first's draft's). Each value drawn was then looked for, as a whole number, in the record's play,
probe and runner scripts, its rig sources and its registrations: none is there. `bash tools/plays/play_22.sh <work
folder> <out folder> draw` prints the draw.

The commands are new seeds of the record's generator (`measure/instrument/sx_actions.sx`, which re-makes the
twenty-first's draft's commands byte for byte): 22101 for `cart_pole` (108 episodes of 100 control steps), 22102 for
`half_cheetah` and 22103 for `ant` (108 of 40), in [`actions/22/`](../actions/22/). None is the same as any earlier
command file.

| What | The numbers | Drawn from |
|---|---|---|
| Chain A | 1.152 kg and 0.632 kg, half-size 0.0439 m, centres 0.279 m and 0.247 m from their joints, joints 0.561 m apart; the second joint at -0.934 rad, turning at 2.33 and -1.16 rad/s | 1 to 1.5 and 0.6 to 0.9 kg; 0.04 to 0.05 m; 0.25 to 0.3, 0.2 to 0.25 and 0.5 to 0.6 m; -1 to -0.6 rad; 2 to 3 and -1.5 to 1.5 rad/s |
| Chain B | 1.177 kg and 0.897 kg, 0.0423 m, 0.274 m and 0.206 m, 0.585 m; -0.922 rad; 2.1 and -0.27 rad/s | the same |
| Chain T | 1.063 kg and 0.854 kg, 0.0497 m, 0.254 m and 0.203 m, 0.598 m; -0.893 rad; 2.08 and 1.35 rad/s; the second joint's axis tilted 0.787 rad | the same; the tilt 0.3 to 0.9 rad |
| The swinging chain | 1.325 kg and 0.649 kg, 0.0471 m, 0.26 m and 0.226 m, 0.529 m; released at rest from 0.346 and -0.502 rad | the same; 0.3 to 0.7 and -0.8 to -0.4 rad |
| The arm | 2.216 kg, half-size 0.0514 m, centre 0.444 m from the joint; the free spin at 3.8 rad/s | 1.5 to 3 kg; 0.04 to 0.06 m; 0.35 to 0.5 m; 3 to 4 rad/s |

## What is played

**Run 052**, on the Linux machine of runs 039 to 049 (AWS EC2, Ubuntu 24.04, Clang 18), by
[`tools/plays/play_22.sh`](../tools/plays/play_22.sh), from the root of a copy of this repository:

    bash tools/plays/play_22.sh <work folder of run 039 step 1> validation/run_052_study22

Its parts, one play after another; after build and rigs each part can be a process of its own:

- **build**: the derived library, from the work folder's SuperDex checkout and the derived set of patch files.
- **rigs**: every rig used here, from `tools/*.cpp` by `tools/build_player.sh`: against the derived library in
  `tools/` (the identity check plays those), against the stock library in `tools/` (`*_stock`), against library
  build 15 in the work folder; their checksums go to `rigs.sha256`.
- **identity**: `tools/play_identity.sh` on the derived library, parts rotvec, flight, suites, joints, zero, fg, bench
  and benchrec (E1, E2), with the plays Linux makes differently from the laptop compared as the twenty-first
  registration's draft compares them.
- **bdf2**: the head to head. Both forms, under BDF2 with the accurate configuration's switches, at its tolerances and
  with the solve converged: the three free chains, the swinging chain, the free spin and the pendulum at every step.
- **be**: the same scenes, tolerances and steps under backward Euler with every switch set, both libraries (E2, and the
  floor of the order rules below).
- **off**: the same scenes with no switch, under BDF2 and backward Euler at the configuration's tolerances, steps 1,
  1/4, 1/16 and 1/64, the derived library and the stock library (E1).
- **long**: the pendulum released level for 20 s at 1/16 under the accurate configuration, both forms.
- **bench**: Meta's three scenes on the fresh commands, both forms, under the accurate configuration and under the
  recommended one.
- **compare**: the byte comparisons of E1 and E2 written to `compare.txt`.

The measuring is [`measure/runners/sx_study22_run.sh`](../measure/runners/sx_study22_run.sh), with the measures of
`measure/sx_contact.sx` as they stand (no measure is added): `chain`, `final`, `swing`, `swingq` and `rule`:

    sx_study22_run.sh validation/run_052_study22 validation/run_052_study22/reading.txt

## The rules, fixed in advance

Every rule is judged by Simplex (`sx_contact rule`). "Within 1 in N" means the difference is at most the right answer
over N. A value the measuring cannot find stands as 999999999 and is counted. A chain's drift is the largest
departure over its 2 s, in parts per million, of its angular momentum about the first joint from its start
(`momentum_largest_drift_ppm`), or of its kinetic energy (`energy_largest_drift_ppm`, per million of the most kinetic
energy), as V8 and A2 read them.

**The order of convergence: the bound, and why.** BDF2 is a second-order method (Curtiss and Hirschfelder 1952;
Hairer, Norsett and Wanner, Solving ODEs I, chapter III; for constrained mechanical systems, Lotstedt and Petzold 1986
and Brenan, Campbell and Petzold 1996, chapter 3). Its global error over a fixed time is e(h) = C h^p (1 + O(h)) with
p = 2, so each halving of the step divides it by about 2^p: by 2 for an error of the first order, by 4 for one of the
second. A halving is read as second order when the drift falls by at least 2^1.5 = 2.83: the geometric midpoint of 2
and 4, the point at which the observed order, log2 of the fall, is nearer 2 than 1. Written as a rule: the finer
step's drift is at most 500/1414 of the coarser step's. The bound depends on nothing measured.

**Where a halving is above rounding: the floor, and why.** A drift is read from the rig's whole micrometres and
micrometres a second and the measure's whole parts per million. From the drawn numbers, before the run, that rounding
moves one drift by at most 6.5 parts per million on chain A's momentum, 6.2 on B's and 5.8 on T's, and 4.8 and 4.7 on
A's and B's energy (each reading rounded by half a unit in every position and speed, the speeds bounded by the
chain's kinetic energy, twice for a drift, and 1 for the whole parts per million): 7 at most. At the configuration's
tolerances the solve leaves more. Both are read on a quantity that is kept exactly: backward Euler with patch G keeps
a free chain's angular momentum about the first joint exactly (run 049: 0.000 parts per million in double precision
at every step, planar and tilted), so what the record's measure reads there is what the measurement and the solve
leave. The floor of a chain, at a tolerance and a step, is the largest momentum drift it reads under backward Euler
with patch G at that tolerance and step (part be), or 7 parts per million, whichever is larger; the energy's floor is
the same chain's (the same rounded numbers and the same solve). A halving is ruled where the finer step's drift is at
least 5 floors (the larger of the two steps' floors). Why 5: with an error of up to one floor in each of the two
drifts, a fall of 4 cannot read below (4 x 5 - 1)/(5 + 1) = 3.17, and a fall of 2 cannot read above (2 x 5 + 1)/(5 - 1)
= 2.75: each stays on its own side of 2.83. At 4 floors a fall of 2 could read 3. A halving under 5 floors is reported.

| Rule | It holds when | Why, and the source of the bound |
|---|---|---|
| **O0** required | The current form, the solve converged, each free chain (A, B, T): from the shipped step to 1/64 the momentum's drift falls by less than 2^(1.5 x 6) = 512, and its drift at 1/64 is at least 5 floors | The defect the derived form corrects must be there on these chains, or the head to head shows nothing (Study 15's V8; run 034's probe 33). 512 is the bound above, over six halvings |
| **O1** correct, momentum | The derived form, each free chain (A, B, T), at the configuration's tolerances and with the solve converged: every ruled halving from the shipped step to 1/64 falls by at least 2.83; with the solve converged, at least one halving of each chain is ruled | The claim of the derived form: BDF2's own order on a chain's angular momentum. At the configuration's tolerances the solve's floor may leave no halving above 5 floors; then none is ruled there, and the count is reported |
| **O2** correct, energy | The same for the kinetic energy of A and B | BDF2 is second order for every smooth quantity of the motion; the derived form must not cost the energy's order |
| **T1** the chains at 1/16 | The derived form, the accurate configuration: each free chain's momentum drift at most 1,000 parts per million; A's and B's kinetic energy at the end within 1 in 200 of the start | The fourteenth registration's A2 for the accurate configuration's chain, which V8 replayed (Study 15) |
| **T2** the swinging chain at 1/16 | The derived form, the accurate configuration: the energy at the end within 1 in 200 of the most kinetic energy (5,000 per million) | A2 and the fifteenth registration's V5 at 1/16 |
| **T3** the free spin at 1/16 | The derived form, the accurate configuration: the speed after 1 s at least 9,999 in 10,000 of 3.8 rad/s (3,799,620 urad/s) | A2's free spin at 1/16 |
| **T4** the pendulum at 1/16 | The derived form, the accurate configuration: the first three swings between 9,995 and 10,005 per 10,000, read at the steps and with each turn placed between the steps; released level for 20 s, every swing between 9,990 and 10,005 with each turn placed between the steps | V5's bounds at 1/16 and V9's (Study 15, as amended) |
| **U1** the solver | No step of the derived form's plays under BDF2 (both tolerances, every step, the 20 s pendulum) diverges, and none stops at the iteration limit (each play's most iterations under 200); stopped steps are reported | At the converged tolerances SuperDex's rule for an update too small to matter stops steps at the finest steps (run 049's probes); the fifteenth registration's amendment ruled stops at the iteration limit, not those |
| **U2** Meta's scenes | The derived form, the accurate configuration (BDF2 at 1/16), the fresh commands: on each scene no step diverges, none stops at the iteration limit, and no more than 1 in 1,000 stop | The fourteenth registration's A7 with the fifteenth's amendment: the derived form acts on every articulated body under BDF2, and Meta's scenes are chains |
| **E1** safe when off | On the derived library, patch G's switch unset: (a) every file of the identity check's parts rotvec, flight, suites, joints, zero, bench and benchrec (no play of which sets patch G's switch; ten parts as the script counts them) byte-identical to its registered file (stock's, for the plays with no switch), but the plays run 040 found Linux makes differently from the laptop (a joint swing at 1/64 in joints and in zero; `ant` s4, c1, c06 and c03 in bench; `half_cheetah` y1 and y4 in benchrec), each byte-identical to the Linux file run 040 kept from library build 15 and, those with no switch, to the same play on the stock library on this machine; (b) the scenes here with no switch, under BDF2 and backward Euler at steps 1, 1/4, 1/16 and 1/64, byte-identical to the stock library's on this machine (48 of 48) | The five checks: with its switch unset a patch gives stock's output. (a) is the twenty-first registration's draft's E0 without part fg; (b) adds the BDF2 plays the derived form changes when switched on |
| **E2** backward Euler unchanged | On the derived library, patch G's switch set, under backward Euler: (a) every file of the identity part fg (44 files) byte-identical to its registered file, the four fg plays run 040 found Linux makes differently from the laptop to the Linux files run 040 kept from library build 15; (b) the scenes here under backward Euler with every switch set, both tolerances, steps 1 to 1/64, byte-identical to library build 15's (84 of 84); (c) Meta's three scenes under the recommended configuration at the shipped step on the fresh commands: each stream and its solver statistics, but the wall-clock time, byte-identical to library build 15's | The derived form is to change patch G under BDF2 only; every result under backward Euler, the recommended configuration's integrator, must stand |

That is 11 rules. O1 and O2 have one rule line for each halving ruled, as many as the readings decide, and each
halving not ruled is reported with its drift and its floor. Besides those, the rules have 42 lines: O0 6, the five
that count O1's and O2's halvings ruled with the solve converged, T1 to T4 10, U1 and U2 11, E1 and E2 10.

Reported, not deciding: every measured line; both forms' drifts at every step, tolerance and chain; the floors; the
swinging chain's energy drift at every step (its order is not a claim of the derived form, and T2 rules it at the
accurate configuration's step); the current form's readings beside every T rule; stopped steps; Meta's scenes under
both forms and both configurations; the time each part took; and the free spin and the pendulum at every step under
both forms, below.

## The coarse-step cost of the derived form, stated before the run

Known and derived before this registration (run 049, from its derivation and from a standalone reproduction of the
discretisation that matches SuperDex to four to six digits): on a single joint the derived form gives up about
(omega h)^2 of the joint's speed once, at the backward-Euler step that starts BDF2, where the current share gives up
less. It is a one-time loss, not a rate: it does not grow with the length of a play, and it falls four times a halving
of the step. On this arm's free spin it is about 14 in 10,000 at the shipped step and about 0.06 in 10,000 at 1/16.

It is reported, not ruled. The accurate configuration's registered bounds are at its own step, 1/16 (A2, V5 and V9),
and T3 and T4 carry them there; they were not set for this cost, which is far inside them. At the coarse steps the
record has ruled only the current form (I5b, I5c and V5, at the shipped step and 1/4), and run 049 found by how much
the derived form would fall outside four of those lines. A bound written now at those steps would be written knowing
on which side of it each form falls, so it would be a bound written to pass or to fail the derived form. The free spin
and the pendulum are played under both forms at every step and reported with (omega h)^2 beside them.

## Decisions fixed in advance

- **If every rule holds**, the derived form replaces the current one as patch G under BDF2:
  `patches/in_design/senua_inertia_transport_bdf2_derived.patch` becomes `patches/senua_inertia_transport.patch`, the
  current file moves to `patches/superseded/`, the four patch files are library build 16, and the open item "patch G
  under BDF2 on a chain" closes. Every play E1 and E2 compare is the same on library build 16 as on build 15; nothing
  else of the record is carried by this registration.
- **If any rule fails**, the current form stays as patch G under BDF2, the derived form stays in design, the open item
  stays open, and every rule that failed is recorded as measured with what it concerns.
- Nothing about backward Euler is decided here (the twenty-first registration's draft is to decide patch G there), nor
  about the accurate configuration as a whole, which this registration plays only as far as patch G acts.

## Known risks, stated before the run

- **O1 and O2 at the configuration's tolerances**: the solve's floor there may leave few or no halvings above 5 floors.
  Then those lines rule nothing, as written.
- **O1 with the solve converged**: chain B's second arm turns slowly against the first (-0.27 rad/s against 2.1), so
  its drifts may be the smallest of the three; a chain whose drift is already under 5 floors at 1/2 of the step would
  leave no halving ruled, and that line fails.
- **O1 at the shipped step**: the next term of the error is of the order of omega h against the leading term, which can
  move a fall from 4; the bound sits 29% below 4.
- **The tilted chain** is played by a registered rig for the first time (run 049 played it in its own probe rig). With
  `tilt2` unset the rig makes the registered chain files byte for byte (the identity part fg; the dry run, below).
- **U1**: at 1/32 and 1/64 with the solve converged many steps stop on the small-update rule; none at the iteration
  limit in run 049's probes.
- **E1 and E2 rest on the machine**, as the twenty-first's draft's E0 does: the twelve plays named for Linux are
  compared with the files run 040 kept there.
- **T4's 20 s swing**: at the configuration's tolerances the absolute tolerance can let a small gain through (10,001
  in run 032's probe 30); V9 held at 10,000 and 10,001.
- **The floor** comes from the derived library's backward-Euler plays; E2 (b) shows whether they are build 15's too.
- **The build**: the derived library is built for this run on this machine; its checksum is recorded, and nothing of
  it is compared across machines.

## The dry run, before registering

Every part was played once on the Linux machine, 15 October 2026, in a work folder of its own (the libraries of runs
039 to 049 read through links and not written), with throwaway numbers: run 049's probe chains, arm and tilt (none of
this registration's numbers), and commands of two episodes a scene from throwaway seeds. The play script and the
runner were copies of the ones here with only their blocks of numbers replaced. Nothing of it decides anything.

- **build** made the derived library in 7 minutes on 4 cores. Its sources are run 049's `g3` sources, file for file;
  the two libraries' checksums differ, each naming the folder it was built in. **rigs** built every rig, each loading
  the library it was meant to (`rigs.sha256`).
- The play parts ran in under a minute each, the identity check in 25 minutes beside other work on the machine. The
  runner wrote every line, none missing, and every one of the 66 rule lines held: 42 and 24 for the halvings ruled.
  A first reading, made before the identity check's part bench was played, failed E1's count of parts (9 of 10), as
  it should; the identity check was then played whole and read again.
- The readings reproduce run 049's probe readings to the whole part per million: the derived form's chain A with the
  solve converged read 2,654, 701, 176, 44 and 11 at steps 1 to 1/16, where run 049's probe read 2,656.8, 702.8,
  176.9, 44.2 and 11.0 from the same link states. The current form's momentum fell by about 2 a halving on all three
  chains; on the halvings ruled the derived form's fell by 3.8 to 5.0, and its energy by 4.0 to 4.7.
- The floor: under backward Euler with patch G the momentum read 1 to 2 parts per million with the solve converged
  (the floor stays 7), and 2 to 16 at the configuration's tolerances, but 48 and 134 on chain B at 1/32 and 1/64,
  where the solve's own error grows as the step shrinks. The floor rose there, and nothing was ruled at those steps.
- E1 and E2: the identity check 513 files, every one the same as registered but the twelve plays named for Linux,
  each the same as run 040's kept file and, the six with no switch, as stock on this machine; with `tilt2` unset the
  chain rig made all 9 chain files of part fg. The scenes with no switch 48 of 48 as stock, under backward Euler 84 of
  84 as library build 15, Meta's scenes under the recommended configuration 6 of 6.
- The coarse-step cost, on the throwaway arm at 4.2 rad/s ((omega h)^2 = 17.6 in 10,000 at the shipped step): the
  free spin kept 9,983 per 10,000 at the shipped step with the derived form and 9,993 with the current one, and
  9,999.94 and 9,999.98 at 1/16; the pendulum's first three swings at the shipped step read 9,982, 9,958 and 9,946
  against 9,985, 9,968 and 9,962, and from 1/4 the two read the same.

Nothing in the rules changed after it. Its text was corrected in one place: the count of the rule lines besides the
halvings, which the runner showed to be 42.

## What this does and does not say

If the rules hold, the derived form is recorded as replacing the current one as patch G under BDF2, on numbers no
earlier study used: a chain's angular momentum and energy second order, the accurate configuration's own bounds kept
at its step, the solver converging on Meta's scenes, and nothing changed with the switch off or under backward Euler on
every play compared. It says nothing about the coarse-step cost beyond reporting it; nothing about 32-bit (run 049:
below the shipped step, joint motion in 32-bit is limited by rounding even in stock); nothing about BDF3 or the DIRK
integrators, for which patch G's share is 0; nothing about chains of more than two links outside Meta's scenes, joint
limits or joint friction under BDF2; nothing about gradients; and nothing against a real robot.

If a rule fails, it is recorded as measured.

## As registered

Play script `tools/plays/play_22.sh` 2d7b28a1a13bcb99...; runner `measure/runners/sx_study22_run.sh` 557daf2d3c159c77...; measuring program
`measure/sx_contact.sx` as run 87e921cd4d2c03bf... (published 4779c518d77ee09e...). Patch files: `patches/senua_contact.patch` 05cfa0a011a0bcf6...,
`patches/senua_joint_limit.patch` 6faaa83202139795..., `patches/senua_rotation_axis.patch` 279c951076464943...,
`patches/senua_inertia_transport.patch` 9807f00f6b543135..., `patches/in_design/senua_inertia_transport_bdf2_derived.patch` c3e1442befd6dee9....
The libraries, built on the Linux machine: stock 75def9201a45216a... and library build 15 eee7cca1423650df... by
`validation/run_039_linux_replication/build.sh` 1a98c75155d7bed6...; the derived library by the play script's part build, its checksum written to the run's files.
Identity: `tools/play_identity.sh` bb1f52e8fdae023f.... Rigs: `tools/build_player.sh` b6daae9c807f3a3e... and the sources
`tools/sdx_chain.cpp` (with `tilt2`) fd52b61041ab80de..., `sdx_joint.cpp` 4cd5a6f600f139ca..., `sdx_player.cpp` e7328fcff80a0856..., `sdx_contact.cpp` 9ce3b6f33cdf705e...,
`sdx_pair.cpp` ad80834cecbaccdb... and `sdx_rotvec.cpp` cfffbfaf9fb72b25...; the built rigs' checksums are written by the play script to
`rigs.sha256`. Commands: `actions/22/ant.txt` e46f7675d092c9a8..., `cart_pole.txt` 93067e6d2e99a446..., `half_cheetah.txt` e55713de50ffb52f....
