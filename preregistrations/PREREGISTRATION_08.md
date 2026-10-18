# Eighth pre-registration: joint limits

Registered 14 October 2026, after design probes on another arm and throwaway commands
([validation/run_018_design_probes](../validation/run_018_design_probes/)). Registered before any run of this
registration existed.

## The question

A joint's end stop can push a link back into range. It cannot hold a link that is leaving. The probes found that a
damped joint limit of stock SuperDex does hold it: the limit's force is stiffness times depth plus damping times
the rate of change of depth, with no lower bound, so it pulls while the joint comes back into range. Above critical
damping the joint never bounces off its limit; it is held there and creeps out. Meta's three benchmark scenes ship
damped limits.

This registration tests that on a new arm, tests a correction, and measures what the correction does to the
benchmark scenes.

## The right answers

- An arm resting on a limit of stiffness k under a torque sits where the limit's spring balances the torque.
- A spring and damper that can only push releases an arm when its force reaches zero. The speed at that moment
  follows from the arm's inertia, the stiffness and the damping, and is computed here by integrating that law at a
  step of 0.1 microseconds.
- An arm resting on its limit and then driven away from it by more than the load that held it there accelerates at
  least as fast as it would with no limit.

## The correction

`patches/senua_joint_limit.patch` (92 added lines, none removed), off unless `SUPERDEX_LIMIT_UNILATERAL` is set: the
force along a range constraint is the shipped one, never below zero. It is the derivative of an energy.

## The scene, registered parameters

`tools/sdx_joint.cpp`, the sixth registration's arm (2 kg, 0.4 m from the joint, inertia 0.3221333 kg m2; no limit
run was ever played on it). Lower limit at -0.3 rad, limit stiffness 2,000.

| Test | What is played | The right answer | It passes when |
|---|---|---|---|
| LT1 rest | Gravity; released level, it falls onto the limit (damping 150) and rests, 3 s; steps 1, 1/16 | -303,741 micro-radians | Depth past the limit within 1 part in 100 of 3,741 |
| LT2 release | No gravity; released at rest 0.03 rad inside the limit, 0.5 s; damping 20 and 150; steps 1, 1/16, 1/64 | It leaves at 1,434,131 micro-radians a second (damping 20) and 369,401 (damping 150) | At 1/64 of the step the speed at leaving is within 2 parts in 100; at steps 1 and 1/16 it has left by the end (more than 1,000 micro-radians past the limit, at a tenth of the answer's speed or more) |
| LT3 lift | Gravity; it rests on the limit (damping 150), then a torque of 15.68 N m, twice gravity's, lifts it from 1.5 s; steps 1, 1/16 | With no limit it would turn 127,259 micro-radians in the first 0.1 s | 0.1 s after the lift starts its angle is -189,208 micro-radians or more (nine tenths of that turn) |

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **H0** safe when off | With the patched library and no switch: the 10 limit runs and the sixth registration's 30 runs are byte-identical to stock, and so are the 38 registered benchmark streams |
| **H1** the limit at rest | LT1 passes for stock and with the correction, at both steps |
| **H2** stock's damped limit holds back a joint that is leaving it | Stock fails LT2 at both dampings and fails LT3 at both steps |
| **H3** the correction | With it LT2 passes at both dampings and LT3 at both steps, and no solver step of its runs stops without converging or diverges |
| **H4** nothing changes where there is no limit | The sixth registration's 30 runs with the switch on are byte-identical to stock |
| **H5** the benchmark's solver | With the switch on and nothing else changed, at the shipped step on the registered commands (the fifth registration's for `half_cheetah` and `ant`, the third's for `cart_pole`): no step diverges and no more stop without converging than stock's count plus 1 in 1,000 (stock: 2, 206 and 0 of 21,600) |

## A decision fixed in advance

Whether the correction joins the recommended configuration is decided by one measurement: `half_cheetah` and `ant`
on the fifth registration's commands at steps 1 to 1/16, under the recommended configuration corrected with the
switch added. It joins if both time-step chains are in order in 3 folds of 3 and no step diverges. Otherwise it is
recorded as correct and optional, with what it costs. The probes say `ant` may not stay in order (2 of 3 on other
commands).

Reported, not deciding: every measured line; the largest fall of speed inside the limit; how far each scene's
stream moves when the switch is set.

## Known risks, stated before the run

- LT2's answer at 1/64 of the step carries the integrator's own error; the probes were 0.4% and 0.65% short.
- At the shipped step the release takes less than two steps; the coarse-step pass line only asks that the arm has
  left.
- H5 leaves 21 steps of 21,600; the probes had 24 against 21 of 2,400 for `ant`.

## As registered

Patches `patches/senua_contact.patch` sha256 5cf3c66296270d0c... and `patches/senua_joint_limit.patch`
80f4c8c28ffacf51...; the library built from both c37eee7140cce9da...; stock 5a213c925bc86b61.... Measuring in the
Simplex repository: `sx_contact.sx` 44cf1def6e7d2cbf..., `sx_limit_run.sh` c4ed3c11f4c16202.... Plays: `tools/limit_all.sh`,
`tools/plays/play_08.sh`.
