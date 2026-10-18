# Study 6: joints and the integrator, on one arm

| | |
|---|---|
| Registration | Sixth: [PREREGISTRATION_06.md](../../preregistrations/PREREGISTRATION_06.md) |
| Question | On one arm on one joint, with nothing touching it: does a free arm keep its motion, does a driven arm accelerate as its inertia says, and does joint friction hold a load? |
| Outcome | Every rule held: all three. No patch follows from it |
| Registered | 14 October 2026, before any run of this registration existed |
| Result | [Run 015](../../validation/run_015_joints/README.md), 14 October 2026 |
| Runs | [014, design probes](../../validation/run_014_design_probes/), [015, the registered runs](../../validation/run_015_joints/) |
| Data | [`joints/`](../../joints/) (30 one-arm runs) |
| Played by | [`tools/sdx_joint.cpp`](../../tools/sdx_joint.cpp), [`tools/joint_all.sh`](../../tools/joint_all.sh), on stock SuperDex |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx) (`final`, `swing`, `creep`, `joints`), `sx_joint_run.sh` |

Previous: [Study 5](05-contact-patches.md). Next: [Study 7](07-slide-and-two-bodies.md). All studies:
[index](README.md).

## Why it was asked

Studies 4 and 5 are about contact. A robot is joints. So the same kind of test was taken to the rest of what a
robot simulator has to get right: a case with a right answer and nothing else in the scene. Stock SuperDex, no
patch.

## The physics behind it

- A rigid body turning freely about a fixed axis keeps its angular speed. Driven by a constant torque it gains
  torque times time over inertia. A pendulum keeps its energy and comes back to the height it was released from.
- An implicit Euler step applied to rotation loses speed: the step cuts the corner of the arc, at a rate that grows
  with the square of the speed and with the step (Hairer, Lubich and Wanner 2006).
- Coulomb friction at a joint holds any torque below its limit. A friction law regularised in speed cannot. SuperDex's
  joint friction is that kind of law with its own falloff speed, shipped at 0.001 radians a second, and its header
  says the static friction "is regularized to allow slight slippage".

## What the design probes showed

On a different arm from the registered one ([run 014](../../validation/run_014_design_probes/)).

- **A free arm slows down by itself.** Released spinning at 4 radians a second with no gravity and no friction, it
  has lost 13% after a second at the shipped step. At 1/64 of the step it has lost almost nothing.
- **The loss grows with speed.** At the shipped step, in one second: 1% at 1 radian a second, 3.8% at 2, 13% at 4
  and 34% at 8.
- **Joint friction does not hold.** An arm held level by joint friction of twice gravity's torque creeps at exactly
  the speed the friction law's formula gives, at the shipped step and at 1/16 of it. With the falloff speed at 1e-6
  it does not move.
- **The benchmark scenes do not exercise this.** They use viscous joint friction only.

## What was played

A base welded to the world and one arm on a revolute joint. The arm is a cube of 2 kg and half-size 0.04 m whose
centre is 0.4 m from the joint. None of these numbers was used in the probes. Its inertia about the joint is
0.3221 kg m2, and gravity's torque on it when level is 7.84 N m. Stock library, iteration limit 200.

| Test | What is played | The right answer | It passes when |
|---|---|---|---|
| JT1, spin | No gravity, no friction, released at 3 radians a second, for 1 s | Still 3 radians a second | At least 99% of the release speed is left |
| JT2, torque | No gravity, no friction, 1.5 N m for 1 s | 4,656,457 micro-radians a second | Within 1% |
| JT3, swing | Gravity, no friction, released level, for 3 s | It comes up level on the other side | The first swing reaches at least 99% |
| JT4, hold | Gravity, joint friction 12 N m, released level at rest, for 2 s | It does not move | Mean speed over the second half within 10 micro-radians a second of zero |
| JT5, slip | No gravity, joint friction 2 N m, torque 3 N m, for 1 s | 3,104,308 micro-radians a second | Within 3% |

## The rules fixed in advance

