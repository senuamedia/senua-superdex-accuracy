# Run 048: patch F reviewed, and the cause of T15 found

15 October 2026, on the Linux machine of runs 039 to 047, in a work folder of its own. Not registered: a review of
patch F's code, rig, measure and readings, and design probes. Study 11's registration records patch F as measured
(its rule F3 failed). Nothing here decides anything; a study that registers rules for it does. `INDEX.txt` lists
every file.

## The question

Study 11's F3 failed on T15: a 0.5 kg cube slipping on a 3 kg block should accelerate at Coulomb's 4,410 mm/s2, and at
the shipped step it read 4,224 with patch F and 4,392 without it. Study 11 read the difference as a cost of patch F.
Is patch F's code right, is the rig and the measure right, and what makes T15 short?

## What was done

- **The code.** Patch F's lines in `patches/senua_contact.patch` read against SuperDex's contact kernel at the upstream
  commit: the switch, the friction normal force, the step's own penalty force, the energy, the Hessian, viscous
  friction, its composition with patches A to C, contact damping, SuperDex's `implicitNormalForceForDissipation` and
  `explicitNormals`, every contact path (one kernel serves them all) and both precisions.
- **A probe library** (`probe_kp.patch` on library build 15): it prints, every step, the forces on the cube split into
  penalty, friction and damping. It makes all 40 plays of the pair byte for byte as library build 15 does
  (`t15/kp_same.txt`). A second probe library has patch F's lines removed (`noF.patch`), for a strict check that F off
  is no F.
- **The pair played again** (`probe_t15.sh`): stock, F alone, patches A to E, and A to F, at steps 1 to 1/16, on
  SuperDex's own grid distance field and with the grid cell at 1/32 of a body's side; controls with SuperDex's
  `explicitNormals`, with friction's fade off, on SuperDex's box collider, and at tolerances 1e-9 and 1e-12
  (`t15/controls.txt`); in 32-bit (`t15/plain32.txt`); under the full recommended configuration (`t15/full.txt`).
- **Every rule of patch F, F0 to F6, on probe numbers** under the recommended configuration (patches A to G, contact
  damping 5, friction falloff 0.03, tolerances 1e-4 and 1e-8, the grid cell at 1/32, Newton-Euler inertia on the
  benchmark): a first-suite cube of 1.25 kg, radius 0.045 m, friction 0.32; a pair of 3.2 kg, 0.27 m and 0.55 kg,
  0.032 m, friction 0.37; three more impact cubes; benchmark commands from seeds 91101 to 91103 (`actions/`). No
  registration uses these numbers. Read by the record's measuring program and suite runner (`measure_rules.sh`,
  `rules/reading.txt`).

## What it found

**Patch F has no defect.** Friction takes exactly the damping force the contact applies to the body, at the step's own
distance, with SuperDex's own mask, fade and padding; its energy, Hessian and viscous term are consistent with it; it
composes correctly with every switch and setting above, on every contact path, in both precisions. Measured on the
pair: friction over 0.45 times the normal force actually applied is 0.9989 to 1.0000 at every step from 1 to 1/16.

**T15 is SuperDex's default grid distance field.** On the block's top the cube's six bottom samples cross the block's
last grid node at 0.83 s (the default cell is 85 mm), where the field rounds the block's edge: the cube sinks from
-0.40 mm to -1.64 mm, its support falls from 4,900 to 3,884 mN and the contact force tilts backward. That happens the
same with and without patch F. On the 1/32 grid the cube stays at -0.40 mm, and every configuration reads 4,409 to
4,413 at every step; on SuperDex's box collider 4,409 to 4,412 (`t15/plain.txt`, `t15/bins.txt`).

