# Run 012: design probes for the fifth registration (the patches)

Made on 14 October 2026 to design the fifth registration ([PREREGISTRATION_05.md](../../preregistrations/PREREGISTRATION_05.md)). These
are not registered data. The suite runs use the fourth registration's cube, which is not the fifth's. The benchmark
runs are twelve episodes a scene on throwaway actions (seeds 9112, 9113).

Four builds of the patch were made while probing. Build 1 edited the corrections into SuperDex's shipped contact
kernel. Build 2 only adds lines: the shipped kernel is untouched and the corrected kernel is a separate copy.
Build 3 corrected patch B. Build 4, the one the registration tests, makes patch B's derivative consistent.

| File | What it is |
|---|---|
| `build1.txt` | Build 1: the nine-test suite under every configuration, and the check that it reproduces registered benchmark streams with its switches off |
| `build2_suite.txt` | Build 2: the ten-test suite under every configuration |
| `build2_impact_and_after.txt` | Build 2: Coulomb's law over the impact alone, and over the impact and the 0.1 s after it |
| `build2_solver.txt` | Build 2: the solver's own status at the shipped step on `ant` and `half_cheetah`, under each correction and combination |
| `build2_benchmark_everything.txt` | Build 2: the benchmark time-step chain with everything and the implicit setting on |
| `build3_build4.txt` | Builds 3 and 4: the suite under the configurations that changed, and the recommended configuration on the benchmark |

## What the probes showed

**Build 1 was not identical to stock with its switches off.** All 39 suite files were byte-identical, and 9 of 10
benchmark streams were. The tenth, `ant` with contact smoothing 1.25 mm, differed in 3 of 21,600 readings by one
count. Stock played twice gives the registered stream both times, so the difference is the build. SuperDex is
compiled with `-ffp-contract=fast`, which lets the compiler fuse a multiply and an add into one operation wherever
it likes, so editing the kernel changes the rounding even where the logic is unchanged. Build 2 leaves the shipped
kernel's text alone for that reason.

**The shipped friction's shortfall at an impact is a one-step delay.** Friction impulse over normal impulse, per
10,000 (Coulomb's law: 4,000), from the coarsest step to the finest:

| | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| Shipped, over the impact alone | 2,203 | 2,336 | 2,224 | 3,032 | 3,164 | 3,372 | 3,598 |
| Shipped, over the impact and the 0.1 s after it | 3,821 | 3,906 | 3,987 | 4,000 | 4,000 | 4,000 | 4,000 |
| Contact damping 5, stock code, impact and 0.1 s after | 4,221 | 4,900 | 5,085 | 4,935 | 4,606 | 4,323 | 4,155 |
| Contact damping 5 with patch A, impact and 0.1 s after | 3,818 | 3,910 | 3,955 | 3,978 | 3,989 | 3,995 | 3,997 |

What the start-of-step normal force leaves out of one step arrives in the next. With contact damping on stock code,
friction over the same window is 3.9% to 27% more than Coulomb's law allows, because friction is built on the penalty
part of the normal force while the damping part lowers the real normal force as the body settles. Patch A removes
that.

**With contact damping on stock code the ground pulls.** The lowest ground force on the 2 kg cube was minus 12.9 N
and minus 0.49 N when lifted, and minus 335 N on a fast rebound. Patch B as first written stopped the pull only
with the implicit setting on (without it: minus 181 N). Build 3 bounds the damping by the penalty force of the step
being solved, and the ground no longer pulls (0 N in all three runs).

**Build 3 cost the solver on `ant`, and build 4 removed the cost.** With build 3 in the recommended configuration,
27 of 2,400 steps at the shipped step stopped without converging on `ant`, where stock leaves 21. At its bound the
damping part cancels the penalty force, so its derivative has to cancel the penalty's derivative as well. With that
in (build 4): `ant` leaves none unconverged at the shipped step and one at each finer step; `half_cheetah` leaves
none at any step and needs at most 10 solver iterations, where stock needs 178
([run 006](../run_006_design_probes/)'s `probe.txt`, `PLAY half_cheetah sref`); no step diverges; and both time-step
chains are in order in every part of the episode.

**The solver.** Steps that stopped without converging, and steps that diverged, of 2,400 at the shipped step:

| | ant | half_cheetah |
|---|---|---|
| Shipped | 21, none diverged | 0 |
| Implicit setting | 0 | 1 |
| Contact damping 5 | 1 | 0 |
| Damping with patches A and B | 0 | 0 |
| Damping with the implicit setting | 12, worst residual 3,160 | 0 |
| Damping, the implicit setting, patches A and B | 18, worst residual 5,810 | 3 |
| Patch C alone, 10 micrometres | 19 | 87, and 2.7 times the wall time |
| Patch C alone, 300 micrometres | 20 | 0 |
| Damping, A, B and C at 10, 30, 100, 300 micrometres and 1 mm | 0 at every distance | 63, 22, 1, 0, 0 |
| The same with the implicit setting | 2 to 8 stopped and 11 to 20 diverged, at every distance | 76, 26, 5, 0, 1 |

- A stick distance of 10 micrometres is too stiff for `half_cheetah` at a 10 ms step. 300 micrometres is not.
- SuperDex's own implicit setting stops the solver converging on `ant` as soon as there is contact damping, with no
  patch involved. With the patches on as well, the solve explodes. The recommendation leaves that setting out.

**The suite on the fourth registration's cube, build 2** (T01 to T10, 1 = passed):

| Configuration | Result | Passed |
|---|---|---|
| Stock | 1110001011 | 6 of 10 |
| Implicit setting | 1110101011 | 7 |
| Contact damping 5 | 1111001100 | 6 |
| Damping with patch A | 1111001101 | 7 |
| Patch C at 300 micrometres | 1110011011 | 7 |
| Damping with A, B and C | 1111011101 | 8 |
| The same with the implicit setting | 1111111111 | 10 |

The patched library with no switch set gave 39 of 39 suite files byte-identical to stock.
