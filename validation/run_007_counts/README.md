# Run 007: stage 1 of the third registration (no instrument)

Recorded on 13 October 2026 for [PREREGISTRATION_03.md](../../preregistrations/PREREGISTRATION_03.md), before the instrument read any
stream of this registration. Four of the six registered rules are decided here, by plain subtraction of the rig's
noiseless encoder streams.

## Files

| File | What it is |
|---|---|
| `stats_<scene>.txt` | One line a source from the rig, with the solver's own status of every step |
| `identity_<scene>.txt` | Rule R1: the reference played twice, and with the nudge at zero, compared byte for byte |
| `counts.txt` | Every comparison as the harness printed it, and the four rules in its last lines |
| `../../streams/03/` | The 84 streams (`SHA256SUMS` beside them), played by `tools/plays/play_03.sh` |

## The four rules

| Rule | Result |
|---|---|
| **R1** the rig repeats | **Held.** Six of six pairs byte-identical, encoder stream and state file |
| **N1** the scenes do not amplify a tiny change | **Held.** With the first command nudged by 1e-9 or by 1e-6, every one of the 21,600 readings is identical to the reference, on all three scenes |
| **E1** `half_cheetah` with the ground is out of order | **Held.** Out of order in three folds of three |
| **R2** in order with nothing touching the agent | **Fired on `cart_pole`.** `half_cheetah` without the ground: three folds of three in order. `ant` without the ground: three of three. `cart_pole`: two of three |

One rule fired, so the registered claim does not hold in full. The registration named this risk in advance for
`cart_pole` and it is recorded as measured.

## Where each rule's numbers are

Plain subtraction over each fold's 36 test episodes, from the coarsest gap to the finest (step 1 to 1/2, 1/2 to 1/4,
1/4 to 1/8, 1/8 to 1/16):

| Chain | Fold 0 | Fold 1 | Fold 2 |
|---|---|---|---|
| `half_cheetah` with the ground | 4,144,564; 3,200,618; 4,688,047; 8,051,707 | 4,266,572; 3,388,408; 4,711,505; 7,035,001 | 3,504,062; 3,053,908; 3,415,118; 5,662,877 |
| `half_cheetah` without the ground | 2,706,016; 1,500,647; 804,733; 411,653 | 2,499,612; 1,385,238; 742,798; 381,279 | 2,338,801; 1,311,616; 688,374; 355,058 |
| `ant` with the ground | 8,773,448; 4,265,563; 2,504,577; 1,609,182 | 10,374,235; 4,933,983; 2,910,289; 1,666,059 | 11,813,878; 6,702,443; 3,747,664; 2,987,318 |
| `ant` without the ground | 7,763,092; 3,518,317; 1,959,527; 1,240,413 | 8,578,761; 4,533,357; 2,710,896; 1,229,790 | 9,719,125; 6,006,797; 2,488,569; 1,786,433 |
| `cart_pole` (no ground, no contact) | 2,189,682; 1,108,814; 562,389; 310,285 | 31,102,509; 1,383,158; 655,841; 294,097 | 12,109,368; 22,562,429; 1,015,323; 413,291 |

- **`half_cheetah`.** Without the ground each gap is a little over half the one before, in every fold. With the
  ground the finest gap is the largest, in every fold. The same commands, the same rig, the same stepping: the
  ground is the difference.
- **`ant`.** In order with and without the ground down to 1/16 of the step, as in the second registration.
- **`cart_pole`.** In fold 2 the gap between the 10 ms and 5 ms steps is larger than the gap between 20 ms and
  10 ms. The by-part lines of `counts.txt` (`TIME cart_pole`, all 108 episodes) show where: the two coarsest
  pairs differ by hundreds of thousands of counts late in the episode while every finer pair differs by a few
  hundred. `cart_pole`'s pole ends each episode
  resting on one of its joint limits (the recorded joint reads plus or minus 4,143 counts, 91 degrees), and in a
  few episodes the coarsest steps put it on the other side from the finer steps. The finer four steps agree with
  each other and halve.

## By part of the episode (reported)

The summed absolute difference over all 108 episodes, in each part of the episode (readings 0-5, 5-10, 10-20, 20-40,
40-80, 80-120, 120-160, 160-200), from `counts.txt`.

