# Probes after run 032

15 October 2026, after [run 032](../) and before any run of the fifteenth registration. Probes 24 to 28 find the
causes of the eight rule lines run 032 failed. Probes 29 to 32 found a defect in the fourteenth registration's accurate
configuration, which the amendment to the [fifteenth registration](../../../preregistrations/PREREGISTRATION_15.md)
corrects before its run. Nothing here decides anything. Libraries: build 13 for probes 24 to 26 (no switch is set,
and both builds are identical with every switch off), none for probe 27 (it measures run 032's own files), build 14
for probes 28 to 32. Measured by [`measure/sx_contact.sx`](../../../measure/sx_contact.sx).

## The cantilever (I4a, I4c): SuperDex's shipped solver tolerance

Run 032 read the rods held across the clamp 0.103% to 0.120% over the textbook, against a bound of 0.1%.

- Played longer the drop does not change (8 s against 4 s, `probe_24_cantilever_cause.txt`): the rod is at rest.
- The `ship` lines of `probe_25_cantilever_tolerances.txt` for the thirteenth registration's rod and the
  fourteenth's are run 032's own plays made again, and read the same: 0.110%, 0.120%, 0.103% and 0.113% over.
- At the tightest tolerances (1e-9 absolute and 1e-12 relative) the solver reports every step of 400 stopped, not
  converged, after at most 4 iterations; there the three rods come within 0.005% to 0.023% of
  the textbook (0.005% to 0.013% at 128 elements, 0.014% to 0.023% at 64), within 5 nm of what they read at 1e-6 and
  1e-10 (the `tight6` lines), where 35 to 61 steps of 400 stopped. At the final configuration's tolerances (1e-4
  and 1e-8) they come within 0.001% to 0.021%, with at most 2 steps of 400 stopped.

So the 0.1% is the shipped tolerance stopping the solve short of a static equilibrium. The fifteenth registration
plays the cantilever at the final configuration's tolerances.

## The soft cube's slide (D4, A5): it pitches forward on the contact and rocks back

Run 032 read the soft cube 0.86% to 1.65% short of the distance at the end of the play, failing at 1.53% to 1.65%. `probe_27_run032_deformables.txt`
measures run 032's own files where each slide stopped (the measure `deformstop`):

