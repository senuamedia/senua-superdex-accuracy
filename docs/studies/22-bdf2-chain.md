# Study 22: patch G under BDF2, its current form and its derived form head to head

| | |
|---|---|
| Registration | Twenty-second: [PREREGISTRATION_22.md](../../preregistrations/PREREGISTRATION_22.md) |
| Question | Under BDF2, on numbers no earlier study used, does the derived form of patch G replace its current form? |
| Outcome | **Every rule held: 11 rules, 66 rule lines of 66.** On three fresh free chains the derived form's angular momentum and energy fall about four times a halving of the step (3.56 to 4.59 on every halving ruled), where the current form's momentum falls about twice; the accurate configuration's bounds hold at 1/16 of the step; Meta's scenes stop no step under it; nothing changes with the switch off or under backward Euler on every play compared. By the decision fixed in advance the derived form replaces the current one as patch G (library build 16), and the open item "patch G under BDF2 on a chain" closes |
| Registered | 15 October 2026, before run 052 |
| Result | [Run 052](../../validation/run_052_study22/README.md), 15 October 2026 |
| Runs | [049](../../validation/run_049_patch_g_review/README.md) (the review and the design probes), [052](../../validation/run_052_study22/README.md), on the Linux machine of runs 039 to 049 |
| Played by | [`tools/plays/play_22.sh`](../../tools/plays/play_22.sh); measured by [`measure/runners/sx_study22_run.sh`](../../measure/runners/sx_study22_run.sh) |

Previous: [Study 21](21-recommended-configuration.md). Next: [Study 23](23-recommended-configuration-again.md). All studies: [index](README.md).

## Why it was asked

Under BDF2, the integrator of the accurate configuration, patch G's form of library builds 13 to 15 scales its
correction by a share of 1/3, derived for one joint. It is right there, but on a chain it is first order: a free
two-link chain lost 1,540 parts per million of its angular momentum over 2 s at 1/16 of the step, against 1,000
allowed ([Study 15](15-replication.md), V8). The review of patch G
([run 049](../../validation/run_049_patch_g_review/README.md)) found the cause in stock SuperDex: for a jointed body
it starts each BDF2 stage from the forward kinematics of the combined joint angles, where BDF2 for a constrained system
combines each link's own centres, and the two differ at second order in the step, so the velocity a link keeps is short
at first order. It derived a form of patch G that adds the force m D/h_s^2, with D that difference, adds D/h_s to the
link velocity kept at the end of the stage, uses the current Jacobian under BDF2 and keeps the transport for backward
Euler alone, with no constant tuned. This study put the two forms head to head on fresh numbers.

## What was played

Both forms, under BDF2 with the accurate configuration's switches, at its tolerances (1e-4 and 1e-8) and with the
solve converged (1e-9 and 1e-12), at steps 1 to 1/64 of the shipped 10 ms: three fresh free chains (A and B planar, T
with its second joint's axis tilted 0.787 rad so that it moves in three dimensions, using the chain rig's new `tilt2`),
a swinging chain, and a 2.216 kg arm's free spin at 3.8 rad/s and pendulum, and the pendulum for 20 s at 1/16. The
same scenes under backward Euler with both libraries (the floor of the order rules, and E2), and with no switch on the
derived and stock libraries (E1). Meta's three scenes on fresh commands (seeds 22101 to 22103, `actions/22/`), both
forms, under the accurate configuration and under the recommended one. The identity check on the derived library. The
registration gives every number and how it was drawn.

## The rules, and the result

