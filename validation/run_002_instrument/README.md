# Run 002: stage 2, the instrument's reading

The one run of the instrument registered in [PREREGISTRATION_01.md](../../preregistrations/PREREGISTRATION_01.md), made on 13 October 2026
after stage 1 ([run_001_counts](../run_001_counts/)) was recorded and committed. `reading.txt` is the output exactly
as produced. Nothing was re-run and nothing was tuned.

**Outcome: the registered claim did not hold in full. 16 of 27 cells held.**

## How to read `reading.txt`

- `CELL <scene> <ladder> fold <f>`: one scene, one ladder, one fold. The 108 episodes are three blocks of 36; in fold
  f the normal is declared on one block and a different block is read.
- `reference_C level A of B`: the reference read against itself (a third noisy run of it). A of the B windows read
  were flagged. This is the calibration reading.
- `<source> level A of B ... magnitude M`: A of B windows flagged for that source against the reference; M is the
  size, the summed absolute difference over the flagged windows, in encoder counts (16,384 a turn). `change` is a
  second flag the instrument reports; no registered check uses it.
- `IS the reference (identical stream)`: the source is byte-identical to its reference (stage 1) and left the ladder.
- The last line of a cell gives the registered checks, 1 held and 0 fired: `G0` calibration, `G1` detection of the
  coarsest rung, `A1` order, `N0` the control. Ladder `X` holds the two sources reported beside the ladders.

## The registered checks

| Check | Held | Where it fired |
|---|---|---|
| G0 calibration: the reference against itself flags at most 2 in 100 windows | 18 of 27 cells | every cell of fold 2: 128 of 6,084 windows, 2.10% |
| G1 detection: the coarsest rung is flagged | 24 of 24 | nowhere |
| A1 order: among detected rungs the size falls at every step toward the reference | 21 of 24 | `cart_pole` time integration, folds 1 and 2; `ant` contact, fold 1 |
| N0 control: no rung detected where the setting cannot matter | 3 of 3 | nowhere, but see below |

By fold: 9 of 9 cells held in fold 0, 7 of 9 in fold 1, 0 of 9 in fold 2.

**The calibration check is one reading a fold, not nine.** The calibration reading is one noisy run of a reference
minus another. The reference cancels, and what is left is the simulated sensor noise, which was seeded the same way for
every scene and ladder. So every cell of a fold makes the same calibration reading: 0.38%, 0.72% and 2.10% for the
three folds, as the identical `reference_C` lines show. One of those three readings is 7 windows over the bound,
and it counts against all nine cells of its fold. That is a weakness of this registration's design. It is recorded
as registered.

**The control is empty.** On `cart_pole` all four contact rungs are byte-identical to the reference (stage 1), so
there was nothing for the instrument to read and N0 held by construction.

**Where the order fired.**

- `cart_pole`, time integration, fold 1: the size falls from the shipped step to 1/4 step, then rises at 1/8.
- `cart_pole`, time integration, fold 2: the 1/4 and 1/8 step sources read farther from the reference than the
  shipped step does. The same two sources read 13 to 17 times smaller in fold 0. Either a few episodes part
  completely on this unstable scene (a risk named in the pre-registration), or the reference is not a converged
  solution (317,422 of its 345,600 solver steps end `stopped`, stage 1). This run does not separate the two.
- `ant`, contact, fold 1: the shipped 5 mm rung reads below the 2.5 mm and 1.25 mm rungs. Folds 0 and 2 are in
  order.

## Every reading

Flagged: the share of windows flagged. Size: the gated magnitude in encoder counts. Each cell is fold 0 / 1 / 2.
The last column is derived from the other two: size / (flagged windows x 32 readings), the mean difference a
reading in the flagged windows, in counts. Differences that change sign inside a window partly cancel, so it
understates. One count is 0.022 degrees.


