# Sixth pre-registration: joints and the integrator

Registered 14 October 2026, after design probes on one arm with other parameters
([validation/run_014_design_probes](../validation/run_014_design_probes/)). Registered before any run of this
registration existed. Stock SuperDex v1.0.0 throughout: no patch is involved.

## The question

The fourth and fifth registrations are about contact. This one puts the same kind of test to the other thing a
robot simulator has to get right: joints. One arm on one revolute joint, with nothing touching it. Does a free arm
keep its motion, does a driven arm accelerate as its inertia says, and does joint friction hold a load.

## The right answers

- A body turning freely about a fixed axis keeps its angular speed.
- Driven by a constant torque, it gains torque times time over inertia.
- A pendulum keeps its energy: released level, it comes up level on the other side.
- Coulomb friction at a joint holds any torque below its limit.

A one-joint arm with no gravity obeys inertia times acceleration equals torque. Backward Euler, SuperDex's shipped
integrator, integrates that without error when the torque is constant, if the equation is formed in the joint's own
coordinate. Any loss therefore comes from how the engine forms its equations, and not from the order of the method
alone. Implicit Euler applied to rotation in Cartesian coordinates is known to lose angular speed, at a rate that
grows with the square of the speed and with the step (Hairer, Lubich and Wanner 2006).

## What the design probes showed

On a probe arm of 1 kg, 0.5 m from the joint ([validation/run_014_design_probes](../validation/run_014_design_probes/)).

- **A free arm slows down by itself.** Released spinning at 4 rad/s with no gravity and no friction, it is at
  3.48 rad/s a second later at the shipped 10 ms step: 13% of its speed gone with nothing acting on it. At 1/16 of
  the step it loses 1%, and at 1/64 0.04%. At the shipped step the loss in one second is 1% at 1 rad/s, 4% at 2,
  13% at 4 and 34% at 8. SuperDex's second-order integrator loses 5% at 4 rad/s, and its third-order one 3%.
- **A driven arm gains less than its inertia says**: 3.7% less at the shipped step, 0.01% less at 1/64.
- **A pendulum loses its swing.** Released level, its first three swings reach 92%, 77% and 67% of the way at the
  shipped step, and 99.9% at 1/64.
- **Joint friction does not hold.** An arm held level by joint friction of twice gravity's torque creeps at
  0.29 mrad/s, exactly what the friction law's own formula gives. With the law's falloff speed set a thousand times
  smaller it does not move, the solver works no harder, and a swinging arm with joint friction swings exactly as
  before.
- **The benchmark scenes** use viscous joint friction only, so they do not exercise the creep, and their joint
  limits have damping set.

## The scene, registered parameters

`tools/sdx_joint.cpp`: a base welded to the world and one arm on a revolute joint. The arm is a cube of 2 kg and
half-size 0.04 m whose centre is 0.4 m from the joint. None of these numbers was used in the probes. Its inertia
about the joint is 0.3221333 kg m2, and gravity's torque on it when level is 7.84 N m.

| Test | What is played | The right answer | It passes when |
|---|---|---|---|
| JT1 spin | No gravity, no friction, released at 3 rad/s, 1 s | Still 3 rad/s | Final speed at least 9,900 per 10,000 of the release speed |
| JT2 torque | No gravity, no friction, 1.5 N m, 1 s | 4,656,457 micro-radians a second | Within 1 part in 100 |
| JT3 swing | Gravity, no friction, released level, 3 s | It comes up level on the other side | First swing at least 9,900 per 10,000 of half a turn |
| JT4 hold | Gravity, joint friction 12 N m, released level at rest, 2 s | It does not move | Mean speed over the second half within 10 micro-radians a second of zero |
| JT5 slip | No gravity, joint friction 2 N m, torque 3 N m, 1 s | 3,104,308 micro-radians a second | Within 3 parts in 100 |

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **Q1** the integrator owns the loss | As shipped (backward Euler, 10 ms), JT1, JT2 and JT3 fail. With backward Euler at 1/64 of the step, all three pass |
| **Q2** joint friction does not hold, and one setting makes it | As shipped, JT4 fails at the shipped step and at 1/16 of it, with the creep within 1 part in 100 of what the friction law gives for this load: 411 micro-radians a second. With `falloffVel` at 1e-6, JT4 passes at both steps and no solver step stops without converging |
| **Q3** the setting changes nothing else | JT5 passes at the shipped step and at 1/16, with the shipped falloff and with 1e-6 |

Reported, not deciding: every measured line; the second-order and third-order integrators at the shipped step on JT1
to JT3; JT1 at 1, 2, 4 and 8 rad/s; backward Euler at 1/4 and 1/16.

## Known risks, stated before the run

- The registered arm is shorter and heavier, and spins slower, than the probe's. If its loss at the shipped step is
  under 1%, Q1 fails on JT1.
- At 1/64 of the step the probe arm was 0.12% short on the swing and 0.04% on the spin. The margins to 1% look
  comfortable, but the arm is new.

## What this does and does not say

Q1 measures a cost of the shipped integrator at the shipped step, on the simplest jointed motion there is. SuperDex
says in its own documentation that it trades accuracy for stability, and it offers higher-order integrators. Q1 is
not a defect of the joint equations, and no patch is proposed for it.

Q2 is the same absence of stick as at a contact (fourth registration), with a remedy that is one of SuperDex's own
settings.

Limits: one joint, one arm, no contact. Nothing here is against a real robot.
