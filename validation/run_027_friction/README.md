# Run 027: the eleventh registration, friction at an impact

14 October 2026. Registered before this run ([PREREGISTRATION_11.md](../../preregistrations/PREREGISTRATION_11.md)), committed with the tenth and twelfth registrations.
Library build 12. Both contact suites on the registered cubes and the benchmark, played by
[`tools/plays/play_11.sh`](../../tools/plays/play_11.sh) and measured by `measure/runners/sx_study11_run.sh`.

**Result: 6 rules of 7 held, on 16 rule lines of 17. F3 did not: the second suite's T15 fails, with the correction
and without it, at 1/16 of the step; at the shipped step it fails with the correction only. The decision fixed in
advance held: patch F joins the recommended configuration.**

## Friction over the impact, per 10,000 of the normal impulse (T05; the law: 3,000)

| Step | 1 | 1/2 | 1/4 | 1/8 | 1/16 | 1/32 | 1/64 |
|---|---|---|---|---|---|---|---|
| Recommended configuration (A to E) | 1,801 | 1,971 | 2,133 | 2,318 | 2,620 | 2,804 | 2,897 |
| With the correction (patch F) | 3,000 | 3,000 | 2,999 | 3,000 | 2,999 | 2,999 | 2,999 |

Over the impact and the 0.1 s after it (T10) the correction reads 3,000 at every step.

## The rules

| Rule | Held | Measured |
|---|---|---|
| F0 safe when off | yes | [run 025](../run_025_identity/): 362 of 362 files identical |
| F1 required | yes | without the correction T05 fails; 1,801 per 10,000 at the shipped step against the bound of 2,400 |
| F2 correct | yes | within 1 in 100 of the law at all seven steps; T10 passes |
| F3 the suites | **no** | first suite 1111111111 with the correction; second suite 1111011 (T15 fails), as it does without the correction |
| F4 the solver on the suites | yes | no step of either suite stopped or diverged |
| F5 the benchmark | yes | stopped at the shipped step with the correction, against without: `half_cheetah` 5 and 6, `ant` 0 and 7, `cart_pole` 0 and 0; none diverged |
| F6 the other tests do not move | yes | T01 to T04 and T06 to T09 pass as they do without the correction (the rule compares pass and fail); each reads the same but T07, 787,900 and 792,000 um/s with the correction against 790,800 and 794,100 without it (right answer 784,000) |
| Decision | yes | `half_cheetah` and `ant` in order in 3 folds of 3 at steps 1 to 1/16; no step diverged in the chains |

## Why F3 failed

T15 is the slip of the second suite's pair: a cube of 0.5 kg on a block of 3 kg, the block pushed with one and a
half times what friction can carry, so the cube slips and Coulomb's law says it accelerates at the friction
coefficient times g, 4,410 mm/s2. It read 4,224 and 4,219 mm/s2 with the correction at the shipped step and at 1/16,
and 4,392 and 4,215 without it. At 1/16 it is about 4% short either way, outside the test's band of 1 in 50. At the
shipped step it is 0.4% short without the correction, inside the band, and 4.2% short with it (the correction alone
on stock contact: 4,220): there the correction reads outside its band, on this pair; the cause is SuperDex's grid, not the patch (see "The cause of T15's shortfall" below).
The block's own acceleration was right (6,985 to 7,014 against 6,982). The eleventh registration's cubes are the
first on which T15 failed. It is an item of the [open list](../../docs/open-items.md), which says what closed it.

## Reported

A slide that ends (the law: 205.78 mm; backward Euler's own at the shipped step: 200.28 mm):

| Step | 1 | 1/4 | 1/16 | 1/64 |
|---|---|---|---|---|
| Without the correction | 210.69 | 207.14 | 206.28 | 205.72 |
| With it | 200.44 | 204.57 | 205.59 | 205.55 |

With the correction friction acts in full from the first step of the slide, so the shipped step's distance is
backward Euler's own; without it the first step's friction is short and the slide is long.

The correction alone on stock contact (reported): first suite 1110101011, second 1110011.

Files: `reading.txt` (every measured line and every rule), `counts.txt` (the chains), `runs/s1|s2/<configuration>/`
(the rigs' output), `stats_<scene>.txt`, `traces/` (the solver's trace of every benchmark play),
[`../../streams/11/`](../../streams/11/).

## The cause of T15's shortfall

- T15's shortfall is SuperDex's default grid distance field, which rounds the block's edge within its last cell, the
  same with and without patch F ([run 030](../run_030_design_probes/), section 1). [Run 048](../run_048_patch_f_review/README.md),
  a review of patch F, found why the shipped step differed: stock's friction on that cell runs up to 55% above
  Coulomb's law and hid the shortfall, and patch F, which takes the normal force actually applied, shows it. Patch F's
  code has no defect. With the grid cell at 1/32 of a body's side, as the recommended configuration sets it, the pair
  reads the law at every step with and without patch F. Every rule line of this run reads as recorded.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the eleventh registration) changes in 26 numbers: the distance slid by
at most 0.18% (212,455 to 212,832 um), the distance come back by at most 2 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
