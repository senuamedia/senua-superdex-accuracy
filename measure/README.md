# The measuring side

These are the measuring programs of the Senua AI Robotics Core, as used on SuperDex. The rigs in
[`../tools/`](../tools/) play SuperDex and write what happened. The programs here read those files and
decide the registered rules. They are written in Simplex, the language Senua AI is built in, and they are published
so that every rule, every right answer and every tolerance can be read line by line.

They do not build outside Senua AI: the Simplex toolchain and the Senua AI engine are not distributed. What they
printed is kept as records in [`../validation/`](../validation/) and
[`../patches/validation/`](../patches/validation/), beside the raw runs they read, so every number can be checked
with any arithmetic you trust.

## Arithmetic against a right answer (registrations 4 to 16 and 19 to 23)

[`sx_contact.sx`](sx_contact.sx) is plain arithmetic on a rig's text file: a header, then one line a step of whole
numbers (height in nanometres, speeds in micrometres a second, forces in millinewtons). Of the Senua AI engine it
uses only two helper files, for reading a file and comparing strings.

Every Simplex file here is published in one form: the code that runs, with comments on what it does, and the
engine's own files named by a single include line, `senua_engine.sx`, which is not distributed. In these files that
one line stands where the program as run names the two helper files, and comments that named the engine's own
repository paths and design documents name the record's paths and registrations instead; no line of code differs.
The registrations cite the checksum of the program as run:

