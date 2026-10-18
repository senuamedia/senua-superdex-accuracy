# Study 5: one setting and three contact patches

| | |
|---|---|
| Registration | Fifth: [PREREGISTRATION_05.md](../../preregistrations/PREREGISTRATION_05.md) |
| Question | For each correction we propose: is it required, is it correct, does it leave everything else alone, is SuperDex untouched when it is off, and does the solver keep converging? |
| Outcome | Every rule held: all six |
| Registered | 14 October 2026, before any run of this registration existed |
| Result | [Run 013](../../validation/run_013_counts/README.md) and [the patch ledger](../../patches/README.md), 14 October 2026 |
| Runs | [012, design probes with four builds](../../validation/run_012_design_probes/), [013, the benchmark on fresh commands](../../validation/run_013_counts/), [the patch ledger](../../patches/README.md) |
| Data | [`patches/validation/runs/`](../../patches/validation/runs/) (39 suite runs under each of nine configurations), [`streams/05/`](../../streams/05/) (22 encoder streams), [`actions/05/`](../../actions/05/) |
| Played by | [`tools/sdx_contact.cpp`](../../tools/sdx_contact.cpp), [`tools/contact_suite.sh`](../../tools/contact_suite.sh), [`tools/sdx_player.cpp`](../../tools/sdx_player.cpp) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx), `sx_contact_suite.sh`, `sx_patch_run.sh` |

Previous: [Study 4](04-one-cube-and-the-ground.md). Next: [Study 6](06-joints.md). All studies: [index](README.md).

**Read this with [Study 7](07-slide-and-two-bodies.md).** Study 7 found a fault in patch C as recorded here and
corrected it. The numbers on this page are the fifth registration as it was recorded.

## Why it was asked

Study 4 showed what in SuperDex's shipped contact is wrong against a known right answer. A finding is not yet a
patch. This study asks five things of each correction, and a patch that does not meet all of them is not proposed.

1. **Required.** Stock SuperDex fails a test whose right answer is known from physics.
2. **Correct.** With the correction on, that test passes.
3. **Nothing else gets worse.** No other test fails that passed before.
4. **Safe when off.** With the patch applied and no switch set, SuperDex's output is byte-identical to stock.
5. **The solver keeps converging.** On Meta's benchmark scenes, on fresh commands, no step diverges at any of the
   five steps, and at the shipped step no more stop than stock's count plus 1 in 1,000 of the steps (rule B2).

## What was proposed

| | What it does | Why | How it is switched on |
|---|---|---|---|
| Setting | Gives the contact a loss of its own: SuperDex's `normalViscousDampingCoefficient` at 5 (shipped: 0) | With no loss of its own, the contact's bounce is decided by the time step | The scene's contact parameters |
| Patch A | Friction on the full normal force | Coulomb's law is on the whole normal force. SuperDex computes friction from the penalty part alone, so once damping is on friction is wrong | `SUPERDEX_FRICTION_FULL_NORMAL=1` |
| Patch B | Contact damping that cannot pull | A contact pushes and never pulls. SuperDex's damping term multiplies the penalty force by one minus the coefficient times the leaving speed, and nothing stops that factor going below zero | `SUPERDEX_DAMPING_UNILATERAL=1` |
| Patch C | Anchored Coulomb friction: a contact holds at rest within a stick distance of 300 micrometres | A friction law that depends on slip speed alone is zero at rest, so it cannot hold a load | `SUPERDEX_STICK_DISTANCE=0.0003` |

The setting is SuperDex's own and needs no patch. The three patches are in one file against v1.0.0 that only adds
lines: the shipped contact kernel is left exactly as it is, the corrected kernel is a separate copy, and the library
calls the copy only when a switch is set.

SuperDex's own `implicitNormalForceForDissipation` was tested and reported beside the recommended configuration. It
was left out of the recommendation because of what the design probes showed about the solver.

## What the design probes showed

On Study 4's cube and on throwaway commands ([run 012](../../validation/run_012_design_probes/)).

- **The first build of the patch was not identical to stock with its switches off.** One benchmark stream of ten
  differed in 3 of 21,600 readings by one count. SuperDex is compiled with `-ffp-contract=fast`, so editing its
  kernel changes the rounding even where the logic is unchanged. The patch was restructured to add lines only.
- **With contact damping on stock code, the ground pulls.** A 2 kg cube was pulled with 12.9 N when lifted and
  335 N on a fast rebound.
