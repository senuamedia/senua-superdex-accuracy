# Run 030: design probes for the five open items

14 October 2026. Throwaway cubes, arms, rods and commands, except where a line says it replays a registered play to
find a cause. Nothing here decides anything, and nothing here is registered. Libraries: build 12 (sha256
ccb1aefeb3fc91f1..., the registered build) and build 13 (sha256 dbd8cf9b7553e3d1..., below).

The thirteenth registration left five items open in [`docs/open-items.md`](../../docs/open-items.md). Each is
probed here for its cause and for a fix. The final configuration below is the thirteenth registration's: patches A
to G with SuperDex's Newton-Euler inertia, contact damping 5 and a friction falloff of 0.03 m/s, backward Euler,
64-bit, iteration limit 200.

## 1. The light cube that slipped short: SuperDex's grid distance field

**The cause.** On the eleventh registration's pair (a block of 3 kg and half-size 0.25 m, a cube of 0.5 kg and
half-size 0.03 m), the cube slips at Coulomb's acceleration until 0.835 s and then sinks into the block, and its
friction falls ([run 027](../run_027_friction/)'s trace at 1/16 of the step). It is not at the block's edge then:
its rear face is 76 mm from it. Each cube collides as a triangle mesh through SuperDex's grid distance field, whose
cell SuperDex sizes from the mesh: a quarter of the mean edge, with at least 6 cells a side. A cube of 12 triangles
gets 6 cells, which for this block is 85 mm, with grid nodes at x = -0.255, -0.170, ... m. Inside the last cell
before an edge, interpolation rounds the edge. The cube's rear face crosses x = -0.170 m at 0.835 s.

**The fix.** SuperDex's own `GridSdfParams` with the cell given explicitly. The pair rig's `sdfcell` sets it for
both cubes; `collider=box` uses SuperDex's box collider instead (`probe_17_slip_grid.txt`, final configuration):

| Grid cell | B at the shipped step, mm/s2 | B at 1/16 | A at the shipped step | A at 1/16 |
|---|---|---|---|---|
| Right answer | 4,410 | 4,410 | 6,982 | 6,982 |
| SuperDex's own (85 mm) | 4,224 | 4,219 | 7,013 | 7,014 |
| 40 mm | 4,387 | 4,368 | 6,986 | 6,989 |
| 20 mm | 4,412 | 4,411 | 6,982 | 6,982 |
| 10 mm | 4,412 | 4,411 | 6,982 | 6,982 |
| 5 mm | 4,412 | 4,411 | 6,982 | 6,982 |
| Box collider | 4,412 | 4,411 | 6,982 | 6,982 |

With SuperDex's own grid the readings are the registered ones to the last digit. The seventh registration's pair
passed because its block is larger: its cube never reached the last cell. Both rigs now also take `sdfdiv`, the
cell as a share of each cube's own side, so that one setting does not coarsen the small cube's field. On a throwaway
pair at 1/32 of each side (`probe_17b_cell_share.txt`) the block read 7,836 and 7,829 against 7,831 and the cube
4,875 and 4,906 against 4,900, where SuperDex's own grid read 4,081 and 4,195 (that pair's cube passes the block's
edge just before 0.9 s).

## 2. Patch G's tolerance: the solver stops on its relative tolerance

The twelfth registration's arm released at 3.5 rad/s (the play that failed G2) with the solver's tolerances varied
(`probe_18_tolerance.txt`, final speed per 3,500,000, and iterations a step):

| Absolute, relative | Shipped step | 1/4 | 1/16 | 1/64 |
|---|---|---|---|---|
| 1e-3, 1e-6 (shipped) | 3,499,956 | 3,499,999 | 3,495,542 (1 iteration) | 3,498,884 (1) |
| 1e-4, 1e-5, 1e-6 and 1e-9; 1e-6 | the same | the same | the same | the same |
| 1e-3, 1e-8 to 1e-12 | 3,499,956 | 3,499,999 | 3,500,000 (2) | 3,498,884 (1) |
| 1e-4, 1e-7 | 3,499,956 | 3,499,999 | 3,500,000 (2) | 3,498,884 (1) |
| 1e-4, 1e-8 | 3,499,956 (2) | 3,499,999 (2) | 3,500,000 (2) | 3,500,000 (2) |
| 1e-5, 1e-8 | 3,500,000 (3) | 3,499,999 (2) | 3,500,000 (2) | 3,500,000 (2) |
| 1e-9, 1e-9 | 3,500,000 (3) | 3,499,999 (2) | 3,500,000 (2) | 3,500,000 (2) |
| 1e-9, 1e-12 | 3,500,000 (4) | 3,500,000 (3) | 3,500,000 (3) | 3,500,000 (2) |

