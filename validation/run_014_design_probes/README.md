# Run 014: design probes for the sixth registration (joints)

Made on 14 October 2026 to design the sixth registration ([PREREGISTRATION_06.md](../../preregistrations/PREREGISTRATION_06.md)). These
are not registered data. Stock SuperDex, one arm on one revolute joint with nothing touching it
(`tools/sdx_joint.cpp`); the probe arm is 1 kg, 0.5 m from the joint, which is not the registered arm. `probe.txt`
is the output as produced.

## What it showed

**A free arm slows down by itself.** Released spinning with no gravity and no friction, its speed a second later:

| Released at 4 rad/s | 10 ms | 2.5 ms | 0.625 ms | 0.156 ms |
|---|---|---|---|---|
| Backward Euler (shipped) | 3.483 | 3.849 | 3.961 | 3.998 |
| Second-order integrator | 3.797 | 3.947 | 3.987 | 4.003 |
| Third-order integrator | 3.866 | 3.965 | 4.009 | 4.002 |

At the shipped step with the shipped integrator, the speed left after one second is 99.0% at 1 rad/s, 96.2% at 2,
87.1% at 4 and 66.3% at 8.

**A driven arm gains less than its inertia says.** 1 N m for 1 s should give 3.9735 rad/s:

| | 10 ms | 2.5 ms | 0.625 ms | 0.156 ms |
|---|---|---|---|---|
| Backward Euler (shipped) | 3.826 | 3.935 | 3.964 | 3.973 |
| Second-order integrator | 3.918 | 3.960 | 3.972 | 3.974 |
| Third-order integrator | 3.939 | 3.965 | 3.975 | 3.974 |

**A pendulum loses its swing.** Released level, each swing in parts per 10,000 of half a turn (right answer 10,000):
backward Euler 9,161, 7,747, 6,737 at the shipped step and 9,988, 9,965, 9,942 at 1/64; the third-order integrator
9,856, 9,574, 9,319 at the shipped step. `probe.txt` holds no free-pendulum block: this output was not kept, so
these numbers are as noted at the time and cannot be checked from the record.

**Joint friction does not hold.** Held level by joint friction of twice gravity's torque, the arm creeps at 293
micro-radians a second, which is the friction law's own 0.2929 of its falloff speed, at the shipped step and at
1/16 of it. With the falloff speed at 1e-4, 1e-5 and 1e-6 rad/s (shipped: 1e-3) the creep is 29, 3 and 0. At 1e-6
the solver still takes 3 iterations, and a swinging arm with joint friction swings as with the shipped falloff to
within one part in 10,000 (at 1/16 of the step 8,195, 4,925, 2,126 against 8,195, 4,926, 2,126; at the shipped step
the first two swings are the same, and only the tight falloff's line records a third).

**A joint limit with no damping rings by an amount set by the step**, as the ground does. The two limit blocks of
`probe.txt` set the limit on the wrong component, so the limit acted at angle zero; what they show is its spring
ringing, with 27% lost a swing at the shipped step and 0.5% at 1/64. The benchmark scenes set damping on their
joint limits.
