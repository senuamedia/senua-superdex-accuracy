# What was found

What Senua AI measured on stock SuperDex v1.0.0: what it gets right, and where it departs from a known right
answer. Every number is from a run or a probe in `validation/`, and each finding links to the study that measured it.

Back to the [documentation index](README.md).

## What stock SuperDex gets right

| What | Measured | Study |
|---|---|---|
| It is deterministic | Every source replayed was byte-identical to its first play, encoder stream and full state. With the first command nudged by 1e-9 or by 1e-6, every one of 21,600 readings is identical, on all three scenes | [3](studies/03-whose-failure.md) |
| Free fall converges at the integrator's order | With nothing to hit, each halving of the step halves the difference: 50.00% to 50.02%, in 64-bit. In SuperDex's shipped 32-bit precision it does not (the T01 test fails, with or without the corrections; [Study 20](studies/20-thirty-two-bit.md)) | [4](studies/04-one-cube-and-the-ground.md) |
| Sliding friction | Friction force over normal force is 0.4000 and 0.4001 where the coefficient is 0.4 | [4](studies/04-one-cube-and-the-ground.md) |
| A body at rest is carried | The ground carries a resting cube's weight to within 1% | [5](studies/05-contact-patches.md) |
| Momentum between two bodies | It changes by 52 to 87 parts per million, which is the resolution of the measure | [7](studies/07-slide-and-two-bodies.md) |
| Slip between two bodies | 6,174 and 3,919 mm/s2 at 1/16 of the step, where Coulomb's law gives 6,174 and 3,920 | [7](studies/07-slide-and-two-bodies.md) |
| A joint above its friction limit | It slips at 3,100,074 micro-radians a second at 1/16 of the step, where the answer is 3,104,308 | [6](studies/06-joints.md) |
| A joint limit at rest | The arm sits at minus 303,744 micro-radians, where the limit's spring gives minus 303,741 | [8](studies/08-joint-limits.md) |
| The solver does not diverge | No solver step diverged in any of the 192 benchmark sources of Studies 1 to 3 | [1](studies/01-accuracy-settings.md), [2](studies/02-independent-calibration.md), [3](studies/03-whose-failure.md) |
| Its own higher-order integrator | SuperDex's third-order integrator returns a dropped cube to 99.96% of its height at 1/64 of the step | [4](studies/04-one-cube-and-the-ground.md) |
| Deformable bodies | A falling rod, strip and soft body follow backward Euler's own drop to within 3.1 micrometres. Hanging, they stretch to within 0.16% of the values registered; the rule's band does not separate the finite-strain value from the small-strain one, about 0.5% apart. Resting, they settle where the contact law puts them. Sliding, they stop within 1 in 100 of backward Euler's own distance, and the soft cube then rocks back 0.3 to 0.9 mm on its compliant contact ([probes after run 032](../validation/run_032_open_items/probes/), [run 036](../validation/run_036_registration16/)) | [13](studies/13-end-to-end.md), [14](studies/14-open-items.md) |
| A gripper's forces | On the built-in hand each finger presses with the commanded 8 N and the two carry the cube's weight, to within 1 in 100. On the FR3 hand the press is right, but the weight splits 1.1% and 1.2% off even; with the patches it is within 1 in 100 | [13](studies/13-end-to-end.md) |

## Where stock SuperDex departs from the right answer

Several of these are trade-offs SuperDex documents: a regularised friction law, a dissipative default integrator,
compliant contact. The measurements say what each one costs, and at which step.

### 1. The time step sets how much a body bounces

The shipped contact is a penalty alone, with no loss of its own. An implicit first-order integrator damps what it
does not resolve by an amount that depends on the step. So the bounce is a property of the step.

| Rebound per 10,000 of the drop height | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| Stock, backward Euler | 0 | 8 | 353 | 1,307 | 3,080 | 5,264 | 7,148 |
| SuperDex's own contact damping at 5 | 0 | 0 | 0 | 0 | 14 | 40 | 57 |

A smaller step, the setting offered for accuracy, moves the physics toward a perfectly elastic bounce instead of
refining one answer. This is what puts `half_cheetah` out of order (finding 10).

Corrected by SuperDex's own `normalViscousDampingCoefficient`, which then needs patches A and B.
Measured in [Study 4](studies/04-one-cube-and-the-ground.md), rule K1.

### 2. With contact damping on, friction ignores the damping part of the normal force

Coulomb's law is on the whole normal force. SuperDex computes friction from the penalty part alone.

| Friction impulse per 10,000 of the normal impulse (the law: 3,000) | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| Stock, no damping | 2,881 | 2,937 | 2,979 | 3,000 | 2,999 | 3,000 | 2,999 |
| Contact damping 5, stock code | 3,284 | 3,612 | 3,996 | 4,021 | 3,675 | 3,379 | 3,195 |
| Contact damping 5 with patch A | 2,880 | 2,940 | 2,970 | 2,986 | 2,993 | 2,997 | 2,998 |

