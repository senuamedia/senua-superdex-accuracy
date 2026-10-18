# Study 11: friction at an impact, given the normal force of the step being solved

| | |
|---|---|
| Registration | Eleventh: [PREREGISTRATION_11.md](../../preregistrations/PREREGISTRATION_11.md) |
| Question | Can friction reach an impact on time without making the solver diverge, and does anything else get worse? |
| Outcome | 6 rules of 7 held, 16 rule lines of 17. Friction over an impact is within 1 in 1,000 of Coulomb's law at every step (the rule's bound: 1 in 100), the solver keeps converging, and patch F joins the recommended configuration, as the decision fixed in advance says. F3 did not hold: the second suite's T15, a light cube's slip on the registered pair, fails. At 1/16 of the step the slip falls short with and without patch F; at the shipped step it reads outside its band with patch F and inside it without. The cause is SuperDex's default grid distance field, not patch F, whose code has no defect and which needed no change (runs 030 and 048); on the recommended configuration's grid the slip reads the law at every step |
| Registered | 14 October 2026, with the tenth and twelfth registrations, committed and pushed before any run of this registration existed |
| Result | [Run 027](../../validation/run_027_friction/README.md), 14 October 2026 |
| Runs | [022](../../validation/run_022_design_probes/) and [023](../../validation/run_023_design_probes/), design probes; [025](../../validation/run_025_identity/), safe when off; [027](../../validation/run_027_friction/), the registered runs |
| Data | [`validation/run_027_friction/`](../../validation/run_027_friction/) (both suites, the benchmark's statistics and traces), [`streams/11/`](../../streams/11/) |
| Played by | [`tools/sdx_contact.cpp`](../../tools/sdx_contact.cpp), [`tools/sdx_pair.cpp`](../../tools/sdx_pair.cpp), [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp), [`tools/plays/play_11.sh`](../../tools/plays/play_11.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx) (the suites' measures, `rule`), `measure/runners/sx_study11_run.sh` |

Previous: [Study 10](10-ant-stops.md). Next: [Study 12](12-joint-motion.md). All studies: [index](README.md).

## Why it was asked

Every study since the fourth found it: over the step in which a sliding cube lands, SuperDex's friction is short of
Coulomb's law. The recommended configuration passed nine of the contact suite's ten tests and failed that one
(T05). It was on the open list.

## The cause, and the correction

Friction is scaled by the penalty force at the start-of-step distance, which is still open over the step in which a
body lands. Patch F gives Coulomb friction alone the whole normal force of the step being solved, leaves contact
damping and viscous friction on the start-of-step force, and gives friction SuperDex's own fitted Hessian. The
probes found the last part necessary: with anchored friction's exact Hessian `ant` diverged on 4 steps of 21,600,
and with the fitted one it had no stopped step at all.

## The rules

Seven rules, F0 to F6, in [PREREGISTRATION_11.md](../../preregistrations/PREREGISTRATION_11.md), and a decision fixed in advance on
whether the correction joins the recommended configuration. In short:

| Rule | It holds when |
|---|---|
| F0, safe when off | The patched library, with no switch set and under each registered configuration's switches, makes every file of the nine identity parts byte for byte |
| F1, required | Patches A to E without the correction fail T05, and at the shipped step friction over the impact is no more than 2,400 per 10,000 (8 tenths of the law) |
| F2, correct | With the correction friction over the impact is within 1 in 100 of the law at each of the seven steps, and T10 passes |
| F3, the suites | With the correction the first suite passes all ten tests and the second all seven |
| F4, the solver on the suites | With the correction no step of either suite stops or diverges |
| F5, the benchmark | With the correction added, at the shipped step on the three scenes: no step diverges, and no more stop than without it plus 21 of 21,600 |
| F6, the other tests do not move | T01 to T04 and T06 to T09 pass or fail as they do without the correction |

The correction joins the recommended configuration if, with it added, `half_cheetah` and `ant` at steps 1 to 1/16
are in order in 3 folds of 3 and no step diverges. If every rule holds, patch F is recorded as required, correct
and safe.

## The result

6 rules of 7 held, 16 rule lines of 17; F3 failed ([run 027](../../validation/run_027_friction/)). The three lines
of the decision held.

| Friction over the impact, per 10,000 of the normal impulse (the law: 3,000) | 1 | 1/2 | 1/4 | 1/8 | 1/16 | 1/32 | 1/64 |
|---|---|---|---|---|---|---|---|
| Recommended configuration, patches A to E | 1,801 | 1,971 | 2,133 | 2,318 | 2,620 | 2,804 | 2,897 |
| With patch F | 3,000 | 3,000 | 2,999 | 3,000 | 2,999 | 2,999 | 2,999 |

- **Required and correct.** Without the correction friction reached the impact at 60% of the law at the shipped
  step; with it, within 1 in 1,000 at every step (2,999 or 3,000 per 10,000, against 3,000; the rule asked for
  1 in 100).
- **The solver.** No step of either suite stopped or diverged. On the benchmark at the shipped step the correction
  took `ant` from 7 stopped steps to 0, `half_cheetah` from 6 to 5, and `cart_pole` stayed at 0.
- **The decision.** With the correction added, `half_cheetah` and `ant` came out in order in 3 folds of 3 at steps 1 to
  1/16, and no step diverged. **Patch F joins the recommended configuration.**
- **F3 did not hold.** On the registered pair, a 0.5 kg cube slipping on a 3 kg block should accelerate at
  Coulomb's 4,410 mm/s2, and T15 asks for it within 2 in 100. At 1/16 of the step it read 4,215 without the
  correction and 4,219 with it: about 4% short either way. At the shipped step it read 4,392 without the
  correction, 0.4% short and inside the band, and 4,224 with it, 4.2% short; patch F alone on stock contact read
  4,220. So at the shipped step patch F reads outside T15's band where stock reads inside it; the cause is the grid, not the patch (below), on this
  pair. The block's own acceleration was right (6,985 to 7,014 against 6,982).
- **The cause.** The shortfall is
  SuperDex's default grid distance field, which rounds the block's edge within its last cell (run 030, below), the same with and
  without patch F. [Run 048](../../validation/run_048_patch_f_review/README.md), a review of patch F, found why the shipped step differed: stock's friction there runs up to 55% above Coulomb's law and hid it; patch F
  takes the normal force actually applied and shows it. With the grid cell at 1/32 of a body's side the pair reads
  4,409 to 4,413 at every step, with and without patch F. F3 stays failed as registered.
- **What the decision on patch F covers.** The registration records patch F as required, correct and safe only if
  every rule holds; with F3 failed, that is recorded as measured. The decision on joining the recommended
  configuration is a separate one, on the benchmark's order, and it held.

## What it does not show

Why the light cube slips short on this pair, at 1/16 with and without the correction and at the shipped step with
it. It is the first pair on which T15 failed. The cause was found after the run, by the probes of
[run 030](../../validation/run_030_design_probes/), section 1: the cube reaches the last cell of the block's grid
distance field, where the field rounds the block's edge. [Study 14](14-open-items.md) tested the fix.
