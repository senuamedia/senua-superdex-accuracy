# Study 9: the rotation vector of a small rotation, and the solver steps it stops

| | |
|---|---|
| Registration | Ninth: [PREREGISTRATION_09.md](../../preregistrations/PREREGISTRATION_09.md) |
| Question | Why does SuperDex's solver stop without converging on steps where nothing is happening, and is it SuperDex's doing or ours? |
| Outcome | Every rule held: all nine. A defect in SuperDex's quaternion, and patch E corrects it. It closes two open items, and it shows that the extra solver stops Study 7 measured under our patches are this defect, not the patches |
| Registered | 14 October 2026, committed and pushed before any run of this registration existed |
| Result | [Run 021](../../validation/run_021_rotation/README.md), 14 October 2026 |
| Runs | [020, design probes](../../validation/run_020_design_probes/), [021, the registered runs](../../validation/run_021_rotation/) |
| Data | [`rotation/`](../../rotation/) (the rotations, the two-cube runs and the solver's trace of every step), [`streams/09/`](../../streams/09/), [`validation/run_021_rotation/runs/`](../../validation/run_021_rotation/runs/) |
| Played by | [`tools/sdx_rotvec.cpp`](../../tools/sdx_rotvec.cpp), [`tools/sdx_pair.cpp`](../../tools/sdx_pair.cpp), [`tools/plays/play_09.sh`](../../tools/plays/play_09.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx) (`rotvec`, `trace`, `flight`, `ends`, `suite2`, `study9`), `sx_study9_run.sh` |

Previous: [Study 8](08-joint-limits.md). Next: [Study 10](10-ant-stops.md). All studies: [index](README.md).

## Why it was asked

Studies 7 and 8 left three items open, all about SuperDex's solver stopping without converging: after two free
cubes separate, at the finest steps with the corrected contact, and on `ant` with the joint limit patch alone. In
each case the motion was right, which made the stops easy to set aside. They were not set aside.

## Looking inside a stopped step

Each rig was given a trace of the solver's own status, iterations and residual of every step. SuperDex marks a step
"stopped" when it meets a stopping rule without converging, and in these runs there are two such rules: an
iteration limit, and an update too small to matter.

The trace showed that the cube scenes' stopped steps are all of one kind. Every one ran to the iteration limit with
a residual on the tolerance, not far from it: between 0.4 and 4 thousandths in the design probe ([run
020](../../validation/run_020_design_probes/)), where the tolerance is 1, and on the registered cubes ([run
021](../../validation/run_021_rotation/)) 1,442 to 3,999 millionths, just above the tolerance of 1,000. The solver was
not failing to solve a hard step. It was circling an answer it already had.

## The defect

`Quaternion::ToAxisAngle`, in SuperDex's `mochi_core/utils/quaternion_inl.h`:

```cpp
auto axis =
    vectorMag > 1e-9_r ? (qPositiveNormalized.data / vectorMag) : Vec4r{1_r, 0_r, 0_r, 0_r};
```

The axis of a rotation is the quaternion's vector part over its length. When that length is 1e-9 or less, the
function returns the x axis instead. So the rotation vector of any rotation of 2e-9 rad or less points along x,
whatever its own axis is. SuperDex uses the function wherever a rotation becomes a vector: its rigid rotation
constraints, its articulated bodies and its time integration, sixteen call sites.

A rotation that small is common. A body whose rotation is held by SuperDex's rotation constraint has a rotation of
exactly zero until something touches it, and of about a nano-radian afterwards. From then on the constraint's error
jumps between the true axis and x, by the constraint's stiffness times a few nano-radians. At the default
stiffness that is 1 to 4 thousandths, and the solver's tolerance is 1 thousandth. The solver cannot get under it,
runs to its iteration limit and reports the step as stopped.

## The correction: patch E

[`patches/senua_rotation_axis.patch`](../../patches/senua_rotation_axis.patch) adds 15 lines and removes none. With
`SUPERDEX_ROTATION_AXIS_EXACT` set, the axis is the vector part over its own length whenever that length is not
zero.

## What was played

- **Forty rotations** through SuperDex's own quaternion: five axes, one of them x as the control, by eight angles
  from 8e-4 down to 2e-14 rad. A rotation passes when the vector read back is within a millionth of its angle of
  the right answer.
- **Two free cubes** that collide and part, with no gravity and no friction, at steps 1, 1/4, 1/16 and 1/64 of
  10 ms. After they part both are in free flight, which backward Euler solves in one iteration.
- **Both contact suites** on Study 7's cubes, so the stop counts can be set beside that study's.
- **The benchmark**, with the correction alone and with it added to the recommended configuration.

None of the new numbers was used in the design probes.

## The rules fixed in advance

| Rule | It holds when |
|---|---|
| E0, safe when off | With the patched library and no switch: the rotations file, the 8 two-cube files, both suites (67 files) against Study 7's stock files, both suites under the recommended configuration (67) against Study 7's, the 40 one-joint files and the 38 benchmark streams are all byte-identical |
| E1, required: the function | Stock passes all 20 rotations larger than 2e-9 rad. Of the 20 of 2e-9 rad or less it passes the 4 about x and fails the other 16, each by more than a tenth of its angle |
| E2, correct: the function | With the correction all 40 pass |
| E3, required: the solver | Stock, two free cubes at 1/64 of the step, after they part: at least 100 steps run to the iteration limit, the iterations are more than ten times the steps, and no stopped step has a residual of ten times the tolerance or more |
| E4, correct: the solver | With the correction, after they part, at each of the four steps: no step stops and the iterations are no more than twice the steps |
| E5, the motion is the same | With the correction, at each of the four steps, each cube ends within 1 micrometre of where stock leaves it and within 10 micrometres a second of its speed |
| E6, nothing else gets worse | With the correction the first suite's code is the same as without it, under stock contact and under the recommended configuration, and so is the second suite's (T11 to T17, with Study 7's pass lines) |
| E7, the solver on the suites | With the correction the stopped steps of each suite are no more than a tenth of what they were, under stock contact (36 and 231) and under the recommended configuration (551 and 728) |
| E8, the benchmark | With the correction alone, at the shipped step: no step diverges on any of the three scenes, and no more stop than stock's count plus 1 in 1,000 (stock: 2, 206 and 0 of 21,600) |

A decision fixed in advance: the correction joins the recommended configuration if, with it added, `half_cheetah`
and `ant` at steps 1 to 1/16 are both in order in 3 folds of 3 and no step diverges. Otherwise it is recorded as
correct and optional.

Risks written down before the run: the stall depends on the cubes' inertia and might be weaker on new cubes; some
of the suites' stops might be of another kind; and this patch touches a header most of the library includes, which
is exactly the kind of change that broke byte-identity once before.

## The result

Every rule held.

### The function

| Rotations | Stock | Corrected |
|---|---|---|
| Larger than 2e-9 rad (20) | 20 pass | 20 pass |
| 2e-9 rad or less, about x (4) | 4 pass | 4 pass |
| 2e-9 rad or less, about another axis (16) | 0 pass. Every one comes back along x, off by 113% to 163% of its angle | 16 pass, exact to the millionth |

### The solver, on two free cubes after they part

Steps, steps that ran to the iteration limit, and iterations in all.

| | 10 ms | 1/4 | 1/16 | 1/64 |
|---|---|---|---|---|
| Stock | 45, 0, 132 | 190, 0, 822 | 768, 0, 5,331 | 3,079, 930, 203,419 |
| Corrected | 45, 0, 46 | 190, 0, 192 | 768, 0, 770 | 3,079, 0, 3,080 |

At 1/64 of the step stock runs 930 steps to its limit and spends 203,419 iterations on 3,079 steps of free flight.
Corrected, it spends 3,080. At the coarser steps stock stops on none, and still takes 3 to 7 times the iterations
it needs.

The cubes end in the same place to the nanometre at three of the steps and within 4 nm at the fourth, with the
same speeds.

### The solver, on both contact suites

Steps that stopped without converging.

| | Stock contact | Stock contact, corrected | Recommended configuration | Recommended, corrected |
|---|---|---|---|---|
| First suite, of 48,090 steps | 36 | 0 | 551 | 0 |
| Second suite, of 35,530 steps | 231 | 0 | 728 | 0 |

Every test passes or fails exactly as it did: 6 of 10 and 9 of 10 on the first suite, and the second suite's seven
tests unchanged.

### The benchmark

With the correction alone: 2, 206 and 0 steps stopped on `half_cheetah`, `ant` and `cart_pole`, exactly stock's
counts, and none diverged. Reported: all 13 benchmark streams played with the correction are byte-identical to the
same configuration without it. On the benchmark streams and the one-joint runs played with it, the correction changes nothing.

### Safe when off

The rotations file, 8 of 8 two-cube files, 67 of 67 suite files against stock, 67 of 67 under the recommended
configuration, 40 of 40 one-joint files and 38 of 38 benchmark streams: all byte-identical.

### The decision

With the correction added to the recommended configuration both scenes are in order in 3 folds of 3 and no step
diverged. Patch E joins [the recommended configuration](../recommended-configuration.md).

## What it means

- **It is a defect in SuperDex's own code**, independent of every patch here, and it costs solver work wherever a
  held rotation has been disturbed: up to 66 times the iterations on these cubes.
- **It closes two open items.** The solver stopping after two free bodies separate, and the solver stopping at the
  finest steps with the corrected contact, were both this.
- **The extra stops under our patches are this defect.** Study 7 measured that the corrected contact configuration
  stops the solver more often than stock on the one-cube suites. The cause is not the patches: the anchored
  friction holds a force on a cube whose rotation is held, which keeps that rotation in the range where the defect
  acts. With the defect corrected the count is 0.

## What it does not show

`ant`'s stopped steps on stock contact are another kind: residuals far above the tolerance (ten to seven hundred
times it in the design probe; about 4 to 10,850 times it on four sets of commands in Study 10's [run
026](../../validation/run_026_ant_stops/)), and the correction leaves all 206 exactly as they are. Why `ant` stops more often with the joint limit patch alone is
in [Study 10](10-ant-stops.md).

Limits: one function, two cubes, the suites' cubes and three benchmark scenes. Nothing against a real robot.
