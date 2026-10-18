# What was built

What the Senua AI Robotics Core used to take SuperDex through its first deep dive: the rigs, the test
suites, seven patches, the measuring programs, and the scripts that play each study.

Back to the [documentation index](README.md).

## The builds of SuperDex

Everything is played on SuperDex Physics v1.0.0 at the commit in [`UPSTREAM_COMMIT`](../UPSTREAM_COMMIT), target
`mochi_physics`, with one worker thread.

| Build | What it is | Used by |
|---|---|---|
| Stock, 32-bit | SuperDex as shipped | Studies 1, 2 and 20 |
| Stock, 64-bit | Built with `-DMOCHI_USE_DOUBLE_PRECISION=ON` | Every study from 2 on but 17 and 18 (which gave the stock rigs library build 15) |
| Patched, 64-bit | The same with the patch files applied, each study on the library build of its time. With no switch set its output is byte-identical to stock on every play compared on the same build | Studies 5 and 7 to 22 |
| Library build 16, 64-bit | The four files in `patches/`: the contact, joint-limit and rotation files of build 15 and patch G's derived form under BDF2. Built on Linux by [`tools/plays/play_22.sh`](../tools/plays/play_22.sh)'s part build with run 039's settings (sha256 2dc292922b3fa4e5..., `validation/run_052_study22/rigs.sha256`; the checksum names the folder it was built in, and the same files built in another folder give another) | Study 22, as its derived form |
| Library build 15, 64-bit | The files of build 16 with `patches/superseded/senua_inertia_transport_registration22.patch` in place of patch G's (Linux: sha256 eee7cca1423650df..., by `validation/run_039_linux_replication/build.sh`) | Studies 16 to 22 and the identity check |
| Patched, 32-bit | The patched source in SuperDex's shipped 32-bit arithmetic (library build 15) | Studies 16 and 20 |
| Library build 14, 64-bit | The build before the second code review's corrections, from the patch files kept in `patches/superseded/` | Studies 16 and 19 |
| Library build 13, 64-bit | The fourteenth registration's build, from the `_registration14` patch files kept in `patches/superseded/` | Study 15's review part, and the plays of it that Study 18 and the identity check make again |

## The rigs

A rig is the adapter between Senua AI and the engine under test, and it is the only part of the tooling written for SuperDex. For
another engine the rigs are what change, and everything else carries over.

A rig is one C++ file against SuperDex's public API. It only plays a scene and writes what happened, as whole
numbers. The measuring is done elsewhere, by programs that never see SuperDex.

### `sdx_player`: Meta's benchmark scenes

[`tools/sdx_player.cpp`](../tools/sdx_player.cpp) plays `cart_pole`, `half_cheetah` or `ant` from SuperDex's own
`assets/benchmarks`, built the way SuperDex Lab's own environment builds it: the published prefab, the ground plane
where the environment adds one, the environment's simulation and control rates and its force scales. Two things
differ, both for determinism: every episode starts from the unperturbed pose, and one worker thread is used.

| It takes | Values |
|---|---|
| The time integrator | Backward Euler (shipped), BDF2, BDF3, three DIRK methods, two symplectic |
| The solver | Iteration limit (shipped: 4), tolerances, linear solver and its strategy, exact or fitted derivatives |
| The time step | K solver steps a shipped simulation step |
| Contact | Smoothing half-distance (shipped: 5 mm), penalty stiffness, friction coefficient and falloff speed, normal and friction damping, the ground left out |
| SuperDex's own evaluation switches | `implicitNormalForceForDissipation`, `explicitNormals`, `fadeFriction`, the friction smoothing, the line search |
| A nudge | A known, tiny change to the first command, to see how far the scene carries one |

It writes one joint's reading at every shipped simulation step, as a 14-bit encoder (16,384 counts a turn), and one
line with the solver's own status of every step: converged, stopped without converging, or diverged.

### `sdx_contact`: one cube and the ground

[`tools/sdx_contact.cpp`](../tools/sdx_contact.cpp) is the smallest contact scene SuperDex can be asked about: one
rigid cube and the static ground plane, under gravity. Nothing else is in the scene, so what happens at the ground
is contact and nothing but contact.

