# Run 052: patch G under BDF2, its current form and its derived form head to head (Study 22)

15 October 2026, 10:08:30 to 11:00:27 UTC (`times.txt`), under
[`preregistrations/PREREGISTRATION_22.md`](../../preregistrations/PREREGISTRATION_22.md), by
[`tools/plays/play_22.sh`](../../tools/plays/play_22.sh) from its own copy of the record at the registration's commit (Study 21 played beside it from another), on the
Linux machine of runs 039 to 049 (AWS EC2, Intel Xeon Platinum 8488C, Ubuntu 24.04, Clang 18). Played once: each part
started and finished once (`times.txt`). The part build made the derived library in 19 minutes 37 seconds (`played.txt`:
"the derived library built"), and rigs built every rig in 1 minute 15 seconds. Then the parts identity, bdf2, be, bench
and long ran side by side as separate processes, as the registration allows, and off after be; the longest was bench,
31 minutes 4 seconds. Run 051 played on the same machine at the same time (its `times.txt` also starts at 10:08:30).

The libraries (`rigs.sha256`):

| | sha256 | Built from |
|---|---|---|
| Stock | 75def9201a45216a... | SuperDex at the commit in `UPSTREAM_COMMIT`, by `validation/run_039_linux_replication/build.sh` |
| The current form, library build 15 | eee7cca1423650df... | The four patch files as they stood at registration (05cfa0a0..., 6faaa832..., 279c9510..., 9807f00f...), by the same script |
| The derived form | 2dc292922b3fa4e5... | The contact, joint-limit and rotation files of build 15 and `patches/in_design/senua_inertia_transport_bdf2_derived.patch` (c3e1442b...), by the play script's part build; by the decision below it is library build 16 |

Every rig was built by the play script from the sources in `tools/`, whose checksums are the registration's: against
the derived library in `tools/`, against the stock library (`*_stock`), and against build 15 in a folder of its own
(`rigs22_cur/`). Each rig's `loads:` line in `rigs.sha256` names the library it loaded, with the address at which
`ldd` found it, which changes from run to run.

Measured by [`measure/runners/sx_study22_run.sh`](../../measure/runners/sx_study22_run.sh) (`reading.txt`); the byte
comparisons of E1 and E2 are `compare.txt`, `identity.txt` and `identity_linux.txt`. The plays are kept under `runs/`:
`bdf2_<tolerance>_<form>/` and `be_<tolerance>_<form>/` (`acc` the accurate configuration's tolerances, `tight` the
solve converged; `cur` and `der` the two forms), `off_<integrator>_<library>/`, `long/` and `bench/`.

## The result: every rule held, 66 rule lines of 66

The reading's last line: `STUDY22 rule lines held 66 failed 0 ; values missing 0 ; measuring complete 1`. Drifts are in
parts per million over the 2 s play, the largest departure from the start, as the registration reads them.

