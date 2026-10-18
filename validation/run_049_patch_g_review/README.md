# Run 049: patch G reviewed, and its form under BDF2 derived

15 October 2026, on the Linux machine of runs 039 to 048, in a work folder of its own. Not registered: a review of
patch G's code, rigs, measures and readings, a derivation of its form under BDF2, and design probes of that form.
Nothing here decides anything; a study that registers rules for it does.

## The question

Study 12 recorded patch G as measured, not as required, correct and safe, because G2 (one arm of nine at 9,987 per
10,000 against a band from 9,990) and G8 (a slip test required to stay at stock's value) failed. Study 15's V8 found
that under BDF2, the accurate configuration's integrator, patch G loses a free chain's angular momentum at first
order. Is patch G's code right, are the rigs and measures right, and what is the right form
under BDF2?

## The code, under backward Euler

Patch G (`patches/senua_inertia_transport.patch`) is correct and complete under backward Euler, the integrator the
recommended configuration uses:

- The stored force is the translational inertia gradient, m/h ((x - x_s)/h - v_s), from the same assembly pass, set to
  zero first so a body with no inertia gives nothing. The Jacobian at the start of the step is captured at the first
  Newton assembly or the previous step's end and checked by exact pose equality.
- On a free chain the angular momentum read from the link velocities is kept exactly, 0.000 ppm at every step, on a
  planar chain and on a chain with a tilted second axis.
- The Newton matrix stays J^T M J where the exact derivative is J(q_n)^T M J(q): an error of the size of the angle
  turned in a step, which is what left G2 short at SuperDex's shipped relative tolerance (run 030). SuperDex's default
  line search reads the residual only, so a residual-only term is consistent with it.
- Both precisions: the arithmetic is SuperDex's `real`, and the checks are exact comparisons.

## BDF2: the cause, in stock SuperDex, and the derived form

SuperDex's BDF2 combines the two previous states with weights 4/3 and -1/3 over a stage of 2h/3. For a jointed body
it sets each link's stage-start pose from the forward kinematics of the combined joint angles, X(q_s)
(`mochi_articulated_body.cpp` at the upstream commit, around lines 3291 to 3319), while BDF2 for a constrained system
combines each link's own centres, x_s = X_n + (-1/3)(X_{n-1} - X_n) (Gear, Leimkuhler and Gupta 1985; Lotstedt and
Petzold 1986; Brenan, Campbell and Petzold 1996, chapter 3; Hairer and Wanner, Solving ODEs II, chapter VII), with
the constraint force removed by the null-space matrix at the node where the equation is written (Betsch 2005; Betsch
and Leyendecker 2006). A linear multistep combination commutes only with a linear map, so X(q_s) - x_s =
(2/9) h^2 Jdot qd + O(h^3): the kept velocity is short by (h/3) Jdot qd and the residual carries an error of first
order. Patch G's current share of 1/3 cancels it for one joint only: for a chain a secular part of the angular
momentum error, (h/3) sum m_i Xd_i x (J_i qdd), remains, and no scalar share cancels it.

The derived form (`patch/senua_inertia_transport_g3.patch`, sha256 c3e1442b..., adding 322 lines and removing none;
`patch/patch_file_current_to_g3.diff` against the current file) adds the force m D/h_s^2 with D = X(q_s) - x_s,
adds D/h_s to the link velocity kept at the end of the stage, uses the current Jacobian under BDF2 and keeps the
transport for backward Euler alone. No constant is tuned. A one-step stage (backward Euler, or the step that starts
or restarts BDF2) is untouched. A standalone reproduction of the discretisation (`model/`) matches SuperDex to four
to six digits and was used to reject three start-up variants.

## The rigs and the measures

- The arm and chain scenes are set up as registered; the inertia of each cube, 2/3 m h^2, is confirmed by backward
  Euler keeping a free chain exactly with it; the initial link velocities are J qd.
- G1's law is the point-mass derivation and leaves out the cube's own spin, 0.8% of the inertia, which moves the
  prediction by at most 0.17%, inside its band of 1 in 100.
- **The chain measure under BDF2** reads SuperDex's link velocities. Under backward Euler they are the scheme's own
  discrete invariant; under BDF2 they carry the first-order bias above (V8's file: -1,540.9 ppm read from the links,
  -1,272.4 read from the joint speeds). With the derived form the kept velocity is BDF2's own.
- The slip's right answer is (3 - 2)/0.3221333 = 3,104,305 micro-radians a second, where the record gives 3,104,308
  (Study 6): 1 ppm, against bounds of 1 in 100 or wider, so no verdict changes.

## The record re-read

Study 12's runner on run 028's own files re-makes `reading.txt` and `counts.txt` byte for byte (31 lines held, 2
failed), and an independent re-derivation agrees on every line (`rederive/`). V8 re-derived from run 034's
`accurate14/runs/joints_accurate/chainfree_16.txt`: largest momentum drift 1,540.9 ppm against 1,000, failed.

## Patch G's rules on probe numbers, under the recommended configuration (backward Euler)

