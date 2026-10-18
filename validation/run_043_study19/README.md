# Run 043: the two corrections no rig had played (Study 19)

15 October 2026, under [`preregistrations/PREREGISTRATION_19.md`](../../preregistrations/PREREGISTRATION_19.md), by
[`tools/plays/play_19.sh`](../../tools/plays/play_19.sh) on the Linux machine of runs 039 to 042 (AWS EC2, Ubuntu
24.04, Clang 18), played once, in 2 minutes 49 seconds. The rigs were run 042's. The contact rigs and the exit
program were checked against its checksums before any play (`rigs_check.txt`, empty: every one matched). The pair
rigs, which S0's second suite plays, were not in that check, and this run records no checksum for them; the ones run
044 recorded for them minutes later (`../run_044_study20/rigs.sha256`) are those of run 042's first step
(`../run_042_two_corrections/rigs.sha256`), and S0's second suite made its 112 registered files byte for byte.
Measured by [`measure/runners/sx_study19_run.sh`](../../measure/runners/sx_study19_run.sh) (`reading.txt`).

## The result: every rule held

| Rule | It holds when | Measured | |
|---|---|---|---|
| **S0** | The contact rig with no new setting makes the 268 registered suite files byte for byte | 268 of 268 (`identity.txt`) | **Held** |
| **L1** required | With build 14 and patches A to D, valgrind reports at least one error, and an invalid read or write in `ClearFrictionAnchors` | 120 errors; invalid accesses in `ClearFrictionAnchors`, called by `DestroyScene` from the exit handler (`runs/valgrind_b14_abcd.txt`) | **Held** |
| **L2** correct | Build 15 with patches A to D and with no switch, and stock: no error, exit 0; every program destroyed its scene | 0, 0 and 0 errors, exit 0; 5 of 5 destroyed (`exit.txt`) | **Held** |
| **M0** safe when off | Build 15 with no switch is byte-identical to stock on all 5 hops | 5 of 5 (`soft.txt`) | **Held** |
| **M1** reached | Builds 14 and 15 differ on at least one hop | 3 of 10: patch C alone at 1/32 and 1/64 of the step, patches A to C at 1/32 | **Held** |

The registration's "patches A to D" (rules L1, L2 and M1) are the switches `AB` and `CD` of
[`tools/plays/play_19.sh`](../../tools/plays/play_19.sh), that is patches A to C: no play of this run sets patch D's
switch, `SUPERDEX_LIMIT_UNILATERAL`.

Reported, not deciding (`reading.txt`):

- **Where builds 14 and 15 end apart** on the hops: at most 20 nm in place and 0 um/s in speed (patch C alone at
  1/64); 1 nm and 0 under patches A to C at 1/32; 0 on every other hop.
- **Build 14 with no switch** under valgrind: 0 errors, exit 0.
- **The hops on build 15**: the fresh cube (1.1 kg, half-size 4 cm, friction 0.4) dropped 6 cm onto the deforming
  block rebounds 6,331 to 6,380 per 10,000 of the drop at 1/64 of the step with no contact damping (stock: 6,308), the
  penalty contact's own bounce, which the recommended configuration's contact damping takes out.

## What it shows

- **The anchor table's lifetime: validated.** Build 14 has a use-after-free when a scene is destroyed after the
  library's own static objects are gone, which happens when a program loads the library with `dlopen` after
  registering its exit handler, as a plugin or a Python extension does. Build 15 has none, with and without the
  switches, and neither has stock.
- **A contact a mapped collider missed: played, safe when off, and below a micrometre.** The corrected path is
  reached on fresh numbers, on a soft block that deforms under a hopping cube, and build 15 with no switch makes
  stock's plays. Build 14's anchor for a missed contact moved the cube by at most 20 nm by the end of a play. As the
  registration decided, no rule asks for a size: no right answer exists for a single missed contact, and the
  difference is recorded as measured.

Neither correction is on the open list.

## Corrected 17 October 2026: the measure's step

Senua AI's measure read the step in whole microseconds and cut the distance slid as it added it up; the MuJoCo deep
dive found it ([the measure](../../measure/README.md#corrected-17-october-2026-the-step-and-the-distance-slid)). Read
again by the corrected program, this run's reading (the nineteenth registration) changes in 22 numbers: the distance slid by
at most 0.23% (1,729 to 1,733 um), the distance come back by at most 41 um (10,101 to 10,142). No rule's verdict changes. The reading as printed and registered
stays in `reading.txt`; the corrected one is beside it, [`reading_corrected.txt`](reading_corrected.txt).