BDF2 is second order, so each halving of the step should divide a drift by about 4, where a first-order error divides
it by 2. A halving is read as second order when the drift falls by at least 2^1.5 = 2.83, and it is ruled only where
the finer step's drift is at least 5 floors, the floor being what backward Euler with patch G reads on the same chain
(it keeps a free chain's angular momentum exactly), or 7 parts per million, whichever is larger. The registration gives
the reasons for each bound.

| Rule | It holds when | Measured ([run 052](../../validation/run_052_study22/README.md)) | |
|---|---|---|---|
| O0, required | The current form, the solve converged, each free chain: the momentum drift falls by less than 512 from step 1 to 1/64, and is at least 5 floors at 1/64 | Falls 66.6, 67.4 and 68.5 times (1.99 to 2.08 a halving); 246, 284 and 154 parts per million at 1/64, against 35 | Held, 6 of 6 |
| O1, correct, momentum | The derived form, each free chain, both tolerances: every ruled halving falls by at least 2.83, and with the solve converged at least one halving of each chain is ruled | Falls 3.88 to 4.03 with the solve converged, 3.56 to 4.19 at the configuration's tolerances; two halvings ruled on each chain at each tolerance, the finer ones under 5 floors | Held, 15 of 15 |
| O2, correct, energy | The same for the kinetic energy of A and B | Falls 4.16 to 4.33 and 4.33 to 4.59; three halvings ruled on each chain at each tolerance | Held, 14 of 14 |
| T1 | The derived form at 1/16 under the accurate configuration: each free chain's momentum drift at most 1,000 parts per million; A's and B's energy at the end within 1 in 200 | Momentum 5, 6 and 5; energy 999,999 and 999,980 per million | Held, 5 of 5 |
| T2 | The swinging chain's energy at the end within 1 in 200 of the most kinetic energy | -596 per million | Held |
| T3 | The free spin keeps at least 9,999 in 10,000 of 3.8 rad/s after 1 s | 3,799,981 micro-radians a second | Held |
| T4 | The pendulum's first three swings between 9,995 and 10,005 per 10,000, both readings; over 20 s every swing between 9,990 and 10,005 | 9,999, 9,999 and 9,999; over 20 s 9,999 to 10,000 | Held, 3 of 3 |
| U1, the solver | No step of the derived form's BDF2 plays diverges or stops at the iteration limit | None diverged; the most iterations of any step 13 (570 steps stopped on SuperDex's small-update rule, reported) | Held, 2 of 2 |
| U2, Meta's scenes | The derived form, BDF2 at 1/16, the fresh commands: no step diverges, none stops at the iteration limit, no more than 1 in 1,000 stop | 0 steps stopped of 345,600 on each scene, none diverged | Held, 9 of 9 |
| E1, safe when off | Patch G's switch unset: the identity check's ten parts (not fg) as registered, the plays named for Linux as run 040's kept files; the scenes here with no switch the same as stock | Every file as registered but the eight named for Linux, each as run 040 kept it; 48 of 48 as stock | Held, 4 of 4 |
| E2, backward Euler unchanged | Patch G's switch set under backward Euler: the identity part fg as registered; the scenes here as library build 15's; Meta's scenes under the recommended configuration as build 15's | 44 of 44 (4 of them the Linux plays, as run 040 kept them); 84 of 84; 6 of 6 streams and their solver statistics | Held, 6 of 6 |

Reported, not deciding: the current form at 1/16 under the accurate configuration read 981, 1,137 and 615 parts per
million on the chains' momentum (chain B above T1's bound), and within the T bounds on the other T readings. The coarse-step cost of the derived form, stated before the run, came out as derived: the free
spin kept 9,985.5 per 10,000 at the shipped step against 9,994.2 with the current form ((omega h)^2 = 14.4 per 10,000),
and 9,999.95 against 9,999.98 at 1/16; the pendulum's first three swings at the shipped step read 9,989, 9,971 and 9,962
against 9,991, 9,978 and 9,972, and from 1/8 of the step on the two read the same.

## What the decision records

Every rule held, so the derived form replaces the current one as patch G under BDF2, as decided in advance:

- `patches/senua_inertia_transport.patch` is the derived form (sha256 c3e1442befd6dee9...; 328 lines added, none
  removed), and the form it supersedes (9807f00f6b543135...) is kept as
  [`patches/superseded/senua_inertia_transport_registration22.patch`](../../patches/superseded/senua_inertia_transport_registration22.patch).
  The registration names the derived form as `patches/in_design/senua_inertia_transport_bdf2_derived.patch`, kept
  there with the same bytes and checksum.
- The four patch files are library build 16. On Linux, the play script's part build made it (sha256
  2dc292922b3fa4e5..., `validation/run_052_study22/rigs.sha256`).
- The open item "patch G under BDF2 on a chain" closes.
- Every play E1 and E2 compared is the same on library build 16 as on build 15: the identity check's plays, with the
  switches of each registered configuration, and backward Euler with patch G on these scenes and on Meta's.

## What it means

- **Under BDF2 a chain is second order with patch G**: its angular momentum and its energy, on planar chains and on one
  that moves in three dimensions. The cause of the first-order loss stays a finding about stock SuperDex: how it starts
  a jointed body's BDF2 stage ([finding 8](../findings.md#8-the-default-integrator-takes-speed-out-of-joint-motion)).
- **The accurate configuration's bounds hold at its own step** with the derived form, and on Meta's scenes its solver
  stops no step. This study did not decide the accurate configuration as a whole, which it played only as far as patch
  G acts.
- **Under backward Euler, the recommended configuration's integrator, nothing changes**: every result there stands for
  library build 16.
- **The cost, as stated before the run**: a single joint gives up about (omega h)^2 of its speed once, at the
  backward-Euler step that starts BDF2. On this arm (omega h)^2 is 14.4 in 10,000 at the shipped step and 0.056 at
  1/16, and the free spin lost 14.5 and 0.05.
- It says nothing about 32-bit, BDF3 or the DIRK integrators (for which patch G's share is 0), chains of more than two
  links outside Meta's scenes, joint limits or joint friction under BDF2, gradients, or a real robot.