It takes the cube's mass and size, its drop height and sideways speed, the friction coefficient, a push or a lift
that starts at a chosen time, the contact settings, the integrator, and SuperDex's evaluation switches. It writes
one line a step: the height of the cube's lowest face in nanometres, its two speeds in micrometres a second, and the
ground's force on it, up and along, in millinewtons.

### `sdx_pair`: two cubes that both move

[`tools/sdx_pair.cpp`](../tools/sdx_pair.cpp) is the smallest scene with contact between two moving bodies: a large
cube A and a small cube B. In the stacked layout B rests on top of A, which rests on the ground. In the side layout
there is no ground and no gravity, and B moves into A's side. Rotation is held fixed on both, so what passes between
them is a force along the line of contact, friction across it, and nothing else.

It writes one file for each cube, in the same six columns as `sdx_contact`.

### `sdx_joint`: one arm on one joint

[`tools/sdx_joint.cpp`](../tools/sdx_joint.cpp) is the smallest jointed scene: a base welded to the world and one
arm on a revolute joint, with nothing touching it. It takes the arm's mass, size and length, its angle and speed at
release, gravity on or off, the joint's dry and viscous friction and its falloff speed, a torque that starts at a
chosen time, and joint limits with their stiffness and damping. It writes the joint's angle in micro-radians and its
speed in micro-radians a second at every step.

It can also switch on SuperDex's own experimental Newton-Euler inertia for the arm (`newtoneuler=1`), which the probes
of the joint-motion item use.

### `sdx_rotvec`: one function, one question

[`tools/sdx_rotvec.cpp`](../tools/sdx_rotvec.cpp) simulates nothing. A rotation by an angle about an axis has a
rotation vector: the angle times the axis. The program builds SuperDex's own quaternion from that vector, reads the
vector back through SuperDex's own function, and writes both. SuperDex uses that function wherever a rotation
becomes a vector: in its rigid rotation constraints, its articulated bodies and its time integration.

It was built for [Study 9](studies/09-rotation-axis.md).

### Rigs added for Studies 12 and 13

Three rigs and one mode of `sdx_contact` were added after Study 9. Each was probed first and then used in a registered
study.

| Rig | What it plays | Used in |
|---|---|---|
| [`tools/sdx_chain.cpp`](../tools/sdx_chain.cpp) | Two arms on two revolute joints with nothing touching them. With no gravity their kinetic energy and their angular momentum about the first joint must stay; with gravity their total energy must. With `tilt2` (added for the twenty-second registration) the second joint's axis tilts out of the plane and the chain moves in three dimensions; its file then holds the angular momentum about the first joint's axis, and only the planar part of the kinetic energy | [Study 12](studies/12-joint-motion.md); `tilt2` in [Study 22](studies/22-bdf2-chain.md) |
| `sdx_contact` with `floor=cloud` | The one-cube scene with the ground replaced by a held cloth sheet, which the cube meets through SuperDex's point-cloud collider. It lets the whole contact suite be replayed on the contact path that shells and rods use | [Study 13](studies/13-end-to-end.md) |
| [`tools/sdx_deform.cpp`](../tools/sdx_deform.cpp) | One rod, shell or soft body, built as a plain regular mesh: free fall, hanging from a clamp, a cantilever, and resting, sliding or held on the ground. Each case has a textbook answer, written in the file's header | [Study 13](studies/13-end-to-end.md) |
| [`tools/sdx_grip.cpp`](../tools/sdx_grip.cpp) | A parallel-jaw gripper holding a cube under gravity: a hand-built control, and the Franka FR3 hand shipped with SuperDex (Apache-2.0) with its arm welded. Hold, slide, grip force and symmetry each have a right answer | [Study 13](studies/13-end-to-end.md) |

For the five items left open after Study 13 the rigs took new settings, each off unless given: a mesh body's grid
cell for SuperDex's distance field (`sdfcell`, `sdfdiv`), the point-cloud collider's quadrature (`pcquad`), the
solver's two tolerances on every rig, every SuperDex integrator, and a cantilever held across its clamp
(`clampmid`). They were probed in [run 030](../validation/run_030_design_probes/).

