# Study 7: a slide that ends, and two moving bodies

| | |
|---|---|
| Registration | Seventh: [PREREGISTRATION_07.md](../../preregistrations/PREREGISTRATION_07.md) |
| Question | Does a cube that slides to a stop stay stopped, and is contact right between two bodies that both move? |
| Outcome | Every rule held: all eight. It caught a fault in our own patch C, which was withdrawn and corrected, and the recommended configuration takes the corrected form |
| Registered | 14 October 2026, before any run of this registration existed |
| Result | [Run 017](../../validation/run_017_counts/README.md), 14 October 2026 |
| Runs | [016, design probes](../../validation/run_016_design_probes/), [017, the registered runs](../../validation/run_017_counts/) |
| Data | [`validation/run_017_counts/runs/`](../../validation/run_017_counts/runs/) (the first suite under four configurations, `off`, `stock`, `rec_old` and `rec_new`; the second under those and `stick` and `stickd`), [`streams/07/`](../../streams/07/) |
| Played by | [`tools/sdx_contact.cpp`](../../tools/sdx_contact.cpp), [`tools/sdx_pair.cpp`](../../tools/sdx_pair.cpp), [`tools/contact_suite2.sh`](../../tools/contact_suite2.sh), [`tools/plays/play_07.sh`](../../tools/plays/play_07.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx) (`stop`, `pair`, `accel`, `ledger7`), `sx_ledger7_run.sh` |

Previous: [Study 6](06-joints.md). Next: [Study 8](08-joint-limits.md). All studies: [index](README.md).

## Why it was asked

Study 5 recorded three patches and a recommended configuration. Its tests never asked two things. Does a cube that
slides to a stop stay stopped? And is contact right between two bodies that both move? Every test in Study 5 had one
moving body.

The design probes asked both. Stock SuperDex stops dead. The anchored friction as recorded in Study 5 (patch C)
comes back by its stick distance and rings, more as the step is refined. **That is a fault in our patch, not in
SuperDex.**

## What the design probes showed

On throwaway cubes and throwaway commands ([run 016](../../validation/run_016_design_probes/)).

- **Stock SuperDex is right between two moving bodies**, with one exception. Momentum is kept in a collision and
  in a slide of one cube on the other. A stack at rest carries its weights. A cube that slips on a pushed cube
  accelerates at Coulomb's value. But a cube that should ride on a gently pushed cube falls behind at the speed the
  shipped friction law gives. The absence of stick is the same between two bodies as on the ground.
- **Patch C as recorded does not stay stopped.** With it a cube that has slid to a stop comes back by the stick
  distance and then rings on it. The ringing is hidden at the shipped step, where the integrator damps it, and
  grows as the step is refined: 228 micrometres a second left at 1/16 of the step and 11,404 at 1/64.
- **The cause.** Anchored friction is a spring between a contact and its anchor. As recorded in Study 5 it has no
  loss of its own, and it keeps its anchor while the contact is open.
- **How stiff and how damped the correction should be.** With the shipped `frictionFalloffVel` (0.01) the corrected
  stick costs `half_cheetah`'s solver: 2 of 2,400 steps stop at a 300 micrometre stick, 6 at 100, 24 at 30 and 62
  at 10. With `frictionFalloffVel` at 0.03 and the stick at 300 micrometres it stops on none.

## The correction

Both parts are in [`patches/senua_contact.patch`](../../patches/senua_contact.patch) and are off unless
`SUPERDEX_STICK_DAMPING` is set.

- **A damped stick.** Friction acts on the offset from the stick anchor over the stick distance plus the sliding
  speed over SuperDex's own `frictionFalloffVel`, inside the one saturation. At rest it holds as before. While
  sliding it is the friction coefficient times the normal force as before. In between, the speed term is the loss.
  This is the bristle damping of the LuGre friction law (Canudas de Wit, Olsson, Astrom and Lischinsky 1995).
- **A fresh anchor when the contact is open.** A contact that carries no normal force at the start of a step holds
  no stick. This is the return mapping of penalty friction (Simo and Hughes 1998, Laursen 2002) onto a friction
  limit of zero.