Friction is 6.5% to 34% more than the law allows. Corrected by patch A.
Measured in [Study 5](studies/05-contact-patches.md), test T10.

### 3. With contact damping on, the ground can pull

SuperDex's damping term multiplies the penalty force by one minus the coefficient times the leaving speed, and
nothing stops that factor going below zero. A body that leaves fast enough is pulled back by the ground.

| The lowest force of the ground on a 0.5 kg cube | Lifted, 10 ms | Lifted, 0.625 ms | Fast rebound |
|---|---|---|---|
| Stock, no damping | 0 | 0 | 0 |
| Contact damping 5, stock code | Minus 3.2 N | Minus 0.1 N | Minus 90 N |
| Contact damping 5 with patches A and B | 0 | 0 | 0 |

Corrected by patch B. Measured in [Study 5](studies/05-contact-patches.md), test T09.

### 4. Nothing holds at rest

SuperDex's friction law is zero at zero slip speed, so it cannot hold a load. There is no stick state, no anchor and
no static coefficient in the contact path. SuperDex documents this as a regularised static regime.

| Setting, with a cube pushed at 0.6 of what friction can hold | Creep, micrometres a second |
|---|---|
| Shipped | 3,670 |
| C-infinity friction law | 3,742 |
| Implicit normal force, explicit normals, no fading, Armijo line search | 3,670 each |
| Falloff speed 0.001 (shipped 0.01) | 367 |
| Viscous friction 100 | 1,559 |

None of the seven settings tried removes it; a lower falloff speed lowers it in proportion. The same holds between two bodies: a cube that should ride on a gently pushed
cube falls behind at 2,919 micrometres a second, the speed the friction law's own formula gives (2,929).

Corrected by patch C. Measured in [Study 4](studies/04-one-cube-and-the-ground.md), rule K3, and
[Study 7](studies/07-slide-and-two-bodies.md), test T14.

### 5. Friction arrives one step late at an impact

Friction uses the normal force of the start of the step.

| Friction impulse over normal impulse, per 10,000 (the law: 4,000) | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| Stock | 2,203 | 2,336 | 2,224 | 3,032 | 3,164 | 3,372 | 3,598 |
| With SuperDex's `implicitNormalForceForDissipation` | 4,000 | 3,999 | 4,000 | 3,999 | 3,999 | 4,000 | 4,000 |

Over the impact alone, friction delivers 55% to 90% of what Coulomb's law requires. Over the impact and the 0.1 s
after it, it delivers 96% at the shipped step and all of it at finer steps, so the shortfall is a delay.

SuperDex's own switch corrects it on one cube, but with contact damping it stops `ant`'s solver converging. Patch F
gives friction alone the normal force of the step being solved: over an impact it is then within 1 in 1,000 of the law (2,999 or 3,000 per 10,000, against 3,000, on Study 11's cube; the table above is Study 4's, whose law is 4,000)
at every step, and the solver keeps converging.
Corrected by patch F ([Study 11](studies/11-friction-at-impact.md)). Measured in [Study 4](studies/04-one-cube-and-the-ground.md), rule K2.

### 6. A damped joint limit holds back a joint that is leaving it

The limit's force is stiffness times depth plus damping times the rate of change of depth, with no lower bound, so
it is negative while the joint comes back into range.

| | The right answer | Stock |
|---|---|---|
| Leaving speed, damping below critical, micro-radians a second | 1,434,131 | 1,004,593 |
| Leaving, damping above critical | It leaves at 369,401 | It has not left after 0.5 s |
| Angle 0.1 s after being lifted by twice the torque that held it | Minus 189,208 or more | Minus 259,228 |

All three of Meta's benchmark scenes ship damped limits. Corrected by patch D.
Measured in [Study 8](studies/08-joint-limits.md).

### 7. Joint friction does not hold a load

SuperDex's joint friction is regularised in speed, like its contact friction. An arm held level by joint friction of
1.5 times gravity's torque creeps at 411 micro-radians a second, which is 1.4 degrees a minute and exactly what the
friction law's formula gives.

Corrected by SuperDex's own joint `falloffVel` at 1e-6 (shipped: 0.001). The creep is then 0, the solver still
converges, and slip above the friction limit is unchanged. Measured in [Study 6](studies/06-joints.md).

### 8. The default integrator takes speed out of joint motion

