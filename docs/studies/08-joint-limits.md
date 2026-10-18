# Study 8: joint limits

| | |
|---|---|
| Registration | Eighth: [PREREGISTRATION_08.md](../../preregistrations/PREREGISTRATION_08.md) |
| Question | Does a joint limit only push a joint back into range, or does it also hold back a joint that is leaving? |
| Outcome | Five rules of six held. Stock's damped limit holds a leaving joint back, and patch D corrects it. The rule that did not hold: with patch D alone, `ant`'s solver stops more often than the bound fixed in advance |
| Registered | 14 October 2026, before any run of this registration existed |
| Result | [Run 019](../../validation/run_019_limits/README.md), 14 October 2026 |
| Runs | [018, design probes](../../validation/run_018_design_probes/), [019, the registered runs](../../validation/run_019_limits/) |
| Data | [`limits/`](../../limits/) (the one-joint runs under stock, off and patched), [`streams/08/`](../../streams/08/) |
| Played by | [`tools/sdx_joint.cpp`](../../tools/sdx_joint.cpp), [`tools/limit_all.sh`](../../tools/limit_all.sh), [`tools/plays/play_08.sh`](../../tools/plays/play_08.sh) |
| Measured by | [`measure/sx_contact.sx`](../../measure/sx_contact.sx) (`final`, `leave`, `limits`), `sx_limit_run.sh` |

Previous: [Study 7](07-slide-and-two-bodies.md). Next: [Study 9](09-rotation-axis.md). All studies: [index](README.md).

## Why it was asked

A joint's end stop can push a link back into range. It cannot hold a link that is leaving. The design probes found
that a damped joint limit of stock SuperDex does hold it. The limit's force is stiffness times depth plus damping
times the rate of change of depth, with no lower bound, so it pulls while the joint comes back into range.

This matters to the benchmark. All three of Meta's scenes ship damped limits: `ant` with stiffness 1,000 and
damping 50, `cart_pole` with 1,000 and 2,500, and `half_cheetah` with damping 100.

## The right answers

- An arm resting on a limit of stiffness k under a torque sits where the limit's spring balances the torque.
- A spring and damper that can only push releases an arm when its force reaches zero. The speed at that moment
  follows from the arm's inertia, the stiffness and the damping. It is computed here by integrating that law at a
  step of 0.1 microseconds.
- An arm resting on its limit and then driven away by more than the load that held it there accelerates at least as
  fast as it would with no limit.

## The correction

[`patches/senua_joint_limit.patch`](../../patches/senua_joint_limit.patch) adds 92 lines and removes none. It is
off unless `SUPERDEX_LIMIT_UNILATERAL` is set. With it, the force along a range constraint is the shipped one, never
below zero. It is the derivative of an energy, so the solver still minimises one.

## What was played

Study 6's arm: 2 kg, 0.4 m from the joint. No limit run had ever been played on it. Lower limit at minus 0.3
radians, limit stiffness 2,000.