Probe numbers (no registration uses them): chains of 0.9 and 0.7 kg and of 1.6 and 0.45 kg, an arm of 1.3 kg at
0.33 m, a joint-test arm of 2.6 kg at 0.37 m, and benchmark commands from fresh seeds (`probes/`, `host/out/rules_cur`).

| Rule | Measured, library build 15 |
|---|---|
| G1 | Stock 1,744,622, 3,416,486 and 4,343,877 micro-radians a second against the law's 1,744,369, 3,415,014 and 4,341,354 |
| G2 | 9 of 9 plays in band; the lowest 3,899,925 of 3,900,000 (9,999.8 per 10,000) |
| G3 | With no switch, 675,215 per million of the energy kept and the momentum -93,669 ppm |
| G4 | Momentum 0, 0 and 1 ppm; largest energy drift 2,156, 133 and 8 per million |
| G5 | Energy 1,000,143, 1,000,009 and 1,000,006 per million; momentum 13, 1 and 1 ppm |
| G6 | Loss 349,586, 105,730 and 25,573 against no switch's 843,976, 553,224 and 310,808, falling with the step |
| G7 | No step stopped or diverged |
| G8 | JT1 2,699,988 (stock 2,523,064 fails); JT2 within 1 in 100; the hold -476, stock's; the slip, read against its right answer, 4,189,174 and 4,189,181 against 4,189,203 at steps 1 and 1/16 (against stock's value, as registered, the shipped step fails) |
| G9 | Stops with and without patch G: `half_cheetah` 7 and 7, `ant` 0 and 0, `cart_pole` 0 and 0; none diverged |

## The derived form on probes

Under BDF2 at tight tolerances, a free chain's angular momentum at the end, read from the joint speeds, ppm
(`host/out/probe_bdf2_tight.txt`):

| Steps | 1 | 1/2 | 1/4 | 1/8 | 1/16 | 1/32 | 1/64 |
|---|---|---|---|---|---|---|---|
| Chain of 0.9 and 0.7 kg, derived form | -875 | -182 | -40.5 | -9.5 | -2.30 | -0.57 | -0.14 |
| The same, current patch G | -36,447 | | | | | | -584 |

The derived form falls four times a halving, second order; the current form twice, first order. The second chain
reads 26.6 ppm at the shipped step falling to 0.001; a chain with a tilted second axis -1,272, -89.5, -5.70 and
-0.357 at 1, 1/4, 1/16 and 1/64 against the current form's -20,556 to -311 (`probe_tilt_32.txt`). Positions converge
at second order too; a swinging chain is second order; at the accurate configuration's tolerances the orders hold
with no step stopped; on Meta's scenes under the accurate configuration no step of 345,600 stopped or diverged.

- **Safe when off and backward Euler unchanged.** With the derived form, 61 of 61 rule-probe files and 18 of 18
  benchmark streams are byte for byte library build 15's, and with no switch stock's. The identity list played with
  it (`host/out/idg3_*`): every suite file the same (1,278 of 1,278); of the 891 other files every one the same but the
  BDF2 plays with patch G set, which change by design, the wall-clock and path lines, and two review plays this
  harness made on the derived form where the record makes them on library build 13.
- **The cost, at coarse BDF2 steps.** A single joint loses (omega h)^2 once, at the backward-Euler step that starts
  BDF2: a free spin keeps 9,982.9 per 10,000 at the shipped step against 9,993.0 with the current form, and 9,999.94
  against 9,999.98 at 1/16; a pendulum's first three swings at the shipped step read 9,985.68, 9,963.68 and 9,949.40
  against 9,988.46, 9,971.74 and 9,963.42, and from 1/16 they are the same. Played on the registered numbers, the
  derived form would improve V8 (1,540 to 7 ppm), I5c's chain momentum (143 to 5 ppm) and A2 (194 to 6 ppm), and
  would fail four registered lines that held at coarse steps: I5b's free spin (3,993,537 against 3,996,000) and
  pendulum (9,935 against 9,950), I5c at 1/4 (-11,133 ppm against 10,000), and V5's free spin (3,495,765 against
  3,496,500).
- **32-bit.** Backward Euler is the same with both forms. Below the shipped step, joint motion in 32-bit is limited by
  rounding even in stock (nearly every step stops on the solver's small-update rule), so 32-bit cannot judge either
  form under BDF2.

## What it means

- Under backward Euler, the recommended configuration's integrator, patch G has no defect and met every rule of its
  registration on fresh probe numbers, G8 read against the slip's right answer.
- Under BDF2 its current form is right for one joint and first order for a chain, because of how stock SuperDex
  starts a jointed body's BDF2 stage. The derived form makes chains second order and changes nothing under backward
  Euler or with the switch off, at the cost of a one-time loss of second order at BDF2's start on coarse steps.
- Whether the derived form replaces the current one is for a registered study to decide.
  [Study 22](../../docs/studies/22-bdf2-chain.md) decided it ([run 052](../run_052_study22/README.md)): the derived
  form is patch G under BDF2 in library build 16.