The patch still only adds lines. With the switch off, the anchored friction is the one Study 5 recorded, bit for
bit.

## What was played

| Configuration | What it is |
|---|---|
| Stock | SuperDex v1.0.0 as built from source |
| Off | The patched library with no switch set |
| C as recorded | `SUPERDEX_STICK_DISTANCE=0.0003` |
| C corrected | The same with `SUPERDEX_STICK_DAMPING=1` and `frictionFalloffVel` 0.03 |
| Recommended as recorded | Contact damping 5, patches A and B, C as recorded (Study 5) |
| Recommended corrected | Contact damping 5, `frictionFalloffVel` 0.03, patches A and B, C corrected |

One cube of 0.8 kg and half-size 0.035 m with friction 0.35. Two cubes: A of 4 kg and half-size 0.3 m, B of 0.6 kg
and half-size 0.03 m, with friction 0.4 between them and none under A. None of these numbers was used in the
probes.

The first suite is Study 5's T01 to T10, on the new cube. The second suite is new:

| Test | What is played | The right answer | It passes when |
|---|---|---|---|
| T11, stop | The cube set sliding at 0.9 m/s, at steps 1, 1/4, 1/16 and 1/64 | It stops and stays stopped | Largest speed over the last third within 100 micrometres a second of zero, at every step |
| T12, land | The same cube dropped 0.07 m while moving at 0.9 m/s | It lands, stops and stays stopped | The same |
| T13, comes back | The eight runs of T11 and T12 | Stock does not come back | It comes back no more than 330 micrometres |
| T14, carry | B on A, with A pushed at half of what friction can carry B at | B rides on A | Mean of B's speed less A's over the second half within 100 micrometres a second of zero |
| T15, slip | A pushed at one and a half times that | A accelerates at 6,174 mm/s2 and B at 3,920 | Both within 2% |
| T16, momentum | B into A's side with no gravity, and B sliding on top of A | The momentum of the two never changes; on top they end together | Largest change no more than 500 parts per million in both; on top, relative speed at the end within 100 micrometres a second |
| T17, rest | B on A on the ground | Each contact carries its weight: 39,200 mN and 5,880 mN | Both within 1% |

## The rules fixed in advance

| Rule | It holds when |
|---|---|
| G0, safe when off | Every file of both suites under "off" is byte-identical to stock, and so are the 38 registered benchmark streams |
| G1, patch C as recorded does not stay stopped | Stock passes T11 and T12 at every step. C as recorded fails at one step or more, and so does the recommended configuration as recorded |
| G2, the correction | C corrected passes T11 and T12 at every step. The recommended configuration corrected passes T11, T12 and T13 at every step |
| G3, two moving bodies, stock | Stock passes T15, T16 and T17 at both steps, and fails T14 with B falling behind at the speed the shipped friction law gives: 2,929 micrometres a second, within 1% |
| G4, two moving bodies, corrected | The recommended configuration corrected passes T14 to T17 at both steps |
| G5, nothing else gets worse | The recommended configuration corrected passes every test of the first suite but T05 |
| G6, the benchmark | `half_cheetah`'s time-step chain is in order in 3 folds of 3, no solver step diverges, and at the shipped step no more steps stop than stock's count plus 1 in 1,000 |
| G7, the solver on the suites | Over each suite, fewer solver steps stop under the recommended configuration corrected than as recorded |

If a rule failed, the result was to be recorded as measured, and Study 5's recommended configuration would stay
marked as having the fault.

## The result

| Rule | Result |
|---|---|
| G0, safe when off | Held. 39 of 39 and 28 of 28 suite files, and 38 of 38 benchmark streams, byte-identical to stock |
| G1, patch C as recorded does not stay stopped | Held |
| G2, the correction | Held |
| G3, two moving bodies, stock | Held |
| G4, two moving bodies, corrected | Held |
| G5, nothing else gets worse | Held. The first suite: 1111011111 |
| G6, the benchmark | Held |
| G7, the solver on the suites | Held |

### A slide that ends

Largest speed over the last third of the run, in micrometres a second. The right answer is 0.

