# Study 12: the loss on joint motion, and projecting at the right node

| | |
|---|---|
| Registration | Twelfth: [PREREGISTRATION_12.md](../../preregistrations/PREREGISTRATION_12.md) |
| Question | Can a free arm, and a free chain, keep their speed and momentum at the shipped step? |
| Outcome | 8 of its 10 rules held (31 of 33 lines of the record). A free arm keeps its speed and a free chain its energy and momentum at the shipped step; patch G with SuperDex's Newton-Euler inertia joins the recommended configuration, as the decision on it fixed in advance says. G2 and G8 each failed on one reading: one fine-step play of the arm kept 9,987 per 10,000 of its speed against at least 9,990, and a slip test moved from stock's value to within 1 in 10,000 of its right answer. The causes (runs 030 and 049): G2's shortfall is SuperDex's shipped relative solver tolerance, G8's rule was posed against stock's value, and patch G has no defect under backward Euler; the registration's record of patch G as measured stands |
| Registered | 14 October 2026, with the tenth and eleventh registrations, committed and pushed before any run of this registration existed |
| Result | [Run 028](../../validation/run_028_joint_motion/README.md), 14 October 2026 |
| Runs | [022](../../validation/run_022_design_probes/) and [023](../../validation/run_023_design_probes/), design probes; [025](../../validation/run_025_identity/), safe when off; [028](../../validation/run_028_joint_motion/), the registered runs |
| Data | [`validation/run_028_joint_motion/`](../../validation/run_028_joint_motion/) (the arms, the chains, the sixth study's tests, the benchmark's statistics and traces), [`streams/12/`](../../streams/12/) |
| Played by | [`tools/sdx_joint.cpp`](../../tools/sdx_joint.cpp), [`tools/sdx_chain.cpp`](../../tools/sdx_chain.cpp), [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp), [`tools/plays/play_12.sh`](../../tools/plays/play_12.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx) (`final`, `swing`, `creep`, `chain`, `rule`), `measure/runners/sx_study12_run.sh` |

Previous: [Study 11](11-friction-at-impact.md). Next: [Study 13](13-end-to-end.md). All studies: [index](README.md).

## Why it was asked

The sixth study measured that SuperDex's default integrator takes speed out of joint motion: a free arm loses 7.9%
of its speed in one second at the shipped step. It was on the open list as "not fixed: removing it is a change of
formulation". The registration's question gives the loss as 3.9%; the sixth study's run measured 7.9% (JT1: 9,208
per 10,000 left at the shipped step, [run 015](../../validation/run_015_joints/)), the figure used here.

## The cause, and the correction

Every link's inertial force is the centred second difference of its position, which belongs to the start of the
step, and SuperDex projects it onto the joints with the Jacobian of the current position. For an arm turning about
a joint that loses the square of the angle turned in a step. Patch G projects the translational part with the
Jacobian of the start of the step (the discrete null space method of Betsch and Leyendecker); SuperDex's own
experimental Newton-Euler inertia corrects the rotational part. On the probes a free arm then kept 9,999 of every
10,000 of its speed, and a free two-link chain its energy and momentum.

## The rules

Ten rules, G0 to G9, in [PREREGISTRATION_12.md](../../preregistrations/PREREGISTRATION_12.md), and a decision fixed in advance on
whether the two corrections join the recommended configuration. In short:

| Rule | It holds when |
|---|---|
| G0, safe when off | The patched library, with no switch set and under each registered configuration's switches, makes every file of the nine identity parts byte for byte |
| G1, required: the law | Stock, one arm, shipped step: the speed after 1 s within 1 in 100 of the law's prediction at each of three release speeds |
| G2, correct: one arm | With both corrections the speed after 1 s is between 9,990 and 10,010 per 10,000 of the release speed in all nine plays |
| G3, required: two arms | No switch, free chain, shipped step: more than a tenth of the kinetic energy and more than 3 in 100 of the angular momentum gone after 2 s |
| G4, correct: two arms, the solver converged | Both corrections, tight tolerances, free chain: the angular momentum within 100 per million at every step; the energy drift within 5,000, 1,000 and 500 per million at steps 1, 1/4 and 1/16 |
| G5, correct: two arms, as shipped | Both corrections, shipped tolerances, free chain: the energy within 1 in 100 and the angular momentum within 5,000 per million at every step |
| G6, under gravity | Swinging chain: with both corrections the energy lost is at most 6 tenths of stock's at every step, and falls from each step to the next finer one |
| G7, the solver | No step of the arm and chain plays at shipped tolerances with both corrections stops or diverges |
| G8, nothing else gets worse | The sixth registration's tests with both corrections: JT1 passes, JT2 within 1 in 100, the hold's creep within 10 micro-radians a second of stock's, the slip speeds within 1 in 100 of stock's at steps 1 and 1/16 |
| G9, the benchmark | Both corrections added, shipped step, three scenes: no step diverges, and no more stop than without them plus 21 of 21,600 |

The two join the recommended configuration if, with them added, `half_cheetah` and `ant` at steps 1 to 1/16 are in
order in 3 folds of 3 and no step diverges. If every rule holds, patch G is recorded as required, correct and safe.

## The result

8 of its 10 rules held, 31 of 33 lines of the record ([run 028](../../validation/run_028_joint_motion/)).

