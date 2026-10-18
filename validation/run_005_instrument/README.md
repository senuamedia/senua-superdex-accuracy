# Run 005: stage 2 of the second registration, the instrument's reading

The one run of the instrument registered in [PREREGISTRATION_02.md](../../preregistrations/PREREGISTRATION_02.md), made on 13 October
2026 after stages 0 and 1 ([run_004_counts](../run_004_counts/)) were recorded and committed. It ran as twelve
processes (three scenes by four parts). `reading.txt` is their output in order, exactly as produced, followed by
the pooled verdict. Nothing was re-run and nothing was tuned.

**Outcome: the registered claim did not hold in full. 25 of 36 cells held; calibration held.**

## The registered checks

| Check | Held | Where it fired |
|---|---|---|
| G0 calibration, pooled over 84 independent readings | yes: 1.23% of windows (bound 2 in 100) | nowhere |
| G1 detection: the coarse end is detected | 24 of 24 cells asked | nowhere |
| R0 the solver reference: five times the iterations is not detected against it | 9 of 9 | nowhere |
| A1 order, solver-convergence ladder | 8 of 9 | `ant`, one fold, at the fine end |
| A1 order, time-step chain | 6 of 9 | `half_cheetah`, all three folds |
| A1 order, contact-smoothing chain | 0 of 6 | `half_cheetah` and `ant`, all folds, at the fine end |
| N0 the control is not detected | 5 of 6 | `half_cheetah`, one fold |

Cells by scene: `cart_pole` 12 of 12 (six of them empty: it has no contact, so its contact chain and its control
are identical streams); `half_cheetah` 5 of 12; `ant` 8 of 12.

## How to read `reading.txt`

- Each process starts with a `LIBRARY` line (the detection bar and its noise slot) and ends with a `PART` line.
- `CELL <scene> <cell> fold <f>`: one cell. In a ladder cell, `reference_C` is the calibration reading and each
  rung line gives the windows flagged (`level A of B`) and the size (`magnitude`, in encoder counts). `refined
  sref2` is the reference with five times the iterations, read like a rung.
- In a chain cell, each `gap a against b` line is source a read against the next finer source b, with that gap's
  own calibration reading and whether it is detected (more flagged windows than the bar, 219).
- The last line of a cell gives the registered checks, 1 held and 0 fired.
- The last three lines of the file are the pooled calibration and the verdict.

## Solver convergence: each iteration limit against the limit of 200

Size in encoder counts (16,384 a turn), folds 0 / 1 / 2. A rung in brackets was not detected.

| Scene | Limit | Windows flagged | Size |
|---|---|---|---|
| cart_pole | 1 | 84.3% / 86.1% / 85.0% | 4.47M / 34.32M / 3.46M |
| cart_pole | 2 | 43.8% / 39.8% / 39.7% | 317.9k / 388.5k / 319.3k |
| cart_pole | 4 (shipped) | 7.1% / 1.9% / 3.3% | 27.4k / (1.8k) / (18.3k) |
| cart_pole | 8 | identical to the reference | |
| cart_pole | 16 | identical to the reference | |
| half_cheetah | 1 | 99.3% / 98.9% / 99.2% | 34.13M / 34.97M / 33.73M |
| half_cheetah | 2 | 99.2% / 98.8% / 98.3% | 29.15M / 30.90M / 32.59M |
| half_cheetah | 4 (shipped) | 98.4% / 98.4% / 97.6% | 18.84M / 18.07M / 20.55M |
| half_cheetah | 8 | 83.6% / 82.4% / 87.9% | 2.81M / 2.22M / 2.35M |
| half_cheetah | 16 | 31.8% / 26.5% / 30.5% | 255.3k / 210.9k / 260.0k |
| ant | 1 | 100.0% / 99.7% / 99.2% | 109.01M / 102.95M / 117.22M |
| ant | 2 | 96.9% / 93.1% / 94.7% | 45.43M / 36.53M / 37.19M |
| ant | 4 (shipped) | 66.3% / 53.5% / 52.5% | 3.85M / 3.24M / 2.05M |
| ant | 8 | 25.1% / 19.8% / 16.0% | 1.06M / 242.1k / 389.1k |
| ant | 16 | 16.9% / 8.9% / 10.9% | 574.9k / 591.3k / 310.6k |

