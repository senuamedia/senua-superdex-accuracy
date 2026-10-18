# Run 022: design probes for the studies after the ninth

14 October 2026. Throwaway cubes and throwaway commands. Nothing here decides anything, and nothing here is
registered.

Throwaway inputs: the suites' default cubes; a one-joint arm of 1.5 kg and half-size 0.06 m; for `ant`, 12 episodes
from run 009's probe commands (not kept) and one set of 108 episodes drawn from seed 9100, which is not a registered
seed.

Library: build 10 (sha256 7b915d53ba70df9f...), which is build 9 plus the changes in
[`../../patches/in_design/`](../../patches/in_design/). With no switch set it reproduces 14 registered files byte
for byte, and with the new switch off it reproduces build 9's 67 suite files under the recommended configuration.
The output of these two checks was not kept, so they are as noted at the time and cannot be checked from the
record.

## 1. Friction one step late at an impact: a correction that moves friction alone

Read from SuperDex's source: its own switch `implicitNormalForceForDissipation` gives one normal force to friction
and to contact damping. With it on, the damping term's derivative is incomplete, which is why `ant` did not
converge with that switch and contact damping together.

The candidate correction (`SUPERDEX_FRICTION_STEP_NORMAL`) gives Coulomb friction alone the normal force of the
step being solved, and leaves contact damping on the start-of-step force.

| First contact suite, throwaway cube | Code, T01 to T10 | T05: friction impulse per 10,000 of the normal impulse at the seven steps (the law: 4,000) |
|---|---|---|
| Recommended configuration | 1111011111 | 2113 2064 2332 3130 3439 3729 3858 |
| Recommended with the candidate | 1111111111 | 4000 4000 3999 3999 3999 3999 3999 |
| The candidate alone, stock contact | 1110101011 | 4000 3999 4000 3999 3999 4000 4000 |

With the candidate added, the recommended configuration passes all ten tests, and no solver step stops in either
suite (`probe_11a_suites.txt`).

**It is not safe yet.** On `ant` at the shipped step, the candidate together with anchored friction (patch C) makes
solver steps diverge: 1 of 2,400 on the 12 episodes, and 3 to 6 of 21,600 on the 108 (`probe_11a_bench.txt`,
`probe_11c.txt`, `probe_11e.txt`). Without patch C none diverge. So the candidate as it stands cannot join the
recommended configuration, and the next step is the anchored friction's own derivative when its normal force moves
within a step.

## 2. Why `ant`'s solver stops on stock contact

`ant`, 108 throwaway episodes, shipped step, 21,600 solver steps (`probe_11c.txt`, `probe_11d.txt`, `probe_11e.txt`):

| Configuration | Stopped | Diverged | Iterations in all |
|---|---|---|---|
| Stock | 223 | 0 | 181,733 |
| Stock with SuperDex's `explicitNormals` | 12 | 0 | 140,676 |
| Stock with SuperDex's `explicitNormals` and Armijo line search | 12 | 0 | 148,845 |
| Stock with SuperDex's Armijo line search alone | 216 | 0 | 193,474 |
| Stock with SuperDex's `implicitNormalForceForDissipation` | 1 | 0 | 160,075 |
| Stock with the candidate alone | 1 | 0 | 160,075 |
| Contact damping 5 with patches A, B and the candidate | 0 | 0 | 162,020 |
| The same with patches D and E | 0 | 0 | 155,137 |
| Patch C alone | 196 | 0 | 147,186 |
| Recommended configuration (A to E) | 5 | 0 | 125,765 |
| Recommended with SuperDex's `explicitNormals` | 3 | 0 | 125,290 |
| Recommended with the candidate | 2 | 4 | 136,529 |
| Patch C with the candidate, no damping | 0 | 3 | 136,854 |

Stock's 223 stopped steps are nearly all gone as soon as friction's normal force is no longer the estimated
start-of-step one: 12 are left with SuperDex's own exact start-of-step distance, and 1 with the force of the step
being solved. So `ant`'s stopped steps on stock contact look like a consequence of how friction's normal force is
estimated, and two of SuperDex's own switches remove them. This is a probe on one set of commands, to be
registered on fresh ones.

## 3. The integrator's loss on joint motion: the law

Read from SuperDex's source: the inertial target of every link is a straight line for each of its points, and it
is projected onto the joints at the current position. For an arm turning about a joint that loses the square of
the angle turned in a step, whatever the arm's length or mass.

Spin left after 1 s at the 10 ms step, per 10,000 of the release speed (`probe_12a.txt`):

| | Predicted by that law | Stock, arm 0.3 m | Stock, mass on the axis | SuperDex's Newton-Euler inertia, arm 0.3 m | Newton-Euler inertia, mass on the axis |
|---|---|---|---|---|---|
| Released at 2 rad/s | 9,622 | 9,624 | 9,626 | 9,633 | 9,933 |
| Released at 5 rad/s | 8,164 | 8,169 | 8,177 | 8,204 | 9,999 |

The law holds to three figures (the stock readings are 2 to 13 parts in 10,000 above it). SuperDex's own experimental
Newton-Euler inertia removes the loss only for mass that turns about its own centre: it corrects the rotation of each
link, and the straight-line target of each link's centre is still there.

## Files

| | |
|---|---|
| `probe_11a_suites.txt`, `probe_11a_bench.txt` | Both contact suites and the benchmark with the candidate |
| `probe_11c.txt`, `probe_11d.txt`, `probe_11e.txt` | `ant` on 108 throwaway episodes under the combinations above |
| `probe_12a.txt` | The one-joint arm under the law |
| `../../patches/in_design/` | The source changes these probes were run on, as a patch file |
