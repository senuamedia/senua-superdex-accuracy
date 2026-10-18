# Run 015: the sixth registration. Joints and the integrator, on stock SuperDex

Run once on 14 October 2026 for [PREREGISTRATION_06.md](../../preregistrations/PREREGISTRATION_06.md). One arm on one revolute joint with
nothing touching it (`tools/sdx_joint.cpp`, played by `tools/joint_all.sh`): a cube of 2 kg whose centre is 0.4 m
from the joint. Stock SuperDex v1.0.0, no patch. The 30 runs are in [`../../joints/`](../../joints/) with their
checksums. `reading.txt` is every measured line and the verdict, as produced. `stats.txt` is the solver's own status
of every run: every step of every run converged.

## Result: every rule held

| Rule | Result |
|---|---|
| **Q1** the integrator owns the loss | **Held.** As shipped, all three motion tests fail. At 1/64 of the step all three pass |
| **Q2** joint friction does not hold, and one setting makes it | **Held** |
| **Q3** the setting changes nothing else | **Held** |

## Q1. A free arm, a driven arm and a swinging arm all lose motion at the shipped step

| Test | The right answer | Shipped (10 ms) | 2.5 ms | 0.625 ms | 0.156 ms |
|---|---|---|---|---|---|
| JT1: released spinning at 3 rad/s with nothing acting on it, speed after 1 s | 3.000 rad/s | 2.763 | 2.935 | 2.983 | 2.999 |
| JT2: driven with 1.5 N m for 1 s, speed reached | 4.656 rad/s | 4.425 | 4.595 | 4.641 | 4.656 |
| JT3: a pendulum released level, how far its first swing gets | all the way (100%) | 90.8% | 97.3% | 99.3% | 99.8% |

- At the shipped step with the shipped integrator, an arm spinning freely loses 7.9% of its speed in one second, a
  driven arm reaches 5.0% less speed than its inertia says, and a pendulum's first four swings reach 90.8%, 75.6%,
  64.9% and 56.9% of the way.
- At 1/64 of the step all three are within 0.2% of the right answer. So the joint's equations are right, and the
  loss belongs to the integrator at the shipped step.
- The loss grows with the speed. At the shipped step, the speed left after one second is 99.0% at 1 rad/s, 96.2% at
  2, 87.1% at 4 and 66.3% at 8.

**Reported: SuperDex's higher-order integrators at the shipped step.**

| | Speed left after 1 s (JT1) | Speed reached (JT2) | First swing (JT3) |
|---|---|---|---|
| Backward Euler (shipped) | 92.1% | 5.0% short | 90.8% |
| Second-order (BDF2) | 97.0% | 1.9% short | 97.5% |
| Third-order (DIRK33) | 98.1% | 1.2% short | 98.4% |

They lose less, and none of them reaches the 1% the tests ask for at a 10 ms step.

## Q2. Joint friction does not hold, and one setting makes it hold

The arm is released level and at rest, with joint friction of 12 N m against gravity's 7.84 N m. It should not move.

| | Shipped step | 1/16 of it | Solver steps that stopped |
|---|---|---|---|
| Shipped friction falloff (1e-3 rad/s) | Creeps at 411 micro-radians a second | 411 | 0 |
| Falloff 1e-6 rad/s | 0 | 0 | 0 |

The creep is exactly what the friction law's own formula gives for this load (411). That is 1.4 degrees a minute.
With the falloff speed a thousand times smaller the arm does not move, and the solver converges on every step.

## Q3. The setting changes nothing else

Driven with 3 N m against joint friction of 2 N m, the arm should reach 3.104 rad/s in a second. It reaches 3.033 at
the shipped step and 3.100 at 1/16 of it, and the same to four digits with the falloff at 1e-6 (at 1/16 of the step
3,100,041 against 3,100,074 micro-radians a second).

## What this says

- No patch is proposed for Q1. It is the cost of SuperDex's shipped integrator on the simplest jointed motion there
  is, at the shipped step. SuperDex says in its own documentation that it trades accuracy for stability, and offers
  the higher-order integrators above.
- For Q2 the remedy is one of SuperDex's own settings, `falloffVel` on the joint's friction.
- The benchmark scenes use viscous joint friction only, so Q2 does not touch them. Q1 does: their limbs swing at
  several radians a second.

Limits: one joint, one arm, no contact. Nothing here is against a real robot.