The one cell that fired: on `ant` in fold 1 the limit 16 rung reads larger than the limit 8 rung. `ant`'s reference
keeps about 1 step in 100 `stopped` at limit 200 and still at limit 1,000 (stage 1: 237 and 226 of 21,600; the
limit 16 rung stops 707 and the limit 8 rung 3,926).

## Time step: each step against half of it

Size of each gap, folds 0 / 1 / 2. Backward Euler, 64-bit, limit 200.

| Scene | Gap (fraction of the shipped step) | Windows flagged | Size |
|---|---|---|---|
| cart_pole | 1 against 1/2 | 19% / 18% / 15% | 2.16M / 3.06M / 1.58M |
| cart_pole | 1/2 against 1/4 | 16% / 19% / 15% | 1.11M / 1.84M / 784.7k |
| cart_pole | 1/4 against 1/8 | 15% / 18% / 13% | 573.8k / 1.07M / 381.0k |
| cart_pole | 1/8 against 1/16 | 13% / 17% / 13% | 285.6k / 933.0k / 205.3k |
| half_cheetah | 1 against 1/2 | 97% / 100% / 100% | 4.39M / 4.18M / 4.03M |
| half_cheetah | 1/2 against 1/4 | 99% / 98% / 95% | 3.59M / 3.10M / 3.38M |
| half_cheetah | 1/4 against 1/8 | 98% / 95% / 97% | 4.86M / 3.68M / 4.59M |
| half_cheetah | 1/8 against 1/16 | 98% / 98% / 98% | 7.16M / 6.13M / 6.84M |
| ant | 1 against 1/2 | 96% / 95% / 92% | 8.49M / 7.82M / 8.62M |
| ant | 1/2 against 1/4 | 91% / 88% / 84% | 5.46M / 4.54M / 3.61M |
| ant | 1/4 against 1/8 | 72% / 70% / 70% | 3.05M / 2.12M / 2.20M |
| ant | 1/8 against 1/16 | 63% / 60% / 71% | 2.06M / 2.03M / 1.72M |

On `cart_pole` and `ant` every halving changes the motion less than the one before, in every fold. On
`half_cheetah` it does not: after the first halving the gaps grow, and the 1/8 against 1/16 gap is the largest, in
all three folds. The noiseless streams show the same without the instrument (stage 1: the largest difference of
those four gaps is 351, 325, 440 and 504 counts).

## Contact smoothing: each distance against half of it

Size of each gap, folds 0 / 1 / 2. `cart_pole` has no contact: every gap is byte-identical.

| Scene | Gap | Windows flagged | Size |
|---|---|---|---|
| half_cheetah | 10 against 5 mm | 74% / 71% / 70% | 770.0k / 712.7k / 831.1k |
| half_cheetah | 5 against 2.5 mm | 67% / 64% / 60% | 483.3k / 459.1k / 458.0k |
| half_cheetah | 2.5 against 1.25 mm | 54% / 58% / 51% | 277.3k / 288.9k / 251.9k |
| half_cheetah | 1.25 against 0.625 mm | 41% / 28% / 38% | 157.5k / 107.1k / 150.9k |
| half_cheetah | 0.625 against 0.3125 mm | 42% / 30% / 39% | 172.9k / 146.1k / 162.3k |
| ant | 10 against 5 mm | 42% / 43% / 45% | 3.56M / 2.53M / 3.42M |
| ant | 5 against 2.5 mm | 33% / 35% / 25% | 1.27M / 1.19M / 652.0k |
| ant | 2.5 against 1.25 mm | 24% / 22% / 21% | 275.8k / 371.8k / 232.6k |
| ant | 1.25 against 0.625 mm | 25% / 24% / 24% | 266.7k / 755.1k / 388.4k |
| ant | 0.625 against 0.3125 mm | 26% / 18% / 24% | 300.2k / 122.8k / 170.1k |

