# Patches in design

The builds in this folder are not registered, validated or recommended. They are the source the design probes were
run on, kept so that each probe's library build can be made again.

Builds 10 and 11 are diffs on top of the three patch files registered then, and build 13 on top of the four registered
then (library build 12's, in `../superseded/`). Each applies to SuperDex v1.0.0.
The record of the probes that used it says which library build it is. `senua_inertia_transport_bdf2_derived.patch`
(sha256 c3e1442befd6dee9...) is the derived form of patch G under BDF2, run 049's `g3` form, the form the
twenty-second registration names; by that registration's decision it is `../senua_inertia_transport.patch`, the same
bytes, in library build 16 ([Study 22](../../docs/studies/22-bdf2-chain.md)). It is kept here so the twenty-second
registration's link and its play script find it, and run 049 keeps a copy
(`../../validation/run_049_patch_g_review/patch/senua_inertia_transport_g3.patch`).

| File | Library build | What it adds | Probes |
|---|---|---|---|
| `build10_on_top_of_the_registered_patches.patch` | 10 (sha256 7b915d53ba70df9f...) | A candidate for friction on the normal force of the step being solved (`SUPERDEX_FRICTION_STEP_NORMAL`). Two changes to anchored friction: its anchors are keyed by the collider's feature as well as the sample, and an anchor is appended for the contacts SuperDex appends when its `explicitNormals` switch is on | [run 022](../../validation/run_022_design_probes/) |
| `build11_on_top_of_the_registered_patches.patch` | 11 (sha256 632c3c72b8874329...) | Build 10, and: four variants of the friction candidate, chosen by the value of `SUPERDEX_FRICTION_STEP_NORMAL`; a correction for the loss on joint motion (`SUPERDEX_INERTIA_TRANSPORT`, patch G in design), which projects the translational inertial force of each link of an articulated body with the Jacobian of the start of the step | [run 023](../../validation/run_023_design_probes/) |
| `build13_on_top_of_the_registered_patches.patch` | 13 (sha256 dbd8cf9b7553e3d1...) | Patch G's correction scaled by each integrator's share: 1 for backward Euler (its arithmetic unchanged), 1/3 for BDF2 (the pose of each step's start is kept, and the Jacobian held is checked against it), 0 for every other integrator. 59 lines added and 3 changed in patch G's own lines; against stock SuperDex it still only adds lines | [run 030](../../validation/run_030_design_probes/) |

Library build 12 was built from the four patch files registered then, in `../superseded/`
(`senua_contact_registration14.patch`, `senua_joint_limit_registration14.patch`, `senua_rotation_axis_registration14.patch`
and `senua_inertia_transport_registration12.patch`)
([PREREGISTRATION_11.md](../../preregistrations/PREREGISTRATION_11.md), [PREREGISTRATION_12.md](../../preregistrations/PREREGISTRATION_12.md)). Of the
variants probed in builds 10 and 11, patch F keeps the fourth (the step's normal force everywhere, with SuperDex's
fitted friction Hessian); the other three have left the source.