The benchmark rig and the one-joint rig also take `newtoneuler=1`, which switches on SuperDex's own experimental
Newton-Euler inertia.

### Added for Studies 19 and 20

| Rig | What it plays | Used in |
|---|---|---|
| `sdx_contact` with `floor=soft` | The one-cube scene with the ground replaced by a soft block, which the cube meets through SuperDex's tetrahedral-map collider, the mapped collider its soft bodies carry; `softhold=bottom` holds only its bottom face so it deforms (`softh`, `softcell` size it) | [Study 19](studies/19-two-corrections.md) |
| `sdx_contact` with `exitscene` | The scene destroyed after `main` returns, by an object in static storage (`1`) or from a destructor function (`2`) | [Run 042](../validation/run_042_two_corrections/README.md) |
| [`tools/sdx_exit.cpp`](../tools/sdx_exit.cpp) | A program that registers its exit handler and then loads the library with `dlopen`, as a plugin or a Python extension does, and destroys its scene in that handler; it reaches the library by two looked-up names | [Study 19](studies/19-two-corrections.md) |

### The solver trace, on every rig

SuperDex gives every solver step a status. With the environment variable `SDX_TRACE` set to a file name, each of
the four simulating rigs writes one line a solver step: the step, the status (converged, stopped without converging,
or diverged), the iterations used, and the residual norm in millionths. Nothing else about a play changes when it
is set, and with it unset each rig reproduced its registered files byte for byte (14 files checked when it was added).

A stopped step is one of two kinds, and the trace tells them apart. Either the solver ran out of iterations, or its
update became too small to matter while the residual was still above the tolerance.

Two settings were added to the cube rigs for the same diagnosis: `rotk`, the stiffness of the constraint that holds
a cube's rotation fixed (SuperDex's default is 1e6), and `abstol`, the solver's absolute residual tolerance
(shipped: 1e-3).

## The test suites

Every test has a right answer from physics that does not depend on the time step, and every test but Study 9's rotations is played at more
than one step size. The shipped step is 10 ms, and the finest is 1/64 of it.

### The first contact suite: T01 to T10

One cube and the ground, at up to seven step sizes. Registered in Study 5.

| Test | What is played | The right answer |
|---|---|---|
| T01 | Released high enough never to reach the ground | Each halving of the step halves the difference |
| T02 | Sliding steadily on the ground | Friction force is the coefficient times the normal force |
| T03 | Resting on the ground | The ground carries the cube's weight |
| T04 | Dropped on the ground with no friction | The bounce is the same at every step |
| T05 | Dropped with sideways speed and friction | Over the impact, the horizontal momentum lost is the coefficient times the vertical momentum the ground gives |
| T06 | Set down, then pushed with 0.6 of what friction can hold | It does not move |
| T07 | Set down, then pushed with 1.2 of what friction can hold | It accelerates at push minus friction, over mass |
| T08 | The drop with sideways speed, each step against the next finer one | The differences fall at every step |
| T09 | Lifted off the ground, and on a fast rebound | The ground never pulls |
| T10 | As T05, over the impact and the 0.1 s after it | The same law, and friction is never more than it allows |

T01, T02 and T03 are controls. They check that the scene and the rig are what they are taken to be.

### The second contact suite: T11 to T17

A slide that ends, and two moving bodies. Registered in Study 7.

| Test | What is played | The right answer |
|---|---|---|
| T11 | A cube set sliding on the ground | It stops and stays stopped |
| T12 | The same cube dropped while it moves sideways | It lands, stops and stays stopped |
| T13 | The runs of T11 and T12 | It does not come back |
| T14 | A small cube on a large one, the large one pushed gently | The small cube rides |
| T15 | The large one pushed hard | Each cube accelerates at Coulomb's value |
| T16 | One cube into the side of the other, and one sliding on top of the other | The momentum of the two never changes |
| T17 | One cube resting on the other on the ground | Each contact carries its weight |

### The joint tests: JT1 to JT5

One arm on one joint. Registered in Study 6.