| Test | What is played | The right answer | It passes when |
|---|---|---|---|
| LT1, rest | Gravity. Released level, the arm falls onto the limit (damping 150) and rests | Minus 303,741 micro-radians | The depth past the limit is within 1% |
| LT2, release | No gravity. Released at rest 0.03 radians inside the limit, with damping 20 and with damping 150, at steps 1, 1/16 and 1/64 | It leaves at 1,434,131 micro-radians a second (damping 20) and 369,401 (damping 150) | At 1/64 of the step the leaving speed is within 2%. At steps 1 and 1/16 it has left by the end (more than 1,000 micro-radians past the limit, at a tenth of the answer's speed or more) |
| LT3, lift | Gravity. It rests on the limit, then a torque of twice gravity's lifts it | With no limit it would turn 127,259 micro-radians in the first 0.1 s | After 0.1 s it has turned at least nine tenths of that: to minus 189,208 micro-radians or more |

## The rules fixed in advance

| Rule | It holds when |
|---|---|
| H0, safe when off | With the patched library and no switch, the 10 limit runs and Study 6's 30 runs are byte-identical to stock, and so are the 38 registered benchmark streams |
| H1, the limit at rest | LT1 passes for stock and with the correction, at both steps |
| H2, stock holds back a leaving joint | Stock fails LT2 at both dampings and fails LT3 at both steps |
| H3, the correction | With it LT2 and LT3 pass, and no solver step of its runs stops or diverges |
| H4, nothing changes where there is no limit | Study 6's 30 runs with the switch on are byte-identical to stock |
| H5, the benchmark's solver | With the switch on and nothing else changed, at the shipped step on the registered commands (the fifth registration's for `half_cheetah` and `ant`, the third's for `cart_pole`): no step diverges and no more stop than stock's count plus 1 in 1,000 (stock: 2, 206 and 0 of 21,600) |

**A decision fixed in advance.** Whether the correction joins the recommended configuration was to be decided by
one measurement: `half_cheetah` and `ant` on the fifth registration's commands at steps 1 to 1/16, under the
recommended configuration corrected with the switch added. It joins if both time-step chains are in order in 3
folds of 3 and no step diverges. Otherwise it is recorded as correct and optional, with what it costs.

A risk written down before the run: H5 leaves a margin of 21 steps in 21,600, and the probes had seen `ant` stop on
24 steps against 21 of 2,400 on other commands.

## The result

| Rule | Result |
|---|---|
| H0, safe when off | Held. 40 of 40 joint files and 38 of 38 benchmark streams byte-identical to stock |
| H1, the limit at rest | Held. Minus 303,744 and minus 303,741 micro-radians, stock and corrected alike |
| H2, stock holds back a leaving joint | Held |
| H3, the correction | Held. No solver step stopped or diverged |
| H4, nothing changes where there is no limit | Held. 30 of 30 runs byte-identical with the switch on |
| H5, the benchmark's solver, the switch alone | **Did not hold.** `ant` stops on 245 steps against stock's 206, and the bound was 227 |

### A joint leaving its limit

| | The right answer | Stock | With patch D |
|---|---|---|---|
| LT2, leaving speed at damping 20, micro-radians a second | 1,434,131 | 1,004,593 | 1,423,016 |
| LT2, leaving speed at damping 150 | 369,401 | It has not left after 0.5 s | 367,995 |
| The most the arm slows while still inside the limit, damping 20 at 1/64 of the step | 0 | 418,427 | 4 |
| LT3, angle 0.1 s after the lift starts, micro-radians, at the two steps | Minus 189,208 or more | Minus 259,228 and minus 264,233 | Minus 165,016 and minus 175,432 |

With damping below critical, stock releases the arm 30% slower than a limit that can only push. With damping above
critical it never leaves: after half a second it is still inside the limit and creeping. Lifted off its limit by
twice the torque that held it there, it turns about a third of what it should in the first tenth of a second.

With patch D the leaving speeds are 0.8% and 0.4% under the right answers, which is the integrator's own error at
that step. Over every step and both dampings, the most the arm slows inside the limit with patch D is 72
micro-radians a second (damping 20, at the shipped step); stock's is 206,348 to 418,427.

### The benchmark

Steps that stopped without converging at the shipped step, of 21,600:

| | Stock | Patch D alone, on stock contact | Recommended configuration without D | Recommended configuration with D |
|---|---|---|---|---|
| `half_cheetah` | 2 | 2 | 7 | 6 |
| `ant` | 206 | 245 | 11 | 7 |
| `cart_pole` | 0 | 0 | Not played | Not played |

No step diverged in any of them. The two columns with patch D are this study's run 019. The stock column is the
count H5 quotes, from the same commands: [run 013](../../validation/run_013_counts/) for `half_cheetah` and `ant`,
[run 007](../../validation/run_007_counts/) for `cart_pole`. The column without D is Study 7's play of the
recommended configuration corrected, on the same commands ([run 017](../../validation/run_017_counts/),
`stats_half_cheetah.txt` and `stats_ant.txt`).

### The decision fixed in advance

With the switch added to the recommended configuration, `half_cheetah` and `ant` are both in order in 3 folds of 3
and no step diverged. By the rule fixed in advance, patch D joins the recommended configuration.

## What it shows, and what it does not

- It shows a defect in stock SuperDex: a damped joint limit pulls.
- It shows that the correction gives the right answer on one joint and changes nothing where there is no limit.
- It does **not** show that the correction is free on its own. On stock contact, `ant`'s solver, already the
  weakest of the three, stops on 39 more steps. The registered margin was 21. With the corrected contact
  configuration that cost is not there.

Why `ant`'s solver stops more often with patch D on stock contact is in [Study 10](10-ant-stops.md): its stops on
stock contact come from SuperDex's default estimate of friction's normal force, and patch D adds stops only of that
kind.

Limits: one joint, one arm for the known-answer tests. Nothing against a real robot.
