# The recommended configuration

The combination of SuperDex's own settings and our seven patches that this record recommends, the registered
decision behind each part, what it does on Meta's benchmark scenes, and what it costs. Contact damping and patches A,
B and C entered with the fifth registration, every rule of which held; patch C's corrected form and the friction
falloff by the seventh registration's decision; patches D to G and Newton-Euler inertia by decisions fixed in advance
([how it came to be](#how-it-came-to-be)); patch G is recorded as required, correct and safe under it by Study 21's
decision, replicated on library build 16 by Study 23's, and patch F by Study 23's. Three parts, the solver tolerances,
the grid cell and the smoothing, are recommended on their own rules: the decision that would have admitted them did not
fire. No registered decision records the whole combination as validated end to end: Study 13's did not fire (J4, D6
and G2 failed), nor Study 21's (F3 failed on the measuring program's reading of momentum between two cubes), nor
[Study 23](studies/23-recommended-configuration-again.md)'s, on fresh numbers and library build 16, where 117 rule
lines of 118 held and one line of P2 failed: on the point-cloud floor, friction over a one-step impact read 5.1% above
the law at step 1/4, where the bound is 4% ([the open list](open-items.md)).

Back to the [documentation index](README.md).

## What it is

| Part | Value | Shipped | What it is |
|---|---|---|---|
| Contact damping | `normalViscousDampingCoefficient` = 5 on every actor | 0 | SuperDex's own parameter. It gives the contact a loss of its own |
| Friction falloff speed | `frictionFalloffVel` = 0.03 | 0.01 | SuperDex's own parameter. With patch C it sets the damping of the stick |
| Solver tolerances | `absTol` 1e-4 and `relTol` 1e-8 | 1e-3 and 1e-6 | SuperDex's own parameters. Patch G needs them: at the shipped tolerances its error grows as the step shrinks ([probe 30](../validation/run_032_open_items/probes/)). Recommended on its own rules, which held: I2 in [Study 14](studies/14-open-items.md) (item 2) and V2 on fresh numbers in [Study 15](studies/15-replication.md). Study 14's decision that items 1 to 4 join did not fire (I4a, I4c, D4 and D6 failed), nor Study 15's that records every fix as replicated (V3 and V6 failed) |
| Grid distance field | Each mesh body's cell at 1/32 of its side (SuperDex's `GridSdfParams`: resolution mode `Explicit`, `resolutionDelta` the side over 32) | A quarter of the mean edge, at least 6 cells a side | SuperDex's own parameter. Its default rounds a box's edges within the last of 6 cells, which a light cube on a block can reach ([Study 14](studies/14-open-items.md), item 1). Recommended on its own rules, which held: I1 in Study 14 and V1 on fresh numbers in [Study 15](studies/15-replication.md). Study 14's decision that items 1 to 4 join did not fire (I4a, I4c, D4 and D6 failed), nor Study 15's that records every fix as replicated (V3 and V6 failed) |
| Contact smoothing | A half-distance of 1 mm on a mesh body that rests on a point cloud | 5 mm | SuperDex's own parameter. It takes contact damping off the points a cube's edges pass over (Study 14, item 3). Recommended on its own rules in Study 14, which held (P1, P2 and A4, 16 lines of 16); Study 14's decision that items 1 to 4 join did not fire (I4a, I4c, D4 and D6 failed). In Study 15 item 3's rule V3 failed on one stopped step of 840, so what it concerns stays open ([open list](open-items.md)) |
| Newton-Euler inertia | `EnableNewtonEulerInertia(actor, true)` on every articulated actor | Off | SuperDex's own experimental option. It corrects the rotation of each link about its own centre |
| Patch A | `SUPERDEX_FRICTION_FULL_NORMAL=1` | Off | Friction on the full normal force |
| Patch B | `SUPERDEX_DAMPING_UNILATERAL=1` | Off | Contact damping that cannot pull |
| Patch C | `SUPERDEX_STICK_DISTANCE=0.0003` and `SUPERDEX_STICK_DAMPING=1` | Off | Anchored Coulomb friction with a damped stick |
| Patch D | `SUPERDEX_LIMIT_UNILATERAL=1` | Off | A joint limit that cannot pull |
| Patch E | `SUPERDEX_ROTATION_AXIS_EXACT=1` | Off | The axis of a rotation smaller than 2e-9 rad |
| Patch F | `SUPERDEX_FRICTION_STEP_NORMAL=1` | Off | Friction on the normal force of the step being solved |
| Patch G | `SUPERDEX_INERTIA_TRANSPORT=1` | Off | A link's translational inertial force projected at the start of the step |

