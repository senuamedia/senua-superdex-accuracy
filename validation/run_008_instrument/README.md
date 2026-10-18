# Run 008: stage 2 of the third registration, the instrument beside plain subtraction

Run once on 13 October 2026 for [PREREGISTRATION_03.md](../../preregistrations/PREREGISTRATION_03.md), on the 84 streams of
[run 007](../run_007_counts/). `reading.txt` is the output as produced: ten lists (one list of one scene each), then
the pooled verdict.

## Result: the registered claim does not hold in full. Five rules of six held.

| Rule | Decided in | Result |
|---|---|---|
| **I0** calibration | here | **Held.** 12,228 of 894,348 windows flagged on noise alone, 1.37% (limit 2 in 100) |
| **I1** the instrument orders as arithmetic does | here | **Held.** 30 of 30 cells |
| **R1** the rig repeats | run 007 | **Held.** 6 of 6 pairs byte-identical |
| **N1** the scenes do not amplify a tiny change | run 007 | **Held.** No reading changes, on any scene |
| **E1** `half_cheetah` with the ground is out of order | run 007 | **Held.** 3 folds of 3 |
| **R2** in order with nothing touching the agent | run 007 | **Fired on `cart_pole`** (2 folds of 3). `half_cheetah` and `ant` without the ground: 3 of 3 each |

## What it settles, and what it does not

**The instrument does not own any order failure.** In every one of the 30 cells the instrument's order is the order
plain subtraction gives: in 17 cells both are in order, in 13 both are out of order, in none do they differ. Its
sizes are the plain sizes, a little lower where its gate leaves windows out.

| Cell (fold 0) | The instrument's sizes | Plain subtraction |
|---|---|---|
| `half_cheetah` time step, with the ground | 4,141,157; 3,198,598; 4,675,196; 8,011,549; 9,909,207; 9,997,846 | 4,144,564; 3,200,618; 4,688,047; 8,051,707; 9,965,728; 10,027,632 |
| `half_cheetah` time step, no ground | 2,680,474; 1,470,160; 776,709; 356,286 | 2,706,016; 1,500,647; 804,733; 411,653 |
| `half_cheetah` contact smoothing | 757,144; 570,909; 340,477; 214,122; 251,786 | 886,501; 617,348; 393,759; 263,567; 314,568 |
| `ant` contact smoothing | 4,295,854; 392,324; 203,026; 375,760; 99,713 | 4,556,465; 520,932; 261,202; 443,497; 165,720 |

**On `half_cheetah`, with the ground and without it.** The rig repeats exactly. A change of one part in a
hundred billion to the input changes nothing. Without the ground the time-step chain is in order in every fold,
each gap a little over half the one before. With the ground it is out of order in every fold, and out to 1/64 of
the shipped step its gaps do not fall back (in fold 1 the last gap is 2% smaller than the one before, in folds 0
and 2 larger). The registration attributes the failure to ground contact only if every rule holds, and R2 fired,
so that conclusion did not fire.

**`cart_pole` fired R2, the rig's stepping, and that is recorded as a failure of the claim as registered.** By the
registration, a fired R2 leaves the rig's stepping, or the engine's dynamics without contact, as an owner. In one fold,
the gap between the 10 ms and 5 ms steps is larger than the gap between 20 ms and 10 ms. The cause is visible in
run 007: in two or three of 108 episodes the pole, which ends every episode resting on one of its joint limits,
ends on the opposite limit at the coarsest steps. The four finer steps agree with one another and halve. The
registration named this risk before the run. It means the claim "with nothing touching the agent the chain is in
order" is not true of `cart_pole` at its two coarsest steps, and the registered verdict is a fail.

**What it does not settle.** With R2 fired, it does not clear the rig's stepping, and it does not place
`half_cheetah`'s failure in ground contact as the registration's conclusion would have. It does not say what in
SuperDex's contact does it, or whether that is by design. That is the next registration.

## This run's solver ladder

`ant`'s solver ladder is in order in all three folds on these commands (the second registration had one fold out of
order, in both the instrument and the subtraction).
