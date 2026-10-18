# Run 004: stages 0 and 1 of the second registration

Recorded on 13 October 2026 for [PREREGISTRATION_02.md](../../preregistrations/PREREGISTRATION_02.md), before the instrument read any
stream of this registration.

## Files

| File | What it is |
|---|---|
| `stage0_null.txt` | Stage 0: 810 calibration readings on noise alone, and the detection bar |
| `stats_<scene>.txt` | Stage 1: one line a source from the rig, with the solver's own status of every step |
| `counts.txt` | Stage 1: for the ladder and each chain, how far apart the noiseless streams are |
| `../../streams/02/` | The 63 streams (`SHA256SUMS` beside them), played by `tools/plays/play_02.sh` |

## Stage 0: calibration on noise alone

A calibration reading is one noisy run of a reference minus another, so the reference cancels and only the simulated
sensor noise is read. 810 independent readings, each 6,084 windows:

| | |
|---|---|
| Pooled share of windows flagged | 1.17% (design: 1 in 100) |
| Single readings | smallest 0, median 64 windows (1.1%), nine in ten under 131 (2.2%), largest 312 (5.1%) |
| Readings above 2 in 100 | 103 of 810 (13%) |
| **Detection bar B** | **219 windows (3.6%)**: 8 of the 810 readings exceed it, 1 in 100 |

So one calibration reading in eight exceeds "2 in 100" by chance. The first registration's rules compared single
readings with 2 in 100; this registration detects against B and judges calibration pooled.

## Stage 1: the solver's own status

Steps that ended `stopped` (without converging to tolerance), of the solver steps played. No step in any of the 63
sources diverged.

| Source | cart_pole | half_cheetah | ant |
|---|---|---|---|
| `ship32`: SuperDex as shipped (32-bit, limit 4) | 21 of 21,600 | 19,267 (89.2%) | 17,125 (79.3%) |
| `s4`: the same in 64-bit | 21 | 18,762 (86.9%) | 17,281 (80.0%) |
| `sref`: 64-bit, limit 200 | 0 | 0 | 237 (1.1%) |
| `sref2`: 64-bit, limit 1,000 | 0 | 0 | 226 (1.0%) |
| `t16`: 64-bit, limit 200, 1/16 step | 0 of 345,600 | 1 | 0 |
| `c03`: 64-bit, limit 200, 0.3125 mm smoothing | 0 | 66 (0.3%) | 494 (2.3%) |

In 64-bit at limit 200 and the shipped smoothing, the solves converge on `cart_pole` and `half_cheetah`, and on all
but about 1 step in 100 on `ant`. At 0.3125 mm smoothing more stop: 66 steps of `half_cheetah` and 494 (2.3%) of
`ant`.

## Stage 1: structure of the streams

- **Solver ladder.** On `cart_pole` the limit 8 and 16 rungs are byte-identical to the reference and leave the
  ladder. The refined reference (limit 1,000) is byte-identical to the reference on `cart_pole` and
  `half_cheetah`. On `ant` it differs on 425 of 21,600 readings, by at most 5 counts.
- **Contact chain.** On `cart_pole` every gap is identical (no contact): the chain is empty there, as expected.
- **Control.** On `cart_pole` the control is identical to the reference: empty there. On `half_cheetah` it differs
  on 907 readings, 69 of them by more than one count (largest 6). On `ant` it differs on 669 readings, 123 by more
  than one count (largest 58).
- **No reading is at the encoder's ceiling.**

Largest difference in counts between the two noiseless streams of each gap (one count is 0.022 degrees):

| Gap | cart_pole | half_cheetah | ant |
|---|---|---|---|
| Time step 1 against 1/2 | 2,446 | 351 | 837 |
| 1/2 against 1/4 | 1,433 | 325 | 635 |
| 1/4 against 1/8 | 1,178 | 440 | 446 |
| 1/8 against 1/16 | 1,326 | 504 | 392 |
| Smoothing 10 mm against 5 mm | identical | 98 | 875 |
| 5 against 2.5 mm | identical | 91 | 700 |
| 2.5 against 1.25 mm | identical | 57 | 360 |
| 1.25 against 0.625 mm | identical | 38 | 660 |
| 0.625 against 0.3125 mm | identical | 32 | 170 |

The largest single difference is not the registered measure of a gap; the instrument's size is, in stage 2. Nothing
else about the streams was looked at before stage 2.