### cart_pole: S solver convergence (reference: limit 200)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `s1` | limit 1 | 81.4% / 86.7% / 93.3% | 4.49M / 36.60M / 9.17M | 28.3 / 216.8 / 50.5 |
| `s2` | limit 2 | 47.6% / 44.3% / 37.9% | 506.3k / 441.0k / 338.0k | 5.5 / 5.1 / 4.6 |
| `s4` | limit 4, shipped | 8.1% / 8.1% / 2.3% | 46.3k / 30.8k / 2.8k | 2.9 / 2.0 / 0.6 |
| `s8` | limit 8 | identical to the reference | | |
| `s16` | limit 16 | identical to the reference | | |

### cart_pole: T time integration (reference: BDF2 at 1/16 step)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `base` | shipped step | 97.6% / 96.5% / 98.6% | 5.39M / 7.00M / 8.04M | 28.4 / 37.3 / 41.9 |
| `t2` | 1/2 step | 97.2% / 95.6% / 98.7% | 3.03M / 3.49M / 6.41M | 16.0 / 18.8 / 33.4 |
| `t4` | 1/4 step | 97.9% / 96.0% / 98.4% | 2.05M / 2.37M / 27.74M | 10.7 / 12.7 / 144.8 |
| `t8` | 1/8 step | 96.5% / 95.7% / 97.8% | 1.71M / 3.32M / 29.43M | 9.1 / 17.8 / 154.6 |

### cart_pole: C contact compliance (reference: 0.625 mm)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `c10` | 10 mm | identical to the reference | | |
| `base` | 5 mm, shipped | identical to the reference | | |
| `c2` | 2.5 mm | identical to the reference | | |
| `c1` | 1.25 mm | identical to the reference | | |

### cart_pole: beside the ladders (against the T reference)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `s4` | the shipped source | 91.0% / 95.2% / 98.6% | 5.25M / 6.94M / 8.05M | 29.6 / 37.4 / 41.9 |
| `b1` | BDF2 at the shipped step | 100.0% / 100.0% / 100.0% | 57.56M / 95.80M / 61.52M | 295.7 / 492.0 / 316.0 |

### half_cheetah: S solver convergence (reference: limit 200)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `s1` | limit 1 | 98.3% / 99.0% / 99.2% | 33.06M / 39.33M / 30.17M | 172.8 / 204.1 / 156.2 |
| `s2` | limit 2 | 96.6% / 97.7% / 97.9% | 32.32M / 35.64M / 28.22M | 171.8 / 187.3 / 148.0 |
| `s4` | limit 4, shipped | 93.5% / 96.0% / 98.4% | 17.43M / 23.16M / 18.99M | 95.7 / 123.9 / 99.1 |
| `s8` | limit 8 | 76.2% / 74.2% / 85.3% | 2.35M / 2.02M / 2.84M | 15.8 / 14.0 / 17.1 |
| `s16` | limit 16 | 22.6% / 30.8% / 34.4% | 277.7k / 268.4k / 414.9k | 6.3 / 4.5 / 6.2 |

### half_cheetah: T time integration (reference: BDF2 at 1/16 step)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `base` | shipped step | 99.1% / 99.0% / 100.0% | 21.85M / 22.02M / 19.50M | 113.2 / 114.3 / 100.2 |
| `t2` | 1/2 step | 98.0% / 99.8% / 99.9% | 20.54M / 20.30M / 17.85M | 107.7 / 104.5 / 91.7 |
| `t4` | 1/4 step | 97.2% / 98.8% / 99.9% | 19.10M / 18.59M / 16.12M | 100.9 / 96.6 / 82.8 |
| `t8` | 1/8 step | 96.9% / 98.2% / 99.9% | 17.33M / 16.96M / 14.55M | 91.9 / 88.7 / 74.8 |

