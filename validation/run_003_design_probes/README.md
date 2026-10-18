# Run 003: design probes, on throwaway actions

Made on 13 October 2026 after the first registration did not hold, to design the second
([PREREGISTRATION_02.md](../../preregistrations/PREREGISTRATION_02.md)). These are not registered data: six episodes a scene on seeded
actions (seeds 9101, 9102, 9103) that are used nowhere else. The action files and the probe's command lines were not
kept, so the seeds are as noted at the time and cannot be checked from the record. The instrument read none of the
probe streams. `probe.txt` is the output as produced. `null_preliminary.txt` is the instrument's preliminary reading
on noise alone (405 readings), which the second registration cites for its stage 0.

**The question:** which of SuperDex's accuracy settings give solves that converge, what does each cost, and do
successively finer settings agree with each other?

## How to read `probe.txt`

- `PLAY <scene> <name> ...`: one source. `real_bits` is the arithmetic of the SuperDex build (32 as shipped, 64 with
  `MOCHI_USE_DOUBLE_PRECISION=ON`). `converged`, `stopped` and `diverged` are the solver's own status of every step
  (`stopped` means without converging). `most_iterations` is the most any step used, `worst_residual` the worst residual
  norm, `extra` the settings beyond the first registration's.
- `PAIR <scene> <a> vs <b>`: the two encoder streams compared reading for reading: how many of the 1,200 readings
  differ, how many by more than one count, the largest difference in counts, how many of the 6 episodes have a
  reading more than one count apart, and the earliest step of an episode at which that happens.

## What it showed

| | cart_pole | half_cheetah | ant |
|---|---|---|---|
| Steps stopped, shipped settings (32-bit, limit 4) | 1 of 1,200 | 1,083 | 901 |
| Steps stopped, 64-bit, limit 200 | 0 | 0 | 11 |
| Limit 1,000 against limit 200 | identical | identical | identical |
| Steps stopped, any finer time step (64-bit, limit 200) | 0 | 0 | 0 |
| 64-bit against 32-bit at the shipped settings, largest difference | identical | 3 counts | 383 counts |
| Exact against fitted derivatives, largest difference | identical | 1 count | 1 count |
| Direct or constant-tolerance linear solve against the default | identical | identical | identical |
| Solver tolerances a thousand times smaller, largest difference | 3 counts | 1 count | 1 count |
| BDF2 at 1/16 step against 1/32, largest difference | 45 counts | 553 | 272 |
| DIRK33 (third order) at 1/8 step against 1/16, largest difference | 20 counts | 304 | 213 |
| Contact smoothing 0.625 mm against 0.3125 mm, largest difference | identical (no contact) | 6 counts | 101 |

One count is 0.022 degrees of the recorded joint.

- **64-bit arithmetic makes the solves converge** at limit 200, except 11 of `ant`'s 1,200 steps, and the iteration
  limit then saturates: more iterations change nothing.
- **The time step does not converge to one answer.** Halving it again still moves the joint by tens to hundreds of
  counts, with second and third order integrators alike, starting within the first ten readings of an episode with
  BDF2 (2 to 8) and within the first 16 with DIRK33 (0 to 16).
- **Contact smoothing does not either**, more mildly.

So the second registration uses a reference only for solver convergence, and reads the time step and the contact
smoothing as chains of successive refinements.
