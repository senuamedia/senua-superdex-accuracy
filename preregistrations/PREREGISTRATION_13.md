# Thirteenth pre-registration: the complete patch list, end to end

Registered 14 October 2026, after design probes on throwaway cubes, bodies and commands
([run 023](../validation/run_023_design_probes/), [run 024](../validation/run_024_design_probes/)). Registered before
any run of this registration existed.

## The question

The patches were each validated in their own study. This one asks whether they hold together, and takes them to
the three areas no study had tested: SuperDex's point-cloud contact, its deformable bodies, and a gripper holding an
object. Every play is made under the final configuration, with stock beside it wherever a rule compares with stock.

## The final configuration

Patches A to E with contact damping 5 and a friction falloff of 0.03 m/s (the recommended configuration as it
stood after the ninth registration), with patch F if the eleventh registration's decision takes it, and patch G with
SuperDex's Newton-Euler inertia if the twelfth registration's decision takes them. Library build 12, the same build
as the tenth to twelfth registrations, so safety when off is the one check those registrations share
([run 025](../validation/run_025_identity/)).

## The right answers, and where they come from

- The earlier registrations' own tests and right answers: the contact suites (the fourth, fifth and seventh), the
  arm on one joint (the sixth), the joint limits (the eighth), the rotations (the ninth).
- **Point-cloud contact**, through a held cloth sheet as the floor (`tools/sdx_contact.cpp`, `floor=cloud`): the
  floor carries the weight, never pulls, and Coulomb's law sets friction over an impact, in a slide, on a hold and
  in a slip, as on the plane.
- **Deformable bodies** (`tools/sdx_deform.cpp`): a free fall is backward Euler's own drop; a hanging rod, strip and
  bar stretch by the weight they carry over their stiffness (Timoshenko and Gere), to the material law's own
  finite-strain value; a cantilever sags w L^4 / (8 EI) in the limit of a fine mesh; a slide stops at Coulomb's
  distance at backward Euler's step, v0^2 / (2 mu g) - v0 dt / 2; on a floor tilted below the friction angle a body
  does not move, and SuperDex's regularised friction is known to let it creep at falloff x (1 - sqrt(1 - tan(tilt) /
  mu)).
- **A gripper** (`tools/sdx_grip.cpp`, hand-built and the Franka FR3 hand shipped with SuperDex): each finger
  presses with the commanded force and carries half the weight, and with friction able to carry it the cube must not
  slip.

## The scenes, registered parameters

None of these numbers was used in the probes, except the earlier registrations' own tests, which are their
registered parameters, and the deformable floor bodies, which are the rig's own defaults as probed.

- **The contact suites** on the seventh registration's cubes; **the arm** of the sixth and **the limit runs** of
  the eighth; **the rotations** of the ninth.
- **Point-cloud contact**: a cube of 1.6 kg and half-size 0.035 m on a sheet with a node every 10 mm and the shipped
  range of 10 mm. An oblique landing at 3.5 m/s with friction 0.35 (shipped step and 1/4), a slide at 4 m/s with
  friction 0.35, a rest, a hold and a slip with friction 0.45 and pushes of 4.2336 N and 8.4672 N (0.6 and 1.2 of
  what friction can hold), and a lift of 47.04 N (three times the weight); stock and final configuration.
