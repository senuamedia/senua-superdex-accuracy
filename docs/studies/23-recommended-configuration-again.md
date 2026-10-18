# Study 23: patches F and G and the recommended configuration, held to every rule on fresh numbers, on library build 16

| | |
|---|---|
| Registration | Twenty-third: [PREREGISTRATION_23.md](../../preregistrations/PREREGISTRATION_23.md) |
| Question | Under the recommended configuration, on fresh numbers and on library build 16, with the two cubes' momentum read by `pairg`, do patches F and G meet every rule of their registrations, does the configuration keep `half_cheetah` and `ant` in order, and does it meet every backward-Euler end-to-end rule of the thirteenth to fifteenth registrations? |
| Outcome | **117 rule lines of 118 held (44 rules of 45; one line of P2 failed).** Every rule of patch F held, so patch F is recorded as required, correct and safe under the recommended configuration. Every rule of patch G held, replicating Study 21's decision on library build 16. One line of P2, friction over a one-step impact on the point-cloud floor at step 1/4, read 5.1% above the law against a bound of 4%, so the configuration is not recorded as validated end to end; that item stays open |
| Registered | 15 October 2026, before run 055 |
| Result | [Run 055](../../validation/run_055_study23/README.md), 15 October 2026 |
| Runs | [055](../../validation/run_055_study23/README.md), on the Linux machine of runs 039 to 052 |
| Played by | [`tools/plays/play_23.sh`](../../tools/plays/play_23.sh); measured by [`measure/runners/sx_study23_run.sh`](../../measure/runners/sx_study23_run.sh) |

Previous: [Study 22](22-bdf2-chain.md). All studies: [index](README.md).

## Why it was asked

[Study 21](21-recommended-configuration.md) held 117 of its 118 rule lines. The one that failed, F3's second line, was
the measuring program's: its `pair` measure reads each cube's mass in whole units of 10 g, and Study 21's fresh pair was
the first in the record whose masses were not. Its decision on patch F did not fire, and neither did the end-to-end
decision. [Study 22](22-bdf2-chain.md) then changed patch G under BDF2, making library build 16. This study put every
rule of Study 21 to the configuration again, on numbers no earlier study used, on library build 16, with the momentum
between two cubes read by `pairg`, which takes each mass in whole grams.

## What was played

Study 21's protocol, with fresh numbers drawn from seed 23 by Study 21's procedure: both contact suites on a fresh
1.783 kg cube and a fresh pair (a 4.855 kg block and a 0.465 kg cube); item 1's two fresh pairs; a fresh arm, chain,
limit and point-cloud cube (1.154 kg); 40 rotations; three cantilevers; fresh deformable bodies; both grippers on a
fresh 0.125 kg cube at a 7 N grip; Meta's three scenes on fresh commands (seeds 23101 to 23103, `actions/23/`), and
`half_cheetah` and `ant` at steps 1 to 1/16 for the order; and the identity check's parts rotvec, flight, suites,
joints, zero, fg, bench and benchrec. The registration gives every number, its range and its right answer.

## The rules, and the result

The registration carries Study 21's 45 rules and 118 rule lines. 44 of them held, on 117 of the 118 rule lines
([run 055](../../validation/run_055_study23/README.md)).

