# Run 023: design probes on library build 11

14 October 2026. Throwaway arms, throwaway cubes and throwaway commands. Nothing here decides anything, and nothing
here is registered.

Library: build 11 (sha256 632c3c72b8874329...), which is the registered patches plus the source in
[`../../patches/in_design/build11_on_top_of_the_registered_patches.patch`](../../patches/in_design/). Against stock
SuperDex that source only adds lines.

Throwaway inputs: a one-joint arm of 1.5 kg and half-size 0.06 m; two arms of 1.5 kg and 0.8 kg on two joints; the
contact suites' default cubes; for `ant`, 108 episodes drawn from seed 9100 and 12 episodes from run 009's probe
commands. None is a registered parameter.

## 1. With no new switch set the build changes nothing

`probe_13_identity.txt`:

| Check | Result |
|---|---|
| 14 registered files, no switch set | 14 of 14 byte-identical |
| Both contact suites under the recommended configuration, against build 9 | 67 of 67 byte-identical |
| `ant`, 108 episodes, stock and the recommended configuration, against build 10 | both streams byte-identical |

## 2. The integrator's loss on joint motion: a correction

Run 022 found the law: SuperDex gives every link a straight-line inertial target and projects it onto the joints at
the current position, which loses the square of the angle turned in a step.

The candidate correction (`SUPERDEX_INERTIA_TRANSPORT`, patch G in design) projects the translational inertial
force of each link with the Jacobian of the start of the step. That is the discrete null space method of Betsch and
Leyendecker for a constrained mechanical system: the discrete equations of motion are projected at the node they
are written at. The rotation of each link about its own centre is left to SuperDex's own experimental Newton-Euler
inertia (`EnableNewtonEulerInertia`), which the rigs can now switch on (`newtoneuler=1`).

### One arm on one joint, no gravity

Spin left after 1 s at the 10 ms step, per 10,000 of the release speed (`probe_13_one_joint.txt`):

| | Stock | Newton-Euler alone | The correction alone | Both |
|---|---|---|---|---|
| Arm 0.3 m, released at 2 rad/s | 9,624 | 9,633 | 9,989 | 9,999 |
| Arm 0.3 m, released at 5 rad/s | 8,169 | 8,204 | 9,935 | 9,999 |
| Mass on the axis, released at 2 rad/s | 9,626 | 9,933 | 9,626 | 9,933 |
| Mass on the axis, released at 5 rad/s | 8,177 | 9,999 | 8,177 | 9,999 |

Each of the two removes its own part and neither removes the other's. Together a free arm keeps its speed.

The 9,933 is not the correction's: with the mass on the axis the correction has nothing to act on. There the solver
converges in one iteration (`most_iterations 1`) with one of its tolerances met, which on an arm this light is a loss
of its own; which of its two tolerances this probe does not show.

### Two arms on two joints, no gravity

A new rig, [`tools/sdx_chain.cpp`](../../tools/sdx_chain.cpp), and a new measure (`sx_contact chain`). Nothing does
work on the chain, so its kinetic energy and its angular momentum about the first joint must stay what they were.
After 2 s, per million of the start (`probe_13_two_links.txt`):

| Step | Stock: energy | Stock: momentum | Both corrections: energy | Both corrections: momentum |
|---|---|---|---|---|
| Shipped (10 ms) | 661,574 | 886,537 | 1,000,391 | 999,988 |
| 1/4 | 859,303 | 963,365 | 1,000,155 | 1,000,017 |
| 1/16 | 957,265 | 989,944 | 1,004,396 | 1,001,599 |

Stock loses a third of the chain's energy in 2 s at the shipped step. With both corrections it is kept.

