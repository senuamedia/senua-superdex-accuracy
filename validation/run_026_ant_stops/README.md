# Run 026: the tenth registration, why the solver stops on ant

14 October 2026. Registered before this run ([PREREGISTRATION_10.md](../../preregistrations/PREREGISTRATION_10.md)), committed with the eleventh and twelfth registrations.
Library build 12. `ant` at the shipped step on the four registered command sets (`actions/10/`, 108 episodes each,
21,600 solver steps a play), played by [`tools/plays/play_10.sh`](../../tools/plays/play_10.sh) and measured by
`measure/runners/sx_study10_run.sh`.

**Result: every rule held, 38 of 38, with no value missing.**

Solver steps stopped without converging, of 21,600, by set:

| Configuration | Set 0 | Set 1 | Set 2 | Set 3 |
|---|---|---|---|---|
| Stock | 206 | 213 | 204 | 191 |
| Stock with SuperDex's `explicitNormals` | 5 | 10 | 9 | 9 |
| Stock with SuperDex's `implicitNormalForceForDissipation` | 0 | 0 | 0 | 1 |
| Stock with SuperDex's Armijo line search | 237 | 220 | 212 | 193 |
| Stock, first command of every episode larger by 1 N m | 207 | 229 | 216 | 174 |
| The joint limit patch alone | 258 | 239 | 256 | 217 |
| The joint limit patch with `explicitNormals` | 5 | 10 | 8 | 9 |
| Stock, no ground | 0 | 0 | 0 | 0 |
| The joint limit patch, no ground | 0 | 0 | 0 | 0 |
| Recommended configuration, patches A to E (reported) | 9 | 6 | 6 | 10 |
| The same with the friction correction, patch F (reported) | 0 | 0 | 0 | 0 |

Every stopped step of stock ran to the iteration limit, and the smallest residual among them was 4,187, 5,186,
4,367 and 4,127 millionths, more than four times the solver's absolute tolerance in every set.

| Rule | Held | Measured |
|---|---|---|
| S0 safe when off | yes | [run 025](../run_025_identity/): 362 of 362 files identical |
| S1 stock stops at least 100 | yes, 4 of 4 sets | 206, 213, 204, 191 |
| S2 every stop is at the limit, none near the tolerance | yes, 4 of 4 | all at 200 iterations; smallest residual 4,127 millionths |
| S3 `explicitNormals` leaves no more than a fifth | yes, 4 of 4 | 5, 10, 9, 9 (2% to 5%) |
| S4 `implicitNormalForceForDissipation` leaves no more than a tenth | yes, 4 of 4 | 0, 0, 0, 1 |
| S5 Armijo line search alone leaves at least half | yes, 4 of 4 | 237, 220, 212, 193 |
| S6 no ground, no stop | yes, 4 of 4 | 0 for stock and for the patch in every set |
| S7 the patch with `explicitNormals` no more than a fifth of the patch alone | yes, 4 of 4 | 5, 10, 8, 9 against 258, 239, 256, 217 |
| S8 the patch's extra stops go with `explicitNormals` | yes, 4 of 4 | 5, 10, 8, 9 against stock's 5, 10, 9, 9 |

Reported: the joint limit patch stopped more than stock in every set (+52, +26, +52, +26) while the nudge moved the
count both ways (+1, +16, +12, -17). With `explicitNormals` the two counts are equal to within one step in every
set. With every correction including the friction correction, no step of 86,400 stopped.

Files: `reading.txt` (every measured line and every rule), `set<i>/<configuration>.tr` (the solver's own trace of
every step), `set<i>/<configuration>_enc.pcm` (the stream), `set<i>/stats.txt`.