| Rule | It holds when |
|---|---|
| Q1, the integrator owns the loss | As shipped (backward Euler, 10 ms), JT1, JT2 and JT3 fail. With backward Euler at 1/64 of the step all three pass |
| Q2, joint friction does not hold, and one setting makes it | As shipped, JT4 fails at the shipped step and at 1/16 of it, with the creep within 1% of what the friction law gives for this load: 411 micro-radians a second. With `falloffVel` at 1e-6 it passes at both steps and no solver step stops |
| Q3, the setting changes nothing else | JT5 passes at both steps, with the shipped falloff and with 1e-6 |

A risk written down before the run: the registered arm is shorter, heavier and slower than the probe's, so if the
loss at the shipped step were under 1%, Q1 would fail.

## The result

| Rule | Result |
|---|---|
| Q1, the integrator owns the loss | Held |
| Q2, joint friction does not hold; one setting makes it | Held |
| Q3, the setting changes nothing else | Held |

### Q1. The integrator takes speed out of joint motion

| | Right answer | Shipped step, 10 ms | 1/64 of the step |
|---|---|---|---|
| JT1, spin left after 1 s, per 10,000 | 10,000 | 9,208 | 9,997 |
| JT2, speed reached under torque, micro-radians a second | 4,656,457 | 4,425,099 | 4,655,787 |
| JT3, the first swing, per 10,000 of level | 10,000 | 9,083 | 9,984 |

At the shipped step a freely spinning arm loses 7.9% of its speed in a second with nothing acting on it, a driven
arm reaches 5.0% less speed than its inertia says, and a pendulum's first swing gets 90.8% of the way. All three
are right to within 0.2% at 1/64 of the step.

Reported, SuperDex's other integrators at the shipped step:

| | Backward Euler (shipped) | BDF2 | DIRK33 |
|---|---|---|---|
| Spin left after 1 s, per 10,000 | 9,208 | 9,705 | 9,807 |
| Short of the speed a torque should give | 5.0% | 1.9% | 1.2% |
| First swing, per 10,000 | 9,083 | 9,748 | 9,839 |

Reported, how the loss grows with speed at the shipped step: 9,902 per 10,000 left after a second at 1 radian a
second, 9,624 at 2, 8,708 at 4 and 6,630 at 8. A pendulum's successive swings at the shipped step: 9,083, 7,555,
6,492 and 5,687.

### Q2. Joint friction creeps, and one setting stops it

Joint friction of 12 N m against a gravity torque of 7.84 N m should hold the arm level. As shipped it creeps at
411 micro-radians a second, at the shipped step and at 1/16 of it, which is exactly what the friction law's formula
gives: 1.4 degrees a minute. With SuperDex's own `falloffVel` at 1e-6 the creep is 0 at both steps, and no solver
step stopped.

### Q3. The setting changes nothing else

Above its friction limit the joint slips at 3,032,560 and 3,100,074 micro-radians a second at the two steps (the
answer: 3,104,308), and at 3,032,561 and 3,100,041 with the falloff at 1e-6.

## What it means

- **Q1 measures a cost of the shipped integrator at the shipped step**, on the simplest articulated motion there
  is, as the registration's closing section says. SuperDex documents that it trades accuracy for stability and
  offers higher-order integrators. The registration reads Q1 as not a defect of the joint equations, and proposes
  no patch.
- **A cause in the formulation.** [Study 12](12-joint-motion.md) found a cause of the loss at the shipped step:
  each link's inertial force is projected onto the joints at the wrong node (with the Jacobian of the current
  position, not of the start of the step). Patch G corrects it, with SuperDex's own Newton-Euler inertia for the
  rotational part.
- **Joint friction has the same absence of stick as a contact** (Study 4, rule K3), with a remedy that is a
  setting.

## What it led to

The benchmark scenes ship joint limits with damping, which have a loss of their own. That was looked at in
[Study 8](08-joint-limits.md).

Limits: one joint, one arm, no contact. Nothing against a real robot.