**The gain at 1/16 is the solver's tolerance, and it is a cost of the correction.** With the correction the Newton
matrix is no longer exact, so the solver approaches the answer from one side and stops as soon as one of its
tolerances is met (absolute 1e-3, relative 1e-6). On arms this light that leaves a small push in one direction.
With the tolerances tightened (absolute 1e-9, relative 1e-12) it is gone (`probe_13_two_links_tolerance.txt`). This
probe tightens both together, so it does not show which of the two the solver stops on; on a one-joint arm the
probes of [run 030](../run_030_design_probes/) show it is the relative one at 1/16 of the step, and both at 1/64.

| Step | Shipped tolerances: energy, momentum | Tight tolerances: energy, momentum |
|---|---|---|
| Shipped (10 ms) | 1,000,391 and 999,988 | 1,000,346 and 1,000,000 |
| 1/16 | 1,004,396 and 1,001,599 | 1,000,001 and 999,999 |
| 1/64 | 1,002,100 and 1,000,705 | 1,000,000 and 1,000,000 |

With the tight tolerances the chain's angular momentum ends within a part in a million of its start at every step,
and drifts by at most 2 parts in a million on the way. Its energy ends 346 parts in a million above its start at the
shipped step (largest drift 0.13%) and within a part in a million at 1/16 and 1/64 (largest drift 6 and 1). The
tight tolerances are not met everywhere: at 1/64, 239 of 12,800 steps stopped without converging.

### The same chain under gravity

Under gravity the total energy must stay. What is lost, as a share of the largest kinetic energy reached
(`probe_13_two_links.txt`, the `swing` lines):

| Step | Stock | Both corrections |
|---|---|---|
| Shipped (10 ms) | 101% | 47% |
| 1/4 | 69% | 11% |
| 1/16 | 21% | 2.5% |

A loss is left, and it falls four times for each four times smaller step. That part belongs to backward Euler,
which damps any swing a force drives. The correction removes the part that was there with no force at all.

One arm as a pendulum, released level, 4 s at the shipped step (`probe_13_one_joint.txt`): the largest speed in the
last second is 3.6 rad/s on stock and 5.2 rad/s with both corrections. The right answer is 8.0 rad/s every swing.

### On the benchmark scenes

12 throwaway episodes, the recommended configuration with each addition (`probe_13_benchmark_joint_motion.txt`):
with the correction alone no step stops and none diverges on `ant`, `half_cheetah` or `cart_pole` at the shipped
step or at 1/4 of it. With SuperDex's Newton-Euler inertia `ant` has 1 stopped step at the shipped step without the
correction and 2 with it.

## 3. Friction one step late at an impact: which variant is safe

Run 022 left a candidate that gives Coulomb friction the normal force of the step being solved. It passed all ten
contact tests and made `ant` diverge beside anchored friction (patch C). Build 11 carries four variants of it,
chosen by the value of `SUPERDEX_FRICTION_STEP_NORMAL`:

| Variant | What it does |
|---|---|
| 1 | The step's normal force everywhere (run 022's candidate) |
| 2 | The step's normal force where a contact slides, the start-of-step force where it is stuck |
| 3 | As 2, and where a contact slides the friction Hessian is SuperDex's own fitted one |
| 4 | As 1, and the friction Hessian is SuperDex's own fitted one everywhere |

`ant`, 108 throwaway episodes, shipped step, 21,600 solver steps (`probe_13_friction_variants_ant.txt`):

| Variant | Recommended configuration with it: stopped, diverged | Patch C with it, no damping: stopped, diverged |
|---|---|---|
| none | 5, 0 | 196, 0 (run 022) |
| 1 | 2, 4 | 0, 3 |
| 2 | 20, 8 | 30, 8 |
| 3 | 3, 0 | 3, 0 |
| 4 | 0, 0 | 0, 0 |

So what made `ant` diverge was not the step's normal force. It was the exact friction Hessian that anchored
friction uses (variants 1 and 4 differ only in it). Why that Hessian fails once the normal force moves within the
step, for example by not being positive definite, was not measured. With SuperDex's own
fitted Hessian (variant 4) no step stops and none diverges, which is fewer than the recommended configuration has
without the correction.

