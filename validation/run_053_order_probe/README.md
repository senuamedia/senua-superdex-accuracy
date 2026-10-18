# Run 053: the order test at the recommended configuration's solver tolerances (a probe)

15 October 2026, 08:55:21 to 09:12:59 UTC (`log/started.txt`, `log/plays.txt`), on the SuperDex Linux machine of runs
039 to 047 (AWS EC2, Intel Xeon Platinum 8488C, 8 CPUs, Ubuntu 24.04, Clang 18), 4 CPUs used. **Not registered, and
it decides nothing.** It is a probe for designing Study 21's order rule.

## The question

Studies 11 and 12 decided that patches F and G join the recommended configuration on the order test: with the patch
added, `half_cheetah` and `ant` at steps 1 to 1/16 are in order in 3 folds of 3, and no step diverges. "In order"
means that each halving of the time step changes the motion less than the one before. Both studies played it at
SuperDex's shipped solver tolerances (absTol 1e-3, relTol 1e-6). The recommended configuration has 1e-4 and 1e-8,
where no study had played the order test before this probe.

At the configuration's tolerances, with every other part of it, are both scenes in order in 3 folds of 3 at steps 1
to 1/16, and does any step stop or diverge? The same question without patch F and without patch G.

## What was played

| | |
|---|---|
| Scenes | `half_cheetah`, `ant` (Meta's benchmark, SuperDex v1.0.0 assets) |
| Steps | 1, 1/2, 1/4, 1/8, 1/16 of the shipped 10 ms (`sub=1` to `sub=16`) |
| Episodes | 108 of 200 readings (40 control steps), read in 3 folds of 36 episodes, as the record reads them |
| Commands | **`actions/05`**: the fifth registration's commands, the same ones Studies 8, 9, 11 and 12 decided the order on. Not fresh: the record's generator `measure/instrument/sx_actions.sx` needs the engine to build, and there is no Linux build of it on the host (none in `~/sxbuild`, none found under `~`). `actions/21` (Study 21's registered commands) was not used |
| Library | library build 15, the Linux build in `~/work/sdx/build-patched` (`libmochi_physics_double.so` sha256 eee7cca1...), read only |
| Rig | `tools/sdx_player.cpp` at record commit 2355fed, built with the record's `tools/build_player.sh` and Clang 18 against build-patched; sha256 5de4e34a..., byte-identical to run 040's Linux player |
| Instrument | `~/sxbuild/sx_settings3` (sha256 63cda648...), `time` and `plain chain`, as `measure/runners/sx_study11_run.sh` and `sx_study12_run.sh` read the order |

Every play: `integ=be maxiter=200 ndamp=5 falloff=0.03`, patches A to E switched on
(`SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1
SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1`), and:

| Label | Configuration | Adds |
|---|---|---|
| `rec` | The recommended configuration | F and G switches, `newtoneuler=1 abstol=1e-4 reltol=1e-8` |
| `nof` | Without patch F (Study 21's `nof`) | G switch, `newtoneuler=1 abstol=1e-4 reltol=1e-8` |
| `nog` | Without patch G and Newton-Euler inertia (Study 21's `nog`) | F switch, `abstol=1e-4 reltol=1e-8` |
| `shp` | Control: `rec` at the shipped tolerances, which is Study 12's g chain exactly | F and G switches, `newtoneuler=1` |

The player rig has no setting for the grid cell, so Meta's scenes keep SuperDex's own (as in Studies 13, 14 and 21).
40 plays (4 configurations, 2 scenes, 5 steps), one per CPU, 4 at a time from a queue (`play_probe.sh`, `jobs.txt`).

## Checks before reading

- **The instrument.** The Linux `sx_settings3` re-makes run 027's and run 028's `counts.txt` byte for byte from the
  record's `streams/11` and `streams/12` (`check/c11.txt`, `check/c12.txt`).
- **The machine and the library, by the control.** `shp`'s 10 streams are byte-identical to the record's
  `streams/12` g chain (laptop, library build 12). Its order counts are identical to run 028's, and its stopped steps
  are run 028's (`half_cheetah` 2, 0, 1, 0, 0; `ant` 2, 0, 0, 0, 0). So on these commands this machine and build 15
  make Study 12's chain exactly. What differs below comes from the tolerances or from the patch removed.

## The result

### The order, folds in order of 3 (`out/counts_*.txt`, `out/summary.txt`)

| Configuration | `half_cheetah` | `ant` |
|---|---|---|
| `rec`, the recommended configuration | **3 of 3** | **3 of 3** |
| `nof`, without patch F | 3 of 3 | 3 of 3 |
| `nog`, without patch G and Newton-Euler inertia | 3 of 3 | 3 of 3 |
| `shp`, control at the shipped tolerances | 3 of 3 | 3 of 3 |

The instrument's gaps between successive halvings (plain subtraction over the fold's episodes):

| | Fold | 1 against 1/2 | 1/2 against 1/4 | 1/4 against 1/8 | 1/8 against 1/16 |
|---|---|---|---|---|---|
| `rec` `half_cheetah` | 0 | 3,033,246 | 1,746,979 | 918,204 | 518,002 |
| | 1 | 3,392,781 | 2,168,735 | 1,080,045 | 543,772 |
| | 2 | 2,809,433 | 1,817,386 | 995,668 | 486,354 |
| `rec` `ant` | 0 | 12,103,629 | 7,995,857 | 5,457,076 | 3,131,537 |
| | 1 | 9,329,471 | 6,577,994 | 3,592,983 | 2,382,677 |
| | 2 | 10,464,636 | 6,250,361 | 3,649,607 | 2,149,224 |
| `nof` `half_cheetah` | 0 | 3,603,242 | 2,189,451 | 1,269,055 | 721,970 |
| | 1 | 4,283,061 | 2,336,842 | 1,424,469 | 846,596 |
| | 2 | 3,429,024 | 2,085,839 | 1,354,439 | 807,509 |
| `nof` `ant` | 0 | 12,965,683 | 10,744,907 | 7,291,907 | 3,815,220 |
| | 1 | 9,399,469 | 6,812,480 | 3,858,600 | 3,163,639 |
| | 2 | 13,045,475 | 6,930,259 | 4,465,661 | 2,744,340 |
| `nog` `half_cheetah` | 0 | 3,064,450 | 1,766,308 | 925,604 | 521,188 |
| | 1 | 3,400,416 | 2,198,811 | 1,098,987 | 548,063 |
| | 2 | 2,825,566 | 1,835,512 | 996,128 | 489,941 |
| `nog` `ant` | 0 | 12,147,808 | 7,890,753 | 5,878,964 | 3,159,772 |
| | 1 | 9,169,177 | 6,574,090 | 3,602,711 | 2,306,526 |
| | 2 | 10,421,421 | 6,236,259 | 3,678,310 | 2,172,817 |

How close each chain came to falling out of order: the largest ratio of a gap to the gap before it. This is
arithmetic on the gaps above, given for design, not a reading of the instrument:

| | `half_cheetah` | `ant` |
|---|---|---|
| `rec` | 0.65 (fold 2, 1/2 against 1/4) | 0.71 (fold 1, 1/2 against 1/4) |
| `nof` | 0.65 (fold 2, 1/4 against 1/8) | 0.83 (fold 0, 1/2 against 1/4); 0.82 (fold 1, 1/8 against 1/16) |
| `nog` | 0.65 (fold 2, 1/2 against 1/4) | 0.75 (fold 0, 1/4 against 1/8) |
| `shp` | 0.65 (fold 2, 1/2 against 1/4) | 0.70 (fold 1, 1/2 against 1/4) |

**The tolerances hardly move the order reading.** `rec` against `shp` (the same configuration, the same commands,
only the tolerances differ): every `half_cheetah` gap within 0.2%, every `ant` gap within 2% (the largest change is
`ant` fold 0 at 1/8 against 1/16: 3,131,537 against 3,195,066). `nog` reads within 1% of Study 11's f chain
(run 027, the same switches at the shipped tolerances, on the laptop). Removing patch F moves the gaps most:
`half_cheetah`'s are 8% to 66% larger without it, and `ant`'s chain comes closest to falling out of order.

### Stopped and diverged steps (`stats/`, `stops/`, `out/summary.txt`)

Solver steps stopped without converging, at steps 1, 1/2, 1/4, 1/8 and 1/16 (21,600, 43,200, 86,400, 172,800 and
345,600 solver steps; 669,600 a chain):

| | `half_cheetah` | of the chain | `ant` | of the chain |
|---|---|---|---|---|
| `rec` | 5, 0, 2, 1, 0 | 8 | 2, 1, 0, 0, 0 | 3 |
| `nof` | 6, 1, 2, 1, 1 | 11 | 25, 8, 8, 9, 8 | 58 |
| `nog` | 8, 2, 1, 1, 0 | 12 | 2, 0, 0, 0, 0 | 2 |
| `shp` (control) | 2, 0, 1, 0, 0 | 3 | 2, 0, 0, 0, 0 | 2 |

- **No step diverged in any of the 40 plays.**
- **Every stop is at the iteration limit (200).** None stopped below it, so none is SuperDex's small-update rule.
  Under `rec` the stopped steps' residual norms are 0.0013 to 0.46 (the traces kept in `stops/`: step, status,
  iterations, residual in millionths).
- The tighter tolerances add stops at the limit. Under `rec` against `shp`: `half_cheetah` at step 1 has the same two
  (solver steps 8616 and 20527) and 3 more; at 1/4 the same one and 1 more; at 1/8, 1 more. `ant` at 1/2 has 1 more.
- One stop stands out: without patch F, `half_cheetah` at 1/16 stopped one step (solver step 248,375) with a residual
  norm of 3,220 (the STATS line's `worst_residual 3.22e+03`). It is counted as stopped, not diverged.
- Without patch F, `ant` at the shipped step stops 25 of 21,600, more than 1 in 1,000 (21.6). Under `rec` the most in
  any play is 5 of 21,600 (`half_cheetah` at step 1).

### Time

40 plays in 17 min 38 s of wall time on 4 CPUs. Each play's own time is in its STATS line: the `rec` chain took
1,175 s (`half_cheetah` 985, `ant` 190), `nof` 842, `nog` 1,154, `shp` 1,031; 4,202 s in all. The tighter tolerances
cost `rec` 14% more time than `shp` on `half_cheetah` and 15% more on `ant`. The longest single play,
`rec` `half_cheetah` at 1/16, took 374 s. The reading took under a second.

## What it means for Study 21

1. **The order test can be carried at the configuration's tolerances in the form the decisions used:** both scenes
   in order in 3 folds of 3 at steps 1 to 1/16, and no step diverges. On these commands it holds for the
   configuration, without patch F and without patch G. Tightening the tolerances moved the gaps by at most 2%, so
   the tolerances give no reason for it to fail.
2. **A chain rule must not ask that no step stops.** The configuration's chains stop 8 of 669,600 solver steps on
   `half_cheetah` and 3 on `ant`, every one at the iteration limit. The rule form of Study 21's change 3 ("none stops
   at the iteration limit, each play's most iterations under 200") would fail on these chains, and so would "no step
   stops". A bound of 1 in 1,000 stopped per play holds for the configuration in every play here (the most is 5 of
   21,600). The decisions of Studies 11 and 12 asked only that no step diverge in the chains.
3. **The probe does not show how the order fares on fresh commands.** It used `actions/05`, the commands every order
   decision of the record was made on (Studies 8, 9, 11 and 12). Study 21's `actions/21` was not used: this probe saw
   none of its commands. `ant` is the scene at risk. Its largest ratio here is 0.71 under the configuration and 0.83 without
   patch F, and its ratios vary from fold to fold (0.52 to 0.83 across the configurations). The eighth
   registration's probes found `ant` in order in only 2 of 3 folds on other commands, under an earlier
   configuration. A registered order rule on `actions/21` should state that risk.
4. **Cost.** The configuration's chain is about 1,200 CPU-seconds (10 plays, 8 of them beyond the shipped-step plays
   Study 21 makes anyway). On 4 CPUs it
   is bounded by the 374 s `half_cheetah` play at 1/16, about 6 to 7 minutes. With the `nof` and `nog` chains as
   well it is about 3,200 CPU-seconds, about 14 minutes on 4 CPUs.

## Files

| File | What it is |
|---|---|
| `play_probe.sh` | The play script that ran (queue worker, one play per job) |
| `jobs.txt` | The 40 jobs in the order they were taken (longest first) |
| `read_probe.sh` | The reading: `sx_settings3 time` and `plain chain` per configuration and scene, the solver counts, the control compared |
| `out/counts_rec.txt`, `counts_nof.txt`, `counts_nog.txt`, `counts_shp.txt` | The instrument's readings (TIME, PARTING, CELL, PLAIN lines), in the form of runs 027 and 028 |
| `out/summary.txt` | Folds in order, each play's solver counts, the control's byte comparison |
| `out/provenance.txt` | Checksums of the player, library, instrument, rig source, commands and patches; record commit; machine |
| `out/streams.sha256` | Checksums of the 40 encoder streams (the streams are not kept; they are in `~/work/orderprobe/streams` on the host) |
| `stats/half_cheetah.txt`, `stats/ant.txt` | Every play's STATS line |
| `stops/<scene>_<cfg><k>.txt` | Every stopped or diverged solver step from the play's trace (step, status 2 stopped or 3 diverged, iterations, residual in millionths); the traces themselves were removed |
| `check/c11.txt`, `check/c12.txt` | The instrument check: run 027 and run 028 counts re-made on Linux |
| `log/plays.txt` | Start and end of every play, with exit code and wall seconds |
| `bin/build_player.txt` | The player build's output |
