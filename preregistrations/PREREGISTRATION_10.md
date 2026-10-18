# Tenth pre-registration: why the solver stops on ant, and what the joint limit patch adds

Registered 14 October 2026, after design probes on throwaway commands
([run 022](../validation/run_022_design_probes/), [run 024](../validation/run_024_design_probes/)). Registered before any
run of this registration existed.

## The question

Two items were left open about SuperDex's solver stopping without converging on `ant`, the legged benchmark scene:
why it stops on stock contact (about 1 step in 100 at the iteration limit, with residuals 10 to 700 times the
tolerance), and why it stops more often with the joint limit patch alone (the eighth study failed one rule on that).
The ninth study showed neither is the quaternion defect it found.

## The cause

Read from SuperDex's source at v1.0.0 (`contact_utils.h`, `mochi_stage_start_contact.cpp`). With `explicitNormals`
off, the shipped default, friction's normal force is computed from an estimate of the start-of-step distance made
from the current iterate. It moves from one Newton iteration to the next, and its derivative is left out of the
Newton matrix. With `explicitNormals` on, the start-of-step distance and normal are taken exactly from the start of
the step, and the residual is the true gradient of what the solver minimises. SuperDex's own header says as much: its
`ApplyImprovedConvergenceSettings` turns `explicitNormals` on for that reason.

## The right answers, and where they come from

- Newton's method converges when its matrix is the derivative of its residual, and can stall when part of the
  residual moves with the iterate while its derivative is left out (Nocedal and Wright, Numerical Optimization,
  2006; Dennis and Schnabel, 1996).
- Incremental potential contact keeps friction a potential by holding the normal force it is scaled by fixed over
  the step (Li et al., ACM Trans. Graph. 2020). Held truly fixed, its derivative is truly zero.
- A legged scene carries a small change of its motion into a different sequence of contact events (the third study
  measured it with a 1 N m nudge of one command), so two configurations' counts of stopped steps differ by chance as
  well as by cause.

## What the probes found

On four sets of 108 throwaway episodes stock stopped 204 to 234 steps of 21,600, the joint limit patch alone more
in every set (by 22 to 41), and stock with the first command of every episode nudged by 1 N m more or fewer (by -9 to
+17). Without the ground neither stopped a step. With `explicitNormals` stock and the patch both stopped 12, and
with `implicitNormalForceForDissipation` 1 and 0. Armijo line search alone left 216 of stock's 223.

So the patch does add stops, but of stock's kind: it changes how the legs meet the ground, and more of those
meetings land on the estimated normal force.

## The scenes, registered parameters

None of these numbers was used in the probes.

**Commands**: four sets of 108 `ant` episodes of 40 commands each, drawn in sequence from one state of the rig's
command generator at seed 10100 ([`actions/10/`](../actions/10/), `ant_set0.txt` to `ant_set3.txt`).

**Plays** ([`tools/plays/play_10.sh`](../tools/plays/play_10.sh)): `ant` at the shipped step, backward Euler, 200
iterations, with the solver's trace of every step, under: stock; stock with `explicitNormals`; stock with
`implicitNormalForceForDissipation`; stock with Armijo line search; stock with the nudge; the joint limit patch
alone; the patch with `explicitNormals`; stock and the patch with no ground; and, reported, the recommended
configuration and the recommended configuration with the friction correction.

## The rules, fixed in advance

Each of S1 to S8 must hold in each of the four sets.

| Rule | It holds when |
|---|---|
| **S0** safe when off | The patched library, with no switch set and under each registered configuration's switches, reproduces every file in all nine parts of [`tools/play_identity.sh`](../tools/play_identity.sh) byte for byte ([run 025](../validation/run_025_identity/)) |
| **S1** required | Stock stops at least 100 steps of 21,600 |
| **S2** the kind | Every stopped step of stock is at the iteration limit, and none has a residual under twice the absolute tolerance (2,000 millionths) |
| **S3** the cause | With `explicitNormals` on, stock stops no more than a fifth of the steps it stops without it |
| **S4** the same cause from the other side | With `implicitNormalForceForDissipation` on, stock stops no more than a tenth of them |
| **S5** the control | Armijo line search alone leaves at least half of them |
| **S6** the patch stops nothing by itself | With no ground neither stock nor the joint limit patch stops a step |
| **S7** with the ground, the same cause | With `explicitNormals` on, the joint limit patch stops no more than a fifth of the steps it stops without it |
| **S8** the patch's extra stops are of that kind | With `explicitNormals` on, the joint limit patch stops no more than stock with `explicitNormals` plus 21 (1 in 1,000) |

Reported, not deciding: every trace; the patch's excess over stock in each set against the nudge's; the recommended
configuration, and the recommended configuration with the friction correction, on the same sets; iterations.

## Known risks, stated before the run

- **S1 and S3 to S5 rest on probes of one set**, and the counts move from set to set.
- **S8 rests on one probe set** (12 against 12). On the registered sets the two counts with `explicitNormals` may
  differ by more than 21.

## What this does and does not say

If the rules hold, `ant`'s stopped steps are recorded as a consequence of SuperDex's default estimate of friction's
normal force, with SuperDex's own setting as the remedy, and the joint limit patch is recorded as adding stops only
of that kind, through the motion it changes, and none of its own. Both open items close. The recommended
configuration does not change here.

If a rule fails, it is recorded as measured.

## As registered

Patches: `patches/senua_contact.patch` sha256 1baa6dfec5400d35... (patches A, B and C, and F), `patches/senua_joint_limit.patch` 80f4c8c28ffacf51... (D), `patches/senua_rotation_axis.patch` 1ce1e2b97003929d... (E), `patches/senua_inertia_transport.patch` e39d71c153a3485e... (G). The four apply together to v1.0.0 and give the tree the library was built from (checked file by file). The patched library, build 12: ccb1aefeb3fc91f1.... The stock library: 5a213c925bc86b61.... Measuring program: `measure/sx_contact.sx` d18cbf6fc9dfd08e..., which is the ninth registration's program with lines added and none changed; with it the records of the fourth to the ninth registrations are re-made byte for byte. Safe when off: `tools/play_identity.sh` 220b28d98e06e1e8.... Runner: `measure/runners/sx_study10_run.sh` b6f92cf7ad12a2d2.... Plays: `tools/plays/play_10.sh` cb2c34b4b6774c26.... Commands: `actions/10/ant_all.txt` a4c00fe3380f7fdb... (seed 10100), split in order into the four sets.