| | Right answer | Backward Euler at 10 ms (shipped) | Backward Euler at 1/64 | BDF2 at 10 ms | DIRK33 at 10 ms |
|---|---|---|---|---|---|
| Spin left after 1 s, per 10,000 | 10,000 | 9,208 | 9,997 | 9,705 | 9,807 |
| A pendulum's first swing, per 10,000 | 10,000 | 9,083 | 9,984 | 9,748 | 9,839 |

A freely spinning arm loses 7.9% of its speed in a second with nothing acting on it. The loss grows with speed: 1%
at 1 radian a second and 34% at 8. It is right to within 0.2% at 1/64 of the step, so the loss belongs to the shipped
step and goes away with refinement (Study 6); its cause is in how the step is formed (Study 12).

Its cause, read from the source: each link's inertial force is the centred second difference of its position, which
belongs to the start of the step, and it is projected onto the joints with the Jacobian of the current position.
Projected at the start of the step (patch G) with SuperDex's own Newton-Euler inertia for each link's rotation, a
free arm keeps 9,999 of every 10,000 of its speed at the shipped step. What remains is backward Euler's damping of a
swing that a force drives, which falls with the step.

Corrected by patch G ([Study 12](studies/12-joint-motion.md)), which has no defect under backward Euler
([run 049](../validation/run_049_patch_g_review/README.md)) and is recorded as required, correct and safe under it by
[Study 21](studies/21-recommended-configuration.md)'s decision, on fresh numbers. Measured in
[Study 6](studies/06-joints.md).

Under SuperDex's BDF2 a second departure sits beneath it, found by the review of patch G (run 049, a review, not
registered). For a jointed body SuperDex sets each link's pose at the start of a BDF2 stage from the forward kinematics
of the combined joint angles, where BDF2 for a constrained system combines each link's own centres. The two differ at
second order in the step, so the velocity a link keeps is short at first order. Patch G's earlier form, with its
share for BDF2, cancels it for one joint only; on a chain it loses the angular momentum at first order (a free
two-link chain: 1,540 parts per million over 2 s at 1/16 of the step, [Study 15](studies/15-replication.md)). This
departure is stock SuperDex's and is a finding. Patch G's derived form, patch G under BDF2 by
[Study 22](studies/22-bdf2-chain.md)'s decision (library build 16), corrects it: on three fresh chains a free chain's
angular momentum and energy fall about four times a halving of the step (3.56 to 4.59 on every halving ruled), and its
momentum drift at 1/16 of the step is 5 or 6 parts per million.

### 9. As shipped, the solver stops before it converges

SuperDex gives every solver step a status. `stopped` is its status for a step that met a stopping criterion without
converging to the requested tolerance.

| Steps that stopped, under seeded random commands | `cart_pole` | `half_cheetah` | `ant` |
|---|---|---|---|
| As shipped: 32-bit, at most 4 iterations | 21 of 21,600 | 19,267 (89.2%) | 17,125 (79.3%) |
| 64-bit, at most 200 iterations | 0 | 0 | 237 (1.1%) |
| 64-bit, at most 1,000 iterations | 0 | 0 | 226 (1.0%) |

Two of SuperDex's own settings account for it: the arithmetic precision, which is a build option, and the iteration
limit. In 32-bit arithmetic the solver stops as soon as an update is smaller than about a millionth of the state.
With 64-bit arithmetic and 200 iterations, what is left is on `ant`, and it is SuperDex's default estimate of
friction's normal force: its own `explicitNormals` removes 95% to 98% of those stops, and with patch F there are none
([Study 10](studies/10-ant-stops.md)).
Measured in [Study 2](studies/02-independent-calibration.md).

### 10. On `half_cheetah`, refining the time step changes the motion more, not less

Plain subtraction of the encoder streams, each step against the next finer one, fold 0:

| `half_cheetah` | 1 to 1/2 | 1/2 to 1/4 | 1/4 to 1/8 | 1/8 to 1/16 |
|---|---|---|---|---|
| Stock, with the ground | 4,144,564 | 3,200,618 | 4,688,047 | 8,051,707 |
| Stock, without the ground | 2,706,016 | 1,500,647 | 804,733 | 411,653 |
| With contact damping 5 | 3,929,347 | 2,333,050 | 1,470,814 | 1,278,152 |

Without the ground each gap is about half the one before. With the ground the finest gap is the largest, in every
fold. With a contact that has a loss of its own, it is in order again. The cause is finding 1.
Measured in [Study 3](studies/03-whose-failure.md) and [Study 4](studies/04-one-cube-and-the-ground.md).

### 11. The rotation vector of a rotation under 2e-9 rad points along x

SuperDex's `Quaternion::ToAxisAngle` takes the axis of a rotation as the quaternion's vector part over its length
only when that length is above 1e-9. Otherwise it returns the x axis. The function is used wherever a rotation
becomes a vector: the rigid rotation constraints, the articulated bodies and the time integration.