| | Slide, 10 ms | 1/4 | 1/16 | 1/64 | Landing, 10 ms | 1/4 | 1/16 | 1/64 |
|---|---|---|---|---|---|---|---|---|
| Stock | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| Patch C as recorded | 0 | 0 | 380 | 12,857 | 0 | 0 | 4,754 | 147,786 |
| Recommended as recorded | 0 | 0 | 333 | 14,767 | 0 | 0 | 341 | 14,478 |
| Patch C corrected | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 25 |
| Recommended corrected | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

At the shipped 10 ms step every row reads 0. The fault only shows when the step is refined, which is why a test at
the shipped step alone would never have found it.

With the recommended configuration corrected the cube comes back 297 to 299 micrometres, once, and then stays.

### Two moving bodies

| | The right answer | Stock | Recommended corrected |
|---|---|---|---|
| T17, force up on A and on B at rest, mN | 39,200 and 5,880 | 39,194 and 5,885 | Passes |
| T15, slip of A and of B, mm/s2, shipped step | 6,174 and 3,920 | 6,170 and 3,940 | 6,172 and 3,932 |
| T15, the same at 1/16 of the step | 6,174 and 3,920 | 6,174 and 3,919 | 6,174 and 3,916 |
| T16, largest change of momentum, parts per million | 0 | 52 to 87 | 44 to 87 |
| T14, B's speed behind A, micrometres a second | 0 | 2,919 and 2,927 | 0 and 0 |

Stock SuperDex keeps momentum to within the resolution of the measure and slips at Coulomb's value. A cube that
should ride on a pushed cube falls behind at the speed the shipped friction law gives. Corrected, it rides.

### The benchmark, and the solver

| | Stock | Recommended corrected |
|---|---|---|
| `half_cheetah`: folds in order | 0 of 3 | 3 of 3 |
| `ant`: folds in order (reported) | 3 of 3 | 3 of 3 |
| `half_cheetah`: steps stopped at the shipped step, of 21,600 | 2 | 7 |
| `ant`: steps stopped at the shipped step, of 21,600 | 206 | 11 |
| Steps diverged | 0 | 0 |

Solver steps that stopped without converging on the suites: 645 on the first suite as recorded and 551 corrected,
and 2,197 and 728 on the second.

## What the corrected configuration costs

These are reported in the record and stated wherever the patch is.

- A cube that slides to a stop comes back by about the stick distance, 0.3 mm, once. Stock does not come back at
  all. This is the elastic part of any friction law that can hold a load.
- On the suites the solver still stops more often than stock, nearly all of it at the finest steps: 551 of 48,090
  steps on the first suite, which is one cube on the ground (stock 36), and 728 of 35,530 on the second (stock 231).
  The second suite also has two-cube runs: 203 of its 728 stops are in them (stock 191), and 525 in its one-cube runs
  (stock 40). The results of those runs are right. The cause of these stops is a defect in SuperDex's quaternion,
  not the patches: with patch E the counts are 0 ([Study 9](09-rotation-axis.md)).
- Patch C corrected without contact damping, on a cube that bounces at 1/64 of the step, stays stopped and ends
  3.2 mm back from where it first stopped. With contact damping it is 0.3 mm at every step.
- T05 still fails: friction is one step late at the impact itself.

Reported about stock: after two free cubes collide and separate, stock's solver stops without converging on 184 of
800 steps at 1/16 of the step, while both cubes move uniformly and nothing touches. The motion is right.

## What it means

- Patch C as recorded in Study 5 is withdrawn. It is kept in
  [`patches/superseded/`](../../patches/superseded/) so that Study 5's numbers can still be re-made.
- The recommended configuration takes patch C corrected: see
  [the recommended configuration](../recommended-configuration.md).
- A patch has to be tested at every step size, on motion that ends, and with more than one moving body. Each of
  those was missing from Study 5's suite, and each is in Study 7's.

## What it led to

The contact side was now tested between bodies. The joint side still had one part untested: the limits the
benchmark scenes ship. That is [Study 8](08-joint-limits.md).