- **The stick distance matters to the solver.** 10 micrometres leaves 87 of 2,400 steps unconverged on
  `half_cheetah` at the shipped step, and 300 micrometres leaves none.
- **SuperDex's implicit setting is not safe with damping.** It leaves 12 steps unconverged on `ant` as soon as
  there is contact damping, with no patch involved.

## The suite

One cube and the ground. The cube is 0.5 kg with half-size 0.03 m, and none of the registered numbers had been used
before. Steps are 10 ms divided by 1 to 64.

| Test | The right answer | It passes when |
|---|---|---|
| T01, never reaches the ground | Each halving of the step halves the gap | Every gap is 45% to 55% of the one before |
| T02, steady sliding | Friction is the coefficient times the normal force | Within 1%, at two steps |
| T03, at rest | The ground carries the weight | Mean force within 1%, at two steps |
| T04, the bounce | The same at every step | Rebounds at the seven steps are within 5 points of the drop height of each other |
| T05, Coulomb over the impact | Friction impulse is the coefficient times the normal impulse | Within 1% at all seven steps, and still sliding |
| T06, held below the friction limit | It does not move | Mean speed within 10 micrometres a second of zero, at two steps |
| T07, pushed above it | It accelerates at push minus friction, over mass | Mean speed within 3%, at two steps |
| T08, the refinement chain | The gaps fall at every step | They do |
| T09, the ground never pulls | The ground's force is never below zero | Lowest force at or above minus 1 mN, in two lifts and a fast rebound |
| T10, Coulomb over the impact and the 0.1 s after it | The same law, and never more | Never more than 1% above, and within 1% at the three finest steps |

T01, T02 and T03 are controls: they check that the scene and the rig are what they are taken to be.

## The rules fixed in advance

| Rule | It holds when |
|---|---|
| S0, safe when off | All 39 suite runs are byte-identical between the stock library and the patched library with no switch set, and each of 38 registered benchmark streams reproduces byte for byte. The list includes the stream the first build failed on |
| S1, required | Stock fails T04, T05, T06 and T08 on the new cube. With contact damping 5 on stock code, T09 and T10 fail |
| S2, correct | The implicit setting alone passes T05. Damping 5 alone passes T04 and T08. Damping with patch A passes T10. Damping with patches A and B passes T09 and T10. Patch C alone passes T06. The recommended configuration passes every test but T05 |
| S3, nothing else gets worse | Every configuration passes T01, T02, T03 (the controls) and T07. T09 passes wherever there is no damping or patch B is on. T10 passes wherever there is no damping or patch A is on |
| B1, the benchmark keeps its order | On fresh commands, `half_cheetah`'s shipped time-step chain is out of order in at least one fold, and with the recommended configuration it is in order in all three |
| B2, the solver keeps converging | With the recommended configuration on the fresh commands, no step diverges at any of the five steps on either scene. At the shipped step, on each scene, no more steps stop than stock's plus 1 in 1,000 of the steps |

Risks written down before the run: S0 could fail again, because the compiler is free to fuse differently even with
the shipped kernel's text untouched. The new cube is four times lighter, so damping 5 might not hold its bounce and
300 micrometres might be too soft.

## The result

| Rule | Result |
|---|---|
| S0, safe when off | Held. 39 of 39 suite runs and 38 of 38 registered benchmark streams byte-identical to stock |
| S1, required | Held. Stock fails four tests, and contact damping on stock code fails two more |
| S2, correct | Held. Each correction passes the test it is for, and the recommended configuration passes 9 of 10 |
| S3, nothing else gets worse | Held |
| B1, the benchmark keeps its order | Held. `half_cheetah`: stock in order in 0 folds of 3, recommended in 3 of 3 |
| B2, the solver keeps converging | Held. No step diverged. Steps stopped at the shipped step: `half_cheetah` 2 with stock and 0 recommended, `ant` 206 and 2 |

### The suite, configuration by configuration

T01 to T10, 1 means passed.

| Configuration | T01 to T10 | Passed |
|---|---|---|
| Stock | 1110001011 | 6 of 10 |
| Patched library, no switch set | 1110001011 | 6 of 10, and all 39 runs byte-identical to stock |
| Contact damping 5 | 1111001100 | 6 |
| Contact damping 5 with patch A | 1111001101 | 7 |
| Contact damping 5 with patches A and B | 1111001111 | 8 |
| Patch C alone | 1110011011 | 7 |
| Recommended: damping 5 with patches A, B and C | 1111011111 | 9 |

