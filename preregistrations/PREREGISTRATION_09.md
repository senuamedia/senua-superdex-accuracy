# Ninth pre-registration: the rotation vector of a small rotation, and the solver steps it stops

Registered 14 October 2026, after design probes on throwaway cubes and throwaway commands
([validation/run_020_design_probes](../validation/run_020_design_probes/)). Registered before any run of this
registration existed.

## The question

Three items were left open about SuperDex's solver stopping without converging: after two free cubes separate
(seventh registration), at the finest steps with the corrected contact (seventh), and on `ant` with the joint limit
patch alone (eighth). The probes looked inside those steps with a trace of the solver's own status. The first two
turned out to be one thing, and it is a defect in a function of SuperDex's own, not in its solver and not in our
patches.

## The defect

`Quaternion::ToAxisAngle`, in `mochi_core/utils/quaternion_inl.h` at v1.0.0:

```cpp
auto axis =
    vectorMag > 1e-9_r ? (qPositiveNormalized.data / vectorMag) : Vec4r{1_r, 0_r, 0_r, 0_r};
```

The axis of a rotation is the quaternion's vector part over its length. When that length is 1e-9 or less, the
function returns the x axis instead. So the rotation vector of any rotation of 2e-9 rad or less points along x,
whatever its own axis is. SuperDex uses the function wherever a rotation becomes a vector: its rigid rotation
constraints, its articulated bodies, its time integration, sixteen call sites.

A rotation that small is not rare. A cube whose rotation is held fixed by SuperDex's pivot rotation constraint has
a rotation of exactly zero until something touches it, and of about a nano-radian afterwards. From then on the
constraint's error vector jumps between the true axis and x, by the constraint's stiffness times a few
nano-radians. At the default stiffness of 1e6 that is 1 to 4 thousandths, and the solver's absolute tolerance is 1
thousandth. The solver cannot get under it, runs to its iteration limit, and reports the step as stopped.

## The right answers

- A rotation by an angle about a unit axis has the rotation vector of that angle times that axis, whatever the size
  of the angle.
- A body in free flight under backward Euler is a linear problem. One Newton iteration solves it. So after two free
  cubes part, every step converges, and the iterations are about as many as the steps.
- Correcting the function must not change where anything goes by more than the size of the rotations it concerns.

## The correction (patch E)

[`patches/senua_rotation_axis.patch`](../patches/senua_rotation_axis.patch): 15 added lines, none removed, off unless
`SUPERDEX_ROTATION_AXIS_EXACT` is set. With it, the axis is the vector part over its own length whenever that
length is not zero.

## The scenes, registered parameters

None of these numbers was used in the probes, except where a rule compares with an earlier registration's files.

**Forty rotations** through SuperDex's quaternion (`tools/sdx_rotvec.cpp`): five axes, (0, -1, 0), (0, 0.6, -0.8),
(0.36, 0.48, 0.8), (-1, 2, 2) normalised, and x as the control, by eight angles: 8e-4, 3e-7, 6e-9, 2.2e-9, 1.8e-9,
4e-10, 5e-12 and 2e-14 rad. A rotation passes when the vector read back is within 1 millionth of the angle of the
right answer.

**Two free cubes** (`tools/sdx_pair.cpp`, layout side): A of 5 kg and half-size 0.2 m, B of 0.8 kg and half-size
0.05 m, B at 1.5 m/s into A's side, no gravity, no friction, 0.5 s, at steps 1, 1/4, 1/16 and 1/64 of 10 ms.
Measured from the step after the two part, which is one past the last step at which A feels a contact force.

**Both contact suites** on the seventh registration's cubes, so that the counts can be set beside that
registration's: stock (36 and 231 steps stopped) and the recommended configuration (551 and 728).