Left as shipped: the integrator (backward Euler) and the time step. For motion that must be right on fast swings and impacts alike, the accurate configuration below is the same with BDF2 at 1/16 of the step. No registered decision recommends it: Study 14's decision to recommend it did not fire (A5 failed), nor Study 15's to record it, at the final configuration's tolerances, as validated end to end (V8 failed, on a free chain's angular momentum). Its own rules held: I5 in Study 14, and V5 and V9 in Study 15. The chain's loss was patch G's earlier form under BDF2, the share of 1/3, whose cause is in how stock SuperDex starts a jointed body's BDF2 stage ([run 049](../validation/run_049_patch_g_review/README.md)). By [Study 22](studies/22-bdf2-chain.md)'s decision patch G under BDF2 takes its derived form (library build 16): on three fresh free chains under BDF2 at 1/16 of the step at these tolerances the angular momentum drifts 5 or 6 parts per million over 2 s, where the share's drifted 615 to 1,137, and the accurate configuration's own bounds on the chains, the free spin and the pendulum held at that step. Study 22 played the accurate configuration only as far as patch G acts, so no registered decision recommends it as a whole yet.

Every measurement of it was made with the solver's iteration limit at 200, in 64-bit arithmetic, and for its contact
corrections in 32-bit too ([Study 20](studies/20-thirty-two-bit.md): every test of what they do passes). SuperDex ships
32-bit arithmetic and a limit of 4, and at those settings its solver stops before converging on most steps of
`half_cheetah` and `ant` ([finding 9](findings.md)).

For a joint that has to hold a load by dry friction, one more of SuperDex's own settings: the joint's `falloffVel`
at 1e-6 (shipped: 0.001). It was validated on its own in [Study 6](studies/06-joints.md).

## How it was played

With the patched library, on the benchmark rig:

```
export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1
export SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1
export SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1
export SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1
tools/sdx_player64 ant <superdex assets> actions/14/ant.txt <out prefix> \
    integ=be maxiter=200 ndamp=5 falloff=0.03 newtoneuler=1 abstol=1e-4 reltol=1e-8
```

The exact lines, with the grid cell (`sdfdiv=32`) and the smoothing for the rigs that take them, are in [`tools/plays/play_14.sh`](../tools/plays/play_14.sh) and [`tools/plays/play_15.sh`](../tools/plays/play_15.sh). The accurate configuration adds `integ=bdf2` and 16 sub-steps a step (`sub=16`).

## What it does

### On Meta's benchmark scenes

At the shipped 10 ms step, over 108 seeded episodes a scene, on commands no earlier study used
([Study 14](studies/14-open-items.md)):

| | Stock | Recommended |
|---|---|---|
| `half_cheetah`: solver steps stopped without converging, of 21,600 | 3 | 9 |
| `ant`: solver steps stopped without converging, of 21,600 | 199 | 0 |
| `cart_pole`: solver steps stopped without converging, of 21,600 | 0 | 0 |
| Solver steps diverged | 0 | 0 |

`half_cheetah`'s 9 are steps on which the solve reaches the iteration limit at the configuration's tighter
tolerances; the registered bound, no more than 1 in 1,000, holds. Under the accurate configuration (BDF2 at 1/16 of
the step) no step of 345,600 stopped on any of the three scenes ([Studies 14 and 15](studies/15-replication.md)).

On [Study 21](studies/21-recommended-configuration.md)'s fresh commands, at the shipped step: `half_cheetah` stopped 5
steps of 21,600 (stock 0), `ant` 1 (stock 223), `cart_pole` 0 (stock 0), and none diverged.

