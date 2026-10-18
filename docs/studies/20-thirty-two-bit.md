# Study 20: the corrections switched on in SuperDex's shipped 32-bit precision

| | |
|---|---|
| Registration | Twentieth: [PREREGISTRATION_20.md](../../preregistrations/PREREGISTRATION_20.md) |
| Question | Do the corrections, switched on, do in SuperDex's shipped 32-bit precision what they do in 64-bit? |
| Outcome | **6 rules of 7 held, as predicted.** In 32-bit the corrections pass every test of what they do on fresh cubes (T02 to T07, T09, T10 and T11 to T17), safe when off; free flight (T01) and the refinement chain (T08) fail in 32-bit, free flight with the same reading with or without them. The 64-bit control passes all |
| Registered | 15 October 2026, before run 044 |
| Result | [Run 044](../../validation/run_044_study20/README.md), 15 October 2026 |
| Runs | 041 (the design probe), [044](../../validation/run_044_study20/README.md), on the Linux machine of runs 039 to 043 |
| Played by | [`tools/plays/play_20.sh`](../../tools/plays/play_20.sh); measured by [`measure/runners/sx_study20_run.sh`](../../measure/runners/sx_study20_run.sh) |

Previous: [Study 19](19-two-corrections.md). Next: [Study 21](21-recommended-configuration.md). All studies: [index](README.md).

## Why it was asked

SuperDex builds in 32-bit unless told otherwise, and every reading of the corrections before this study was 64-bit.
The design probe, [run 041](../../validation/run_041_corrections_32bit/README.md), found them carrying over on eight
of the ten contact tests, free flight failing in 32-bit with or without them, and the refinement chain rising once
past 1/16 of the step. This study puts that to fresh cubes, with 64-bit beside it on the same machine as a control.

## The result

| Rule | It holds when | Measured | |
|---|---|---|---|
| S0 | The 32-bit rigs make run 041's 32-bit plays again | 134 of 134 | Held |
| Z0 safe when off | In 32-bit, patched with no switch is stock, byte for byte, on both suites | 39 of 39 and 28 of 28 | Held |
| Z1 | In 32-bit under the final configuration, all ten tests of the first suite pass | 8 of 10: T01 and T08 fail | Failed |
| Z2 | In 32-bit under the final configuration, T02 to T07, T09 and T10 pass | 8 of 8 | Held |
| Z3 | In 32-bit, T01's reading under the final configuration is stock's, gap by gap | the same five numbers | Held |
| Z4 | In 32-bit under the final configuration, T11 to T17 pass | 7 of 7 | Held |
| Z5 | The 64-bit control, under the final configuration on the fresh cubes: all ten and T11 to T17 | 10 of 10 and 7 of 7 | Held |

## What it means

- **The contact corrections are validated in SuperDex's shipped 32-bit precision**, on fresh cubes: the weight,
  the bounce, friction at an impact and over it, the hold, the slip, the ground that never pulls, the slide that
  stays stopped, the carried cube and momentum between two cubes, as in 64-bit. 32-bit stock fails six of the first
  suite's tests and two of the second's.
- **Two limits are 32-bit SuperDex's own**, recorded as the registration decided: free flight (T01), whose reading
  is the same with and without the corrections, and the refinement chain (T08), which in 32-bit falls to 1/16 of the
  step, rises once and falls again.
- The joint, limit, rotation and benchmark corrections were not played in 32-bit.
