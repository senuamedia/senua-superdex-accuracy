# Run 028: the twelfth registration, the loss on joint motion

14 October 2026. Registered before this run ([PREREGISTRATION_12.md](../../preregistrations/PREREGISTRATION_12.md)), committed with the tenth and eleventh registrations.
Library build 12. The arm, the two-link chain, the sixth registration's tests and the benchmark, played by
[`tools/plays/play_12.sh`](../../tools/plays/play_12.sh) and measured by `measure/runners/sx_study12_run.sh`. The benchmark's
configuration as it stands after the eleventh registration's decision: patches A to F (`bench_base.txt`).

**Result: 8 of its 10 rules held (31 of 33 lines of the reading). G2 and G8 did not, each on one reading. The decision fixed in advance held: patch G,
with SuperDex's Newton-Euler inertia, joins the recommended configuration.**

## One arm, no gravity: speed after 1 s, micro-radians a second

| Released at | Step | Stock | Newton-Euler alone | Patch G alone | Both |
|---|---|---|---|---|---|
| 1.5 rad/s | 1 | 1,467,500 | 1,467,755 | 1,499,727 | 1,499,999 |
| | 1/4 | 1,491,643 | 1,491,711 | 1,498,562 | 1,498,596 |
| | 1/16 | 1,499,640 | 1,499,649 | 1,499,640 | 1,499,649 |
| 3.5 rad/s | 1 | 3,137,971 | 3,140,474 | 3,496,497 | 3,499,956 |
| | 1/4 | 3,397,614 | 3,398,412 | 3,499,127 | 3,499,999 |
| | 1/16 | 3,473,515 | 3,473,729 | 3,495,434 | 3,495,542 |
| 6 rad/s | 1 | 4,578,686 | 4,586,470 | 5,981,984 | 5,999,352 |
| | 1/4 | 5,523,885 | 5,527,321 | 5,995,598 | 5,999,990 |
| | 1/16 | 5,869,430 | 5,870,461 | 5,998,899 | 6,000,000 |

The law's prediction for stock at the shipped step: 1,467,348, 3,136,775 and 4,574,957.

## Two arms on two joints

Free, no gravity, after 2 s (kinetic energy per million of its start; angular momentum drift per million):

| Step | No switch | Both, shipped tolerances | Both, tight tolerances |
|---|---|---|---|
| 1 | 700,138; -115,772 | 1,000,208; -6 | 1,000,177; 0 |
| 1/4 | 886,488; -35,365 | 1,000,136; 24 | 1,000,011; 0 |
| 1/16 | 966,960; -9,467 | 1,003,630; 1,429 | 1,000,000; 0 |

Swinging under gravity, energy lost over 2 s as a share of the largest kinetic energy, per million:

| Step | No switch | Newton-Euler alone | Patch G alone | Both |
|---|---|---|---|---|
| 1 | 949,320 | 945,273 | 389,375 | 360,747 |
| 1/4 | 588,360 | 575,507 | 129,912 | 106,120 |
| 1/16 | 240,633 | 235,066 | 30,514 | 25,173 |

## The rules

| Rule | Held | Measured |
|---|---|---|
| G0 safe when off | yes | [run 025](../run_025_identity/): 362 of 362 files identical |
| G1 required: the law | yes | stock within 1 in 1,000 of the law at all three speeds |
| G2 correct: one arm | **no** | 8 of 9 plays between 9,990 and 10,010 per 10,000; at 3.5 rad/s and 1/16 of the step, 9,987 |
| G3 required: two arms | yes | 30% of the energy and 11.6% of the momentum gone at the shipped step |
| G4 correct, the solver converged | yes | momentum drift 0 at every step; largest energy drift 902, 56 and 3 per million |
| G5 correct, as shipped | yes | energy 1,000,208, 1,000,136 and 1,003,630 per million; momentum within 1,429 |
| G6 under gravity | yes | 38%, 18% and 10% of the loss with no switch, falling with the step |
| G7 the solver | yes | no step of the arm or chain plays stopped or diverged |
| G8 nothing else gets worse | **no** | JT1 and JT2 pass at the shipped step; the hold reads -411 as stock; the slip at 1/16 is within 1 in 100 of stock's; at the shipped step it read 3,104,079 against stock's 3,032,560 |
| G9 the benchmark | yes | stopped at the shipped step with both against without: `half_cheetah` 2 and 5, `ant` 2 and 0, `cart_pole` 0 and 0; none diverged |
| Decision | yes | `half_cheetah` and `ant` in order in 3 folds of 3 at steps 1 to 1/16; no step diverged in the chains |

## Why G2 and G8 failed

- **G2.** At 1/16 of the step the arm released at 3.5 rad/s took one solver iteration a step, and the solver stops
  there as soon as either of its tolerances is met; here the relative one (1e-6 as shipped), as the probes of run 030 show. With patch G the Newton matrix is not
  exact, so it approaches the answer from one side, and over 1,600 steps the tolerance left 0.13% of the speed. The
  probes showed the same cost on the chain, and tight tolerances remove it (G4).
- **G8.** The sixth registration's slip test (joint friction overcome by a torque) has the right answer 3,104,308
  micro-radians a second. Stock read 3,032,560 at the shipped step, 2.3% short, because of the very loss this patch
  removes. With both corrections it read 3,104,079, within 1 in 10,000 of the right answer. The rule asked for
  stock's value within 1 in 100, which was written expecting the slip to be untouched. It moved to the right answer.

## Reported

The sixth registration's pendulum (JT3) at the shipped step: its first swing comes back to 9,627 per 10,000 of its
height with both corrections, against 9,083 on stock; backward Euler's own damping of a swing a force drives is
what remains.

Files: `reading.txt`, `counts.txt` (the chains), `arm/`, `chain/` (the rigs' output and the solver's trace of every
step), `joints_neg/` (the rigs' output, and the solver's counts of each run in its `stats.txt`; no trace),
`stats_<scene>.txt`, `traces/`, [`../../streams/12/`](../../streams/12/).

## The review of patch G

- [Run 049](../run_049_patch_g_review/README.md), a review of patch G for publication, re-made `reading.txt` and
  `counts.txt` from this run's files byte for byte (31 lines held, 2 failed), and an independent re-derivation agrees
  on every line.
- It read patch G's code and found no defect under backward Euler, the integrator of this run. G2's shortfall is the
  one given above, SuperDex's shipped relative tolerance meeting patch G's inexact Newton matrix after one iteration a
  step ([run 030](../run_030_design_probes/)). G8 asked for stock's value; patch G moved the slip to its right answer,
  which run 049 computes as 3,104,305 micro-radians a second against the 3,104,308 used here (1 part per million, no
  verdict changes). G1's law leaves out the cube's own spin, at most 0.17% of the prediction, inside its band.
- On probe numbers under the recommended configuration (backward Euler at the configurations' tolerances), patch G met
  every rule G1 to G9, G8 read against the slip's right answer.

Every rule line of this run reads as recorded, and the registration records patch G as measured.