With patches F and G added, `half_cheetah` and `ant` stay in order in 3 folds of 3 at steps 1 to 1/16
([Study 11](studies/11-friction-at-impact.md), [Study 12](studies/12-joint-motion.md), at SuperDex's shipped tolerances),
and so do they under this configuration at its own tighter tolerances, on fresh commands
([Study 21](studies/21-recommended-configuration.md), B3: the largest ratio of a gap to the gap before it 0.82 on
`half_cheetah` and 0.66 on `ant`); on stock `half_cheetah` is in order in 0 folds of 3. "In order" means that each halving of the time step changes the motion less than the one
before, which is what refining a time step is supposed to do.

### On the known-answer tests

From [Study 13](studies/13-end-to-end.md) on, every earlier test played under the configuration as it then stood, and from [Study 14](studies/14-open-items.md) under this one:

| Test | Stock | Recommended |
|---|---|---|
| The bounce is the same at every step (T04) | Fails: 0% of the drop height at 10 ms, 67% at 1/64 (on the seventh registration's cube) | Passes |
| Coulomb's law over the impact alone (T05) | Fails | Passes: within 1 in 1,000 at every step (3,499 or 3,500 per 10,000, against 3,500) |
| Coulomb's law over an impact and the 0.1 s after it (T10) | Passes | Passes |
| Held below the friction limit (T06) | Fails: creeps at 3.67 mm a second | Passes |
| The refinement chain falls at every step (T08) | Fails | Passes |
| The ground never pulls (T09) | Passes | Passes |
| A slide ends and stays ended (T11, T12) | Passes | Passes |
| A cube rides on a pushed cube (T14) | Fails: falls behind at 2.9 mm a second | Passes |
| A free arm keeps its speed (JT1) | Fails: 92% after 1 s | Passes: 99.999% |
| A driven arm gains torque over inertia (JT2) | Fails: 5% short | Passes |
| A joint leaves its limit as it should (LT2, LT3) | Fails: 30% slow, or never | Passes |
| First contact suite, T01 to T10 | 6 of 10 | 10 of 10 |
| Second contact suite, T11 to T17 | 6 of 7 | 7 of 7 |
| Solver steps stopped over both contact suites | 36 and 231 | 0 and 0 |

And where no study had looked before ([Study 13](studies/13-end-to-end.md)):

| | Stock | Recommended |
|---|---|---|
| Point-cloud floor: friction over an impact, per 10,000 of Coulomb's law | 37,786 | 10,463 in Study 13; 10,166 with the grid cell and smoothing of Study 14, and 9,990 to 10,098 on Study 15's fresh cube |
| Point-cloud floor: a cube pushed below the friction limit | creeps at 3.6 mm a second | holds |
| Cloth and a soft cube on a floor tilted below the friction angle | creep at 4.0 mm a second | stop; in Study 13 the soft cube's centre moved 0.37 mm, past the 0.3 mm stick distance (D6 failed); read by its drift, the hold does not creep ([Study 16](studies/16-second-review.md)) |
| A gripper holding a cube at 8 N a finger | the cube creeps out at 0.7 to 1.1 mm a second | holds |

## What it costs

Each of these is measured and stated in the record.

- **A slide that ends comes back about 0.3 mm, once.** Stock does not come back at all. It is the elastic part of
  any friction law that can hold a load.
- **A slide stops at backward Euler's own distance.** With friction acting in full from the first step, a slide at
  the shipped step stops about 3% short of the continuous answer; it converges to it as the step is refined.
- **Impacts are nearly dead.** Contact damping 5 takes the bounce out. A contact that should bounce needs SuperDex's
  own calibration of that coefficient, a higher-order integrator and a step near 0.1 ms, as SuperDex's own bounce
  test uses.
- **A swing a force drives is still damped** by backward Euler, less than before (38% of stock's loss at the
  shipped step on a two-link swing) and falling with the step. The accurate configuration keeps it: every swing of a 20 s pendulum within 9,999 to 10,001 per 10,000 at 1/16.
- **The tighter tolerances patch G needs.** 15% to 24% more solver iterations a step on `half_cheetah` and `ant`, 9 steps of
  21,600 that reach the iteration limit on `half_cheetah` (stock: 3), and, on a point-cloud sheet, steps that stop
  on SuperDex's rule for an update too small to matter; friction, hold and slip read as at the shipped tolerances, and the rest within 9 mN.
- **The accurate configuration** costs 16 times the steps: 2.9 to 3.6 times the final configuration's time on `half_cheetah` and `ant`, and 11 times on `cart_pole`, whose steps are cheap (runs 032 and 034). With patch G's
  earlier share a free chain lost angular momentum under it at first order: 0.15% over 2 s at 1/16 of the step
  (Study 15), because stock SuperDex starts a jointed body's BDF2 stage from the kinematics of the combined joint
  angles and the share of 1/3 cancels that for one joint only. Patch G's derived form, in library build 16, makes
  a chain second order ([Study 22](studies/22-bdf2-chain.md)), at a one-time loss of about (omega h)^2 of a single
  joint's speed at BDF2's start, small at 1/16 of the step: a free spin at 3.8 rad/s keeps 9,999.95 per 10,000 there,
  against 9,999.98 with the share, and 9,985.5 against 9,994.2 at the shipped step.
- **A soft body rocks back after a slide**, 0.3 to 0.9 mm (Studies 14 and 16), on SuperDex's compliant deformable contact, with or
  without the patches.
- **More solver iterations on `ant`** than patches A to E alone, at SuperDex's shipped tolerances ([run 023](../validation/run_023_design_probes/)'s `probe_13_ant_together.txt`): 21% more with patch F (7.06 a step), and 24% more with patches F and G and Newton-Euler inertia (7.24 a step), still fewer than stock's 8.41. At the configuration's tighter tolerances it has not been compared with stock on the same commands.

## How it came to be

| Study | The configuration | Why it changed |
|---|---|---|
| [4](studies/04-one-cube-and-the-ground.md) | Contact damping 5 alone | It puts `half_cheetah` in order, but with stock code it breaks friction and lets the ground pull |
| [5](studies/05-contact-patches.md) | Damping 5 with patches A, B and C | Each patch shown required, correct and safe |
| [7](studies/07-slide-and-two-bodies.md) | The same with a damped stick and `frictionFalloffVel` 0.03 | Patch C as first recorded did not stay stopped |
| [8](studies/08-joint-limits.md) | The same with patch D | Decided by a rule fixed in advance: both scenes in order in 3 folds of 3, no step diverged |
| [9](studies/09-rotation-axis.md) | The same with patch E | Decided the same way |
| [11](studies/11-friction-at-impact.md) | The same with patch F | Decided the same way |
| [12](studies/12-joint-motion.md) | The same with patch G and SuperDex's Newton-Euler inertia | Decided the same way |
| [13](studies/13-end-to-end.md) | Unchanged | Played end to end on every earlier test, on point clouds, deformable bodies, a gripper and fresh commands: 65 rule lines of 68 held. J4, D6 and G2 each failed on one line, so the decision to record the patch list as validated end to end did not fire |
| [14](studies/14-open-items.md) | The same with the solver's tolerances at 1e-4 and 1e-8, each mesh body's grid cell at 1/32 of its side and 1 mm smoothing on a point cloud; BDF2 at 1/16 as the accurate configuration | Fixes for the five open items, by SuperDex's own settings and patch G's share by integrator. Items 1, 2, 3 and 5 held every rule of their own; item 4 failed (I4a, I4c). Neither decision fired: items 1 to 4 do not join by this registration (I4a, I4c, D4 and D6 failed), and the accurate configuration is not recommended by it (A5 failed). The three settings are recommended on their own rules |
| [15](studies/15-replication.md) | Unchanged; the accurate configuration at the final configuration's tolerances | The fixes of items 1, 2, 4 and 5 held every rule line on fresh numbers (V1, V2, V4, V5); V3 and V6 failed, so the decision that records every fix as replicated did not fire. The amendment moved the accurate configuration to the final configuration's tolerances, because at the shipped tolerances BDF2 with patch G gains energy as the step shrinks; V9 held, but V8 failed on a chain's angular momentum, so it is not recorded as validated end to end |
| [21](studies/21-recommended-configuration.md) | Unchanged | Every rule of patches F and G and every backward-Euler end-to-end rule played again on fresh numbers: 117 rule lines of 118 held, the order test at the configuration's tolerances among them. Patch G recorded as required, correct and safe under it. F3 failed on the measuring program's reading of momentum between two cubes, so patch F's decision and the end-to-end decision did not fire |
| [22](studies/22-bdf2-chain.md) | Unchanged; under BDF2, patch G's derived form (library build 16) | Every rule held: with the derived form a chain is second order under BDF2, and nothing changes with the switch off or under backward Euler |

## What not to add

SuperDex's own `implicitNormalForceForDissipation` gives Coulomb's law over an impact on one cube, but it moves
contact damping to the step's normal force as well, and on `ant` at the shipped step, with contact damping, it left
35 steps unconverged and 121 diverged (on library build 15 the same play leaves 34 and 120, [Study 17](studies/17-whole-record.md)). Patch F
moves friction alone and keeps the solver converging.

SuperDex's own `explicitNormals` removes most of stock's stopped steps on `ant` ([Study 10](studies/10-ant-stops.md)).
With patch F in the configuration there are none left to remove, so it is not part of the recommendation.