| File | sha256 as run (cited) | sha256 as published | Cited by |
|---|---|---|---|
| `sx_contact.sx` | b1047b84134afc4f... | defda2a288f05af5... | corrected 17 October 2026 ([below](#corrected-17-october-2026-the-step-and-the-distance-slid)); it re-makes every reading of the record. The same day it gained `fastest` (the MuJoCo deep dive's box-rest reading); every other reading prints the same bytes as the form before it (3,900 readings of 300 plays) |
| `registered/sx_contact_mujoco_study21.sx` | 804d51e14d2ade30... | 238edb006b7b6b27... | the corrected measure before `fastest`, as the MuJoCo deep dive's Study 21 and its runs 091 to 097 ran it |
| `registered/sx_contact_registration23.sx` | d0abd0c601f83a37... | ecd668a4ebb8d0dc... | the twenty-third registration (`pairg`); the MuJoCo deep dive reads its lift with `hover` |
| `registered/sx_contact_registration22.sx` | 87e921cd4d2c03bf... | 4779c518d77ee09e... | the nineteenth to twenty-second registrations |
| `registered/sx_contact_registration16.sx` | d22b1d5de8ade342... | 11e4170ecef88fe9... | the sixteenth registration |
| `registered/sx_contact_registration15_amended.sx` | cbc6a401dc305836... | dda433a050fefded... | the fifteenth registration as amended (run 034) |
| `registered/sx_contact_registration15.sx` | a9e9e2134cf0fa26... | e932f0e7b3d9fbff... | the fifteenth registration as first registered |
| `registered/sx_contact_registration14.sx` | d18cbf6fc9dfd08e... | e36fbce4dd446553... | the tenth to fourteenth registrations |
| `registered/sx_contact_registration9.sx` | 2d93ab7cb329dd47... | 33796cd9bf3b4365... | the ninth registration |
| `registered/sx_contact_registration8.sx` | 44cf1def6e7d2cbf... | 6c6d3951acb2fe6c... | the eighth registration |
| `registered/sx_contact_registration7.sx` | 3d93198f49de9574... | 95d777ab219ed040... | the seventh registration |
| `registered/sx_contact_registration6.sx` | 0d716ed5c449f968... | e67bf532e2334849... | the sixth registration |

Each later file is the earlier one with measures added. Up to the ninth registration the only line that changed is
the usage banner; from the ninth to the current file no line changed at all. The fourth and fifth registrations
used earlier states of the same file, and the current file re-makes the records of the fourth to the ninth
registrations byte for byte (checked again when the tenth to twelfth were registered). The fifteenth registration's
file adds one measure, `deformstop`, its amendment `swingq` and the sixteenth `deformdrift`, each changing no line: with them the records of the fourth to the fifteenth
registrations are re-made byte for byte. `hover`, added after the sixteenth registration for the MuJoCo deep
dive, changes no line either: with it the records of the fourth to the sixteenth registrations are re-made byte for
byte.

`pairg`, added after the twenty-second registration, is `pair` with each cube's mass taken in whole grams (`pair` takes
it in units of 10 g, cut down, so momentum passing between two cubes whose masses are not whole multiples of 10 g
appears to change: [run 051](../validation/run_051_study21/README.md)). It changes no line: with it every reading of
the record re-makes byte for byte (26 of 26, on Linux).

### Corrected 17 October 2026: the step, and the distance slid

Found by the MuJoCo deep dive (its run 088): at a step of 31.25 us, `accel` read a deceleration of 3,951 mm/s2 where
the rig's own columns give 3,919.99. Three faults, each in how a measure used the time:

- `stop`, `accel`, `swing`, `swingq` and `grip` read the step in whole microseconds (`intdiv(dt_ns, 1000)`). A step
  with a fraction of a microsecond was read short: 156.25 us as 156 (0.16%), 31.25 us as 31 (0.8%). A step that is a
  whole number of microseconds was read exactly.
- `stop` cut each step's distance to 0.01 um, and its speed to 100 um/s, before adding it up, so the more steps, the
  shorter the distance read.
- `grip` read the hold's second half in whole milliseconds (749.375 ms as 749).

As corrected, every measure takes the step as the file gives it, in nanoseconds. `stop` adds its distance up exactly,
in whole micrometres, picometres and thousandths of a picometre, each carried into the one above every step, so no sum
outgrows the arithmetic however far a body goes (a cube thrown 487 m in a MuJoCo play reads 487,191,138 um, the sum of
the rig's own columns). `accel` divides the change in speed by the time between the two steps it reads, and `grip` by
the second half's time, each by long division so that no product leaves the arithmetic's range. No other line changed.
Before any reading was re-made, the corrected program was checked against known answers: on four slides of a MuJoCo
play at 2 to 0.03125 ms, the distance is the sum of the rig's columns to the micrometre and the deceleration Coulomb's
3,920 mm/s2; so are the distances of a 487 m flight and of a spinning joint.

Every reading of the record was re-made on Linux by [`runners/remake.sh`](runners/remake.sh), with the program
before the correction and after it, built by the same compiler. Before it, all 26 re-make byte for byte, as they
always have. After it, 16 are unchanged and 10 change in 207 lines. **No rule's verdict changes in any of them.**

| Reading | Numbers changed | Distance slid, largest change | Distance come back, largest change |
|---|---|---|---|
| [Run 017](../validation/run_017_counts/), registration 7 | 43 | 0.18% (118,064 to 118,275 um) | 27 um |
| [Run 021](../validation/run_021_rotation/), registration 9 | 20 | 0.18% (118,064 to 118,275 um) | 3 um |
| [Run 027](../validation/run_027_friction/), registration 11 | 26 | 0.18% (212,455 to 212,832 um) | 2 um |
| [Run 029](../validation/run_029_end_to_end/), registration 13 | 12 | 0.18% (117,945 to 118,155 um) | 3 um |
| [Run 032](../validation/run_032_open_items/), registration 14 | 18 | 0.18% (117,949 to 118,159 um); the 0.625 ms grip's creep by 0.05% | 3 um |
| [Run 034](../validation/run_034_replication/), registration 15 | 7 | 0.01% (117,934 to 117,948 um); the grip's creep by 0.05% | 1 um |
| [Run 043](../validation/run_043_study19/), registration 19 | 22 | 0.23% (1,729 to 1,733 um) | 41 um (10,101 to 10,142) |
| [Run 044](../validation/run_044_study20/), registration 20 | 36 | 0.30% (127,467 to 127,849 um) | 6 um |
| [Run 051](../validation/run_051_study21/), registration 21 | 19 | 0.18% (122,886 to 123,102 um) | 4 um |
| [Run 055](../validation/run_055_study23/), registration 23 | 20 | 0.17% (209,080 to 209,442 um) | 4 um |

Each reading stays as it was printed and registered, `reading.txt`, and the reading made by the corrected program is
kept beside it as `reading_corrected.txt`; `remake.sh` compares with the corrected one where there is one (26 of 26).
The measure as the twenty-third registration ran it is kept as
[`registered/sx_contact_registration23.sx`](registered/sx_contact_registration23.sx), and every earlier registered
state stays as it ran. The design probes' play files were read again the same way, play file by play file, by the
MuJoCo deep dive's `remeasure_step.sh`: 1,230 play files, 2,234 readings. The distance slid changes in two probes, run
041 (483 readings, by at most 0.18% on its long slides and 4 um on its shortest, of 107 um) and run 048 (334 readings,
by at most 0.16%); the distance come back in run 041 (72 readings, by at most 40 um); and run 034's accurate replay's
swing by 1 urad (3 readings). No probe's finding changes: run 048's rules read the stop's fastest speed and the
distance come back, which do not change, and the comparisons of 32-bit against 64-bit run 041's page quotes move by at most 0.002 of a
percentage point; each run's page carries its corrected figures (the re-read, line by line: [`remeasure_probes.txt`](../validation/audit/remeasure_probes.txt)).

The fifteenth and sixteenth registrations also cite a published form, c553426611b6fe08... (the fifteenth as
amended) and e4eaffefa238d296... (the sixteenth). Those forms differ from the ones above in comments only: where
their comments name the engine repository's paths, the forms above name the record's ([changelog](../docs/changelog.md)).

The runners the registrations cite by checksum, and how the published runner differs from the one cited:

| Runner | Cited by | sha256 as cited | sha256 as published | What differs |
|---|---|---|---|---|
| `runners/sx_ledger7_run.sh` | the seventh registration | a026d09a1c90fcb2... | 60f056bba6a70a0e... | comments |
| `runners/sx_limit_run.sh` | the eighth | c4ed3c11f4c16202... | c5fbe241a621e6e5... | comments |
| `runners/sx_study9_run.sh` | the ninth | d217ad42829ff4c8... | e321c91040925a1a... | comments, and the stream folders' names after the repository's folders were gathered (`streams9/` became `streams/09/`) |
| `runners/sx_study10_run.sh` | the tenth | b6f92cf7ad12a2d2... | 08cf47a8de2e0b96... | comments |
| `runners/sx_study11_run.sh` | the eleventh | 95438f6e5bb2ac13... | 3330147965005018... | comments, and the stream folder's name, as for the ninth |
| `runners/sx_study12_run.sh` | the twelfth | b2cc0798cbc7eac7... | 6f12c48a19c6b5c0... | comments, and the stream folder's name, as for the ninth |
| `runners/sx_study13_run.sh` | the thirteenth | fe8d8e27ace03b22... | ae0194ac87a5049f... | comments |
| `runners/sx_study14_run.sh` | the fourteenth | eb020cfe6bfbaf9d... | a75ed0d1364654d7... | comments |
| `runners/sx_study15_run.sh` | the fifteenth | ea0ab61c1511fb1b... as registered, 4545e3780e6ab762... as amended | d9df7ecd2919a77b... | the amendment's rules; then the two corrections [run 034](../validation/run_034_replication/README.md) gives (c34f448a87d0a008..., then fec190adf8c03203..., with which its reading re-makes byte for byte); then comments |
| `runners/sx_study16_run.sh` | the sixteenth | 88d6665cbaa8c0d1... | 6261899af1b89392... | comments |

With the published runners every reading of the record re-makes byte for byte (`runners/remake.sh`, below). The
layout change is in the [changelog](../docs/changelog.md) (14 October); the runners of the fourth to the sixth
registrations and the instrument's scripts are not cited by checksum.

| Measure | What it reads | The right answer it is held to |
|---|---|---|
| `bounce`, `settle` | One cube dropped on the ground | The rebound does not depend on the time step |
| `impact` | A cube dropped with sideways speed | Coulomb's law over the impact |
| `creep`, `rest`, `slip`, `pull` | A cube set down and pushed, or lifted | It holds below the friction limit, slips at the law above it, and the ground never pulls |
| `stop` | A cube that slides to a stop | It stays stopped |
| `fastest` | Any play, over its last steps | The largest speed there, either sign: a body at rest has no step faster than its rule's bound |
| `hover` | A cube set sliding along the ground | It stays on the ground while it slides: the highest it rises and its fastest upward speed, both 0 |
| `pair`, `accel` | Two cubes that both move | Momentum is kept, a carried cube rides, and it slips at Coulomb's value |
| `final`, `swing`, `joints` | One arm on one joint | A free arm keeps its speed, a driven arm gains torque over inertia, a pendulum comes back level |
| `swingq` | One arm swinging on one joint | As `swing`, with each turn placed between the steps, over every turn of the play |
| `leave`, `limits` | An arm at a joint limit | A limit pushes a joint back into range and never holds it there |
| `rotvec` | SuperDex's quaternion asked for the rotation vector of a rotation | The angle times the axis, whatever the size of the angle |
| `trace`, `flight`, `ends` | The solver's own status, iterations and residual of every step | A body in free flight is solved in one iteration, and a correction does not move where it ends |
| `chain` | Two arms on two joints | With nothing doing work the kinetic energy and the angular momentum about the first joint stay; under gravity the total energy does |
| `deform` | One rod, shell or soft body | Where it rests, how far it moved, how it swings; a free fall against backward Euler's own drop |
| `deformstop` | A deformable body's slide on the floor | Where the slide stopped and the furthest it reached, before any return of the body's own lean |
| `deformdrift` | A deformable body set down on the floor | How far its centre moved between the second and the last quarter of the play: a creep, not a rock |
| `grip` | A gripper holding a cube | The force each finger presses and lifts with, how far the cube slips, how it accelerates when the grip is too weak |
| `verdict`, `suite`, `ledger`, `ledger7`, `suite2`, `study9` | The measured lines of one registration | The registered rules, decided |
| `rule` | One registered rule and its numbers | Whether it held. Every rule of the tenth to sixteenth, nineteenth and twentieth registrations is judged here |

The scripts in [`runners/`](runners/) run those measures over a whole registration and write the record:

| Script | Registration | Record it re-makes |
|---|---|---|
| `runners/sx_contact_run.sh` | 4 | `validation/run_010_contact/reading.txt` |
| `runners/sx_link.sh` | 4 | `validation/run_011_counts/counts.txt` |
| `runners/sx_contact_suite.sh` | 5, 7 | `patches/validation/suite_<configuration>.txt` |
| `runners/sx_patch_run.sh` | 5 | `patches/validation/ledger.txt`, `validation/run_013_counts/counts.txt` |
| `runners/sx_joint_run.sh` | 6 | `validation/run_015_joints/reading.txt` |
| `runners/sx_ledger7_run.sh` | 7 | `validation/run_017_counts/reading.txt` and `counts.txt` |
| `runners/sx_limit_run.sh` | 8 | `validation/run_019_limits/reading.txt` and `counts.txt` |
| `runners/sx_study9_run.sh` | 9 | `validation/run_021_rotation/reading.txt` and `counts.txt` |
| `runners/sx_study10_run.sh` | 10 | `validation/run_026_ant_stops/reading.txt` |
| `runners/sx_study11_run.sh` | 11 | `validation/run_027_friction/reading.txt` and `counts.txt` |
| `runners/sx_study12_run.sh` | 12 | `validation/run_028_joint_motion/reading.txt` and `counts.txt` |
| `runners/sx_study13_run.sh` | 13 | `validation/run_029_end_to_end/reading.txt` |
| `runners/sx_study14_run.sh` | 14 | `validation/run_032_open_items/reading.txt` |
| `runners/sx_study15_run.sh` | 15 | `validation/run_034_replication/reading.txt` |
| `runners/sx_study16_run.sh` | 16 | `validation/run_036_registration16/reading.txt` |
| `runners/sx_study19_run.sh` | 19 | `validation/run_043_study19/reading.txt` |
| `runners/sx_study20_run.sh` | 20 | `validation/run_044_study20/reading.txt` |
| `runners/sx_study21_run.sh` | 21 | `validation/run_051_study21/reading.txt` |
| `runners/sx_study22_run.sh` | 22 | `validation/run_052_study22/reading.txt` |
| `runners/sx_study23_run.sh` | 23 | `validation/run_055_study23/reading.txt` |
| `runners/remake.sh`, `runners/inputs.txt` | 1 to 16, 19, 20 | Every reading above, from the record's own files: `inputs.txt` says where in the record each input of the runners of registrations 1 to 16 is, and `remake.sh` assembles them and runs every runner |

## What the engine was asked to do (registrations 1 to 3)

The first three registrations read SuperDex's encoder streams with Senua AI's gap instrument. The programs in
[`instrument/`](instrument/) are the calls that were made: which streams were read, in which roles, with which
sensor noise, and how the result was compared with the registered rules.

| File | What it does |
|---|---|
| `instrument/sx_actions.sx` | Writes the seeded commands in [`../actions/01/`](../actions/01/) and the later action folders |
| `instrument/sx_settings.sx` | The first registration: counts, then the instrument's one reading |
| `instrument/sx_settings2.sx`, `sx_run2.sh` | The second registration: calibration on noise alone, the detection bar, the reading |
| `instrument/sx_settings3.sx`, `sx_count3.sh`, `sx_run3.sh` | The third registration: plain subtraction of the streams, and the instrument beside it on the same gaps. Its `plain` measure is also what the later registrations use for the benchmark scenes, with no instrument |

The Senua AI engine is proprietary and is not in this repository. In these four programs the lines that include
engine files are replaced by one line (`// use "senua_engine.sx"`), one comment that named an engine file is
shortened, and comments that named the engine's own repository paths, design documents or the workings of its
generator and runtime are replaced. No line of code differs from the files as they ran. Their checksums as run, for
the record:

| File | sha256 as run |
|---|---|
| `sx_actions.sx` | a739e224c820e163... |
| `sx_settings.sx` | ae1b036356516004... |
| `sx_settings2.sx` | 848adc5597c4441e... |
| `sx_settings3.sx` | 93a2a71d4c8c13a7... (cited by the seventh registration) |

The third registration is the check on the instrument itself: on every one of 30 cells it agreed with plain subtraction of the same streams on whether the settings are in order
([`../validation/run_008_instrument/`](../validation/run_008_instrument/)).

As run, all of these files sat in one directory. They are split in two here only to keep the arithmetic apart from
the programs that call the engine.
