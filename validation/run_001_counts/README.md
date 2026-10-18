# Run 001: stage 1, the counts

Stage 1 of [PREREGISTRATION_01.md](../../preregistrations/PREREGISTRATION_01.md): the rig plays every source and only counts are recorded.
The instrument has read nothing in this run.

## Files

| File | What it is |
|---|---|
| `stats_<scene>.txt` | One line a source, printed by the rig (`tools/sdx_player`): the settings, solver steps, the solver's own status of every step, the most iterations used, the range of the recorded joint |
| `counts.txt` | For each ladder: readings, range, readings at the s16 ceiling, and whether a rung's stream is byte-identical to its reference |
| `../../streams/01/` | The 45 streams (`SHA256SUMS` beside them) |

## How it was produced

`tools/plays/play_01.sh <superdex assets> cart_pole ant half_cheetah` on 13 October 2026, SuperDex v1.0.0
(`UPSTREAM_COMMIT`), one worker thread.

The host machine reset while the eighth `half_cheetah` source (`t4`) was playing. 37 sources were complete at that
point. The remaining 8 were played afterwards with the same command lines, in the same order, into the same files.
The `wall_s` field is a wall-clock time on a shared machine and is not a measurement of anything.

## Checks that the streams are what the rig produces

SuperDex is deterministic within a build, so a source can be played again and compared byte for byte. The streams
and comparisons of these four checks were kept only in a local working folder and are not part of the published
record, so their results are as noted at the time and cannot be checked from the record.

| Check | Result |
|---|---|
| `cart_pole` `s1` played again after the reset | encoder stream and full state byte-identical |
| `half_cheetah` `t2` (the last source finished before the reset) played again | encoder stream and full state byte-identical |
| `ant` with the contact smoothing set to 5 mm explicitly | byte-identical to `base`, which sets nothing |
| `half_cheetah` with the contact smoothing set to 5 mm explicitly | byte-identical to `base`, which sets nothing |

The last two confirm what the pre-registration assumed from the source: `base` is the 5 mm rung of ladder C.

## What the counts say

Structure only. Nothing else about the streams was looked at before stage 2.

**Rungs that are their reference.** A rung whose stream is byte-identical to its ladder's reference leaves the
ladder, as registered.

- `cart_pole`, ladder S: the 8 and 16 iteration rungs are identical to the reference (limit 200). The solver never
  uses more than 7 iterations on this scene, except in the fine-step reference `tref`, which reaches the limit of
  200. The ladder that remains is 1, 2, 4.
- `cart_pole`, ladder C: all four rungs are identical to the reference. The scene has no contact, so the setting
  changes nothing at all. The registered control (N0: no rung detected) therefore holds by construction, and it
  tests nothing about the instrument on this scene; the calibration check (G0) still does.
- Every other rung differs from its reference.

**Steps the solver did not converge.** SuperDex reports a status for every solver step. `stopped` is its status
for a step that "met at least one stopping criterion without converging to the requested tolerance"
(`nonlinear_solver_params.h`); the stopping criteria include the iteration limit and a relative tolerance on the
size of the update. No step in any source has the status `diverged`.

At the shipped settings (`s4`: backward Euler, limit 4):

| Scene | Solver steps | Stopped | Share |
|---|---|---|---|
| cart_pole | 21,600 | 22 | 0.1% |
| half_cheetah | 21,600 | 19,350 | 89.6% |
| ant | 21,600 | 17,089 | 79.1% |

The references, as the pre-registration said would be reported:

| Reference | cart_pole | half_cheetah | ant |
|---|---|---|---|
| S: limit 200 (`base`) | 0 of 21,600 | 4,437 of 21,600 (20.5%) | 2,525 of 21,600 (11.7%) |
| T: BDF2 at 1/16 step (`tref`) | 317,422 of 345,600 (91.8%) | 345,576 of 345,600 (all but 24) | 345,598 of 345,600 (all but 2) |
| C: 0.625 mm (`cref`) | 0 of 21,600 | 4,480 of 21,600 (20.7%) | 5,283 of 21,600 (24.5%) |

