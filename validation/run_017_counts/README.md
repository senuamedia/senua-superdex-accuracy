# Run 017: the seventh registration, run once. Every rule held.

14 October 2026. Rules: [PREREGISTRATION_07.md](../../preregistrations/PREREGISTRATION_07.md), registered and committed before any
of these runs existed. Plays: `tools/plays/play_07.sh suites`, `identity`, `bench`. Measuring: the Simplex harness
(`sx_ledger7_run.sh`), which re-makes `reading.txt` and `counts.txt` from the files kept here.

| Rule | Held | Measured |
|---|---|---|
| **G0** safe when off | yes | 39 of 39 and 28 of 28 suite files, and 38 of 38 registered benchmark streams, byte-identical to stock |
| **G1** patch C as first recorded does not stay stopped | yes | Largest speed over the last third, micrometres a second, slide at steps 1, 1/4, 1/16, 1/64 then landing at the same: stock 0 0 0 0 0 0 0 0; patch C as recorded 0 0 380 12,857 0 0 4,754 147,786; recommended as recorded 0 0 333 14,767 0 0 341 14,478 |
| **G2** the correction | yes | Patch C corrected 0 0 0 0 0 0 0 25; recommended corrected 0 at all eight, and it comes back 297 to 299 micrometres |
| **G3** two moving bodies, stock | yes | Force up 39,194 and 5,885 mN (39,200 and 5,880); slip 6,170 and 3,940 mm/s2 at the shipped step, 6,174 and 3,919 at 1/16 (6,174 and 3,920); momentum change 52 to 87 parts per million; B falls behind A at 2,919 and 2,927 micrometres a second (the shipped friction law: 2,929) |
| **G4** two moving bodies, corrected | yes | B rides A: 0 and 0; slip 6,172 and 3,932, then 6,174 and 3,916; momentum change 44 to 87 parts per million |
| **G5** nothing else gets worse | yes | The first suite: 1111011111 (T05 fails as before: 2,533 of 3,500 at the shipped step) |
| **G6** the benchmark | yes | `half_cheetah` folds in order: stock 0 of 3, corrected 3 of 3. No step diverged. Stopped at the shipped step: `half_cheetah` 7 (stock 2), `ant` 11 (stock 206), of 21,600 |
| **G7** the solver on the suites | yes | Steps stopped without converging: first suite 645 as recorded, 551 corrected; second suite 2,197 and 728 |

## Reported, not deciding

- `ant`'s time-step chain is in order in 3 folds of 3 with stock and with the corrected configuration.
- Stops at the finer steps of the benchmark, corrected: `half_cheetah` 7, 4, 1, 0 of 43,200 to 345,600; `ant` 6, 5,
  7, 5.
- The solver on the suites against stock: first suite 551 of 48,090 (stock 36); second suite 728 of 35,530 (stock
  231). Nearly all at the finest steps: the slide at 1/64 of the step 176 of 9,600, the landing 235, the first
  suite's chain 243 of 6,400.
- Patch C corrected without contact damping, the bouncing landing: it comes back 1.6 mm at 1/16 of the step and
  3.2 mm at 1/64. With contact damping (the recommended configuration) 0.3 mm at every step.
- Stock: after the two cubes collide and separate, 184 of 800 steps stop without converging at 1/16 of the step.

## Files

| | |
|---|---|
| `reading.txt` | Every measured line and the rules, decided |
| `counts.txt` | The benchmark chains by part of the episode and by plain subtraction |
| `identity.txt` | The 38 registered streams re-played on the patched library with no switch set |
| `stats_half_cheetah.txt`, `stats_ant.txt` | The solver's own status of every benchmark play |
| `runs/s1/<configuration>/`, `runs/s2/<configuration>/` | The rig's raw output of every suite run, with checksums |
| `../../streams/07/` | The benchmark streams under the corrected configuration |

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the seventh registration) changes in 43 numbers: the distance slid by
at most 0.18% (118,064 to 118,275 um), the distance come back by at most 27 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