The solver converges when either test is met, so both must be tightened: the relative one to 1e-8 for the fine
steps, the absolute one to 1e-4 for the finest. The twelfth registration's free chain at absolute 1e-4 and relative
1e-8 keeps its energy within 202 parts per million at every step and its angular momentum within 8 (as shipped: 3,630
and 1,430 at 1/16). Tighter still costs Meta's scenes more than it gains (section 6): at 1e-9 and 1e-9
`half_cheetah` stalls 70 steps of 21,600, most of them already inside the shipped tolerance, so 1e-4 and 1e-8 it is.

## 3. The point-cloud floor: the cube's grid, and damping at its edges

**What it is not.** On this floor the sheet's own nodes are the contact samples, and they read the cube through the
cube's grid distance field. The collider range and its quadrature (`pcradius`, the new `pcquad`) belong to the
other direction and change nothing here, to the last digit (`probe_22_point_cloud.txt`).

**What it is.** A throwaway cube (1.2 kg, half-size 0.04 m, friction 0.4), final configuration, shipped step; the
slip is read against the same slip on the plane, which meets Coulomb's law:

| Floor | Friction over the impact (law 4,000) | Sliding friction over normal (law 4,000) | Slip, share of the plane's speed |
|---|---|---|---|
| Plane | 4,000 | 4,000 | 100% |
| Sheet, node every 10 mm, SuperDex's grid on the cube | 4,202 | 4,138 | 85% |
| The same, node every 5 mm and range 5 mm | 4,145 | 4,132 | 87% |
| The cube's grid cell 2.5 mm (1/32 of its side) | 4,018 | 4,037 | 97% |
| The same, contact damping 0 | 4,017 | 3,997 | 101% |
| The cube's grid 2.5 mm, smoothing 1 mm | 4,106 | 4,011 | 99% |
| The cube's grid 1.25 mm, smoothing 1 mm | 4,002 | 3,999 | 98% |
| The cube's grid 5 mm, smoothing 1 mm | 3,987 | 4,023 | 97% |

Two causes. The first is item 1's: the cube's default grid rounds its edges, and the sheet reads them. The second:
sheet nodes that the cube's leading edge passes over, within SuperDex's contact smoothing distance (5 mm a side as
shipped), close on the edge and are damped, while trailing nodes separate and patch B lets them pull nothing back.
With damping off, the floor matches the plane. SuperDex's documentation expects the smoothing to be small against
the collider; at 1 mm it is. A pair takes its smoothing from the collider, here the cube, so it can be set on a
body that meets a point cloud without changing its contact with a plane. The friction over a one-step impact on a
discrete floor was noted at the time to vary by up to 3% with where the cube lands among the nodes, but no kept play
moves the landing point (`probe_22_point_cloud.txt` varies the spacing, the range, the cube's grid, damping and
smoothing), so that figure cannot be checked from the record.

## 4. The cantilever: the clamp sat half an element inside

The rig held a rod's first two nodes from x = 0, which makes the rod stiff to the middle of its first element, so
the length that bends was short by half an element. With `clampmid=1` the held element sits across the clamp, its
middle at x = 0, and the bending length is the rod's (`probe_21_cantilever.txt`, a throwaway rod, stock, tip drop
against w L^4 / (8 EI) = 3,828,125 nm):

| Elements | Held from x = 0 | Held across the clamp |
|---|---|---|
| 16 | 3,367,631 (12.0% short) | 3,819,689 (0.22% short) |
| 32 | 3,596,491 (6.1%) | 3,825,737 (0.062%) |
| 64 | 3,713,421 (3.0%) | 3,827,200 (0.024%) |
| 128 | 3,768,073 (1.6%) | 3,827,561 (0.015%) |
| 256 | 3,797,818 (0.79%) | 3,827,651 (0.012%) |