Both contact suites, the recommended configuration with the variant (`probe_13_suites_friction.txt`):

| Variant | First suite, T01 to T10 | T05: friction impulse per 10,000 of the normal impulse, step 1 to 1/64 (the law: 4,000) | Stopped steps, both suites |
|---|---|---|---|
| none | 1111011111 | 2113 2064 2332 3130 3439 3729 3858 (run 022) | 0 |
| 3 | 1111111111 | 4000 4000 3999 3999 3999 3999 3999 | 0 |
| 4 | 1111111111 | 4000 4000 3999 3999 3999 3999 3999 | 0 |

The stopped-steps column is not in `probe_13_suites_friction.txt`: the solver's counts of these plays were not
kept, so that column is as noted at the time and cannot be checked from the record.

Two things move in the second suite, and they are reported as measured: the two slides that end. With variant 4
the cube of `stop` slides 177.7 mm at the shipped step, then 182.3, 183.3 and 183.4 mm at 1/4, 1/16 and 1/64.
Without it the same slide is 186.5, 184.4, 183.9 and 183.5 mm. Both arrive at the same distance; with the correction
the shipped step is 3.1% short of it where it was 1.6% long. The landing that slides to a stop (`land`) moves the
same way: 217.8 mm at the shipped step with variant 4 against 230.8 mm without it (5.6% less), and 223.3 against
223.5 mm at 1/64. Friction now acts in full from the first step of a slide, so the distance is backward Euler's own
(short by the release speed times half a step). Nothing else in the second suite moves by more than 3 parts in
4,900, apart from the largest change of momentum in `top` at the shipped step, 300 against 320 (75 against 80 parts
per million of its momentum).

Variant 4 is the one taken forward. The other three leave the source before anything is registered.

## 4. Everything together on `ant`

`ant`, 108 throwaway episodes, shipped step, 21,600 solver steps (`probe_13_ant_together.txt`):

| Configuration | Stopped | Diverged | Iterations in all |
|---|---|---|---|
| Stock | 223 | 0 | 181,733 |
| Stock with SuperDex's Newton-Euler inertia | 209 | 0 | 179,681 |
| Stock with Newton-Euler inertia and the joint-motion correction | 217 | 0 | 184,743 |
| Recommended configuration (patches A to E) | 5 | 0 | 125,765 |
| Recommended with Newton-Euler inertia | 6 | 0 | 126,336 |
| Recommended with the joint-motion correction | 11 | 0 | 129,780 |
| Recommended with both | 5 | 0 | 129,193 |
| Recommended with the friction correction (variant 4) | 0 | 0 | 152,598 |
| Recommended with the friction correction and the joint-motion correction | 0 | 0 | 156,400 |
| Recommended with all three | 0 | 0 | 156,391 |

With every correction on, no step of 21,600 stops and none diverges, against 223 stopped on stock. It costs about a
quarter more solver iterations than the recommended configuration and fewer than stock.

These are probes on one set of throwaway commands. Each correction is registered on fresh parameters before any of
this is claimed.

## Files

| | |
|---|---|
| `probe_13_identity.txt` | Build 11 with no new switch set, against the registered files and the earlier builds |
| `probe_13_one_joint.txt` | One arm on one joint: free spin and a pendulum, with and without each correction |
| `probe_13_two_links.txt`, `probe_13_two_links_tolerance.txt` | Two arms on two joints: energy and angular momentum |
| `probe_13_benchmark_joint_motion.txt` | The three benchmark scenes, 12 episodes, with the joint-motion correction |
| `probe_13_friction_variants_ant.txt`, `probe_13_suites_friction.txt` | The four friction variants on `ant`, and the two that survived on both suites |
| `probe_13_ant_together.txt` | `ant`, 108 episodes, every combination above |
| `../../patches/in_design/build11_on_top_of_the_registered_patches.patch` | The source these probes ran on |