| Rotations asked of SuperDex's own quaternion | Stock |
|---|---|
| Larger than 2e-9 rad, any axis (20) | Exact |
| 2e-9 rad or less, about x (4) | Exact |
| 2e-9 rad or less, about another axis (16) | Along x, off by 113% to 163% of the angle |

A body whose rotation is held has a rotation of about a nano-radian once something has touched it. The rotation
constraint's error then jumps between the true axis and x, by its stiffness times a few nano-radians, which sits on
the solver's tolerance. The solver cannot get under it and runs to its iteration limit.

| Two free cubes after they part: steps, steps at the iteration limit, iterations | 10 ms | 1/4 | 1/16 | 1/64 |
|---|---|---|---|---|
| Stock | 45, 0, 132 | 190, 0, 822 | 768, 0, 5,331 | 3,079, 930, 203,419 |
| With patch E | 45, 0, 46 | 190, 0, 192 | 768, 0, 770 | 3,079, 0, 3,080 |

It accounts for every stopped step of both contact suites: 36 and 231 with stock contact, 551 and 728 with the
recommended configuration, and 0 in all four once it is corrected. On the 13 benchmark streams played with it, it never acts: every
stream is byte-identical with the correction on.

Corrected by patch E. Measured in [Study 9](studies/09-rotation-axis.md).

### 12. On a point-cloud collider, sliding friction is far from Coulomb's law

SuperDex's shells and rods are met by other bodies through a point-cloud collider. With a held cloth sheet as the
floor (a node every 10 mm, the shipped range of 10 mm), a cube of 1.6 kg with friction 0.35 and 0.45:

| On the point-cloud floor | Right answer | Stock |
|---|---|---|
| Friction over an impact at the shipped step, per 10,000 of the normal impulse | 3,500 | 13,225 |
| Friction while sliding | 3,500 | 1,824, and the cube almost stops |
| Pushed with 1.2 of what friction can hold: mean speed | 881,000 um/s | 428,700 |
| Pushed with 0.6 of it: speed | 0 | 3,598 um/s |
| The floor carries the weight | 15,680 mN | 15,664 |

At rest and when lifted the floor is right. Sliding on it is not, and the solver stops on many of those steps. The
contact kernel the patches correct is the one this collider uses. With them, in Study 13, friction over an impact read within
5% of the law and a pushed cube held. The few percent left came from the cube's own grid distance field and from contact damping at its edges: with each mesh body's grid cell at 1/32 of its side and 1 mm smoothing, friction over an impact reads within 1.7% and sliding friction within 1 in 100 ([Studies 14 and 15](studies/15-replication.md)).

Corrected by patches A to F with SuperDex's grid cell and smoothing. Measured in [Study 13](studies/13-end-to-end.md).
The grid cell and smoothing held their rules in [Study 14](studies/14-open-items.md); in
[Study 15](studies/15-replication.md) V3 failed on one stopped step, so it stays [open](open-items.md).

## What each shipped setting costs

From [Study 2](studies/02-independent-calibration.md): the size of one change, everything else held, in encoder
counts (16,384 a turn), for folds 0, 1 and 2. A value in brackets was not detected.

| One change, everything else held | `cart_pole` | `half_cheetah` | `ant` |
|---|---|---|---|
| 32-bit to 64-bit arithmetic | Not detected | 22.6k / 121.1k / (5.3k) | 3.68M / 2.75M / 1.58M |
| Iteration limit 4 to 200 | 27.4k / (1.8k) / (18.3k) | 18.84M / 18.07M / 20.55M | 3.85M / 3.24M / 2.05M |
| Time step, shipped to half | 2.16M / 3.06M / 1.58M | 4.39M / 4.18M / 4.03M | 8.49M / 7.82M / 8.62M |
| Contact smoothing, 5 mm to 2.5 mm | No contact | 483k / 459k / 458k | 1.27M / 1.19M / 652k |

On `half_cheetah` the iteration limit is the largest single cost. On `ant` it is the time step. On `cart_pole` only
the time step matters.

## A fault of our own

One finding is about our work and not about SuperDex. The anchored friction patch as first recorded in Study 5 did
not stay stopped: a cube that slid to a stop came back and rang, leaving up to 12,857 micrometres a second at 1/64
of the step where stock leaves 0. The integrator hid it at the shipped step. [Study 7](studies/07-slide-and-two-bodies.md)
found it, and the patch was withdrawn and corrected.

A second finding is about our own reading. Study 7 reported that the corrected contact configuration stops the
solver more often than stock on the one-cube suites, which we read as a cost of our patches. Those stops are finding
11, a defect of SuperDex's, and with it corrected the count is 0 ([Study 9](studies/09-rotation-axis.md)).
