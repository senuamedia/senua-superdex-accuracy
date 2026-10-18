# Study 13: the complete patch list, end to end

| | |
|---|---|
| Registration | Thirteenth: [PREREGISTRATION_13.md](../../preregistrations/PREREGISTRATION_13.md) |
| Question | Do the corrections hold together on every earlier test, and do they carry over to point-cloud contact, deformable bodies and a gripper? |
| Outcome | 65 rule lines of 68 held; J4, D6 and G2 each failed on one reading, so the decision that records the patch list as validated end to end did not fire, and each failure is recorded as measured. Under the final configuration both contact suites, the arm, the joint limits and the rotations passed their rules but J4: the joint-friction slip, asked to read as on stock, moved to within 1 in 10,000 of its right answer. On point-cloud contact and on the gripper every rule of the final configuration held; G2 failed on stock's FR3 hand. On deformable bodies every rule held but D6: under the final configuration the soft cube on the tilted floor stopped but moved 0.37 mm, past the 0.3 mm allowed. On fresh commands `ant` stops 0 steps against stock's 231 |
| Registered | 14 October 2026, committed and pushed before any run of this registration existed |
| Result | [Run 029](../../validation/run_029_end_to_end/README.md), 14 October 2026 |
| Runs | [023](../../validation/run_023_design_probes/) and [024](../../validation/run_024_design_probes/), design probes; [025](../../validation/run_025_identity/), safe when off; [029](../../validation/run_029_end_to_end/), the registered runs |
| Data | [`validation/run_029_end_to_end/`](../../validation/run_029_end_to_end/), [`actions/13/`](../../actions/13/) |
| Played by | [`tools/sdx_contact.cpp`](../../tools/sdx_contact.cpp), [`tools/sdx_pair.cpp`](../../tools/sdx_pair.cpp), [`tools/sdx_joint.cpp`](../../tools/sdx_joint.cpp), [`tools/sdx_rotvec.cpp`](../../tools/sdx_rotvec.cpp), [`tools/sdx_deform.cpp`](../../tools/sdx_deform.cpp), [`tools/sdx_grip.cpp`](../../tools/sdx_grip.cpp), [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp), [`tools/plays/play_13.sh`](../../tools/plays/play_13.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx), `measure/runners/sx_study13_run.sh` |

Previous: [Study 12](12-joint-motion.md). Next: [Study 14](14-open-items.md). All studies: [index](README.md).

## Why it was asked

Each patch was validated in its own study, on its own question. A user takes them together. This study plays the
final configuration through every earlier known-answer test, and through the three areas that had not been tested:
SuperDex's point-cloud contact (the path shells and rods are met through), its deformable bodies, and a gripper
holding an object, the smallest dexterous scene.

## The rules

Thirty-odd rules in ten groups in [PREREGISTRATION_13.md](../../preregistrations/PREREGISTRATION_13.md). The final configuration
follows the eleventh and twelfth registrations' decisions on patches F and G. In short:

| Group | It holds when |
|---|---|
| C0, E0 | The final configuration is played as those decisions say, and the library is safe when off on every file of the nine identity parts |
| K1 to K3 | Both contact suites pass every test (the first all ten with patch F in), and no step of either stops or diverges |
| J1 to J5 | With patch G a free arm keeps at least 9,900 per 10,000 of its speed and a driven arm is within 1 in 100; joint friction holds and slips as on stock; no step stops or diverges |
| L1 to L4 | The eighth registration's three limit tests pass, and no step stops or diverges |
| R1 | All 40 rotation vectors are right |
| P1, P2 | On the point-cloud floor stock departs from the law; the final configuration carries the weight, holds, slides, slips and meets the impact within its bounds, with no step stopped or diverged |
| D1 to D8 | Deformable bodies: they fall, hang and sag as their right answers say; slides stop within 1 in 100 of backward Euler's distance, stock and final; stock creeps on a tilt at its law's speed, and the final configuration there ends with no speed above 10 micrometres a second, moved no more than the stick distance (0.3 mm); bodies set down come to rest; no step stops or diverges |
| G1 to G5 | Each finger presses with the commanded force and carries half the weight, within 1 in 100, both grippers, stock and final; stock lets the cube creep out; the final configuration holds it; no step stops or diverges |
| B1, B2 | On fresh commands under the final configuration no step diverges and no more than 1 in 1,000 stop, on each scene |

