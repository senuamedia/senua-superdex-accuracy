# Run 013: the fifth registration's benchmark, on fresh commands

Recorded on 14 October 2026 for [PREREGISTRATION_05.md](../../preregistrations/PREREGISTRATION_05.md), rules B1 and B2. `half_cheetah` and
`ant` with the ground on fresh commands (`actions/05/`, seeds 4602 and 4603, 108 episodes): the shipped time-step
chain played with the stock library, and the same steps played with the recommended configuration of
[the patch ledger](../../patches/) (contact damping 5 with patches A, B and C). No instrument: plain subtraction of
the rig's encoder streams.

| File | What it is |
|---|---|
| `stats_<scene>.txt` | One line a source from the rig, with the solver's own status of every step |
| `counts.txt` | Every comparison as the harness printed it |
| `../../streams/05/` | The 22 streams (`SHA256SUMS` beside them) |

`sref t2 t4 t8 t16` are stock. `q1 q2 q4 q8 q16` are the recommended configuration at the same steps. `qi1` is the
recommended configuration with SuperDex's implicit normal force added, at the shipped step (reported).

The results, and the rest of the registration, are in [the patch ledger](../../patches/README.md).
