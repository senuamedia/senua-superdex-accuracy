# Study 10: why the solver stops on ant, and what the joint limit patch adds

| | |
|---|---|
| Registration | Tenth: [PREREGISTRATION_10.md](../../preregistrations/PREREGISTRATION_10.md) |
| Question | Why does SuperDex's solver stop without converging on `ant` on stock contact, and why more often with the joint limit patch alone? |
| Outcome | Every rule held: the nine rules S0 to S8, 38 rule lines of 38. Stock's stopped steps on `ant` come from the default estimate of friction's normal force, which SuperDex's own `explicitNormals` removes; the joint limit patch adds stops only of that kind. Both open items close |
| Registered | 14 October 2026, with the eleventh and twelfth registrations, committed and pushed before any run of this registration existed |
| Result | [Run 026](../../validation/run_026_ant_stops/README.md), 14 October 2026 |
| Runs | [022](../../validation/run_022_design_probes/) and [024](../../validation/run_024_design_probes/), design probes; [025](../../validation/run_025_identity/), safe when off; [026](../../validation/run_026_ant_stops/), the registered runs |
| Data | [`actions/10/`](../../actions/10/) (the registered commands), [`validation/run_026_ant_stops/`](../../validation/run_026_ant_stops/) (every play's stream and the solver's trace of every step) |
| Played by | [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp), [`tools/plays/play_10.sh`](../../tools/plays/play_10.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx) (`trace`, `rule`), `measure/runners/sx_study10_run.sh` |

Previous: [Study 9](09-rotation-axis.md). Next: [Study 11](11-friction-at-impact.md). All studies: [index](README.md).

## Why it was asked

From the fifth study on, `ant` stopped about 1 step in 100 at the solver's iteration limit on stock contact,
and the eighth study found it stopping more often with the joint limit
patch alone. The ninth study showed neither is the quaternion defect it found. Both were on the open list.

## The cause, read from the source

With SuperDex's `explicitNormals` off, which is the default, friction's normal force is computed from an estimate of
the start-of-step distance made from the current iterate. It moves from one Newton iteration to the next while its
derivative is left out of the Newton matrix. With `explicitNormals` on it is taken exactly from the start of the
step. SuperDex's own `ApplyImprovedConvergenceSettings` turns it on for that reason.

## What the probes found

- On one set of 108 throwaway episodes stock stopped 223 steps of 21,600; with `explicitNormals` 12; with
  `implicitNormalForceForDissipation` 1; with Armijo line search alone 216.
- On four sets the joint limit patch alone stopped more than stock in every set (by 22 to 41), while a 1 N m nudge
  of the commands moved the count either way. Without the ground neither stopped a step, and with `explicitNormals`
  both stopped 12.

## The rules

Nine rules, S0 to S8, in [PREREGISTRATION_10.md](../../preregistrations/PREREGISTRATION_10.md), S1 to S8 each in
each of the four sets: safe when off; stock stops at least 100 steps of 21,600; every stopped step of stock is at the
iteration limit, none with a residual under twice the absolute tolerance (2,000 millionths); with `explicitNormals`
on, stock stops no more than a fifth of the steps it stops without it, and with
`implicitNormalForceForDissipation` on, no more than a tenth; Armijo line search alone leaves at least half of them;
with no ground neither stock nor the joint limit patch stops a step; with `explicitNormals` on, the joint limit
patch stops no more than a fifth of the steps it stops without it, and no more than stock with `explicitNormals`
plus 21 (1 in 1,000).

## The result

Every rule held: the nine rules, 38 rule lines of 38 across the four registered command sets ([run
026](../../validation/run_026_ant_stops/)).
Stopped steps of 21,600, by set:

| Configuration | Set 0 | Set 1 | Set 2 | Set 3 |
|---|---|---|---|---|
| Stock | 206 | 213 | 204 | 191 |
| Stock with `explicitNormals` | 5 | 10 | 9 | 9 |
| Stock with `implicitNormalForceForDissipation` | 0 | 0 | 0 | 1 |
| Stock with Armijo line search (the control) | 237 | 220 | 212 | 193 |
| The joint limit patch alone | 258 | 239 | 256 | 217 |
| The joint limit patch with `explicitNormals` | 5 | 10 | 8 | 9 |
| Either, with no ground | 0 | 0 | 0 | 0 |
| Patches A to F | 0 | 0 | 0 | 0 |

## What it means

- **`ant`'s stopped steps on stock contact are SuperDex's default estimate of friction's normal force.** Fixing that
  estimate at the start of the step, with SuperDex's own `explicitNormals`, removes 95% to 98% of them. Line search
  does not: the iteration is not overshooting, its residual is not the derivative it is being solved with.
- **The joint limit patch adds stops, but only of that kind.** It changes how the legs meet the ground, and more
  of those meetings land on the estimated normal force. Without the ground it stops nothing; with `explicitNormals`
  it stops within one step of stock in every set (5, 10, 8 and 9 steps, against stock's 5, 10, 9 and 9).
- **With patches A to F, `ant` converges on every step** (patch G was not in this study's plays). The friction
  correction, patch F, gives friction the normal
  force of the step being solved, which removes the estimate altogether.

## What it does not show

The counts are of solver steps, not of motion: a stopped step is a step whose answer is less exact than the
tolerance, not a wrong motion. Limits: one scene, four sets of commands, the shipped step.