- **Deformable bodies**, at 0.01 s and 0.001 s, on stock: a rod of 0.12 kg/m and stretching stiffness 150 N, 0.6 m
  long, falling and hanging (stretch with the finite-strain term 1.404624 mm); a strip of 1.2 kg/m2 with membrane
  constants 500 and 0 N/m, 0.4 m long (0.936416 mm); a bar of 1,100 kg/m3 and Young's modulus 2 MPa, 0.4 m long
  (0.431200 mm); the rod as a cantilever with bending stiffness 3 N m2 at 32, 64 and 128 elements (textbook
  6.3504 mm). On the floor, stock and final configuration: the rig's cloth patch and soft cube with friction 0.4,
  sliding at 0.8 m/s (backward Euler's distance 77.6327 mm at 0.01 s and 81.2327 mm at 0.001 s), and on a floor
  tilted by 0.25 rad (regularised creep 3,986 micrometres a second).
- **The gripper**: a cube of 0.15 kg and half-size 0.012 m, friction 0.45, a grip of 8 N on each finger (and 0.9 N,
  reported), the hand-built gripper and the FR3 hand; stock and final configuration.
- **The benchmark**: fresh commands for all three scenes ([`actions/13/`](../actions/13/), seeds 13101 to 13103), at the
  shipped step, stock and final configuration.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **C0** | The final configuration was played as the eleventh and twelfth registrations decided |
| **E0** safe when off | Every file of all nine parts of `tools/play_identity.sh` is byte-identical ([run 025](../validation/run_025_identity/)) |
| **K1** | The first contact suite passes all ten tests if patch F is in, and all but T05 if it is not |
| **K2** | The second contact suite passes all seven |
| **K3** | No step of either suite stops or diverges |
| **J1, J2** | If patch G is in: a free arm keeps at least 9,900 per 10,000 of its speed after 1 s at the shipped step, and a driven arm is within 1 part in 100 of its right answer there |
| **J3, J4** | Joint friction holds and slips as on stock (the creep within 10 micro-radians a second, the slip speeds within 1 part in 100) |
| **J5** | No step of the arm's runs stops or diverges |
| **L1 to L4** | The eighth registration's three limit tests pass (rest within 1 in 100 of the spring's depth; release at the energy's speed within 2 in 100 and free of the limit at the coarser steps; lifted off), and no step stops or diverges |
| **R1** | All 40 rotation vectors are right |
| **P1** | Stock, on the point-cloud floor: friction over the impact at the shipped step is more than 1.2 times the law, and a slip reaches less than 8 tenths of its speed |
| **P2** | Final configuration, on the point-cloud floor: the floor carries the weight within 1 in 100 and never pulls; a hold does not creep; sliding friction is within 1 in 10 of the law; a slip reaches at least 8 tenths of its speed; with patch F in, friction over the impact is within 1 in 10 of the law at both steps; no step stops or diverges |
| **D1** | Stock falls are backward Euler's own: within 1 micrometre for the rod and the strip, 50 micrometres for the soft body |
| **D2** | Stock hanging rod, strip and bar stretch within 1 in 200 of their right answers, at both steps |
| **D3** | The cantilever's sag rises with the element count, stays below the textbook value, and is within 3 in 100 of it at 128 elements |
| **D4** | Slides stop within 1 in 100 of backward Euler's distance, stock and final configuration, at both steps |
| **D5** | Stock on the tilted floor creeps at its regularised law's speed, within 1 in 10 |
| **D6** | Final configuration on the tilted floor: no speed above 10 micrometres a second at the end, and moved no more than the stick distance (0.3 mm) |
| **D7** | Bodies set on the floor come to rest (no speed above 10 micrometres a second over the last tenth), stock and final configuration |
| **D8** | No step of any deformable play stops or diverges |
| **G1, G2** | Each finger presses with the commanded force and carries half the weight, within 1 in 100, both grippers, stock and final configuration |
| **G3** | Stock lets the cube creep out of the grip (faster than 10 micrometres a second), both grippers |
| **G4** | Final configuration: the cube does not creep (under 1 micrometre a second) and slips less than 0.1 mm, both grippers |
| **G5** | No step of the final configuration's grip plays stops or diverges |
| **B1, B2** | On the fresh commands under the final configuration: no step diverges, and no more than 1 in 1,000 stop, on each of the three scenes |

Reported, not deciding: every measured line; stock's counts on the fresh commands; the pendulum; the weak grip;
the cloud floor's settle after the impact; iterations.

## Known risks, stated before the run

- **P1** rests on one probe cube, where stock's friction was 3.4 times the law; on the registered cube it may be
  less.
- **P2** asks for 8 tenths of a slip's speed on a floor whose ripple took 15% in the probe.
- **D2** and **D5** use the material and friction laws' own values; **D3** has not been probed at 32 or 128
  elements.
- **G4**: the probe held within 21 micrometres on another cube and grip.
- **B2** on fresh commands: the probes found no stopped step with every correction on one set of `ant` commands.
- **K1, J and L** combine corrections that were validated one at a time.

## What this does and does not say

If the rules hold, the patch list is recorded as validated end to end, and the three areas are recorded as tested:
what SuperDex gets right there as shipped, where it departs, and that the corrections carry over. It says nothing
about anything against a real robot, which no software test can stand in for.

If a rule fails, it is recorded as measured.

## As registered

The patch files and library build 12 (ccb1aefeb3fc91f1...) as registered with the tenth to twelfth registrations (in the one commit that registered all three). Measuring program: `measure/sx_contact.sx` d18cbf6fc9dfd08e..., unchanged since. Runner: `measure/runners/sx_study13_run.sh` fe8d8e27ace03b22.... Plays: `tools/plays/play_13.sh` c83673f3467a5468.... Commands: ant.txt 7236742f9c1d6036... cart_pole.txt b560ee5f87d746f6... half_cheetah.txt 9fb4286f3b8326da... 