| Test | What is played | The right answer |
|---|---|---|
| JT1 | A free arm released spinning, no gravity | It keeps its speed |
| JT2 | A constant torque, no gravity | It gains torque times time over inertia |
| JT3 | A pendulum released level | It comes up level on the other side |
| JT4 | An arm held level by joint friction | It does not move |
| JT5 | A torque above the joint's friction limit | It accelerates at the torque less the friction, over inertia |

### The joint limit tests: LT1 to LT3

Registered in Study 8.

| Test | What is played | The right answer |
|---|---|---|
| LT1 | An arm resting on its limit under gravity | It sits where the limit's spring balances the torque |
| LT2 | An arm released inside its limit | It leaves at the speed a spring and damper that can only push would give it |
| LT3 | An arm resting on its limit, then lifted off by twice the torque that held it | It turns at least nine tenths of what it would with no limit |

### The rotation and free-flight tests: RV1 and FL1

Registered in Study 9.

| Test | What is played | The right answer |
|---|---|---|
| RV1 | Forty rotations, from 8e-4 down to 2e-14 rad about five axes, through SuperDex's own quaternion | The rotation vector is the angle times the axis, whatever the size of the angle |
| FL1 | Two free cubes that collide and part, read from the solver's own trace after they part | Free flight is solved in one iteration: no step stops, and the iterations are about as many as the steps |

## The seven patches

Four patch files against v1.0.0 (library build 16). They add 1,570 lines and remove none.

| Patch | File | Switch |
|---|---|---|
| A, friction on the full normal force | [`patches/senua_contact.patch`](../patches/senua_contact.patch) | `SUPERDEX_FRICTION_FULL_NORMAL=1` |
| B, contact damping that cannot pull | The same file | `SUPERDEX_DAMPING_UNILATERAL=1` |
| C, anchored Coulomb friction with a damped stick | The same file | `SUPERDEX_STICK_DISTANCE=0.0003` with `SUPERDEX_STICK_DAMPING=1` |
| D, a joint limit that cannot pull | [`patches/senua_joint_limit.patch`](../patches/senua_joint_limit.patch) | `SUPERDEX_LIMIT_UNILATERAL=1` |
| E, the axis of a small rotation | [`patches/senua_rotation_axis.patch`](../patches/senua_rotation_axis.patch) | `SUPERDEX_ROTATION_AXIS_EXACT=1` |
| F, friction on the normal force of the step being solved | [`patches/senua_contact.patch`](../patches/senua_contact.patch) | `SUPERDEX_FRICTION_STEP_NORMAL=1` |
| G, a link's inertial force projected at the start of the step under backward Euler, and its derived form under BDF2 | [`patches/senua_inertia_transport.patch`](../patches/senua_inertia_transport.patch) | `SUPERDEX_INERTIA_TRANSPORT=1`, with SuperDex's `EnableNewtonEulerInertia` |

What each one does and how it was tested is in [the patches](patches.md).

## The measuring programs

[`measure/`](../measure/) holds the programs that read what a rig wrote and decide each registered rule.

| Program | What it does |
|---|---|
| `sx_contact.sx` | Arithmetic against a right answer, for every test above. It reads the rigs' text files; of the Senua AI engine it uses only the helpers for reading a file and comparing strings |
| `instrument/sx_settings.sx`, `sx_settings2.sx`, `sx_settings3.sx` | What Senua AI's gap instrument was asked to do in Studies 1 to 3, and plain subtraction of the encoder streams |
| `instrument/sx_actions.sx` | Writes the seeded commands |
| The `.sh` scripts | Run the measures over a whole study and write its record |

They are written in Simplex, the language Senua AI is built in. The engine itself is proprietary and is not in this
repository, so its readings are published as records beside every file it read.

## The play scripts