If the rules hold, the patch list is recorded as validated end to end, and the three new areas as tested. If a rule
fails, it is recorded as measured.

## The result

65 rule lines of 68 held, with no value missing ([run 029](../../validation/run_029_end_to_end/)).

| | Stock | Final configuration |
|---|---|---|
| First contact suite (ten tests), the seventh registration's cubes | 6 of 10 | 10 of 10 |
| Second contact suite (seven tests) | 6 of 7 | 7 of 7 |
| A free arm: speed kept after 1 s at the shipped step, per 10,000 | 9,208 | 9,999.9 |
| A joint limit: at rest, released, lifted off | 1 of 3 | 3 of 3 |
| Point-cloud floor: friction over an impact, per 10,000 (law 3,500) | 13,225 | 3,662 |
| Point-cloud floor: a cube pushed below the friction limit | creeps at 3.6 mm/s | holds |
| Cloth and soft cube on a tilted floor | creep at 4.0 mm/s | stop (speed 0 at the end); the soft cube's centre moved 0.37 mm, past the 0.3 mm stick distance, so D6 failed |
| A gripper holding a cube at 8 N a finger | the cube creeps out at 0.7 to 1.1 mm/s | holds |
| `ant` on fresh commands: solver steps stopped, of 21,600 | 231 | 0 |

The Stock column's first four rows are the stock readings of the earlier studies' runs, on the same plays: both
contact suites from [run 021](../../validation/run_021_rotation/) (Study 9, stock on the seventh registration's
cubes), the free arm from [run 015](../../validation/run_015_joints/) and the joint limit from [run
019](../../validation/run_019_limits/). The other stock readings, and every reading of the final configuration, are
run 029's.

**The run.** The registered play script gave the FR3 gripper the wrong assets folder, so its four plays did not run
in the first pass. With the path set right and no rule changed, those four plays were made once and the rules
measured again; the first reading is kept beside the second.

**What did not hold.** J4: the joint-friction slip test at the shipped step read 3,104,079 micro-radians a second
against stock's 3,032,560, outside the 1 in 100 the rule allowed; its right answer is 3,104,308, so it moved to
within 1 in 10,000 of it, as in Study 12. D6: on the tilted floor the soft cube stops (no speed at the end), but its
centre moved 0.372 and 0.371 mm, more than the 0.3 mm stick distance; the cloth moved 0.12 mm. The run's README
reads this, after the run, as the soft cube leaning under the load. G2: as shipped the FR3's two fingers shared a
creeping cube's weight unevenly, 743,356 and 726,357 micronewtons against half the weight's 735,000: 1.1% and 1.2%
off, against the 1 in 100 allowed; with the corrections, 734,759 and 734,453, within 0.1%.

## What it means

The registration records the patch list as validated end to end, and the corrections as carrying over to the three
new areas, only if every rule holds. J4, D6 and G2 failed, so that decision did not fire, and each is recorded as
measured. What held, rule by rule:

- **Every earlier test but one rule.** Under the final configuration both contact suites pass every test with no
  step stopped or diverged (K1 to K3); the free and the driven arm, joint friction's hold and the arm's solver pass
  (J1, J2, J3, J5); the joint limits pass (L1 to L4); every rotation vector is right (R1). J4 failed, as above.
- **Point-cloud contact.** Stock departs from the law (P1), and the final configuration met every rule (P2).
- **The gripper.** Every rule of the final configuration held (G1, G2, G4, G5), and stock lets the cube creep out
  (G3). G2 failed on stock's FR3 hand only.
- **Deformable bodies.** Every rule held but D6 (D1 to D5, D7, D8). Under the final configuration the soft cube on
  the tilted floor stopped but moved more than the stick distance, so the corrections are not recorded as carrying
  over to deformable bodies.
- **Fresh commands.** The solver converges on every step of `ant` on commands it has never seen (B1, B2), against
  stock's 231 stopped steps.

## What it does not show

Anything against a real robot: no software test stands in for it. Point-cloud contact keeps a ripple of its own
(friction 4.6% over the law and a slip at 86% of its speed, on a sheet with a node every 10 mm); a finer sheet was not
tested.
