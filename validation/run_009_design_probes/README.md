# Run 009: design probes for the fourth registration

Made on 13 October 2026 to design the fourth registration ([PREREGISTRATION_04.md](../../preregistrations/PREREGISTRATION_04.md)). These
are not registered data. The smallest-scene runs use a 1 kg cube of half-size 0.05 m dropped 0.05 m, which are not
the registered parameters. The benchmark runs are twelve episodes a scene on throwaway actions (seeds 9112, 9113).

## Files

| File | What it is |
|---|---|
| `contact.txt` | The smallest contact scene (`tools/sdx_contact.cpp`): one measured line a run, with the solver's own status |
| `benchmark.txt` | `half_cheetah` and `ant`: one `PLAY` line a source, then every comparison as the harness printed it. The `t` sources were played in [run 006](../run_006_design_probes/) and their `PLAY` lines are in its `probe.txt` |
| `benchmark_by_part.txt` | The same comparisons as a table by part of the episode |

In `benchmark.txt` and its table, `t` is the shipped contact, `d` is contact damping 5, `di` is contact damping 5
with the implicit normal force, `i` is the implicit normal force alone, and the number is the divisor of the step.

## The smallest contact scene

Steps are 10 ms, the benchmark scenes' shipped step, and seven halvings.

| Measured | Right answer | 10 ms | 5 | 2.5 | 1.25 | 0.625 | 0.3125 | 0.156 | 0.078 ms |
|---|---|---|---|---|---|---|---|---|---|
| Rebound of the drop, per 10,000 of the drop height, shipped | 10,000 | 0 | 19 | 301 | 1,163 | 2,840 | 5,004 | 6,947 | 8,295 |
| The same, SuperDex's third-order integrator | 10,000 | 2,771 | 6,474 | 6,791 | 8,803 | 9,761 | 9,965 | 9,995 | 9,999 |
| The same, second-order integrator (BDF2) | 10,000 | 5,247 | 3,876 | 5,736 | 7,675 | 9,219 | 9,839 | 9,975 | 9,996 |
| The same, contact damping 1 | (damped) | 0 | 0 | 146 | 557 | 1,224 | 1,938 | 2,497 | 2,854 |
| The same, contact damping 5 | (damped) | 0 | 0 | 0 | 30 | 83 | 129 | 162 | 182 |
| Friction impulse over normal impulse at an oblique impact, friction 0.5, per 10,000, shipped | 5,000 | 4,268 | 3,852 | 4,141 | 3,537 | 3,684 | 4,201 | 4,479 | 4,697 |
| The same with the implicit normal force | 5,000 | 5,000 | 5,000 | 4,999 | 5,000 | 5,000 | 4,999 | 5,000 | 5,000 |
| The same with explicit normals, without fading, with the C-infinity law, or with Armijo | 5,000 | 4,268 | 3,852 | 4,141 | 3,537 | 3,684 | 4,201 | 4,479 | 4,697 |

**Creep.** The cube at rest, friction 0.6, pushed with half of what friction can hold. Coulomb's law: it does not
move.

| Setting | Creep at 10 ms | Creep at 0.625 ms |
|---|---|---|
| Shipped (the C1 law predicts 2,929) | 2,927 um/s | 2,926 |
| C-infinity friction law (predicts 2,887) | 2,882 | 2,882 |
| Implicit normal force; explicit normals; no fading; Armijo | 2,927 | 2,926 |
| Falloff speed 0.001 (shipped 0.01) | 293 | 292 |
| Falloff speed 0.0001 | 29 | 29 |
| Viscous friction 100 | 1,416 | 1,417 |

**The refinement chain on the smallest scene.** The cube dropped with 2 m/s sideways, friction 0.5, played 1 s. Each
step against the next finer one, the summed difference of the cube's height in micrometres, from the coarsest gap
to the finest:

| Setting | 1 to 1/2 | 1/2 to 1/4 | 1/4 to 1/8 | 1/8 to 1/16 | 1/16 to 1/32 | 1/32 to 1/64 |
|---|---|---|---|---|---|---|
| Shipped | 12,123 | 11,119 | 33,086 | 118,777 | 337,273 | 701,133 |
| Implicit normal force | 12,123 | 11,118 | 33,088 | 118,780 | 337,274 | 701,139 |
| Friction off | 12,122 | 11,119 | 33,048 | 118,767 | 337,282 | 701,127 |
| Contact damping 5 | 11,504 | 6,510 | 4,084 | 2,646 | 1,984 | 1,398 |
| Contact damping 5, friction off | 11,503 | 6,509 | 4,083 | 2,646 | 1,987 | 1,345 |
| The cube never reaches the ground | 1,237,250 | 618,600 | 309,300 | 154,650 | 77,321 | 38,667 |

With the shipped contact the differences grow as the step shrinks, as they do on `half_cheetah`. Friction plays no
part in it. A contact loss puts them in order. With nothing to hit they halve, to within 1 part in 10,000.

**Exploratory, not registered.**

- With contact damping on, the friction impulse at impact is far short of Coulomb's law (1,900 to 4,200 per 10,000)
  and the implicit switch does not restore it. The friction force is the coefficient times the penalty part of the
  normal force, and the damping part is left out.
- The peak contact force of the same drop is 72 N at the shipped step and 790 N at the finest.
- Contact damping did not pull the cube toward the ground (at most 0.1 N, for 4 steps).
- The output of these last two checks was not kept, so their numbers are as noted at the time and cannot be checked
  from the record.

## The benchmark scenes

`half_cheetah` with the ground, readings 160 to 200 of the episode, from the coarsest gap to the finest:

| half_cheetah | 1 to 1/2 | 1/2 to 1/4 | 1/4 to 1/8 | 1/8 to 1/16 | 1/16 to 1/32 |
|---|---|---|---|---|---|
| Shipped | 18,501 | 10,344 | 8,074 | 10,541 | 24,486 |
| Contact damping 5 | 17,777 | 9,702 | 5,253 | 2,667 | 1,473 |
| Contact damping 5, implicit normal force | 16,106 | 9,276 | 4,431 | 2,219 | |
| Implicit normal force alone | 16,139 | 10,470 | 8,705 | 17,412 | |

With contact damping the chain falls in every part of the episode, each gap 0.42 to 0.73 of the one before. The
implicit normal force alone does not help.

`ant` with the ground, in the last part of the episode, loses its order at 1/32 as shipped (last three gaps 3,379;
8,775; 22,368, the shipped chain of [run 006](../run_006_design_probes/)) and keeps it with contact damping (4,385;
3,811; 3,043). Its steps that stop without converging fall from 21 (run 006's `t1`, in its `probe.txt`) to 1 (`d1`
here) at the shipped step.