### The setting: a contact loss

| | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| T04 stock: rebound per 10,000 of the drop height | 0 | 22 | 237 | 921 | 2,370 | 4,455 | 6,502 |
| T04 with contact damping 5 | 0 | 0 | 0 | 7 | 29 | 48 | 61 |

Damping switched on with stock code breaks two other tests, which is why patches A and B are required with it.

### Patch A: friction on the full normal force

| T10: friction impulse per 10,000 of the normal impulse (the law: 3,000) | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 ms |
|---|---|---|---|---|---|---|---|
| Stock, no damping | 2,881 | 2,937 | 2,979 | 3,000 | 2,999 | 3,000 | 2,999 |
| Contact damping 5, stock code | 3,284 | 3,612 | 3,996 | 4,021 | 3,675 | 3,379 | 3,195 |
| Contact damping 5 with patch A | 2,880 | 2,940 | 2,970 | 2,986 | 2,993 | 2,997 | 2,998 |

With damping on stock code, friction is 6.5% to 34% more than the law allows. With patch A it is back to what stock
gives without damping.

### Patch B: contact damping that cannot pull

| T09: the lowest force of the ground on the 0.5 kg cube | Lifted, 10 ms | Lifted, 0.625 ms | Fast rebound |
|---|---|---|---|
| Stock, no damping | 0 | 0 | 0 |
| Contact damping 5, stock code | Minus 3.2 N | Minus 0.1 N | Minus 90 N |
| Contact damping 5 with patches A and B | 0 | 0 | 0 |

### Patch C: anchored Coulomb friction

A cube at rest, pushed with 0.6 of what friction can hold, creeps at 3.67 mm a second with stock (T06). With patch C
its mean speed is 0 and minus 2 micrometres a second at the two steps tested. Pushed above the friction limit it
slips, 1.1% and 2.4% faster than the right answer (T07, allowed 3%).

### The benchmark, on fresh commands

Plain subtraction over each fold's 36 test episodes, from the coarsest gap to the finest.

| `half_cheetah` | Fold 0 | Fold 1 | Fold 2 | In order |
|---|---|---|---|---|
| Stock | 4,100,695; 3,579,634; 4,509,987; 6,489,377 | 4,466,729; 3,585,208; 4,517,204; 6,247,164 | 3,797,639; 3,421,364; 4,617,447; 7,040,743 | 0 folds of 3 |
| Recommended | 3,662,040; 2,244,852; 1,315,956; 827,162 | 4,280,687; 2,432,003; 1,589,696; 1,092,304 | 3,409,236; 2,196,747; 1,485,127; 931,759 | 3 folds of 3 |

| At the shipped 10 ms step, of 21,600 steps | Stopped without converging | Diverged | Most iterations in one step |
|---|---|---|---|
| `half_cheetah`, stock | 2 | 0 | 200, the limit |
| `half_cheetah`, recommended | 0 | 0 | 59 |
| `ant`, stock | 206 | 0 | 200 |
| `ant`, recommended | 2 | 0 | 200 |

B2 rules stopped steps at the shipped step only, and there it held. Away from it the recommended configuration
stopped more often than stock in two places, as measured: at 1/16 of the step `ant` stopped 7 steps under it against
0 for stock ([run 013](../../validation/run_013_counts/), `stats_ant.txt`), and over the suite's 39 runs it stopped
819 steps of 48,090 against stock's 52 (`patches/validation/stats_recommended.txt` and `stats_stock.txt`). No step
diverged in either.

Reported, not deciding: the recommended configuration with SuperDex's implicit setting added left 35 steps
unconverged on `ant` and 121 diverged. It is not safe to add.

## What it did not fix

T05, Coulomb's law over the impact alone. SuperDex's friction uses the normal force of the start of the step, so
friction arrives one step late. Patch F gives friction the normal force of the step being solved
([Study 11](11-friction-at-impact.md)).

## What it led to

Two things. The same kind of test on joints, with stock SuperDex: [Study 6](06-joints.md). And two questions this
suite never asked, which turned out to matter: does a cube that slides to a stop stay stopped, and is contact right
between two bodies that both move? [Study 7](07-slide-and-two-bodies.md) asked them and found a fault in patch C.

Limits: one cube and one ground for the suite. Rigid contact only. Nothing here is against a real robot.
