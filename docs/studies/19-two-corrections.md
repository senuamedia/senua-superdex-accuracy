# Study 19: the two corrections no rig had played

| | |
|---|---|
| Registration | Nineteenth: [PREREGISTRATION_19.md](../../preregistrations/PREREGISTRATION_19.md) |
| Question | Does a play reach the two defects of library build 14 that build 15 corrected without any rig playing them (the anchor table's lifetime, and a contact a mapped collider missed), does build 14 show them, and does build 15 remove them? |
| Outcome | **Every rule held.** The anchor table's lifetime: a use-after-free in build 14 when the library is loaded with `dlopen` after the program's exit handler, none in build 15. A contact a mapped collider missed: played on a deforming soft block, and safe when off; where builds 14 and 15 differ, they end at most 20 nm apart (only the end was measured; in the design probe, run 042, they differed during a play by up to 198 nm in height and 29 um/s up and down) |
| Registered | 15 October 2026, before run 043 |
| Result | [Run 043](../../validation/run_043_study19/README.md), 15 October 2026 |
| Runs | 042 (the design probe), [043](../../validation/run_043_study19/README.md), on the Linux machine of runs 039 to 042 |
| Played by | [`tools/plays/play_19.sh`](../../tools/plays/play_19.sh); measured by [`measure/runners/sx_study19_run.sh`](../../measure/runners/sx_study19_run.sh) |

Previous: [Study 18](18-stock-plays.md). Next: [Study 20](20-thirty-two-bit.md). All studies: [index](README.md).

## Why it was asked

A second code review found four defects that, as it read the code, no play of the record reached. Study 16 validated two of them by plays,
and recorded the other two as corrected and not played. The design probe, [run
042](../../validation/run_042_two_corrections/README.md), found how a play reaches each: a program that loads the
library with `dlopen` after registering its own exit handler, as a plugin or a Python extension does, and a soft
block that deforms under a cube that hops on it.

## The result

| Rule | It holds when | Measured | |
|---|---|---|---|
| S0 | The contact rig with no new setting makes the 268 registered suite files byte for byte | 268 of 268 | Held |
| L1 required | With build 14 and patches A to C (the registration's "A to D", the switches `AB` and `CD`), valgrind reports an error, and an invalid read or write in `ClearFrictionAnchors` | 120 errors, in `ClearFrictionAnchors` called by `DestroyScene` from the exit handler | Held |
| L2 correct | Build 15 with patches A to C and with no switch, and stock: no error, exit 0; every program destroyed its scene | 0 errors each, exit 0; 5 of 5 destroyed | Held |
| M0 safe when off | Build 15 with no switch is byte-identical to stock on all 5 hops | 5 of 5 | Held |
| M1 reached | Builds 14 and 15 differ on at least one hop | 3 of 10 | Held |

Reported, not deciding: where builds 14 and 15 differ, they end at most 20 nm apart, with the same speed.

## What it means

- **The anchor table's lifetime is validated.** Build 14 read and wrote freed memory when a scene was destroyed
  after the library's own static objects were gone. A program that links the library cannot get there, because its
  exit handlers run before the library's objects are destroyed (run 042); a program that loads the library with
  `dlopen` after registering its own exit handler, as a plugin or a Python extension does, can. Build 15 makes the
  table once and never destroys it, and valgrind finds nothing.
- **A contact a mapped collider missed is played and safe when off.** The tetrahedral map misses a sample only
  where its soft body changed shape within the step, so the play needs a block that deforms under a cube that lands
  again. On such a block, where builds 14 and 15 differ, the plays end at most 20 nm apart with the same speed; this
  run measured the end only. During a play the difference can be larger: in the design probe
  ([run 042](../../validation/run_042_two_corrections/README.md)) it reached 198 nm in height and 29 um/s up and
  down. Build 15 gives the missed contact no stick, as stock gives it no friction.
- Both open items close.
