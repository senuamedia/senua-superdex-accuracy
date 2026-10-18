# Run 032: the fourteenth registration, the five open items and two configurations end to end

14 October 2026. The second run of [PREREGISTRATION_14.md](../../preregistrations/PREREGISTRATION_14.md), whose
first, [run 031](../run_031_identity/), is its rule E0; registered and committed before any of it was played.
Library build 13 (sha256 dbd8cf9b7553e3d1...), safe when off by [run 031](../run_031_identity/). Played by
[`tools/plays/play_14.sh`](../../tools/plays/play_14.sh) from the repository root, one play after another; measured
by `measure/runners/sx_study14_run.sh`, every rule judged by Simplex. `reading.txt` is the measuring's own output.

**Result: 142 rule lines of 150 held, 45 rules of 50; no value was missing.** Items 1, 2, 3 and 5 hold on every
rule. Item 4 fails one bound. Three rules on deformable bodies fail: D4 on stock and under the final configuration,
D6 under the final configuration and A5 under the accurate one.

## By item

| Item | Rules | Held | What was measured |
|---|---|---|---|
| 1. The light cube's slip | I1a to I1d | 9 of 9 | SuperDex's own grid: 4,216 mm/s2 at 1/16 (the law 4,410), right until the cube reaches the last cell. Each cube's cell at 1/32 of its side: the cube and the block within 1 in 100 of their laws at both steps, on the eleventh, the seventh and a fresh pair (the eleventh at 1/16: 4,409) |
| 2. Patch G's tolerance | I2a, I2b | 5 of 5 | Absolute 1e-4, relative 1e-8: the twelfth registration's arm keeps its speed within 1 in 10,000 at every speed and step; its free chain its energy within 1 in 1,000 and its momentum within 100 parts per million |
| 3. The point-cloud floor | P1, P2, A4 | 16 of 16 | Each cube's cell at 1/32 and 1 mm smoothing: rest, lift, hold, sliding friction within 1 in 100, a slip at 95 in 100 of its speed or more, friction over the impact within 1 in 25, at the shipped step and under BDF2 at 1/16 |
| 4. The cantilever | I4a to I4c | 6 of 9 | Held from x = 0, both rods fall short by the half-element prediction (I4b, 4 of 4). Held across the clamp, both rods are within 1 in 200 at 32 elements but read 0.10% to 0.12% over the textbook at 64 and 128, above the 1 in 1,000 allowed (I4a, I4c) |
| 5. A driven swing | I5a to I5d | 11 of 11 | BDF2 without patch G loses speed; with patch G's share a free spin keeps 999 in 1,000 at every step, the pendulum's swings stay within 9,950 to 10,010 per 10,000 at the shipped step (9,986, 9,969, 9,958), the swinging chain keeps its energy within 1 in 100 at 1/4 and 1 in 200 at 1/16, and backward Euler loses more; under BDF2 an impact at the coarse steps rebounds |

## End to end

| Group | Held | |
|---|---|---|
| E0 | 2 of 2 | [Run 031](../run_031_identity/): 406 of 406 files identical |
| K (both contact suites, final) | 3 of 3 | 10 of 10 and 7 of 7, no step stopped |
| J, L, R (arm, limits, rotations, final) | 14 of 14 | The slip test at its right answer (J4) |
| D (deformable bodies) | 11 of 15 | D4 and D6 fail, below |
| G (gripper, final) | 8 of 8 | |
| B (Meta's scenes, final, fresh commands) | 6 of 6 | `ant` stopped 0 steps of 21,600 (stock 199), `half_cheetah` 9 (stock 3), `cart_pole` 0 |
| A1 to A7 (BDF2 at 1/16) | 58 of 59 (A4's seven rules are also counted under item 3) | Both suites at 1/16, the arm and chain, the limits, the cloud floor, the gripper, Meta's scenes (0 steps stopped of 345,600 on each); A5 fails on a slide |

## The eight rule lines that failed (five rules)

- **I4a (two readings) and I4c.** Held across the clamp, the sag converges to 0.10% to 0.12% above w L^4 / (8 EI)
  for both rods, where the run 030 probe's rod converged to 0.012% below. The half element is gone; what is left is
  SuperDex's shipped solver tolerance stopping the solve short of a static equilibrium, found by the probes after the
  run ([probes/](probes/)). Item 4 stays open.
- **D4 (three readings) and A5.** On the fresh floor (friction 0.45, 0.7 m/s) the cloth's slides stop at backward
  Euler's distance, but the soft cube's fall short of it, 0.86% to 1.65%, under stock as under the final configuration (the three failed readings 1.53% to 1.65%), and
  1.9% short of Coulomb's distance under BDF2. The rule's right answer is a rigid body's; at the thirteenth
  registration's floor numbers the soft cube came within it. Every slide stopped within 1 in 100 of its distance; the
  soft cube pitches forward on its contact while it slows and its centre rocks back after the stop
  ([probes/](probes/)).
- **D6 (one reading).** On the tilted floor at 0.001 s the soft cube's contact held within the stick distance, but
  the body ended at 15 micrometres a second against the 10 allowed: its own elastic ringing, which backward Euler
  damps less at the finer step.

## Files

`reading.txt` (every measured line and rule), `runs/` (every play, its statistics, and the solver's trace of the
benchmark and gripper plays, compressed with gzip), [`../../actions/14/`](../../actions/14/) (the commands).

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the fourteenth registration) changes in 18 numbers: the distance slid by
at most 0.18% (117,949 to 118,159 um), and the 0.625 ms grip's creep by 0.05%, the distance come back by at most 3 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
