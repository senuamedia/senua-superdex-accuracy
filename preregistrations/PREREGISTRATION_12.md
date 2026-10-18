# Twelfth pre-registration: the loss on joint motion, and projecting at the right node

Registered 14 October 2026, after design probes on throwaway arms and throwaway commands
([run 022](../validation/run_022_design_probes/), [run 023](../validation/run_023_design_probes/)). Registered before
any run of this registration existed.

## The question

The sixth study measured that SuperDex's default integrator takes speed out of joint motion: a free arm on one
joint loses 3.9% of its speed in one second at the shipped step, with nothing touching it and no friction. The open
list carried it as "not fixed: removing it is a change of formulation". The probes found it is two separable
things with one cause, and that the cause has a textbook remedy that fits inside SuperDex's own formulation.

## The cause

Read from SuperDex's source at v1.0.0 (`mochi_rigid.cpp`, `mochi_articulated_body.cpp`). Every link of an
articulated body is given the inertial energy of a free rigid body, whose target for every point is the straight
line from where it was along its old velocity. The gradient of that energy, a force and a torque on each link, is
then projected onto the joints with the Jacobian of the **current** position. But the inertial force is the
centred second difference of the link's position, which belongs to the **start** of the step. Projecting it at the
wrong node is what takes the speed: for an arm turning about a joint it loses the square of the angle turned in a
step, whatever the arm's length or mass.

The loss has two parts:

- the translation of each link's centre, which projecting with the Jacobian of the start of the step corrects;
- the rotation of each link about its own centre, which SuperDex's own experimental Newton-Euler inertia corrects.

## The right answers, and where they come from

- **A free arm keeps its speed.** Nothing does work on it.
- **A free chain keeps its kinetic energy and its angular momentum about the first joint.** Nothing does work on
  it and nothing turns it about that joint.
- **A swinging chain keeps its total energy.** Here backward Euler's own damping is expected to remain, falling in
  proportion to the step; the test is that what is left is much smaller than before and falls with the step.
- **The method is the discrete null space method** (Betsch, CMAME 2005; Betsch and Leyendecker, IJNME 2006;
  Leyendecker, Marsden and Ortiz, ZAMM 2008): the discrete equations of motion of a constrained system are
  projected with the null space matrix of the node they are written at. A scheme of that kind keeps momentum maps
  exactly and energy within a bounded oscillation (Marsden and West, Acta Numerica 2001).

## The correction (patch G)

[`patches/senua_inertia_transport.patch`](../patches/senua_inertia_transport.patch): lines added to
`mochi_rigid.cpp` and `mochi_articulated_body.cpp`, none removed, off unless `SUPERDEX_INERTIA_TRANSPORT` is set.
The translational inertial force of each link is kept as it is assembled; the Jacobian of the end of each step is
kept with the pose it belongs to; and the articulated body's joint residual gains the term (Jacobian of the start of
the step minus the current Jacobian) transposed times that force. The Newton matrix is left as SuperDex forms it.
Rotation is left to SuperDex's `EnableNewtonEulerInertia`, which the rigs switch on with `newtoneuler=1`.

The probes found one cost: with the Newton matrix no longer exact the solver approaches the answer from one side,
and its shipped absolute tolerance (1e-3) then leaves a small push of one sign on light bodies. With tight
tolerances it is gone.

## The scenes, registered parameters

None of these numbers was used in the probes, except where a rule compares with an earlier registration's files.

**One arm** (`tools/sdx_joint.cpp`): 2.4 kg, half-size 0.05 m, centre 0.45 m from the joint, no gravity, released at
1.5, 3.5 and 6 rad/s, 1 s, at steps 1, 1/4 and 1/16 of 10 ms. The law's prediction for stock at the shipped step,
speed / sqrt(1 + 2 (speed x step)^2 x 100): 1,467,348, 3,136,775 and 4,574,957 micro-radians a second.

**Two arms** (`tools/sdx_chain.cpp`): 1.2 kg and 0.6 kg, half-size 0.04 m; the first arm's centre 0.25 m from the
first joint, the second joint 0.5 m from the first, the second arm's centre 0.2 m from the second joint. Free: no
gravity, the second joint at -0.9 rad, joint speeds 2.5 and 1.5 rad/s, 2 s. Swinging: gravity, the joints at 0.4
and -0.7 rad, released at rest, 2 s. Steps 1, 1/4 and 1/16. Tight tolerances: absolute 1e-9, relative 1e-12.

**The sixth registration's arm** (2 kg, half-size 0.04 m, 0.4 m) and its runs, played again with both corrections.

