# Seventh pre-registration: a slide that ends, two moving bodies, and a correction to patch C

Registered 14 October 2026, after design probes with other cubes and throwaway commands
([validation/run_016_design_probes](../validation/run_016_design_probes/)). Registered before any run of this
registration existed.

## Why

The fifth registration recorded three patches and a recommended configuration. Its tests did not ask whether a cube
that slides to a stop stays stopped, and every test had one moving body. The probes asked both. Stock SuperDex
stops dead; the anchored friction as recorded (patch C) comes back by its stick distance and rings, more as the step
is refined. That is a fault in our patch, not in SuperDex. This registration tests a correction, tests the patches
between two moving bodies, and repeats the fifth registration's checks on the corrected patch.

## The correction (in `patches/senua_contact.patch`, off unless `SUPERDEX_STICK_DAMPING` is set)

- **A damped stick.** Friction acts on the offset from the stick anchor over the stick distance plus the sliding
  speed over SuperDex's own `frictionFalloffVel`, inside the one saturation. This is the bristle damping of the
  LuGre friction law (Canudas de Wit, Olsson, Astrom and Lischinsky 1995).
- **A fresh anchor when the contact is open.** A contact that carries no normal force at the start of a step holds
  no stick: the return mapping of penalty friction (Simo and Hughes 1998; Laursen 2002) onto a friction limit of
  zero.

The patch still only adds lines (957). With the switch off, the anchored friction is the recorded one, bit for bit.

## The configurations

| Name | What it is |
|---|---|
| stock | SuperDex v1.0.0 as built from source |
| off | The patched library with no switch set |
| C as recorded | `SUPERDEX_STICK_DISTANCE=0.0003` |
| C corrected | The same with `SUPERDEX_STICK_DAMPING=1` and `frictionFalloffVel` 0.03 |
| recommended as recorded | Contact damping 5, patches A and B, C as recorded (the fifth registration) |
| recommended corrected | Contact damping 5, `frictionFalloffVel` 0.03, patches A and B, C corrected |

## The scenes, registered parameters (none was used in the probes)

One cube of 0.8 kg and half-size 0.035 m, friction 0.35. Two cubes: A of 4 kg and half-size 0.3 m, B of 0.6 kg and
half-size 0.03 m, friction 0.4 between them and none under A. Every run is played at the shipped 10 ms step and at
finer steps as listed.

The first suite (T01 to T10, `tools/contact_suite.sh`) is the fifth registration's, on this cube: drop 0.1 m,
oblique impact at 2.5 m/s, chain at 0.9 m/s, slide at 3 m/s, hold and slip at friction 0.45 with pushes of 2.117 and
4.234 N, lift 23.52 N.

The second suite (`tools/contact_suite2.sh`):

| Test | What is played | The right answer | It passes when |
|---|---|---|---|
| T11 stop | The cube set sliding on the ground at 0.9 m/s, 1.5 s; steps 1, 1/4, 1/16, 1/64 | It stops and stays stopped | Largest speed over the last third within 100 micrometres a second of zero, at every step |
| T12 land | The same cube dropped 0.07 m while moving at 0.9 m/s; the same steps | It lands, stops and stays stopped | The same |
| T13 comes back | The eight runs of T11 and T12 | Stock: it does not come back | It comes back no more than 330 micrometres (the stick distance and a tenth) |
| T14 carry | B on A; A pushed with 9.016 N (half of what friction can carry B at) from 0.5 s, 2 s; steps 1, 1/16 | B rides on A | Mean of B's speed less A's over the second half within 100 micrometres a second of zero |
| T15 slip | A pushed with 27.048 N (one and a half times it) from 0.5 s to 0.9 s | A accelerates at 6,174 mm/s2 and B at 3,920 | Both mean accelerations from 0.7 s to 0.9 s within 2 parts in 100 |
| T16 momentum | B at 1.2 m/s into A's side with no gravity; B released at 0.8 m/s sliding on top of A | The momentum of the two never changes; on top they end together | Largest change no more than 500 parts per million in both; on top, relative speed at the end within 100 micrometres a second |
| T17 rest | B on A on the ground, 1 s | Each contact carries its weight: 39,200 mN up on A in all, 5,880 on B | Both within 1 part in 100 |

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **G0** safe when off | Every file of both suites under "off" is byte-identical to stock (39 and 28), and the 38 registered benchmark streams of the fifth registration's check are byte-identical when re-played on this library with no switch set |
| **G1** the recorded patch C does not stay stopped | Stock passes T11 and T12 at every step. C as recorded fails T11 or T12 at one step or more, and so does the recommended configuration as recorded |
| **G2** the correction | C corrected passes T11 and T12 at every step. The recommended configuration corrected passes T11, T12 and T13 at every step |
| **G3** two moving bodies, stock | Stock passes T15, T16 and T17 at both steps, and fails T14 with B falling behind at the speed the shipped friction law gives, 2,929 micrometres a second, within 1 part in 100 |
| **G4** two moving bodies, corrected | The recommended configuration corrected passes T14, T15, T16 and T17 at both steps |
| **G5** nothing else gets worse | The recommended configuration corrected passes every test of the first suite but T05 (the code 1111011111 or better) |
| **G6** the benchmark | On the fifth registration's commands (seeds 4602 and 4603), with the recommended configuration corrected: half_cheetah's time-step chain is in order in 3 folds of 3; no solver step diverges at any of the five steps of either scene; at the shipped step no more steps stop without converging than stock's count plus 1 in 1,000 (stock: half_cheetah 2, ant 206, of 21,600) |
| **G7** the solver on the suites | Over each suite, fewer solver steps stop without converging under the recommended configuration corrected than under the recommended configuration as recorded |

The stock streams of G6 exist from the fifth registration (half_cheetah in order in 0 folds of 3). No stream of the
corrected configuration on those commands exists.

Reported, not deciding: every measured line; how far the cube comes back under every configuration; T05; ant's
folds in order; the most iterations of any step; the solver's stops run by run.

## Known risks, stated before the run

- The registered cubes are new. The stop tests' pass line (100 micrometres a second) was 0 for stock in the probes
  and 0 to 2 for the correction; a bouncing landing at the finest step is the likeliest to cross it.
- G6's solver bound leaves about 21 steps of 21,600. The probes had 0 of 2,400 for half_cheetah and 1 of 2,400 for
  ant, on other commands.
- T13's bound is the stick distance and a tenth. The probes came back 286 to 300 micrometres.

## What this does and does not say

If the rules hold, patch C as recorded in the fifth registration is withdrawn in favour of the corrected one, and
the recommended configuration becomes the corrected one. The spring-back by the stick distance is a known cost of
it and is stated wherever the patch is. If a rule fails, it is recorded as measured, and the recommended
configuration of the fifth registration stays marked as having the fault G1 measures.

Still not addressed: friction one step late at the impact itself (T05), the integrator's loss on joint motion (sixth
registration), anything against a real robot.

## As registered

Patch `patches/senua_contact.patch` sha256 5cf3c66296270d0c... (957 added lines, none removed); the patched library
built from it 675522c786608721...; the stock library 5a213c925bc86b61.... Measuring programs in the Simplex
repository: `sx_contact.sx` 3d93198f49de9574..., `sx_ledger7_run.sh` a026d09a1c90fcb2..., `sx_contact_suite.sh`
537570452154397e..., `sx_settings3.sx` 93a2a71d4c8c13a7.... Plays: `tools/plays/play_07.sh`.
