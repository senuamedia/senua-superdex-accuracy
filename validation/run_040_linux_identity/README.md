# Run 040: the record's identity check, played on Linux

15 October 2026. Not registered: a replication probe, following [run 039](../run_039_linux_replication/README.md). The
record's own identity check, [`tools/play_identity.sh`](../../tools/play_identity.sh), the one Study 16 played on the
laptop, played on Linux by [`play.sh`](play.sh): every rig built with Clang 18 against run 039's patched library
build (`rigs.sha256`), then the script's parts rotvec, flight, suites, joints, zero and fg, each play against its
registered file (`identity.txt`). Played 03:02:51 to 03:03:36 UTC (`started.txt`, `finished.txt`). The benchmark streams (bench, benchrec) came after, as
step 3: the player rig did not build at first, because the copy of the repository sent to the machine left out
`tools/sdx_player.cpp` (an exclusion meant for the laptop's player binaries caught the source too; `out.txt`).

## The result: 462 of 468 files byte-identical

| Part | Byte-identical |
|---|---|
| rotvec: the ninth study's 40 rotations | 1 of 1 |
| flight: two free cubes at four steps | 8 of 8 |
| suites: no switch, patches A to C, patch E alone, A to C and E (four configurations of both suites) | **268 of 268** |
| joints: the 40 one-joint runs of the sixth and eighth studies | 39 of 40 |
| zero: every switch set to 0 | 106 of 107 |
| fg: the configurations with patch G | 40 of 44 |

## The six that differ ([`differences.sh`](differences.sh); `differences.txt`)

Five plays (the zero part's one is the same play as the joints part's), all a joint or a chain at the two finest
steps. These five Linux plays are kept under `runs/`; the plays that matched are not kept.

| Play | Lines differing | Largest difference | The record's reading, Linux and registered |
|---|---|---|---|
| A joint swing at 1/64 | 4 of 19,201 | 1 urad/s | identical (`swing`) |
| Patch G's chain swing at 1/16 | 4 of 3,202 | 1 in the last digit of four columns | identical (`chain`) |
| Patch G's free chain, tight tolerances, at 1/16 | 1 of 3,202 | 1 in one column | identical (`chain`) |
| Patches A to G, a joint swing at 1/64 | 2 of 19,201 | 1 urad, 1 urad/s | identical (`swing`) |
| Patches A to G, a joint leaving its limit at 1/64 | 1 of 3,201 | 1 urad/s | identical (`final`) |

## What it shows

- **Every contact play replicates to the byte on Linux**: the 268 registered suite files (134 of them the same plays run
  039 compared), the 8 free flights and the 40 rotations.
- **Five long joint and chain plays differ by one unit of their last printed digit on one to four lines** out of
  thousands: a value rounded to the nearest micro-radian falls the other way. Every reading the record takes of those
  plays is the same on both machines. The joints and chains are where SuperDex calls the maths library's
  trigonometric functions every step, and Apple's library and Linux's need not agree in the last bit; that is the
  likely cause, not yet shown.
- The plays are the same to the byte on both machines for contact, and not for joints and chains over long plays;
  the record's readings of the five that differ are the same.

## Step 3: the benchmark streams on Linux

[`play_bench.sh`](play_bench.sh) built the player rig with Clang 18 against run 039's patched library build
(`player.sha256`) and played the identity check's parts bench and benchrec (`identity_bench.txt`), 03:31 to 03:45 UTC.
A first attempt gave the rig the folder of SuperDex's own scenes rather than the top-level assets folder that holds
Meta's benchmark scenes, so no scene loaded and nothing played (`first_attempt_*`); the script was corrected and pushed
before the second.

| Part | Byte-identical |
|---|---|
| bench: the 38 benchmark streams of the third and fourth studies, no switch | 34 of 38 |
| benchrec: the ninth study's 7 benchmark streams under its switches | 5 of 7 |

## Step 4: the six streams that differ ([`differences_bench.sh`](differences_bench.sh); `differences_bench.txt`)

Each stream holds 21,600 readings, 200 an episode. The solver's own counts are from the rig's statistics line on
Linux and from the statistics file registered with the same streams. These six Linux streams are kept under
`runs/bench/`, with the rig's output; the streams that matched are not kept.

| Stream | First differs at reading | Readings differing | Steps stopped, Linux and registered |
|---|---|---|---|
| `ant` at SuperDex's iteration limit of 4 (`s4`) | 122 | 5,637 | 17,050 and 17,041 |
| `ant` with contact smoothing 1.25 mm (`c1`) | 12,711 | 2 | 370 and 370 |
| `ant` with contact smoothing 0.625 mm (`c06`) | 1,339 | 262 | 435 and 434 |
| `ant` with contact smoothing 0.3125 mm (`c03`) | 255 | 482 | 428 and 430 |
| `half_cheetah` under patches A to E at the shipped step (`y1`) | 219 | 9 | 5 and 6 |
| `half_cheetah` under patches A to E at 1/4 of it (`y4`) | 6,255 | 3 | 4 and 4 |

No step diverges in any of them, on either machine, and the encoder's least and largest values are the same.

## What step 3 shows

- **39 of 45 benchmark streams replicate to the byte on Linux**: all 19 of `cart_pole`, all 10 of `half_cheetah`
  but the two under patches A to E, and 12 of the 16 of `ant`, patch E alone on each scene among them.
- **In each of the six that differ, SuperDex's solver stops on some steps**, from 4 to 17,050 (of 21,600 solver steps,
  and of 86,400 in `y4`, four to a reading; `differences_bench.txt`). Stopping
  alone does not decide it: `ant` streams whose solver stops as often are identical (760 stopped steps at an
  iteration limit of 16, 333 with contact smoothing 2.5 mm). Why these six differ is open. In `ant` at an iteration
  limit of 4, 5,637 of the 21,600 readings differ, a quarter; in the other five, 2 to 482.
- **The solver's own counts differ by 0 to 9 steps of 21,600** (0 of 86,400 in `y4`), and no step diverges on either
  machine. The readings the record made from these streams were not re-made on Linux in this run.
