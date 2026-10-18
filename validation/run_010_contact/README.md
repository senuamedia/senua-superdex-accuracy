# Run 010: the fourth registration, part A. The smallest contact scene

Run once on 14 October 2026 for [PREREGISTRATION_04.md](../../preregistrations/PREREGISTRATION_04.md). One rigid cube (2 kg, half-size
0.04 m) and the ground, played by `tools/contact_all.sh`; the 80 runs are in [`../../contact/`](../../contact/) with
their checksums. `reading.txt` is every measured line and the verdict, as produced. `stats.txt` is the solver's own
status of every run.

## Result: every rule held

| Rule | Result |
|---|---|
| **K0a** control: nothing touches the cube | Held. Each gap is 5,000 to 5,002 parts in 10,000 of the one before |
| **K0b** control: steady sliding | Held. Friction over normal force 0.4000 and 0.4001 |
| **K1** the step sets the bounce | **Held** |
| **K2** Coulomb at impact | **Held** |
| **K3** no stick | **Held** |
| **K4** the smallest scene's chain | **Held** |
| **L1** the benchmark link ([run 011](../run_011_counts/)) | **Held** |

Steps are 10 ms, the benchmark scenes' shipped step, and six halvings of it.

## K1. The step sets the bounce

The cube is dropped 0.08 m with no friction. SuperDex's contact force comes from an energy and nothing in it loses
any, so the exact motion returns the cube to the height it was dropped from: 10,000 parts in 10,000.

| Rebound per 10,000 of the drop height | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| SuperDex as shipped (backward Euler) | 0 | 8 | 353 | 1,307 | 3,080 | 5,264 | 7,148 |
| SuperDex's own third-order integrator | 2,443 | 3,014 | 6,846 | 9,005 | 9,813 | 9,973 | 9,996 |
| Shipped integrator, contact damping 5 (reported) | 0 | 0 | 0 | 0 | 14 | 40 | 57 |

At the shipped step the cube keeps none of its impact energy. At 1/64 of that step it keeps 71%. SuperDex's own
third-order integrator reaches 99.96%, which is the right answer for SuperDex's own contact law. So the shipped
contact has no loss of its own, and how much a body bounces is decided by the time step.

With a contact loss (SuperDex's own damping coefficient, shipped at zero), the bounce is within 57 parts in 10,000
at every step.

## K2. Friction during an impact is short of Coulomb's law

The same drop with 4 m/s sideways and friction 0.4, rotation held. The cube slides through the whole impact, so the
horizontal speed it loses must be 0.4 times the vertical speed the ground gives it: 4,000 parts in 10,000.

| Friction impulse over normal impulse, per 10,000 | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| SuperDex as shipped | 2,203 | 2,336 | 2,224 | 3,032 | 3,164 | 3,372 | 3,598 |
| With `implicitNormalForceForDissipation` | 4,000 | 3,999 | 4,000 | 3,999 | 3,999 | 4,000 | 4,000 |
| Contact damping 5 (reported) | 2,207 | 2,364 | 1,937 | 2,371 | 1,578 | 1,560 | 1,339 |
| Contact damping 5 with the implicit switch (reported) | 2,417 | 2,455 | 2,240 | 1,890 | 1,765 | 1,511 | 1,426 |

As shipped, friction delivers 55% of what Coulomb's law requires at the shipped step and 90% at 1/64 of it. The
shipped code computes friction from the normal force at the start of the step. SuperDex's own switch for using the
force of the step being solved gives the right answer at every step.

The two reported rows show a second departure. With contact damping on, friction is far short again, and the
switch does not restore it: the friction force is computed from the penalty part of the normal force, and the
damping part is left out.

## K3. No friction switch gives a stick

The cube rests on the ground with friction 0.5, which can hold 9.8 N, and is pushed sideways with 5.88 N. It should
not move.

| Setting | Creep, micrometres a second |
|---|---|
| Shipped (its law predicts 3,675) | 3,670 |
| C-infinity friction law (predicts 3,750) | 3,742 |
| Implicit normal force | 3,670 |
| Explicit normals | 3,670 |
| No fading | 3,670 |
| Armijo line search | 3,670 |
| Falloff speed 0.001 (shipped 0.01) | 367 |
| Viscous friction 100 | 1,559 |

Under every switch the cube creeps, at the speed the friction law's own formula gives. Lowering the falloff speed
lowers the creep in proportion and does not remove it.

## K4. The benchmark's failure, in the smallest scene

The drop with 1.5 m/s sideways and friction 0.4, played for a second. Each step against the next finer one: the
summed difference of the cube's height, in micrometres, from the coarsest gap to the finest.

| | 1 to 1/2 | 1/2 to 1/4 | 1/4 to 1/8 | 1/8 to 1/16 | 1/16 to 1/32 | 1/32 to 1/64 |
|---|---|---|---|---|---|---|
| Shipped | 21,560 | 23,587 | 76,841 | 270,334 | 734,510 | 1,279,314 |
| Contact damping 5 | 20,144 | 10,494 | 5,832 | 3,425 | 2,199 | 1,359 |
| The cube never reaches the ground | 1,237,250 | 618,600 | 309,300 | 154,650 | 77,321 | 38,667 |

With the shipped contact the differences grow sixty-fold as the step shrinks. That is `half_cheetah`'s failure,
with one cube and nothing else. With a contact loss they fall at every step. With nothing to hit they halve,
each gap 5,000 to 5,002 parts in 10,000 of the one before (K0a), which is what a first-order integrator should do.

## What this says

- The cause of the second registration's time-step failure is in SuperDex's contact as shipped: it has no loss of
  its own, so the time step decides the outcome of every impact. A smaller step, the setting offered for accuracy,
  moves the physics toward a perfectly elastic bounce instead of refining one answer.
- Friction during an impact departs from Coulomb's law in the shipped code path, and one of SuperDex's own
  switches corrects it.
- No friction setting SuperDex ships holds a body at rest under a load.

Limits: one cube, one ground, one drop. A simulator against its own right answers, and nothing against a real
robot.