| Play | Where it stopped, against the distance | Its centre came back | Its base corner came back |
|---|---|---|---|
| Soft cube, stock, 0.01 s | 0.02% short | 0.44 mm | 0.02 mm |
| Soft cube, stock, 0.001 s | 0.21% short | 0.74 mm | 0.01 mm |
| Soft cube, final, 0.01 s | 0.10% short | 0.75 mm | 0.29 mm |
| Soft cube, final, 0.001 s | 0.10% short | 0.86 mm | 0.32 mm |
| Soft cube, accurate | 0.17% short (of Coulomb's) | 0.94 mm | 0.31 mm |
| Cloth, stock, both steps | within 0.05% | none | none |
| Cloth, final and accurate | within 0.03% | 0.27 to 0.30 mm | 0.27 to 0.30 mm |

Every slide stopped within 1 in 100 of its distance. The rows of the play files at the stop and at the end show why
the soft cube's centre comes back. The tracked node is its rear bottom corner, which rests 0.31 mm into the floor's
contact. While the cube slows it pitches forward: at the stop that corner is 0.15 to 0.64 mm above the floor, where at rest it sits 0.31 mm into the contact,
and the centre is 0.42 to 0.73 mm ahead of it. After the stop the cube rocks back onto its base, and its centre
moves back by that lead. Under stock the base itself stays where it stopped (it moves back 9 to 21 micrometres).
Under the patches the base, like the cloth, comes back the stick distance, 0.3 mm. That is patch C's
[documented cost](../../../docs/patches.md#patch-c-anchored-coulomb-friction).

The pitch follows from the compliance of SuperDex's deformable contact (the body sinks 0.31 mm under its own weight).
The cube's own shape changes far less: about 35 micrometres at rest. The cube was not probed with other contact
settings.

## The tilted floor at 0.001 s (D6): ringing, not creep

Under the final configuration the soft cube on the tilt ends at the same place at both steps: its centre is 0.2
micrometres apart, its contact node 0.07 micrometres. At 0.001 s it is still swinging about that place: its tracked
node crosses its resting place at least nine times (the measure counts nine), about every 98 ms. A creep of 15 micrometres a second would have carried it
15 micrometres. Backward Euler damps that swing far less at 0.001 s than at 0.01 s. Under BDF2 (accurate) it swings
more, up to 303 micrometres a second in the last tenth, with its contact within the stick distance (150
micrometres).

## The point-cloud stop under BDF2 (dry run of the fifteenth registration)

`probe_28_cloud_bdf2_stop.txt`: on a throwaway cube on the held sheet under BDF2 at 1/16, at the shipped tolerances,
one step of 3,200 stopped, after two iterations. No step diverged.

## The accurate configuration's tolerances: BDF2 with patch G gains energy at the shipped tolerances

The fourteenth registration's accurate configuration ran BDF2 at 1/16 of the step at SuperDex's shipped tolerances
(1e-3 absolute, 1e-6 relative). Its rules held, but they were 2 s and 3 s plays. Over longer plays and finer steps
it gains energy:

| Arm released level, 20 s, BDF2 with patch G (`probe_30_long_pendulum.txt`) | 1/4 | 1/16 | 1/64 |
|---|---|---|---|
| Shipped tolerances: the last swing, of 10,000 | 10,009 | 10,038 | 10,589 |
| The final configuration's tolerances (1e-4, 1e-8) | 9,994 | 10,000 | 10,001 |
| 1e-6 and 1e-8 | 9,995 | 9,999 | 9,999 |

At the shipped tolerances the gain grows as the step shrinks, which is the opposite of convergence. At the final
configuration's tolerances every swing over the 20 s stays between 9,999 and 10,001 at 1/16 and 1/64. On the chain
over 2 s (`probe_29_bdf2_chain_tolerance.txt`), the shipped tolerances gain 0.17% at 1/16 and 0.58% at 1/64. The
final configuration's tolerances read -0.011% and +0.005%.

Both tolerances matter, the absolute one most at the finest steps. With the shipped absolute tolerance and a relative one of
1e-8 (`probe_32_shipped_absolute_tolerance.txt`) the arm still reads 10,038 and 10,110 at 1/16 and 1/64, against 10,038 and 10,589 at the shipped tolerances. Patch G's Newton matrix is
not exact, so a solve stopped by a fixed absolute tolerance leaves an error every step. At a finer step there are more
steps and a smaller motion each step, so the error weighs more. Backward Euler with patch G shows the same at 1/64,
hidden by its own damping: at the shipped tolerances the 28th swing reads 9,883 against 9,651 to 9,654 converged. The
final configuration plays backward Euler at the final configuration's tolerances, where it reads converged.

On contact (`probe_31_accurate_contact_tolerance.txt`) the final configuration's tolerances cost nothing on the
deformable bodies (one step of 1,600 stopped, on the soft cube at rest). On the point-cloud sheet many steps stop: 67
to 2,583 of a play. Every one stops on SuperDex's rule for an update too small to matter, none at the iteration limit
and none diverged. The friction, hold and slip readings are identical to the shipped tolerances' readings to the last
digit. On the sheet the solve cannot reach an absolute tolerance of 1e-4: its updates become too small to matter first. On `half_cheetah` and `ant` BDF2 at 1/16 at these
tolerances stopped no step of 345,600 ([run 030](../../run_030_design_probes/)'s `probe_23_benchmark.txt`).

## Files

| File | What |
|---|---|
| `probe_24_cantilever_cause.txt` | The cantilever: longer, stiffer along its length, another rod |
| `probe_25_cantilever_tolerances.txt` | The cantilever at four solver tolerances, three rods, 64 and 128 elements |
| `probe_26_soft_slide.txt` | The soft cube's slide with its stiffness, mesh and friction varied; the cloth |
| `probe_27_run032_deformables.txt` | Run 032's deformable plays: where each slide stopped, the rows at the stop and the end, the holds |
| `probe_28_cloud_bdf2_stop.txt` | The point-cloud hold under BDF2 at the shipped tolerances, from the solver's trace |
| `probe_29_bdf2_chain_tolerance.txt` | A swinging chain under BDF2 with and without patch G at five tolerances, 2 s and 20 s |
| `probe_30_long_pendulum.txt` | An arm swinging 20 s under BDF2 and backward Euler with patch G at three tolerances, four steps |
| `probe_31_accurate_contact_tolerance.txt` | The accurate configuration on the point cloud and the deformable bodies at two tolerances, with traces |
| `probe_32_shipped_absolute_tolerance.txt` | The shipped absolute tolerance with a tight relative one |