| Rule | Rule lines held | What was measured |
|---|---|---|
| O0, required | 6 of 6 | The current form, the solve converged: from the shipped step to 1/64 the momentum drift falls 16,386 to 246 (chain A), 19,136 to 284 (B) and 10,547 to 154 (T), 66.6, 67.4 and 68.5 times over six halvings, less than 512: 1.99 to 2.08 a halving. At 1/64 each is above 5 floors (35) |
| O1, correct, momentum | 15 of 15 | The derived form, each free chain, both tolerances: every halving ruled falls by at least 2.83. With the solve converged the falls are 3.88 to 4.03; at the configuration's tolerances 3.56 to 4.19. Two halvings ruled on each chain at each tolerance (1 to 1/2 and 1/2 to 1/4); the finer ones are under 5 floors and reported |
| O2, correct, energy | 14 of 14 | The derived form, chains A and B: every halving ruled falls by 4.16 to 4.33 with the solve converged and 4.33 to 4.59 at the configuration's tolerances; three halvings ruled on each chain at each tolerance (1 to 1/8) |
| T1, the chains at 1/16 | 5 of 5 | The derived form under the accurate configuration: momentum drift 5, 6 and 5 (A, B, T; bound 1,000); kinetic energy at the end 999,999 and 999,980 per million of the start (A, B; bound 1 in 200) |
| T2, the swinging chain at 1/16 | 1 of 1 | Energy at the end -596 per million of the most kinetic energy (bound 5,000) |
| T3, the free spin at 1/16 | 1 of 1 | 3,799,981 micro-radians a second after 1 s, against at least 3,799,620 |
| T4, the pendulum at 1/16 | 3 of 3 | The first three swings 9,999, 9,999 and 9,999 per 10,000, read at the steps and with each turn placed between the steps; released level for 20 s, every swing 9,999 or 10,000 |
| U1, the solver | 2 of 2 | The derived form's plays under BDF2: no step diverged; the most iterations of any step 13, so none stopped at the iteration limit. Reported: 570 stopped, on SuperDex's rule for an update too small to matter |
| U2, Meta's scenes | 9 of 9 | The derived form, BDF2 at 1/16, the fresh commands: 0 steps stopped of 345,600 on each scene, none diverged; the most iterations 115 (`half_cheetah`), 84 (`ant`) and 3 (`cart_pole`) |
| E1, safe when off | 4 of 4 | On the derived library, the identity check's parts rotvec, flight, suites, joints, zero, bench and benchrec (ten parts as the script counts them): every file byte-identical to its registered file but the eight plays named for Linux in them, each byte-identical to the file run 040 kept, and the six with no switch also to stock on this machine. The scenes here with no switch, under BDF2 and backward Euler at steps 1, 1/4, 1/16 and 1/64: 48 of 48 byte-identical to stock (`compare.txt`: 24 and 24) |
| E2, backward Euler unchanged | 6 of 6 | With patch G's switch set under backward Euler: the identity part fg, 40 of 44 files byte-identical to their registered files and the 4 named for Linux to run 040's kept files; the scenes here, both tolerances, steps 1 to 1/64, 84 of 84 byte-identical to build 15's (42 and 42); Meta's scenes under the recommended configuration at the shipped step, 6 of 6 streams and solver statistics byte-identical to build 15's, the wall-clock time apart |

The floors (`reading.txt`, `floor`): 7 parts per million at every step and tolerance, but 13 for chains B and T at the
shipped step at the configuration's tolerances. A halving is ruled where the finer step's drift is at least 5 floors,
35 (65 where the coarser step's floor is 13).

Reported, not deciding (`reading.txt`):

- **The current form beside each T rule**, at 1/16 under the accurate configuration: the chains' momentum 981, 1,137
  and 615 (chain B's above T1's bound of 1,000), energy at the end 1,000,011 and 999,992, the swinging chain -95, the
  free spin 3,799,992, the pendulum 9,999, 9,999 and 9,999, over 20 s 9,999 to 10,000.
- **The coarse-step cost on a single joint**, with (omega h)^2 beside it. The free spin at 3.8 rad/s after 1 s, of
  3,800,000 micro-radians a second, at the configuration's tolerances: at the shipped step 3,794,503 with the derived
  form and 3,797,811 with the current one ((omega h)^2 14.44 per 10,000), at 1/16 3,799,981 and 3,799,992 (0.056). The
  pendulum's first three swings at the shipped step: 9,989, 9,971 and 9,962 with the derived form, 9,991, 9,978 and
  9,972 with the current one; from 1/8 of the step on they read the same.
- **The swinging chain's energy drift at every step** (its order is not a claim of the derived form): at the
  configuration's tolerances 309,313 at the shipped step to 116 at 1/64 with the derived form, 371,340 to 68 with the
  current one.
- **The solver**: under BDF2 with the solve converged, 570 stopped steps with the derived form and 265 with the current
  one; under backward Euler with the solve converged 367 with each; at the configuration's tolerances none. None
  diverged.
- **Meta's scenes**: under the accurate configuration both forms stopped no step of 345,600 on any scene; under the
  recommended configuration both stopped 7 steps of 21,600 on `half_cheetah` and none on `ant` and `cart_pole`.

## What the decision records

Every rule held, so, as the registration decided in advance, the derived form replaces the current one as patch G under
BDF2: `patches/in_design/senua_inertia_transport_bdf2_derived.patch` becomes `patches/senua_inertia_transport.patch`,
the current file moves to `patches/superseded/` (as `senua_inertia_transport_registration22.patch`), the four patch
files are library build 16, and the open item "patch G under BDF2 on a chain" closes. Every play E1 and E2 compared is
the same on library build 16 as on build 15. Nothing about backward Euler is decided here, nor about the accurate
configuration as a whole, which this registration played only as far as patch G acts.