| Rules | Rule lines held | Measured |
|---|---|---|
| E0, safe when off | 2 of 2 | 501 of 513 identity files byte-identical to their registered files; the other 12 exactly the plays named for Linux, each the same as run 040's kept file |
| F1 to F6, patch F | 14 of 14 | Without patch F, T05 fails (the shipped step 79.5% of the law, reported); with it, friction over the impact 3,879 or 3,880 per 10,000 at every step against the law's 3,880, and T10 passes; the first suite 10 of 10 and the second 7 of 7, T16 read by `pairg` at 83 to 111 parts per million against 500; no suite step stopped or diverged; on Meta's scenes 5, 1 and 0 steps stopped against 4, 15 and 0 without patch F, none diverged; the other tests as without patch F |
| G1 to G9, patch G | 30 of 30 | Stock at the law's prediction at the three speeds; with patch G the arm keeps at least 9,999.8 per 10,000 of its speed in all nine plays; a free chain with no switch loses 24.2% of its kinetic energy and 9.7% of its angular momentum at the shipped step, and with patch G keeps both at every step (energy within 94 per million, momentum within 4 parts per million); the swinging chain's loss falls with the step; the slip within 7 parts per million of its right answer |
| J1, J5, L1 to L4, R1 | 11 of 11 | The free arm, the limit at rest, leaving and lifted, and 40 rotation vectors of 40, all at their right answers; no step stopped or diverged |
| P1, P2 | 9 of 10, P2 failed | Stock on the point-cloud floor 3.6 times the law over the impact and the slip at 47%; the configuration within 1 in 100 of the law sliding, holding, the slip at 98.9%, no step diverged; **over the impact 1.5% above the law at the shipped step and 5.1% above at step 1/4, against a bound of 4%: failed** |
| V1, I1d, V2, V4, V9 | 19 of 19 | Item 1's pairs within 1 in 4,000 of their laws; the arm and chain within their bounds; the cantilevers within 0.01% of the textbook at 64 and 128 elements; a 20 s swing never above 9,974 per 10,000 |
| D1 to D8 | 15 of 15 | Falls, hangs, slides, rests and the creep on the tilt at their right answers, stock and the configuration; under the configuration the hold on the tilt moved 8,221 nm at most, inside the stick distance |
| GR1 to GR5 | 8 of 8 | Both grippers press and carry within 1 in 3,600 of their right answers under the configuration and hold; stock lets the cube creep out |
| B1 to B3 | 9 of 9 | On the fresh commands 5, 1 and 0 steps stopped of 21,600 (stock 4, 235 and 0), none diverged; **`half_cheetah` and `ant` in order in 3 folds of 3 at the configuration's tolerances**; 16 steps of the ten order plays stopped, every one at the iteration limit, none diverged |

## What the decisions record

- **Patch F is recorded as required, correct and safe under the recommended configuration**: E0 and F1 to F6 held,
  every one of patch F's 14 rule lines.
- **Patch G is recorded as required, correct and safe under the recommended configuration, under backward Euler**,
  on library build 16: E0 and G1 to G9 held, every one of its 30 rule lines, replicating Study 21's decision.
- **The decision that would record the configuration as validated end to end did not fire**, because one line of P2
  failed. It is recorded as measured, and what it concerns stays open.
- Nothing about BDF2 or the accurate configuration was decided; [Study 22](22-bdf2-chain.md) decided patch G there.

## The rule line that failed

**P2, friction over the impact on the point-cloud floor.** P2 asks that, under the configuration, friction over a
one-step impact on the point-cloud floor be within 1 in 25 of the law (3,970 per 10,000) at steps 1 and 1/4. It read
4,030 and 4,173: 1.5% above at the shipped step, and 5.1% above at step 1/4. Stock on the same cube reads 14,219 and
4,669. Over the 0.1 s after the impact the configuration reads 4,011, 1.0% above.

The registration named it as a known risk before the run: on a discrete floor this reading moves by up to 3% with
where the cube lands among the floor's nodes, and this cube's side faces were 0.3 mm outside a row of nodes. No play
was made again for it, and its cause has not been traced. It is on the [open list](../open-items.md).

## What it means

- **Patch F is validated**, on fresh numbers, under the recommended configuration: required (T05 fails without it),
  correct (friction over an impact within 1 in 1,000 of Coulomb's law at every step), safe when off, with no suite
  step stopped and Meta's scenes no worse.
- **Patch G is validated under backward Euler** on library build 16, as on library build 15 in Study 21.
- **The momentum between two cubes is kept** to within 111 parts per million as `pairg` reads it, on a pair whose
  masses are not multiples of 10 g: Study 21's failure was the measure's, as its diagnostic found.
- **The configuration keeps Meta's scenes in order at its own tolerances**, on fresh commands, as in Study 21.
- **Every end-to-end rule held but one line of P2**: contact suites, items, the arm and chain, limits, rotations,
  cantilevers, deformable bodies, grippers and Meta's scenes. The configuration end to end is not recorded as validated
  by this study; friction over a one-step impact on the point-cloud floor at the finer step is open.
- It says nothing about BDF2 or the accurate configuration, about 32-bit, about `cart_pole`'s order or about gradients,
  and nothing against a real robot.