| | Stock | Both corrections |
|---|---|---|
| One arm released at 6 rad/s: speed kept after 1 s at the shipped step, per 10,000 | 7,631 | 9,999 |
| Free two-link chain: kinetic energy kept after 2 s at the shipped step | 70.0% | 100.02% |
| Free two-link chain: angular momentum kept | 88.4% | 99.9994% |
| The same with the solver converged: angular momentum drift at every step | | 0 |
| Swinging chain: energy lost over 2 s, share of the largest kinetic energy, shipped step | 94.9% | 36.1% |
| The sixth registration's free arm (JT1), per 10,000 | 9,208 | 9,999.9 |
| The sixth registration's driven arm (JT2), against 4,656,457 | 4,425,099 | 4,656,274 |

- **Required, and safe.** Stock loses what the law says, within 0.1% (G1), and a free chain with no switch loses
  more than a tenth of its energy and 3 in 100 of its angular momentum in 2 s (G3). The patched library reproduces
  every file of the nine identity parts byte for byte (G0), no step of the arm and chain plays stopped or diverged
  (G7), and on the benchmark no step diverged and no more stopped than without the corrections plus 21 in 21,600
  (G9: 2 against 5 on `half_cheetah`, 2 against 0 on `ant`, 0 against 0 on `cart_pole`).
- **Correct, on the rules that held.** With both corrections a free chain keeps its energy and momentum, at shipped
  and tight tolerances (G4, G5), and under gravity the loss is at most 6 tenths of stock's and falls with the step
  (G6). A free arm keeps its speed in eight of the nine plays of G2. The registration records patch G as required,
  correct and safe only if every rule holds; with G2 and G8 failed, each is recorded as measured.
- **Under gravity** a loss is left, and it falls with the step: backward Euler's own damping of a swing a force
  drives. The corrections remove the part that was there with no force at all.
- **The decision.** With both added, `half_cheetah` and `ant` came out in order in 3 folds of 3 at steps 1 to 1/16,
  and no step diverged. **Patch G with SuperDex's Newton-Euler inertia joins the recommended configuration**, as the
  decision fixed in advance says.
- **G2 did not hold** on one play of nine: at 3.5 rad/s and 1/16 of the step the arm kept 3,495,542 of 3,500,000
  micro-radians a second, 9,987 per 10,000, against the rule's 9,990 to 10,010. The cause, from the probes of
  [run 030](../../validation/run_030_design_probes/) (section 2): the solver's relative tolerance (1e-6 as shipped),
  met after one iteration a step, leaves an error of one sign; tightened tolerances remove it.
- **G8 did not hold** on one reading, and for a reason worth saying: the joint-friction slip test moved from stock's
  value, 2.3% short of its right answer, to within 1 in 10,000 of it. The rule had expected it not to move.

## What it does not show

That backward Euler stops damping a driven swing: that is the integrator's order, and SuperDex's higher-order
integrators are its remedy. Limits: revolute joints, two links at most in the known-answer tests.

## The review of patch G

[Run 049](../../validation/run_049_patch_g_review/README.md), a review of patch G for publication, not registered:

- **The record re-read.** This study's runner on run 028's own files re-makes `reading.txt` and `counts.txt` byte for
  byte (31 lines held, 2 failed), and an independent re-derivation agrees on every line.
- **No defect under backward Euler**, the integrator of this study and of the recommended configuration. The stored
  force is the translational inertia gradient from the same assembly pass, and the Jacobian of the start of the step
  is captured once and checked by exact pose equality; a free chain's angular momentum read from the link velocities
  is kept exactly, on a planar chain and on one with a tilted second axis.
- **G2.** The Newton matrix with patch G is J^T M J where the exact derivative is J(q_n)^T M J(q), an error of the size
  of the angle turned in a step. At SuperDex's shipped relative tolerance the solve stops on it with an error of one
  sign, which is what left one play at 9,987 ([run 030](../../validation/run_030_design_probes/), section 2). At the
  configurations' tolerances a fresh arm keeps its speed within 1 in 10,000 (Studies 14 and 15).
- **G8.** The rule asked for the slip within 1 in 100 of stock's value, and patch G moved it to its right answer. Run
  049 computes that answer as 3,104,305 micro-radians a second where this page gives 3,104,308, 1 part per million,
  which changes no verdict. G1's law leaves out the cube's own spin, which moves the prediction by at most 0.17%,
  inside its band.
- **The rules on probe numbers.** Under the recommended configuration (backward Euler at the configurations'
  tolerances) patch G met every rule G1 to G9 on numbers no registration uses, G8 read against the slip's right
  answer; read against stock's value, as registered, G8's shipped step fails again.

What was measured here stands as measured, and so does the registration's record: G2 and G8 failed as registered, so
patch G is recorded as measured, not as required, correct and safe by this registration.
[Study 21](21-recommended-configuration.md) decided it on fresh numbers: every rule G1 to G9 held under the recommended
configuration, and patch G is recorded as required, correct and safe under backward Euler. Under BDF2, which this study
did not play, patch G's form of library builds 13 to 15 is right for one joint and first order for a chain; run 049
found the cause in stock SuperDex, and by [Study 22](22-bdf2-chain.md)'s decision library build 16 carries the derived
form, which is second order on a chain.
