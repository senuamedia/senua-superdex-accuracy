# Run 021: the ninth registration, run once. Every rule held.

14 October 2026. Rules: [PREREGISTRATION_09.md](../../preregistrations/PREREGISTRATION_09.md), registered, committed and pushed
before any of these runs existed. Plays: `tools/plays/play_09.sh rotvec`, `flight`, `joints`, `suites`, `identity`,
`bench`. Measuring: Senua AI's harness (`measure/runners/sx_study9_run.sh`), which re-makes `reading.txt` and `counts.txt`
from the files kept here and in `../../rotation/` and `../../streams/09/`.

| Rule | Held | Measured |
|---|---|---|
| **E0** safe when off | yes | With the patched library and no switch set: the rotations file identical to stock's; 8 of 8 flight files; 67 of 67 suite files identical to the seventh registration's stock files; 67 of 67 under the recommended configuration identical to the seventh registration's; 40 of 40 one-joint files; 38 of 38 registered benchmark streams |
| **E1** required: the function | yes | Stock passes 20 of 20 rotations larger than 2e-9 rad. Of the 20 of 2e-9 rad or less it passes the 4 about x and fails the other 16: every one comes back along x, off by 113% to 163% of its angle |
| **E2** correct: the function | yes | With the correction 40 of 40 pass, each exact to the millionth |
| **E3** required: the solver | yes | Stock, two free cubes at 1/64 of the step, after they part: 930 of 3,079 steps run to the 200-iteration limit, with residuals of 1,442 to 3,999 millionths (the tolerance is 1,000). 203,419 iterations for 3,079 steps |
| **E4** correct: the solver | yes | With the correction no step stops at any of the four steps, and the iterations are 46 for 45 steps, 192 for 190, 770 for 768 and 3,080 for 3,079 |
| **E5** the motion is the same | yes | The cubes end in the same place to the nanometre at steps 1, 1/4 and 1/16, and within 4 nm at 1/64. The speeds are the same |
| **E6** nothing else gets worse | yes | First suite: 1110001011 under stock contact and 1111011111 under the recommended configuration, with and without the correction. Second suite: 1110111 and 1111111, with and without |
| **E7** the solver on the suites | yes | Steps stopped, without the correction and with it: first suite 36 and 0 under stock contact, 551 and 0 under the recommended configuration; second suite 231 and 0, and 728 and 0 |
| **E8** the benchmark | yes | With the correction alone at the shipped step: `half_cheetah` 2 stopped, `ant` 206, `cart_pole` 0, exactly stock's counts. No step diverged |

## The decision fixed in advance

With the correction added to the recommended configuration, `half_cheetah` and `ant` are both in order in 3 folds
of 3 and no step diverged. By the rule fixed in advance, patch E joins the recommended configuration.

## Reported, not deciding

- **On the benchmark the correction changes nothing at all.** All 3 streams with the correction alone are
  byte-identical to stock's, and all 10 streams with it added to the recommended configuration are byte-identical to
  the eighth registration's. So every benchmark number recorded for the recommended configuration stands as it is.
- **On one joint it changes nothing either.** The 40 registered one-joint files are reproduced byte for byte with
  the correction switched on.
- **Two free cubes, by step, after they part** (steps, steps at the iteration limit, iterations in all):

  | | 10 ms | 1/4 | 1/16 | 1/64 |
  |---|---|---|---|---|
  | Stock | 45, 0, 132 | 190, 0, 822 | 768, 0, 5,331 | 3,079, 930, 203,419 |
  | Corrected | 45, 0, 46 | 190, 0, 192 | 768, 0, 770 | 3,079, 0, 3,080 |

  At the three coarser steps stock stops on none, and still takes 3 to 7 times the iterations it needs.

## What this shows

- **A defect in SuperDex's quaternion.** `Quaternion::ToAxisAngle` gives the x axis to any rotation of 2e-9 rad or
  less. It is in SuperDex's own code and is independent of every patch here.
- **It was the cause of two open items.** The solver stopping after two free bodies separate, and the solver
  stopping at the finest steps with the corrected contact, were both this defect: with the correction no step
  stops in either suite, under stock contact or under the recommended configuration.
- **The seventh registration's extra stops are this defect, not a cost of the patches.** The seventh registration
  reported that the corrected contact configuration stops the solver more often than stock on the one-cube suites.
  The anchored friction holds a force on a cube whose rotation is held, which keeps that rotation in the range where
  the defect acts.

## What it does not show

- It says nothing about `ant`'s stopped steps on stock contact (206 of 21,600). Those are another kind, with
  residuals up to 10.1, ten thousand times the tolerance of 1e-3 (on run 020's twelve throwaway episodes they were
  ten to seven hundred times it), and the correction leaves them exactly as they are.
- It does not say why `ant` stops more often with the joint limit patch alone.
- One function, two cubes, the suites' cubes and three benchmark scenes. Nothing against a real robot.

## Files

| | |
|---|---|
| `reading.txt` | Every measured line and the rules, decided |
| `counts.txt` | The benchmark chains under the recommended configuration with the correction added |
| `identity.txt` | The 38 registered streams re-played on the patched library with no switch set |
| `joints_identity_off.txt`, `joints_identity_patched.txt` | The 40 registered one-joint files re-played with no switch, and with the correction on |
| `stats_flight.txt` | The rig's own line for every two-cube play |
| `stats_<scene>.txt` | The solver's own status of every benchmark play (e1: the correction alone; y1 to y16: added to the recommended configuration) |
| `runs/s1/<configuration>/`, `runs/s2/<configuration>/` | The raw suite runs: `off`, `rec`, `stock_e`, `rec_e`, with checksums |
| `../../rotation/` | The rotations files, the two-cube files and the solver's trace of every step, with checksums |
| `../../streams/09/` | The benchmark streams |

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the ninth registration) changes in 20 numbers: the distance slid by
at most 0.18% (118,064 to 118,275 um), the distance come back by at most 3 um. No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
