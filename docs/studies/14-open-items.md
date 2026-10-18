# Study 14: the fixes for the five open items, and two configurations end to end

| | |
|---|---|
| Registration | Fourteenth: [PREREGISTRATION_14.md](../../preregistrations/PREREGISTRATION_14.md) |
| Question | Does each fix found for the five open items hold on parameters the probes did not use, and does the configuration with every fix still pass every earlier test? |
| Outcome | 142 rule lines of 150 held; 45 rules of 50. Items 1, 2, 3 and 5 hold on every rule; item 4 read 0.103% to 0.120% over the textbook, above its bound of 0.1% (two rules, I4a and I4c, three rule lines). Three rules on deformable bodies failed, five rule lines: D4 on stock at 0.001 s and on the final configuration at both steps, D6 on the final configuration, A5 on the accurate configuration. So neither decision fired: items 1 to 4 do not join the recommended configuration by this registration (I4, D4 and D6 failed), and the accurate configuration is not recommended by it (A5 failed). The causes of all eight failed lines were probed after the run and put to the [fifteenth registration](15-replication.md) |
| Registered | 14 October 2026, committed and pushed before any run of this registration existed |
| Result | [Run 032](../../validation/run_032_open_items/README.md), 14 October 2026 |
| Runs | [030](../../validation/run_030_design_probes/), design probes; [031](../../validation/run_031_identity/), safe when off; [032](../../validation/run_032_open_items/), the registered runs |
| Data | [`validation/run_032_open_items/`](../../validation/run_032_open_items/), [`actions/14/`](../../actions/14/) |
| Played by | the rigs in [`tools/`](../../tools/), [`tools/plays/play_14.sh`](../../tools/plays/play_14.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx), `measure/runners/sx_study14_run.sh` |

Previous: [Study 13](13-end-to-end.md). Next: [Study 15](15-replication.md). All studies: [index](README.md).

## Why it was asked

Study 13 played the patch list end to end and held 65 of its 68 rule lines; its decision to record the list as
validated end to end did not fire. After it, five items were open: a light cube slipping 4% short on one pair,
patch G's tolerance error, a ripple on point-cloud contact, a cantilever short by half an element, and backward
Euler's damping of a swing a force drives. Each was to be fixed, not listed.

## The causes, from the probes