Held from x = 0 the error halves with each halving of the element: half an element of length. Held across the clamp
it falls fast (3.5 times from 16 to 32 elements) and then levels off at 0.012% short. This probe does not show what
leaves that 0.012%; the probes after [run 032](../run_032_open_items/) found the cause in SuperDex's shipped solver
tolerance on a static equilibrium ([open items](../../docs/open-items.md)). SuperDex's rod was right; the rig's clamp
was not.

## 5. The damping of a swing a force drives: patch G's share by integrator

**SuperDex's other integrators are not the remedy.** The sixth registration's arm as a
pendulum and as a free spin, and the twelfth's two-link chain (`probe_19_integrators.txt`, `probe_19c_chain.txt`):

- Without patch G every integrator loses energy at the shipped step, the symplectic ones too: implicit midpoint
  loses half of the swinging chain's energy in 2 s. The projection defect patch G corrects is in all of them.
- With patch G as registered, only backward Euler is right. Patch G projects with the Jacobian of the stage's start,
  which is right for backward Euler's stencil and not for the others: DIRK33 and implicit midpoint gain energy with
  it, the two-stage schemes drift, and BDF2's swing is untouched (its stage starts from a blend of two earlier steps,
  so no Jacobian of that start is ever held); its free spin moves a little (2,914,395 against 2,912,553 without
  patch G).

**The share, derived.** For a body turning freely about a joint, each scheme's stage residual is a centripetal force
whose direction is radial at one angle; projecting with the Jacobian there keeps the speed. Worked through
SuperDex's stage formulation and checked numerically (the residual's angle over the step, at 0.01 to 0.16 rad):
backward Euler at the stage's start; BDF2 at two thirds of the way from the step's start to the current pose
(0.66664 at 0.01 rad); implicit midpoint at a quarter of the step. The numerical check's output was not kept, so
0.66664 is as noted at the time and cannot be checked from the record. Build 13 scales patch G's correction by the
share this gives: 1 for backward Euler (its arithmetic unchanged), 1/3 for BDF2 (the step start's Jacobian, captured
before each step, weighs 1/3 and the current one 2/3), and 0 for every other integrator. Implicit midpoint's share
(1/2) was tried in design: it kept the swing but left the free spin short, and that probe's numbers were not kept, so it is left out, not tuned. With patch G at its full form implicit midpoint gains on every swing (10,207 to 11,154 per 10,000, `probe_19_integrators.txt`).

| The sixth registration's arm | Backward Euler + G | BDF2 + G, build 13 |
|---|---|---|
| Pendulum, swings per 10,000, shipped step | 9,627, 8,912, 8,250 | 9,989, 9,974, 9,965 |
| The same at 1/4 | 9,904, 9,715, 9,529 | 9,999, 9,999, 10,000 |
| Free spin at 3 rad/s after 1 s, per 3,000,000 | 2,999,980 | 2,998,962 |

| The twelfth registration's chain | Backward Euler + G | BDF2 + G, build 13 |
|---|---|---|
| Swinging: energy lost over 2 s, shipped step | 36.1% | 18.0% |
| The same at 1/4 | 10.6% | 0.56% |
| The same at 1/16 | 2.5% | -0.15% (gained) |
| Free: angular momentum drift, shipped step | 0.006% | 2.6% |

BDF2's small loss on the free spin is its first step, which has no step start to project with; it falls as the
square of the step. With build 13 backward Euler's lines are those of build 12, line for line.

**The trade at contact** (`probe_20_suites_by_integrator.txt`, both contact suites on the seventh registration's
cubes, final configuration): backward Euler passes 10 of 10 and 7 of 7. Under BDF2, DIRK22, DIRK33 and implicit
midpoint the suites fail T01 (written for a first-order integrator: BDF2's gaps read 2,518, 2,481, 2,647, 2,222 and 0 per 10,000 of the one before, its
own second order), and T04: a dropped cube rebounds 8.7% to 14.5% of its drop at the two coarsest steps under BDF2
(119% under implicit midpoint), against 0.3% to 0.8% once the impact is resolved (1/16 and finer, every integrator:
30 to 83 per 10,000). Under BDF2 and implicit midpoint the first suite also fails T08 (the refinement chain does not
fall at every step), and under BDF2, DIRK22 and implicit midpoint the second suite fails T13; DIRK33 passes the
second suite. SuperDex's own `implicitNormalForceForDissipation` does not remove the rebound (9.8% and 10.1%), and
with it BDF2 still fails T08 and T13. The stiff contact is not resolved at 10 ms, and backward Euler's own damping is
what makes its impacts nearly dead. So no one integrator is right at the shipped step on both a fast swing and an
impact. Under BDF2 with patch G both converge by 1/16.

