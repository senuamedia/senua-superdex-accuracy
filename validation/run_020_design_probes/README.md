# Run 020: design probes for the ninth registration

14 October 2026. Throwaway cubes and throwaway commands. Nothing here decides anything. Probe cubes: two cubes, A of
3 kg and half-size 0.25 m, B of 0.5 kg and half-size 0.04 m, B at 1.0 m/s into A's side; one cube of 1 kg and
half-size 0.05 m with friction 0.4, set sliding at 1.2 m/s; the suites' own default cubes. Benchmark probes use the
12-episode command files of run 009's probes, which were not kept.

## What the probes were for

Three items were open about SuperDex's solver stopping without converging: after two free cubes separate, at the
finest steps with the corrected contact, and on `ant` with the joint limit patch alone. To look inside those steps,
each rig was given an optional trace of the solver's own status, iterations and residual of every step
(`SDX_TRACE`). With it unset each rebuilt rig reproduces its registered files byte for byte (14 files checked, stock
and patched; the output of that check was not kept, so it is as noted at the time and cannot be checked from the
record).

## What a stopped step is

SuperDex's nonlinear solver marks a step `stopped` when it meets a stopping rule without converging. In these runs
there are two such rules: the iteration limit (200 here), and an update smaller than ten machine epsilons of the
state. A step converges on an absolute residual of 1e-3 or a relative one of 1e-6 (`newton_solver.cpp`).

## What they showed

**The stopped steps of the cube scenes are all of one kind.** Every one ran to the iteration limit, with a final
residual between 0.4 and 4 thousandths: on the tolerance, not far from it. Two free cubes at 1/64 of the step: after
they part, 2,110 of 3,028 steps ran to 200 iterations, with residuals of 1,071 to 3,998 millionths, and the run took
427,868 iterations where about 3,000 would do. With no collision at all the residual is exactly 0 at every step
(`probe_9a.txt`).

**It comes from the constraint that holds the rotation fixed, and it scales with that constraint's stiffness.** The
cube rigs hold rotation fixed with SuperDex's pivot rotation constraint, at its default stiffness of 1e6. At a
stiffness of 1e4 or 1e5 no step stops. At 1e6, 2,110 stop, with residuals up to 3,998 millionths. At 1e7, 1,196
stop, with residuals up to 29,557. So the stalled residual is the stiffness times about 3 to 4 nano-radians. Raising
the solver's absolute tolerance to 1e-2 leaves 2 stopped steps and 13,194 iterations, with the same final positions
(`probe_9b.txt`).

**The cause is one function.** `Quaternion::ToAxisAngle` (`mochi_core/utils/quaternion_inl.h`) takes the axis of a
rotation as the quaternion's vector part over its length only when that length is above 1e-9. Otherwise it returns
the x axis. So the rotation vector of any rotation of 2e-9 rad or less points along x, whatever its own axis is.
Asked directly (`probe_rotvec.txt`): rotations of 2.0e-9 rad and smaller about y, about z or about a skew axis come
back along x, an error of 141% of the angle about y or z. At 2.5e-9 rad and larger they come back exact. A
collision leaves a held cube with a rotation of about a nano-radian, and from then on the constraint's error vector
jumps between the true axis and x.

SuperDex uses the function in its rigid rotation constraints (four places in `constraints.cpp`), its articulated
bodies, its time integration and elsewhere: sixteen call sites.

**The correction.** Fifteen added lines in `quaternion_inl.h`, off unless `SUPERDEX_ROTATION_AXIS_EXACT` is set: the
axis is the vector part over its own length whenever that length is not zero. With the library rebuilt and no
switch set, the probe files are byte-identical to stock.

**What the correction does (`probe_9c_*.txt`, `probe_9d.txt`).**

| Probe | Without the correction | With it |
|---|---|---|
| The function, rotations of 2e-9 rad or less not about x | Along x | Exact, distance 0 |
| Two free cubes after they part, 1/64 of the step | 2,110 of 3,028 steps stopped; 427,868 iterations | 0 stopped; 3,029 iterations |
| The same at 1/16 of the step | 0 stopped; 6,179 iterations | 0 stopped; 756 iterations |
| One cube sliding to a stop at 1/64, stock contact | 14 stopped; 37,420 iterations | 0 stopped; 13,637 iterations |
| The same, recommended configuration | 145 stopped; 33,514 iterations | 0 stopped; 3,741 iterations |
| A landing at 1/64, recommended configuration | 175 stopped; 41,019 iterations | 0 stopped; 4,185 iterations |
| First suite, stock contact, steps stopped of 48,090 | 15 | 0 |
| First suite, recommended configuration | 212 | 0 |
| Second suite, stock contact, steps stopped of 35,530 | 424 | 0 |
| Second suite, recommended configuration | 799 | 0 |
| First suite, tests passed, stock and recommended | 6 and 9 of 10 | 6 and 9 of 10 |

The cubes end in the same place: the two free cubes within 12 nm, with the same speeds. Over both suites the last
line of a file differs in 13 to 15 of 67 files, by under a micrometre.

**On the benchmark scenes and on one joint it changes nothing that was measured.** `ant`, `half_cheetah` and
`cart_pole` on throwaway commands: with the correction alone every stream is byte-identical to stock. With it added
to the joint limit patch, and with it added to the recommended configuration, the solver's counts and iterations
are the same as without it; `probe_9c_bench.txt` compares those streams only with stock, so their byte identity with
the same configuration without the correction is not shown. Ten one-joint runs on a throwaway arm, one of them
spinning at a nano-radian a second: byte-identical, by a check whose output was not kept, so it cannot be checked
from the record.

**`ant`'s stopped steps are a different kind.** On 12 throwaway episodes, stock: 21 stopped steps, all at the
iteration limit, with residuals from 9 to 738 thousandths, ten to seven hundred times the tolerance. The correction
leaves them as they are.

**`ant` with the joint limit patch alone (`probe_10a.txt`).** Without the ground, 0 steps stop with the patch, as
with stock, and no step needs more than 3 iterations, while the patch changes 3,395 of 4,800 bytes of the stream:
the limits are met, and the patch never stops the solver. With the ground, 24 steps stop against stock's 21, and
only 3 of them are steps at which stock also stops. The two runs part within the first 12 to 40 readings of every
episode and are different trajectories after that. This is for a later registration.

## Files

| | |
|---|---|
| `probe_9a.txt` | The collision by step size, by collider, with no collision, and the steps around the collision |
| `probe_9b.txt` | The stiffness of the rotation constraint and the solver's tolerance |
| `probe_rotvec.txt` | SuperDex's quaternion asked for the rotation vector of rotations from 1e-3 to 1e-15 rad |
| `probe_9c_rotvec.txt`, `probe_9c_pair.txt`, `probe_9c_cube.txt`, `probe_9c_bench.txt` | The patched library with and without the correction |
| `probe_9d.txt` | Both contact suites with and without the correction |
| `probe_10a.txt` | `ant` with the joint limit patch alone, with and without the ground |