| B, mm/s2, SuperDex's own grid | 1 | 1/2 | 1/4 | 1/8 | 1/16 |
|---|---|---|---|---|---|
| Stock | 4,402 | 4,274 | 4,237 | 4,223 | 4,216 |
| Patch F alone | 4,220 | 4,230 | 4,228 | 4,221 | 4,216 |
| Patches A to E | 4,392 | 4,259 | 4,229 | 4,220 | 4,215 |
| Patches A to F | 4,224 | 4,234 | 4,228 | 4,221 | 4,219 |

**Why stock reads near the law at the shipped step.** Stock takes friction's normal force from the start-of-step
distance, extrapolated along the current tilted gradient over about 9 mm of slip a step. On the rounded cell that is
up to 55% above the force applied: at step 87 friction's normal is 6,888 mN against 4,453 applied, and friction 2,898
against Coulomb's 2,004 mN. Summed over steps 83 to 89, stock's friction above Coulomb's gives the cube 33 mm/s more
speed, which is the whole gap between stock and patch F at the shipped step ((4,392 - 4,224) x 0.2 s = 33.6 mm/s). The
excess falls with the step (stock's largest friction over Coulomb's: 1.27 at step 1, 1.005 at 1/16), so at 1/16 stock
and patch F agree. Stock's near-right reading at the shipped step is one error hiding another; patch F removes the
first and so shows the second.

**The rig and the measure are right.** The pair rig builds the registered scene; the law 4,410 mm/s2 is mu times g
for the cube slipping on the block's flat top; the `accel` measure reads the window 0.7 to 0.9 s in mm/s2 along the
push. One limit that does not reach T15: `accel` takes the step in whole microseconds, so at 1/32 and 1/64 its window
moves by about 1 ms and the reading is about 0.16% high; T15 is read at 1 and 1/16 only.

**Run 027 re-read.** Study 11's runner on run 027's own files gives every rule line as recorded (16 held, F3 failed).

## Patch F's rules on probe numbers, under the recommended configuration

| Rule | Result |
|---|---|
| F0, safe when off | 13 of 13 comparisons byte for byte: no switch against stock, every switch set to 0, the recommended settings with no switch (67 of 67 suite files each); F unset under A to E and G against a build with F's lines removed (67 of 67); 9 of 9 benchmark streams |
| F1, required | T05 fails without F (2,568 down to 2,145 and up to 3,070, against 3,200): held. Its clause that the shipped step reads at most 8 tenths of the law failed on this cube (2,568 against 2,560); on the three further cubes stock reads 80.5%, 77.2% and 81.4% of the law. The clause measures how short stock falls on a given cube, not patch F |
| F2, correct | 3,199 to 3,200 at all seven steps, T10 3,199 to 3,200; the three further cubes within 1 in 1,000 at every step |
| F3, the suites | 1111111111 and 1111111; T15 3,626 and 3,625 against 3,626 (on SuperDex's own grid also 1111111, 3,608 and 3,605) |
| F4, the solver on the suites | No step stopped or diverged |
| F5, the benchmark | No step diverged; stops 8 with F against 4 without on `half_cheetah`, 1 against 22 on `ant`, 0 and 0 on `cart_pole` |
| F6, the other tests | 111111111 with and without F |

Study 11's own pair under the full recommended configuration with patch F reads 4,410, 4,410, 4,410, 4,410 and 4,409
at steps 1 to 1/16 (`t15/full.txt`).

## What it means

The 4.2% Study 11 read as a cost of patch F is SuperDex's default grid distance field, which the recommended
configuration already replaces (the grid cell at 1/32, Study 14's item 1). Patch F needs no change. A registration
that reads F1 should state "required" as T05 failing without F, since how far below 8 tenths stock falls depends on
the cube. These are probe readings: a study registered on fresh numbers decides them.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). This
run's play files were read again by the corrected program: 334 readings of the distance slid change, by at most 0.16%
(424,613 to 425,309 um), and nothing else. Patch F's rules read the stop's fastest speed and the distance come back,
which do not change, so every rule above reads as it did. The readings stay as printed.