On `half_cheetah` the first four gaps fall at every step in every fold, and the last one (0.625 against 0.3125 mm)
does not: it is slightly larger than the one before. On `ant` the gaps fall to 2.5 against 1.25 mm and are
irregular below that. The sharper settings are also where the solver starts to stop short (stage 1: 30 and 66
steps on `half_cheetah`, 444 and 494 on `ant`).

## The control and the reported sources

Windows flagged and size, folds 0 / 1 / 2. The detection bar is 219 windows (3.6%). A reading in brackets was not
detected.

| Scene | Pair | Windows flagged | Size |
|---|---|---|---|
| cart_pole | Control: exact against fitted derivatives | identical streams | |
| cart_pole | Precision alone: 32-bit against 64-bit at the shipped settings | 1.4% / 1.3% / 2.7% | (1.4k) / (1.1k) / (2.5k) |
| cart_pole | Tolerance: a thousand times smaller against the default | 6.5% / 8.2% / 3.9% | 43.4k / 47.4k / 10.5k |
| cart_pole | BDF2 against backward Euler, both at 1/16 step | 98.0% / 98.4% / 96.8% | 1.56M / 2.74M / 1.44M |
| cart_pole | BDF2 at 1/16 step against BDF2 at 1/32 | 70.6% / 80.5% / 70.0% | 807.1k / 1.22M / 692.6k |
| cart_pole | SuperDex as shipped against the finest step played | 24.3% / 23.8% / 19.0% | 4.34M / 7.06M / 3.06M |
| cart_pole | 64-bit, limit 200 against the finest step played | 19.7% / 21.1% / 15.9% | 4.29M / 7.00M / 2.99M |
| half_cheetah | Control: exact against fitted derivatives | 2.1% / 3.9% / 1.2% | (2.3k) / 8.9k / (1.3k) |
| half_cheetah | Precision alone: 32-bit against 64-bit at the shipped settings | 5.1% / 5.9% / 1.6% | 22.6k / 121.1k / (5.3k) |
| half_cheetah | Tolerance: a thousand times smaller against the default | 5.2% / 1.2% / 2.4% | 4.7k / (1.3k) / (2.5k) |
| half_cheetah | BDF2 against backward Euler, both at 1/16 step | 97.7% / 99.7% / 98.4% | 13.23M / 14.93M / 14.87M |
| half_cheetah | BDF2 at 1/16 step against BDF2 at 1/32 | 90.4% / 88.8% / 84.2% | 6.85M / 7.77M / 5.86M |
| half_cheetah | SuperDex as shipped against the finest step played | 100.0% / 99.7% / 100.0% | 20.09M / 19.69M / 21.91M |
| half_cheetah | 64-bit, limit 200 against the finest step played | 100.0% / 99.4% / 99.9% | 12.80M / 12.57M / 13.42M |
| ant | Control: exact against fitted derivatives | 2.5% / 1.3% / 1.2% | (13.1k) / (1.3k) / (1.3k) |
| ant | Precision alone: 32-bit against 64-bit at the shipped settings | 53.1% / 37.8% / 37.2% | 3.68M / 2.75M / 1.58M |
| ant | Tolerance: a thousand times smaller against the default | 1.0% / 2.2% / 1.2% | (1.4k) / (2.0k) / (1.2k) |
| ant | BDF2 against backward Euler, both at 1/16 step | 74.6% / 75.9% / 67.1% | 3.10M / 2.54M / 2.99M |
| ant | BDF2 at 1/16 step against BDF2 at 1/32 | 69.5% / 67.4% / 65.8% | 2.84M / 2.17M / 2.19M |
| ant | SuperDex as shipped against the finest step played | 98.3% / 99.8% / 98.1% | 11.80M / 10.04M / 10.66M |
| ant | 64-bit, limit 200 against the finest step played | 98.6% / 99.4% / 98.5% | 10.46M / 9.43M / 10.71M |

The control fired once: on `half_cheetah` in fold 1 it flags 237 windows against the bar of 219. Stage 1 shows the
two streams are not the same there (907 of 21,600 readings differ, 69 by more than one count), so this is a small
real difference read once, as the pre-registration said could happen.