| Item | Cause | Fix |
|---|---|---|
| 1 | SuperDex sizes a mesh's grid distance field from its mean edge: 6 cells a side for a 12-triangle cube, 85 mm on that block. Within the last cell before an edge the field rounds the edge, and the cube had reached it | The grid cell set explicitly to 1/32 of each mesh body's side (SuperDex's `GridSdfParams`) |
| 2 | The solver stops on its relative tolerance after one iteration, and with patch G the Newton matrix is not exact | SuperDex's tolerances at 1e-4 absolute and 1e-8 relative |
| 3 | The cube on the sheet was read through its own default grid (item 1's cause), and contact damping acted where its edges passed over sheet nodes within the 5 mm smoothing | Item 1's cell, and a smoothing half-distance of 1 mm on a body that meets a point cloud |
| 4 | The rig held the rod's first two nodes from x = 0, so it was stiff to the middle of its first element | The held element across the clamp: a correction to the rig |
| 5 | Backward Euler's own damping; and every SuperDex integrator carries the defect patch G corrects, while patch G was derived for backward Euler | Patch G scaled by each integrator's share (library build 13), and a second configuration: BDF2 at 1/16 of the step |

For item 5 there is no single answer at the shipped step. Under BDF2 a dropped cube rebounds up to 15% of its
drop at the coarse steps, where backward Euler's impacts are nearly dead and close to the resolved answer (0.3% to
0.8% of the drop, run 030). Both a fast swing and an impact are right by 1/16 of the step under BDF2.

## The result

142 rule lines of 150 held, 45 of the 50 rules ([run 032](../../validation/run_032_open_items/)).

| Item | Rule lines held | What was measured |
|---|---|---|
| 1 | 9 of 9 | With the cell at 1/32, the cube and the block within 1 in 100 of their laws at both steps on three pairs (the eleventh's at 1/16: 4,409 against 4,410 mm/s2) |
| 2 | 5 of 5 | The twelfth registration's arm within 1 in 10,000 at every speed and step; its free chain's energy within 1 in 1,000, momentum within 100 parts per million |
| 3 | 16 of 16 | The point-cloud floor within 1 in 100 on sliding friction and rest, within 1 in 25 on friction over the impact (at most 1.7% over), a slip at 95 in 100 of its speed or more, at the shipped step and under BDF2 |
| 4 | 6 of 9 | The half-element shortfall measured and gone; across the clamp the sag read 0.10% to 0.12% over the textbook, above the 1 in 1,000 allowed |
| 5 | 11 of 11 | Under BDF2 with patch G a pendulum keeps 9,986, 9,969 and 9,958 per 10,000 of its first three swings at the shipped step; a free spin keeps at least 999 in 1,000 of its speed at every step (the rule bounds it from below only; at 1/16 it gained 0.29%, 4,011,464 against 4,000,000 micro-radians a second); a swinging chain keeps its energy within 1 in 100 at 1/4 and 1 in 200 at 1/16; backward Euler loses more |

End to end, the final configuration held every rule of both contact suites, the arm, the limits, the rotations, the
point-cloud floor, the gripper and Meta's scenes on fresh commands (`ant`: 0 steps stopped of 21,600, stock 199).
On the deformable bodies D4 and D6 failed under it. BDF2 at 1/16 held 58 rule lines of 59, with no step stopped of
345,600 on any of Meta's scenes; A5 failed on a slide.

## What the decisions record

- **Items 1 to 4 join the recommended configuration** only if their rules (I1 to I4) hold and every rule of the
  final configuration end to end holds. I4a and I4c failed, and D4 and D6 failed under the final configuration, so
  this decision did not fire: items 1 to 4 do not join the recommended configuration by this registration. Items 1,
  2 and 3 held every rule of their own.
- **The accurate configuration is recommended** only if I5 and every A rule hold. I5 held, 11 lines of 11; A5
  failed, so this decision did not fire either.
- Each failed rule is recorded as measured, and its item stays open.

## The eight rule lines that failed, and why

The eight are five rules: I4a (two lines), I4c, D4 (three lines), D6 and A5. All three causes were probed after the
run ([probes after run 032](../../validation/run_032_open_items/probes/)).

- **Item 4 (I4a, I4c).** The 0.1% is SuperDex's shipped solver tolerance stopping the solve short of a static elastic
  equilibrium: run 032 played the cantilever at the shipped tolerances. At 1e-9 and 1e-12 (where the solver reports
  every step stopped after at most 4 iterations, within 5 nm of the plays at 1e-6 and 1e-10) the rods come within
  0.005% to 0.023% of the textbook; at the final configuration's tolerances, within 0.001% to 0.021%.
- **Deformable slides (D4, A5).** Every slide stopped within 1 in 100 of its distance, read where it stopped. Then
  the soft cube's centre comes back 0.4 to 0.9 mm. As it slows it pitches forward on SuperDex's compliant
  deformable contact (its rear corner lifts, its centre leads its base by 0.42 to 0.73 mm), and after the stop it
  rocks back onto its base. Under stock the base stays where it stopped. Under the patches it comes back by patch
  C's stick distance, as the cloth does. The rule read the end of the play.
- **The tilted floor at the fine step (D6).** The soft body's contact held within the stick distance, and it ends
  where it ends at 0.01 s, 0.2 micrometres apart. Its end speed is its own swing about that place, which backward
  Euler damps less at 0.001 s.

All three are put to the [fifteenth registration](15-replication.md), with the rules reading what each test is about.
The probes also found a defect in this registration's accurate configuration. At SuperDex's shipped tolerances BDF2
with patch G gains energy as the step shrinks, too slowly to show in these 2 s and 3 s plays. The fifteenth
registration's amendment moves it to the final configuration's tolerances and plays every accurate play of this
registration again.

## What it does not show

Anything on 32-bit arithmetic: every reading is 64-bit. Gradients through the patches: none were tested (see
[what the patches do not cover](../patches.md#what-the-patches-do-not-cover)).
