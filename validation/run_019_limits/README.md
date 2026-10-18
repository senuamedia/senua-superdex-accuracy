# Run 019: the eighth registration, run once. It did not hold in full: five rules of six.

14 October 2026. Rules: [PREREGISTRATION_08.md](../../preregistrations/PREREGISTRATION_08.md), registered and committed before any
of these runs existed. Plays: `tools/limit_all.sh`, `tools/plays/play_08.sh bench`, `identity`. Measuring: the Simplex
harness (`sx_limit_run.sh`), which re-makes `reading.txt` and `counts.txt` from the files kept here and in
`../../limits/` and `../../streams/08/`.

| Rule | Held | Measured |
|---|---|---|
| **H0** safe when off | yes | 40 of 40 joint files and 38 of 38 registered benchmark streams byte-identical to stock |
| **H1** the limit at rest | yes | -303,744 and -303,741 micro-radians, stock and corrected alike (answer -303,741) |
| **H2** stock's damped limit holds back a joint that is leaving it | yes | Release, damping 20: stock leaves at 1,004,593 micro-radians a second at 1/64 of the step (answer 1,434,131), having slowed by 418,427 inside the limit. Damping 150: it has not left after 0.5 s (still 32 micro-radians inside, moving at 445). Lift: 0.1 s after a torque of twice gravity's starts, stock has turned to -259,228 and -264,233 (needed -189,208) |
| **H3** the correction | yes | Release: 1,423,016 (0.8% under the answer) and 367,995 (0.4% under 369,401); it never slows inside by more than 72. Lift: -165,016 and -175,432. No solver step stopped or diverged |
| **H4** nothing changes where there is no limit | yes | The sixth registration's 30 runs with the switch on: 30 of 30 byte-identical |
| **H5** the benchmark's solver, the switch alone | **no** | Steps stopped without converging at the shipped step: `half_cheetah` 2 (stock 2), `cart_pole` 0 (stock 0), **`ant` 245 (stock 206; the bound was 227)**. No step diverged |

## The decision fixed in advance

With the switch added to the recommended configuration corrected, on the fifth registration's commands:
`half_cheetah` in order in 3 folds of 3, `ant` in order in 3 folds of 3, no step diverged. By the rule fixed in
advance the correction joins the recommended configuration. There the solver stops on 6 and 7 of 21,600 steps at
the shipped step (7 and 11 without the switch; stock 2 and 206).

## What this does and does not show

It shows a defect in stock SuperDex: a damped joint limit pulls. It shows the correction gives the right answer on
one joint and changes nothing where there is no limit. It does **not** show the correction is free on its own:
on stock contact, `ant`'s solver, already the weakest of the three (206 steps stopped), stops on 39 more. The
registered bound was 21. With the corrected contact configuration that cost is not there.

## Files

| | |
|---|---|
| `reading.txt` | Every measured line and the rules, decided |
| `counts.txt` | The benchmark chains under the recommended configuration with the switch added |
| `identity.txt`, `nolimit_identity.txt` | The registered streams and the sixth registration's runs re-played |
| `stats_<scene>.txt` | The solver's own status of every benchmark play (u1: the switch alone; z1 to z16: with the recommended configuration) |
| `../../limits/<configuration>/` | The rig's raw output of every limit run, with checksums |
| `../../streams/08/` | The benchmark streams |