**The benchmark**: the fifth registration's commands for `half_cheetah` and `ant`, the third's for `cart_pole`.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **G0** safe when off | The patched library, with no switch set and under each registered configuration's switches, reproduces every file in all nine parts of [`tools/play_identity.sh`](../tools/play_identity.sh) byte for byte ([run 025](../validation/run_025_identity/)) |
| **G1** required: the law | Stock, one arm, shipped step: the speed after 1 s is within 1 part in 100 of the law's prediction at each of the three release speeds |
| **G2** correct: one arm | With both corrections the speed after 1 s is between 9,990 and 10,010 per 10,000 of the release speed in all nine plays |
| **G3** required: two arms | No switch, free chain, shipped step: more than a tenth of the kinetic energy and more than 3 in 100 of the angular momentum are gone after 2 s |
| **G4** correct: two arms, the solver converged | Both corrections, tight tolerances, free chain: at every step the angular momentum ends within 100 per million of its start; the largest energy drift is no more than 5,000 per million at the shipped step, 1,000 at 1/4 and 500 at 1/16 |
| **G5** correct: two arms, as shipped | Both corrections, shipped tolerances, free chain: at every step the kinetic energy ends between 990,000 and 1,010,000 per million of its start, and the angular momentum within 5,000 per million |
| **G6** under gravity | Swinging chain: at every step the energy lost with both corrections is no more than 6 tenths of the loss with no switch, and with both corrections it falls from each step to the next finer one |
| **G7** the solver | In the nine one-arm plays and the six chain plays at shipped tolerances with both corrections, no step stops and none diverges |
| **G8** nothing else gets worse | The sixth registration's tests with both corrections: JT1 (a free arm keeps its speed) passes at the shipped step, where stock fails; JT2 (a driven arm) is within 1 part in 100 of its right answer at the shipped step; the hold creeps within 10 micro-radians a second of stock's creep; the slip speeds are within 1 part in 100 of stock's at steps 1 and 1/16 |
| **G9** the benchmark | Both corrections added to the configuration as it stands after the eleventh registration's decision, shipped step, three scenes: no step diverges, and no more stop than without them plus 21 (1 in 1,000 of 21,600) |

## A decision fixed in advance

The two join the recommended configuration if, with them added, `half_cheetah` and `ant` at steps 1 to 1/16 are in
order in 3 folds of 3 and no step diverges. Otherwise they are recorded as correct and optional.

Reported, not deciding: every measured line; each correction alone on the one arm; the chain at shipped tolerances
step by step; the sixth registration's pendulum (JT3) with both corrections; solver iterations.

## Known risks, stated before the run

- **G5 depends on how light the arms are.** The gain the shipped tolerance leaves grows as the arms get lighter
  against the solver's absolute tolerance, and the registered arms are lighter than the probe's.
- **G4 is tight at the finer steps** (the probes: 6 and 1 per million). Some steps stop at the tight tolerances on
  an update too small to matter; that is expected and is not G7's subject.
- **G6 asks for 6 tenths at the shipped step**, where the probe gave 47 hundredths on another chain.
- **SuperDex marks its Newton-Euler inertia experimental.** On `ant` it had one more stopped step than without it.
- **G0 has failed before** for a patch that touched shipped code, and this one adds lines to two files every
  articulated scene runs through.
- **The benchmark's motion changes** with the corrections, and the chains have not been probed with them.

## What this does and does not say

If the rules hold, patch G is recorded as required, correct and safe; SuperDex's own Newton-Euler inertia is
recorded as the correction for the rotational part; and the open item is closed for motion with no force. It does
not say backward Euler stops damping a swing that a force drives: that loss is the integrator's order, it is
measured here, and SuperDex's higher-order integrators are the remedy SuperDex offers for it.

If a rule fails, it is recorded as measured.

## As registered

Patches: `patches/senua_contact.patch` sha256 1baa6dfec5400d35... (patches A, B and C, and F), `patches/senua_joint_limit.patch` 80f4c8c28ffacf51... (D), `patches/senua_rotation_axis.patch` 1ce1e2b97003929d... (E), `patches/senua_inertia_transport.patch` e39d71c153a3485e... (G). The four apply together to v1.0.0 and give the tree the library was built from (checked file by file). The patched library, build 12: ccb1aefeb3fc91f1.... The stock library: 5a213c925bc86b61.... Measuring program: `measure/sx_contact.sx` d18cbf6fc9dfd08e..., which is the ninth registration's program with lines added and none changed; with it the records of the fourth to the ninth registrations are re-made byte for byte. Safe when off: `tools/play_identity.sh` 220b28d98e06e1e8.... Runner: `measure/runners/sx_study12_run.sh` b2cc0798cbc7eac7.... Plays: `tools/plays/play_12.sh` ac35a4cfdfe5f9ae....