| Script | Study | What it plays |
|---|---|---|
| [`tools/build_player.sh`](../tools/build_player.sh) | All | Builds a rig against a SuperDex build |
| `tools/plays/play_01.sh` | 1 | 45 benchmark sources |
| `tools/plays/play_02.sh` | 2 | 63 benchmark sources |
| `tools/plays/play_03.sh` | 3 | 84 benchmark sources, with the byte-for-byte repeat check |
| `tools/contact_all.sh` | 4 | The one-cube runs at every registered setting and step |
| `tools/plays/play_04.sh` | 4 | The benchmark with contact damping |
| `tools/contact_suite.sh` | 5, 7, 9, 11, 13 | The first contact suite under one configuration |
| `tools/plays/play_05.sh` | 5 | The suite under the nine configurations and the benchmark; written for the seventeenth registration from the fifth's record |
| `tools/contact_suite2.sh` | 7, 9, 11, 13 | The second contact suite under one configuration |
| `tools/joint_all.sh` | 6 | The one-arm runs |
| `tools/plays/play_07.sh` | 7 | Both suites under every configuration, the identity check, the benchmark |
| `tools/limit_all.sh` | 8 | The joint limit runs under stock, off and patched |
| `tools/plays/play_08.sh` | 8 | The identity check and the benchmark with patch D |
| `tools/plays/play_09.sh` | 9 | The rotations, two free cubes with the solver trace, both suites, the identity checks and the benchmark with patch E |
| `tools/plays/play_10.sh` | 10 | `ant`'s four command sets, each played eleven ways, with the solver's trace |
| `tools/plays/play_11.sh` | 11 | Both suites with patch F, and the benchmark with it |
| `tools/plays/play_12.sh` | 12 | The arm, the chain and the sixth study's tests with patch G and Newton-Euler inertia, and the benchmark |
| `tools/plays/play_13.sh` | 13 | Every earlier test under the final configuration, point clouds, deformable bodies, a gripper and the benchmark |
| `tools/plays/play_14.sh` | 14 | The five items' fixes and both configurations end to end |
| `tools/plays/play_15.sh` | 15 | The fixes on fresh numbers, the first code review's corrections, the long plays |
| `tools/plays/play_16.sh` | 16 | The first two studies in 32-bit, the second code review's corrections, the deformable bodies |
| `tools/plays/play_17.sh` | 17 | Studies 3 to 13 made again by their own scripts in a fresh clone, every file compared |
| `tools/plays/play_19.sh` | 19 | On Linux: the two corrections no rig had played, with stock, library build 14 and build 15, under valgrind for the exit |
| `tools/plays/play_20.sh` | 20 | On Linux: both suites on fresh cubes in 32-bit and 64-bit, stock, patched with no switch, and the final configuration |
| `tools/plays/play_21.sh` | 21 | On Linux: patches F and G and the recommended configuration under backward Euler on fresh numbers, every rule of the eleventh and twelfth registrations and the end-to-end rules of the thirteenth to fifteenth |
| `tools/plays/play_22.sh` | 22 | On Linux: the earlier and the derived form of patch G under BDF2 on fresh chains, an arm and a pendulum, and both checked unchanged under backward Euler and with the switch off |
| `tools/plays/play_23.sh` | 23 | On Linux: Study 21's protocol again on fresh numbers, on library build 16, the second suite's momentum read by `pairg` |
| `tools/play_identity.sh` | 10 on | Safe when off: the plays on its list made again on a new build and compared. Its header says it makes every registered play of the record; it makes the plays on its list, which hold a part of the record ([Study 16](studies/16-second-review.md) says which part), and it is kept unchanged as the sixteenth and eighteenth registrations cite it |

## What the runs left behind

| Folder | What is in it |
|---|---|
| `actions/01/` to `actions/14/` | The seeded commands played into every benchmark source, one folder for each registration that drew fresh ones |
| `streams/01/` to `streams/12/` | The encoder streams of Studies 1 to 12, one folder a registration; later studies keep theirs with their runs |
| `contact/`, `joints/`, `limits/` | The raw runs of the one-cube scene, the one-arm scene and the joint limits |
| `patches/validation/runs/`, `validation/run_017_counts/runs/` | The raw suite runs under every configuration |
| `rotation/` | The rotations and the two-cube runs of Study 9, with the solver's trace |
| `validation/run_001_counts/` to `run_053_order_probe/` | The record of every run; from Study 10 on, the study runs themselves (suites, joints, traces, deformable bodies) are kept there too |

The raw-run folders, `actions/`, `streams/` and the suite runs of Studies 5, 7 and 9 have a `SHA256SUMS` file. The study runs from run 026 on have none; a replay compares them file by file ([`tools/plays/play_17.sh`](../tools/plays/play_17.sh)).
