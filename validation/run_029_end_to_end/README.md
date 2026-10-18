# Run 029: the thirteenth registration, the complete patch list end to end

14 October 2026. Registered and committed before this run ([PREREGISTRATION_13.md](../../preregistrations/PREREGISTRATION_13.md)).
Library build 12. Every play under the final configuration, as the eleventh and twelfth registrations decided:
patches A to G with SuperDex's Newton-Euler inertia, contact damping 5 and a friction falloff of 0.03 m/s; stock
beside it where a rule compares with stock. Played by [`tools/plays/play_13.sh`](../../tools/plays/play_13.sh) and
measured by `measure/runners/sx_study13_run.sh`.

**Result: 65 rule readings of 68 held, with no value missing. J4, D6 and G2 did not hold, each on one reading.**

## How the run went

The registered play script gave the FR3 gripper the benchmark scenes' assets folder instead of SuperDex's
`superdex_physics/assets`, so its four plays did not run and twelve values were missing. That first reading is kept
as `reading_before_the_fr3_plays.txt`. The path was fixed, with no rule or parameter changed, the four FR3 plays were
then made once, and every rule was measured again: `reading.txt`. Every other play is the registered run's.

## What held

| Group | What was played | Held | Measured |
|---|---|---|---|
| C0 | The configuration | yes | patches F and G both in, as both decisions said |
| E0 | Safe when off | yes | [run 025](../run_025_identity/): 362 of 362 files identical |
| K1 to K3 | Both contact suites, the seventh registration's cubes | yes | first suite 1111111111 (T05: 3500 3500 3499 3499 3500 3499 3499 against 3,500), second 1111111; no step stopped or diverged |
| J1, J2, J3, J5 | The sixth registration's arm | yes | a free arm keeps 9,999.9 per 10,000; a driven arm 4,656,274 against 4,656,457; joint friction holds as stock (-411); no step stopped |
| L1 to L4 | The eighth registration's limit runs | yes | at rest -303,744 and -303,741 (band -303,778 to -303,704); released at 1,423,020 and 367,995 (answers 1,434,131 and 369,401); lifted off; no step stopped |
| R1 | The ninth registration's rotations | yes | 40 of 40 |
| P1, P2 | A cube on the point-cloud floor | yes | below |
| D1 to D5, D7, D8 | Deformable bodies | yes | below |
| G1, G3 to G5 | The gripper | yes | below |
| B1, B2 | The benchmark on fresh commands, shipped step | yes | final configuration against stock, stopped of 21,600: `half_cheetah` 2 and 3, `ant` 0 and 231, `cart_pole` 0 and 0; none diverged |

## What did not

| Rule | Reading | Why |
|---|---|---|
| J4 | The slip test at the shipped step read 3,104,079 against stock's 3,032,560 | It moved to its right answer, 3,104,308, as in the twelfth registration (G8). The rule asked for stock's value |
| D6 | On the tilted floor the soft cube's centre moved 0.372 and 0.371 mm, against the stick distance of 0.3 mm | It stops: its speed at the end is 0, against stock's creep of 3,984 um/s. The cloth patch moved 0.12 mm. A soft cube also leans under the tilted load, and its centre moves with the lean |
| G2 | Stock, FR3 hand: each finger carried 743,356 and 726,357 uN against 735,000 | As shipped, the creeping cube shared its weight unevenly between the FR3's fingers, one carrying 1.14% more than half and the other 1.18% less. With the final configuration the two read 734,759 and 734,453 |

## The three areas tested for the first time

Point-cloud contact, a cube of 1.6 kg on a held cloth sheet (law: 3,500 per 10,000):

| | Stock | Final configuration |
|---|---|---|
| Friction over the impact, shipped step and 1/4 | 13,225 and 3,581 | 3,662 and 3,632 |
| Friction while sliding | 1,824 (and the cube almost stopped) | 3,623 |
| Pushed with 0.6 of what friction holds: speed | 3,598 um/s | 0 |
| Pushed with 1.2 of it: mean speed, against the predicted 881,000 um/s | 428,700 | 754,600 |
| The floor carries the weight (15,680 mN) | | 15,683 |

Deformable bodies, stock unless said: falls within 108 nm (rod and strip) and 3,067 nm (soft body) of backward
Euler's own drop; the rod, strip and bar hang within 0.11%, 0.11% and 0.15% of their right answers; the cantilever
sags 5.965, 6.160 and 6.259 mm at 32, 64 and 128 elements against the textbook 6.350 mm; slides stop within 1 in 100
of backward Euler's distance, stock and final; on the tilted floor stock creeps at 3,977 to 3,984 um/s against its
law's 3,986, and the final configuration stops.

The gripper, a cube of 0.15 kg held with 8 N a finger: each finger presses 8.000 N in all four plays; stock lets the
cube creep out at 1.11 mm/s (hand-built) and 0.68 mm/s (FR3); the final configuration holds it, 0 creep and 35
micrometres of slip.

Files: `reading.txt`, `reading_before_the_fr3_plays.txt`, `configuration.txt`, `runs/` (every play's output, with the
solver's trace where kept).

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the thirteenth registration) changes in 12 numbers: the distance slid by
at most 0.18% (117,945 to 118,155 um), the distance come back by at most 3 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