**The benchmark**: the fifth registration's commands for `half_cheetah` and `ant`, the third's for `cart_pole`.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **E0** safe when off | With the patched library and no switch set: the rotations file is byte-identical to stock's; the 8 flight files are; both suites (67 files) are byte-identical to the seventh registration's stock files; both suites under the recommended configuration (67 files) are byte-identical to the seventh registration's; the 40 registered one-joint files are reproduced; and the 38 registered benchmark streams are |
| **E1** required: the function | Stock passes all 20 rotations larger than 2e-9 rad. Of the 20 of 2e-9 rad or less it passes the 4 about x and fails the other 16, each by more than a tenth of its angle |
| **E2** correct: the function | With the correction all 40 pass |
| **E3** required: the solver | Stock, two free cubes at 1/64 of the step, after they part: at least 100 steps run to the iteration limit, the iterations are more than ten times the steps, and no stopped step has a residual of ten times the tolerance or more |
| **E4** correct: the solver | With the correction, after they part, at each of the four steps: no step stops, and the iterations are no more than twice the steps |
| **E5** the motion is the same | With the correction, at each of the four steps, each cube ends within 1 micrometre of where stock leaves it and within 10 micrometres a second of its speed |
| **E6** nothing else gets worse | With the correction, the first suite's code is the same as without it, under stock contact and under the recommended configuration, and so is the second suite's (tests T11 to T17, with the seventh registration's pass lines) |
| **E7** the solver on the suites | With the correction, the steps that stop in each suite are no more than a tenth of what they were, under stock contact (36 and 231) and under the recommended configuration (551 and 728) |
| **E8** the benchmark | With the correction alone, at the shipped step: no step diverges on any of the three scenes, and no more stop than stock's count plus 1 in 1,000 (stock: 2, 206 and 0 of 21,600) |

## A decision fixed in advance

The correction joins the recommended configuration if, with it added, `half_cheetah` and `ant` at steps 1 to 1/16
are both in order in 3 folds of 3 and no step diverges. Otherwise it is recorded as correct and optional.

Reported, not deciding: every measured line; how many benchmark streams are byte-identical with the correction to
the same configuration without it; the one-joint files with the correction switched on.

## Known risks, stated before the run

- **E3 depends on the cubes.** How long a nano-radian of rotation lasts depends on the cube's inertia and on the
  step. On the probe cubes the stall appeared at 1/64 of the step and not at 1/16. On the registered cubes it may
  be weaker, and E3 then fails.
- **E7 asks for nine stops in ten to go.** In the probes every one went. On the seventh registration's cubes some
  stops may be of another kind.
- **E5 is tight.** The probes ended within 12 nm. A cube that is still ringing at the end of a run could differ by
  more.
- **E0 is the one that has failed before.** SuperDex is compiled with `-ffp-contract=fast`, and this patch touches
  a header that most of the library includes. The probes found 14 files identical. The full sets have not been
  played.
- **The benchmark was byte-identical in the probes**, on 12 episodes. On 108 a rotation under 2e-9 rad may occur
  somewhere, and a stream then differs.

## What this does and does not say

If the rules hold, patch E is recorded as required, correct and safe, and the open items about the solver after two
bodies separate and at the finest steps with the corrected contact are closed: both were this defect. It says
nothing about `ant`'s stopped steps, which the probes found to be of another kind (residuals ten to seven hundred
times the tolerance), or about why `ant` stops more often with the joint limit patch alone. Those stay open.

If a rule fails, it is recorded as measured.

## As registered

Patches: `patches/senua_contact.patch` sha256 5cf3c66296270d0c..., `patches/senua_joint_limit.patch`
80f4c8c28ffacf51..., `patches/senua_rotation_axis.patch` 1ce1e2b97003929d.... The three apply together to v1.0.0 and
give the tree the library was built from. The patched library: 92bb9315d8a8a196.... The stock library:
5a213c925bc86b61.... `tools/sdx_rotvec64_stock` was built against the unpatched source before the header was
changed: 9b4586d3dd065833.... Measuring programs: `measure/sx_contact.sx` 2d93ab7cb329dd47... and
`measure/runners/sx_study9_run.sh` d217ad42829ff4c8.... Plays: `tools/plays/play_09.sh`.