## 6. Meta's benchmark scenes: what the tolerance and BDF2 cost

On earlier commands (the fifth registration's for `half_cheetah` and `ant`), 108 episodes a scene, the final
configuration with each tolerance and integrator (`probe_23_benchmark.txt`):

| | `half_cheetah` steps stopped | its iterations a step | `ant` steps stopped | its iterations a step |
|---|---|---|---|---|
| Backward Euler, shipped tolerances (1e-3, 1e-6) | 2 of 21,600 | 11.9 | 2 of 21,600 | 7.3 |
| Backward Euler, 1e-4 and 1e-8 | 5 | 14.8 | 2 | 8.4 |
| Backward Euler, 1e-5 and 1e-8 | 15 | 17.6 | 2 | 9.5 |
| Backward Euler, 1e-9 and 1e-9 | 70 | 25.1 | 3 | 10.9 |
| BDF2 with patch G, shipped step, shipped tolerances | 4 | 8.1 | 0 | 4.7 |
| BDF2 with patch G, 1/16 of the step, shipped tolerances | 0 of 345,600 | 3.5 | 0 of 345,600 | 2.3 |
| BDF2 with patch G, 1/16 of the step, 1e-4 and 1e-8 | 0 of 345,600 | 4.1 | 0 of 345,600 | 3.2 |

None of these plays diverged a step. At 1e-9 most of `half_cheetah`'s 70 stops were already inside the shipped
tolerance when they reached the iteration limit (58 of the 70 with a residual under 1e-3 in the solver's trace): the solve cannot reach 1e-9 on its
contact-rich steps. At 1e-4 and 1e-8 three more steps stop than as shipped, each above 1e-3. BDF2 at 1/16 of the
step at 1e-4 and 1e-8 took 437 s for `half_cheetah` and 103 s for `ant`, 3.3 and 3.5 times backward Euler at the
shipped step and shipped tolerances, for 16 times the steps; at the shipped tolerances it took 409 s and 214 s, 3.1
and 7.3 times (wall-clock times, which include any pause of the host guard). `cart_pole`, played under three of
these configurations (backward Euler at the shipped tolerances and at 1e-9 and 1e-9, and BDF2 at the shipped step),
stops no step.

## Changes to the public rigs

All are additions; with none of the new settings given, a rig's output is what it was. The identity run that follows
these probes ([run 031](../run_031_identity/)) shows it for the plays on its list; that list holds no play of
`sdx_deform` or `sdx_grip`, so for those two rigs it is not shown there.

| Rig | Added |
|---|---|
| `sdx_pair` | `sdfcell`, `sdfdiv` (each cube's grid cell), `reltol`, and every SuperDex integrator |
| `sdx_contact` | `sdfcell`, `sdfdiv` (the cube's grid cell), `pcquad` (the sheet's collider quadrature), `reltol`, every integrator |
| `sdx_joint` | `abstol`, `reltol`, every integrator |
| `sdx_chain` | every integrator |
| `sdx_deform` | `clampmid` (the cantilever's held element across the clamp), every integrator |
| `sdx_grip` | `reltol` |
| `play_identity.sh` | a part `fg`: the registered plays with patch G (44 files) |

Library build 13 is build 12 with the change to patch G above, in
[`patches/in_design/build13_on_top_of_the_registered_patches.patch`](../../patches/in_design/build13_on_top_of_the_registered_patches.patch)
(59 lines added and 3 changed on top of the registered files; against stock SuperDex it still only adds lines).

## Files

| File | What |
|---|---|
| `probe_17_slip_grid.txt` | Item 1 |
| `probe_18_tolerance.txt` | Item 2 |
| `probe_19_integrators.txt`, `probe_19c_chain.txt` | Item 5, joint motion |
| `probe_20_suites_by_integrator.txt` | Item 5, contact |
| `probe_21_cantilever.txt` | Item 4 |
| `probe_22_point_cloud.txt` | Item 3 |
| `probe_23_benchmark.txt` | Items 2 and 5 on Meta's scenes: every play's statistics, mean iterations, and stopped steps by residual |
| `probe_17b_cell_share.txt` | Item 1, the cell as a share of each body's side |