| half_cheetah with the ground | 0-5 | 5-10 | 10-20 | 20-40 | 40-80 | 80-120 | 120-160 | 160-200 |
|---|---|---|---|---|---|---|---|---|
| step 1 to 1/2 | 2,824 | 3,802 | 18,062 | 72,316 | 143,228 | 156,279 | 145,461 | 153,207 |
| 1/2 to 1/4 | 1,535 | 2,048 | 12,153 | 68,123 | 116,633 | 109,626 | 93,696 | 99,255 |
| 1/4 to 1/8 | 807 | 1,056 | 8,287 | 76,784 | 170,969 | 137,575 | 94,220 | 99,410 |
| 1/8 to 1/16 | 416 | 531 | 6,138 | 80,816 | 248,248 | 220,385 | 210,331 | 146,268 |
| 1/16 to 1/32 | 197 | 258 | 4,097 | 52,255 | 307,767 | 318,396 | 298,786 | 256,808 |
| 1/32 to 1/64 | 97 | 141 | 2,336 | 26,846 | 262,532 | 345,663 | 364,399 | 353,582 |

| half_cheetah without the ground | 0-5 | 5-10 | 10-20 | 20-40 | 40-80 | 80-120 | 120-160 | 160-200 |
|---|---|---|---|---|---|---|---|---|
| step 1 to 1/2 | 2,824 | 3,804 | 16,797 | 51,128 | 143,701 | 151,619 | 146,435 | 151,746 |
| 1/2 to 1/4 | 1,535 | 2,048 | 9,029 | 28,060 | 80,706 | 87,537 | 82,900 | 86,121 |
| 1/4 to 1/8 | 807 | 1,056 | 4,667 | 14,712 | 42,902 | 47,267 | 44,345 | 46,538 |
| 1/8 to 1/16 | 416 | 531 | 2,369 | 7,523 | 22,293 | 24,348 | 23,004 | 23,838 |

For the first ten readings the two are the same to within two counts: the ground plays no part yet. After that the
chain without the ground keeps halving and the chain with the ground stops. At 1/64 of the shipped step its gaps
are still growing from reading 80 on; up to reading 80 the last gap is smaller than the one before it.

- **`ant` with the ground, beyond 1/16.** The last part of the episode, from the coarsest gap to the finest:
  323,073; 169,769; 112,643; 75,195; 61,925; 122,350. The order is lost at 1/64.
- **Friction off (reported).** `half_cheetah`: out of order in all three folds, the finest gap again the largest
  in folds 0 and 1 (fold 0: 2,738,823; 1,590,612; 1,543,505; 2,932,766); in fold 2 it rises again but stays below
  the coarsest (2,446,330; 1,427,204; 1,215,035; 1,796,239). `ant`: in order in all three.
- **Contact smoothing (reported).** Out of order by plain subtraction in every fold on both scenes, at the sharp
  end, as in the second registration.
- **The larger nudges (reported).** A nudge of 1e-3 changes 9 readings in 21,600 on `half_cheetah`, by one count
  each, and parts no episode. A nudge of 1 gives a summed difference of 12,377 counts on `half_cheetah`, 68,235 on
  `ant` and 106,409 on `cart_pole`.

## The solver's own status

No step in any of the 84 sources diverged. Steps that ended `stopped` (without converging to tolerance):

| Source | cart_pole | half_cheetah | ant |
|---|---|---|---|
| `sref` | 0 of 21,600 | 3 | 228 |
| `t2 t4 t8 t16 t32 t64` | 0 | 1, 0, 0, 1, 0, 0 | 49, 9, 0, 0, 0, 0 |
| `g1` to `g16` (no ground) | not played | 0 | 0 |
| `m1` to `m16` (friction off) | not played | 0 | 0 |
| `c10 c2 c1 c06 c03` | not played | 2, 2, 12, 33, 85 | 116, 333, 370, 434, 430 |
| `s1 s2 s4 s8 s16` | 4,103; 328; 28; 0; 0 | 21,587; 20,054; 18,640; 10,346; 3,135 | 21,600; 20,671; 17,041; 4,022; 760 |

At limit 200 every solve converges without the ground, with friction off, and on `cart_pole`. The steps that stop
at limit 200 are the ones with friction on the ground, and more of them stop as the contact is made sharper. Below
limit 200 the solver ladder stops steps on every scene, `cart_pole` (no ground) included.