So the references are not converged solutions by the solver's own tolerance, most of all the fine-step reference
of ladder T, where nearly every step stops. Where the most iterations used is far below the limit (`cart_pole`
`t8`: 5; `ant` `tref`: 20) the stop was not the iteration limit. This is the risk the pre-registration named ("a
reference may not be converged"). It does not change the registered decision; it is part of how the result is read.

**Range.** No stream has a reading at the s16 ceiling.

## Every source

| Scene | Source | Settings | Solver steps | Converged | Stopped | Diverged | Most iterations |
|---|---|---|---|---|---|---|---|
| cart_pole | s1 | backward Euler, limit 1, 1/1 step | 21600 | 17239 | 4361 | 0 | 1 |
| cart_pole | s2 | backward Euler, limit 2, 1/1 step | 21600 | 21291 | 309 | 0 | 2 |
| cart_pole | s4 | backward Euler, limit 4, 1/1 step | 21600 | 21578 | 22 | 0 | 4 |
| cart_pole | s8 | backward Euler, limit 8, 1/1 step | 21600 | 21600 | 0 | 0 | 7 |
| cart_pole | s16 | backward Euler, limit 16, 1/1 step | 21600 | 21600 | 0 | 0 | 7 |
| cart_pole | base | backward Euler, limit 200, 1/1 step | 21600 | 21600 | 0 | 0 | 7 |
| cart_pole | t2 | backward Euler, limit 200, 1/2 step | 43200 | 43200 | 0 | 0 | 6 |
| cart_pole | t4 | backward Euler, limit 200, 1/4 step | 86400 | 72095 | 14305 | 0 | 5 |
| cart_pole | t8 | backward Euler, limit 200, 1/8 step | 172800 | 73034 | 99766 | 0 | 5 |
| cart_pole | tref | BDF2, limit 200, 1/16 step | 345600 | 28178 | 317422 | 0 | 200 |
| cart_pole | b1 | BDF2, limit 200, 1/1 step | 21600 | 21600 | 0 | 0 | 7 |
| cart_pole | c10 | backward Euler, limit 200, 1/1 step, smoothing 10 mm | 21600 | 21600 | 0 | 0 | 7 |
| cart_pole | c2 | backward Euler, limit 200, 1/1 step, smoothing 2.5 mm | 21600 | 21600 | 0 | 0 | 7 |
| cart_pole | c1 | backward Euler, limit 200, 1/1 step, smoothing 1.25 mm | 21600 | 21600 | 0 | 0 | 7 |
| cart_pole | cref | backward Euler, limit 200, 1/1 step, smoothing 0.625 mm | 21600 | 21600 | 0 | 0 | 7 |
| half_cheetah | s1 | backward Euler, limit 1, 1/1 step | 21600 | 17 | 21583 | 0 | 1 |
| half_cheetah | s2 | backward Euler, limit 2, 1/1 step | 21600 | 1467 | 20133 | 0 | 2 |
| half_cheetah | s4 | backward Euler, limit 4, 1/1 step | 21600 | 2250 | 19350 | 0 | 4 |
| half_cheetah | s8 | backward Euler, limit 8, 1/1 step | 21600 | 9125 | 12475 | 0 | 8 |
| half_cheetah | s16 | backward Euler, limit 16, 1/1 step | 21600 | 15672 | 5928 | 0 | 16 |
| half_cheetah | base | backward Euler, limit 200, 1/1 step | 21600 | 17163 | 4437 | 0 | 169 |
| half_cheetah | t2 | backward Euler, limit 200, 1/2 step | 43200 | 30301 | 12899 | 0 | 126 |
| half_cheetah | t4 | backward Euler, limit 200, 1/4 step | 86400 | 52407 | 33993 | 0 | 76 |
| half_cheetah | t8 | backward Euler, limit 200, 1/8 step | 172800 | 13555 | 159245 | 0 | 200 |
| half_cheetah | tref | BDF2, limit 200, 1/16 step | 345600 | 24 | 345576 | 0 | 200 |
| half_cheetah | b1 | BDF2, limit 200, 1/1 step | 21600 | 16421 | 5179 | 0 | 200 |
| half_cheetah | c10 | backward Euler, limit 200, 1/1 step, smoothing 10 mm | 21600 | 17159 | 4441 | 0 | 200 |
| half_cheetah | c2 | backward Euler, limit 200, 1/1 step, smoothing 2.5 mm | 21600 | 17169 | 4431 | 0 | 200 |
| half_cheetah | c1 | backward Euler, limit 200, 1/1 step, smoothing 1.25 mm | 21600 | 17142 | 4458 | 0 | 200 |
| half_cheetah | cref | backward Euler, limit 200, 1/1 step, smoothing 0.625 mm | 21600 | 17120 | 4480 | 0 | 200 |
| ant | s1 | backward Euler, limit 1, 1/1 step | 21600 | 0 | 21600 | 0 | 1 |
| ant | s2 | backward Euler, limit 2, 1/1 step | 21600 | 954 | 20646 | 0 | 2 |
| ant | s4 | backward Euler, limit 4, 1/1 step | 21600 | 4511 | 17089 | 0 | 4 |
| ant | s8 | backward Euler, limit 8, 1/1 step | 21600 | 16869 | 4731 | 0 | 8 |
| ant | s16 | backward Euler, limit 16, 1/1 step | 21600 | 19066 | 2534 | 0 | 16 |
| ant | base | backward Euler, limit 200, 1/1 step | 21600 | 19075 | 2525 | 0 | 200 |
| ant | t2 | backward Euler, limit 200, 1/2 step | 43200 | 12687 | 30513 | 0 | 200 |
| ant | t4 | backward Euler, limit 200, 1/4 step | 86400 | 2838 | 83562 | 0 | 44 |
| ant | t8 | backward Euler, limit 200, 1/8 step | 172800 | 181 | 172619 | 0 | 31 |
| ant | tref | BDF2, limit 200, 1/16 step | 345600 | 2 | 345598 | 0 | 20 |
| ant | b1 | BDF2, limit 200, 1/1 step | 21600 | 16194 | 5406 | 0 | 200 |
| ant | c10 | backward Euler, limit 200, 1/1 step, smoothing 10 mm | 21600 | 19533 | 2067 | 0 | 200 |
| ant | c2 | backward Euler, limit 200, 1/1 step, smoothing 2.5 mm | 21600 | 18354 | 3246 | 0 | 200 |
| ant | c1 | backward Euler, limit 200, 1/1 step, smoothing 1.25 mm | 21600 | 17421 | 4179 | 0 | 200 |
| ant | cref | backward Euler, limit 200, 1/1 step, smoothing 0.625 mm | 21600 | 16317 | 5283 | 0 | 200 |