### half_cheetah: C contact compliance (reference: 0.625 mm)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `c10` | 10 mm | 76.9% / 81.0% / 87.0% | 1.52M / 1.77M / 1.59M | 10.1 / 11.2 / 9.4 |
| `base` | 5 mm, shipped | 67.8% / 75.3% / 81.0% | 862.0k / 1.06M / 926.0k | 6.5 / 7.3 / 5.9 |
| `c2` | 2.5 mm | 55.6% / 64.2% / 67.1% | 436.7k / 568.7k / 480.8k | 4.0 / 4.5 / 3.7 |
| `c1` | 1.25 mm | 28.7% / 41.5% / 40.2% | 133.0k / 186.4k / 186.7k | 2.4 / 2.3 / 2.4 |

### half_cheetah: beside the ladders (against the T reference)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `s4` | the shipped source | 98.2% / 99.3% / 99.9% | 24.06M / 28.06M / 24.77M | 125.8 / 145.1 / 127.3 |
| `b1` | BDF2 at the shipped step | 97.4% / 98.8% / 99.9% | 19.66M / 17.51M / 16.57M | 103.7 / 91.1 / 85.2 |

### ant: S solver convergence (reference: limit 200)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `s1` | limit 1 | 99.1% / 99.2% / 100.0% | 128.20M / 126.97M / 118.19M | 664.5 / 657.4 / 607.1 |
| `s2` | limit 2 | 88.5% / 93.7% / 97.3% | 38.22M / 44.36M / 37.52M | 221.8 / 243.2 / 198.2 |
| `s4` | limit 4, shipped | 52.8% / 49.9% / 61.6% | 4.49M / 3.42M / 4.58M | 43.6 / 35.2 / 38.2 |
| `s8` | limit 8 | 17.2% / 15.5% / 24.0% | 3.66M / 756.4k / 1.26M | 109.1 / 25.1 / 27.0 |
| `s16` | limit 16 | 13.9% / 10.5% / 19.3% | 3.54M / 482.5k / 1.03M | 130.4 / 23.7 / 27.3 |

### ant: T time integration (reference: BDF2 at 1/16 step)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `base` | shipped step | 89.3% / 95.2% / 98.9% | 12.27M / 12.21M / 11.53M | 70.6 / 65.8 / 59.9 |
| `t2` | 1/2 step | 80.9% / 84.9% / 95.5% | 8.84M / 6.95M / 6.74M | 56.1 / 42.0 / 36.2 |
| `t4` | 1/4 step | 71.2% / 76.2% / 89.0% | 5.82M / 3.85M / 4.21M | 42.0 / 26.0 / 24.3 |
| `t8` | 1/8 step | 66.0% / 70.9% / 82.9% | 4.41M / 3.02M / 3.33M | 34.4 / 21.9 / 20.7 |

### ant: C contact compliance (reference: 0.625 mm)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `c10` | 10 mm | 46.7% / 43.2% / 52.6% | 6.58M / 5.15M / 3.44M | 72.4 / 61.3 / 33.6 |
| `base` | 5 mm, shipped | 34.0% / 28.1% / 45.3% | 2.67M / 833.5k / 1.80M | 40.3 / 15.2 / 20.4 |
| `c2` | 2.5 mm | 24.7% / 30.0% / 34.8% | 1.66M / 1.44M / 580.7k | 34.6 / 24.6 / 8.6 |
| `c1` | 1.25 mm | 23.3% / 20.8% / 27.5% | 1.63M / 1.11M / 331.0k | 36.1 / 27.4 / 6.2 |

### ant: beside the ladders (against the T reference)

| Source | Setting | Flagged | Size | Mean difference a reading (counts) |
|---|---|---|---|---|
| `s4` | the shipped source | 90.1% / 94.4% / 99.1% | 13.10M / 13.05M / 12.36M | 74.7 / 71.0 / 64.0 |
| `b1` | BDF2 at the shipped step | 92.9% / 96.3% / 99.7% | 17.97M / 18.17M / 14.72M | 99.3 / 96.9 / 75.9 |
