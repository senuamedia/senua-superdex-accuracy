# Run 011: the fourth registration, part B. The benchmark link

Recorded on 14 October 2026 for [PREREGISTRATION_04.md](../../preregistrations/PREREGISTRATION_04.md). `half_cheetah` and `ant` with the
ground, on the third registration's commands (`actions/03/`, 108 episodes), with SuperDex's contact damping
coefficient at 5 on every actor and nothing else changed. Each source differs from the third registration's shipped
source of the same step by the damping alone. No instrument: plain subtraction of the rig's encoder streams.

| File | What it is |
|---|---|
| `stats_<scene>.txt` | One line a source from the rig, with the solver's own status of every step |
| `counts.txt` | Every comparison as the harness printed it |
| `../../streams/04/` | The 13 streams (`SHA256SUMS` beside them), played by `tools/plays/play_04.sh` |

## Rule L1: held

Plain subtraction over each fold's 36 test episodes, from the coarsest gap to the finest (step 1 to 1/2, 1/2 to 1/4,
1/4 to 1/8, 1/8 to 1/16).

| half_cheetah with the ground | Fold 0 | Fold 1 | Fold 2 | In order |
|---|---|---|---|---|
| Shipped ([run 007](../run_007_counts/)) | 4,144,564; 3,200,618; 4,688,047; 8,051,707 | 4,266,572; 3,388,408; 4,711,505; 7,035,001 | 3,504,062; 3,053,908; 3,415,118; 5,662,877 | 0 folds of 3 |
| Contact damping 5 | 3,929,347; 2,333,050; 1,470,814; 1,278,152 | 4,219,209; 2,587,302; 1,483,106; 883,347 | 3,229,993; 1,861,165; 1,102,688; 782,590 | 3 folds of 3 |

The same commands, the same rig, the same steps. With the shipped contact the finest gap is the largest. With a
contact that has a loss of its own, every gap is smaller than the one before, and the next gap, 1/16 to 1/32, is
smaller again in every fold (790,448; 561,531; 401,834).

## Reported

- **`ant`.** Shipped, its chain to 1/64 of the step was in order in no fold. With contact damping it is in order in
  all three, out to 1/64 (fold 0: 8,758,689; 4,348,440; 2,553,039; 1,266,592; 692,989; 474,695).
- **By part of the episode**, `half_cheetah` with contact damping, the last fifth of the episode from the coarsest
  gap to the finest: 150,855; 91,484; 50,573; 37,409; 19,610. Shipped, the same part read 153,207; 99,255; 99,410;
  146,268; 256,808.
- **The solver.** With contact damping, `ant`'s steps that stop without converging fall from 228 of 21,600 to 9 at
  the shipped step. `half_cheetah` has 2 (shipped: 3). No step diverged.
