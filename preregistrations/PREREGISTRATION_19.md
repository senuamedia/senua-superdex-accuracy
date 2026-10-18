# Nineteenth pre-registration: the two corrections of library build 15 that no rig had played

Registered 15 October 2026, before any run of this registration existed.

## The question

A second code review of the patch code found four defects that, as it read the code, no play of the record reaches.
Library build 15 corrected all four with added lines only. Study 16 validated two of them by plays. The other two were
"corrected, not played":

- **The anchor table's lifetime.** In library build 14 the table of patch C's stick anchors was a static object of the
  library, so a scene destroyed after the library's static objects are gone could find it already destroyed. Build 15
  makes it once and never destroys it.
- **A contact a mapped collider missed at the stage start.** A mapped collider is a soft body. SuperDex finds where a
  sample was at the start of the step through the body's tetrahedral map, and the map misses a point outside every
  tetrahedron of the body's shape at that time. Stock gives a missed sample no friction. Build 14's patch C gave it a
  stick anchor; build 15 gives it none and keeps none.

Does a play reach each defect, does build 14 show it, and does build 15 remove it?

## What the design probe found (run 042, not registered)

Run 042 tried four ways in. A scene destroyed after `main` returns, by an object in static storage or from a
destructor function, does not reach the lifetime defect: on Linux both run before a linked library's static objects
are destroyed. A program that registers its exit handler and then loads the library with `dlopen`, as a plugin or a
Python extension does, does: with build 14 and patches A to D valgrind reported 120 errors, all in
`ClearFrictionAnchors` called from `DestroyScene`; with build 15, none. A soft block with every node held never changes
shape, so its map cannot miss; a block held only along its bottom deforms under a cube, and a cube that hops on it
made builds 14 and 15 differ on 3 of 26 plays, by at most 198 nm and 1 um/s.

## What is played

**Run 043**, on the Linux machine of runs 039 to 042 (AWS EC2, Ubuntu 24.04, Clang 18), by
[`tools/plays/play_19.sh`](../tools/plays/play_19.sh), from the root of the copy of this repository runs 040 to 042
played in:

    bash tools/plays/play_19.sh <work folder of run 039> validation/run_043_study19

The libraries, 64-bit, all built on that machine from SuperDex at the commit in `UPSTREAM_COMMIT`: stock
(75def9201a45216a...) and library build 15 (eee7cca1423650df...), from run 039; library build 14 (33935ba1df6c7ebe...),
from run 042, from the patch files `patches/superseded/senua_contact_registration15.patch` and
`senua_joint_limit_registration15.patch` with the current rotation and inertia patches. The rigs are run 042's
(`validation/run_042_two_corrections/rigs4.sha256`); the play script refuses to play if any differs.

- **S**, safe when off: the contact rig with no new setting plays the seventh and ninth studies' suites (stock, off,
  patches A to D, A to E; both suites), against the 268 registered files.
- **L**, the lifetime: `tools/sdx_exit` loads the library with `dlopen` after registering its exit handler, plays 25
  steps of a cube resting on the ground and destroys the scene in that handler, under valgrind's memcheck: stock with
  no switch; builds 14 and 15 with no switch and with patches A to D.
- **M**, the mapped collider, on fresh numbers: a cube of 1.1 kg and half-size 0.04 m, friction 0.4, dropped 6 cm
  with a sideways speed of 1.5 cm/s onto the soft block held along its bottom (`floor=soft softhold=bottom`), so it
  hops; at steps 1, 1/4, 1/16, 1/32 and 1/64 of 10 ms; stock, build 15 with no switch, and builds 14 and 15 under
  patch C alone and under patches A to D (frictionFalloffVel 0.03, no contact damping, so the cube bounces).

The measuring is [`measure/runners/sx_study19_run.sh`](../measure/runners/sx_study19_run.sh): every rule by
`sx_contact rule`, the hops by `ends`, `bounce`, `stop` and `hover`.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **S0** | The contact rig with no new setting makes the 268 registered suite files byte for byte |
| **L1** required | With build 14 and patches A to D, valgrind reports at least one error, and at least one invalid read or write in `ClearFrictionAnchors` |
| **L2** correct | With build 15, with patches A to D and with no switch, and with stock: valgrind reports no error and the program exits 0; every program, build 14's included, destroyed its scene |
| **M0** safe when off | Build 15 with no switch is byte-identical to stock on all 5 hops |
| **M1** reached | Builds 14 and 15 differ on at least one hop, under patch C alone or under patches A to D |

Reported, not deciding: where builds 14 and 15 end apart on each hop (place and speed), and each hop's bounce, stop
and lift on build 15; build 14 with no switch under valgrind.

## Decisions fixed in advance

- **If L1 and L2 hold**, the lifetime correction is validated: build 14's defect is shown, and build 15 removes it.
- **If M0 and M1 hold**, the mapped-collider correction is played on fresh numbers and safe when off there. How much
  it changes the motion is what the hops report; no rule asks for a size, because the probe found it below a
  micrometre and no right answer exists for a single missed sample. The open list then records it as played, with
  its measured size.
- **If M1 fails**, the correction is recorded as not reached on fresh numbers, and stays on the open list as it is.

## Known risks, stated before the run

- **M1 depends on the cube landing again where the block moved within the step.** The probe's three differing hops
  were at the finer steps; on fresh numbers none may differ.
- **valgrind's error count can include errors that are not SuperDex's.** L2 asks for none at all, which the probe
  found on every build but build 14 with patches.
- **L1 depends on the table holding anchors at exit.** The cube rests for 25 steps under patch C, which makes them.

## The dry run, before registering

No play was made. The runner was run on run 042's step 4 outputs, rearranged as the play script writes them; every
rule line was written, and they read as run 042 found (S0, L1, L2, M0 and M1 held). A first arrangement of the mock
kept the probe's file names in its soft lines, so M1 read 0; that was the mock, and was corrected.

## As registered

Play script `tools/plays/play_19.sh` and runner `measure/runners/sx_study19_run.sh` as in this commit; the rigs and
libraries as above; the measure `sx_contact.sx` as run 87e921cd4d2c03bf....
