# Run 024: design probes for what had not been tested

14 October 2026. Throwaway cubes, bodies and commands. Nothing here decides anything, and nothing here is
registered. Library: build 11 (sha256 632c3c72b8874329...), the same source as [run 023](../run_023_design_probes/).

## 1. Point-cloud contact: one cube on a held cloth sheet

SuperDex's shells and rods are met by other bodies through a point-cloud collider. To put that contact path under
the same tests as the ground plane, the one-cube rig can now replace the plane with a level cloth sheet whose
every node is held (`floor=cloud`). Everything else about each play is the same, so the contact suite's own plays
and measures apply unchanged. The probe sheet has a node every 10 mm and the shipped collider range of 10 mm.

The cube is 2 kg with half-size 0.04 m. Shipped step unless a second number is given, which is at 1/4 of it
(`probe_14_point_cloud_floor.txt`):

| Test | Right answer | Stock, plane | Stock, cloud | Recommended, cloud | Recommended with the friction correction, cloud |
|---|---|---|---|---|---|
| At rest the floor carries the weight, mN | 19,600 | 19,593 | 19,581 | 19,604 | 19,604 |
| Lifted with three times its weight: steps the floor pulls | 0 | 0 | 0 | 0 | 0 |
| Friction impulse over an impact, per 10,000 of the normal impulse | 4,000 | 2,203 and 2,224 | 13,448 and 4,693 | 2,156 and 2,937 | 4,152 and 4,238 |
| The same over the impact and the 0.1 s after it | 4,000 | 3,820 and 3,987 | 13,818 and 5,458 | 3,878 and 4,018 | 4,164 and 4,251 |
| Sliding at 5 m/s: friction over normal force, per 10,000 | 4,000 | 4,000 | 2,220 | 3,918 | 4,144 |
| The same slide: mean speed over the measuring window, m/s | as the plane | 3.55 | 0.13 | 3.55 | 3.46 |
| Pushed with 0.6 of what friction can hold: creep, micrometres a second | 0 | 3,670 | 3,560 | 0 | 0 |
| Pushed with 1.2 of it: mean speed against the predicted 980,000 | 980,000 | 982,200 | 476,800 | 569,600 | 836,700 |
| Solver steps stopped, of 1,590 | 0 | 2 | 48 | 4 | 0 |
| Seconds to play all of the configuration's plays | | 3 | 278 | 55 | 48 |

What the probe shows:

- **At rest and when lifted the point-cloud floor is right**, as shipped.
- **Sliding on it is far from Coulomb's law as shipped.** Over an impact at the shipped step friction takes 3.4
  times what the law allows. A cube set sliding at 5 m/s is almost stopped within a quarter of a second. A cube
  pushed with 1.2 times what friction can hold moves at half the speed it should. The solver stops on 48 steps of
  1,590 and the plays take ninety times longer than on the plane.
- **The corrections made for the ground plane carry over to this path.** The contact kernel they live in is the
  one the point-cloud collider uses. With the recommended configuration the slide keeps its speed, the creep is
  gone and the stopped steps fall from 48 to 4; with the friction correction added friction over an impact is
  within 4% of the law at the shipped step, the push above the limit reaches 85% of its speed, and no step stops.
- **What is left is the sheet's own ripple.** A floor made of points 10 mm apart with a 10 mm range is not flat, and
  the friction read 4% high and the slip 15% low are of that size. The spacing against the range is what a
  registered study has to vary.

## 2. Why `ant`'s solver stops: four sets of commands

Run 022 found that `ant`'s stopped steps on stock contact follow the way friction's normal force is estimated at
the start of a step, and that two of SuperDex's own settings remove them. These probes ask the second open
question, why `ant` stops more with the joint limit patch alone, on four sets of 108 throwaway episodes drawn in
sequence from seed 9100 (`probe_10_ant_stops.txt`). Stopped steps of 21,600:

| Set | Stock | Joint limit patch alone | Stock, first command 1 N m larger | Patch minus stock | Nudge minus stock | Without the ground, stock and patch |
|---|---|---|---|---|---|---|
| 0 | 223 | 249 | 214 | +26 | -9 | 0 and 0 |
| 1 | 234 | 257 | 228 | +23 | -6 | 0 and 0 |
| 2 | 204 | 226 | 221 | +22 | +17 | 0 and 0 |
| 3 | 204 | 245 | 212 | +41 | +8 | 0 and 0 |

On set 0 the joint limit patch stops 249 steps alone, 12 with SuperDex's `explicitNormals`, the same 12 with
`explicitNormals` and Armijo line search, and none with `implicitNormalForceForDissipation`. Stock with
`explicitNormals` stops 12 too (run 022).

What the probe shows: **the patch does add stopped steps, in every set**, about one in nine, while a change of the
motion alone (the nudge) moves the count either way. But it adds them only of the kind stock has: without the ground
neither stops a step, and with `explicitNormals` the patch stops exactly as few as stock. Unilateral limit damping
changes how the legs meet the ground, and more of those meetings land on the estimated normal force. That is what
the tenth registration tests.

## 3. Deformable bodies: rods, cloth and soft bodies

A new rig, [`tools/sdx_deform.cpp`](../../tools/sdx_deform.cpp), plays one body at a time, built as a plain regular
mesh, and a new measure (`sx_contact deform`) reads it. Each case has a textbook answer, written in the rig's
header. Default bodies, stock, at 0.01 s and 0.001 s (`probe_15_deformable.txt`):

| Case | Right answer | Stock, 0.01 s | Stock, 0.001 s |
|---|---|---|---|
| Rod, cloth, soft cube in free fall: centre against backward Euler's own drop | 0 apart | 0, 41 and 923 nm | 0, 44 and 16,019 nm |
| Rod hanging from a clamp: tip stretch (textbook 1.2250 mm; with the material's own finite-strain term 1.2190 mm) | 1.2190 mm | 1.2203 mm | 1.2178 mm |
| Cloth strip hanging: stretch (textbook 1.5313 mm; with the finite-strain term 1.5219 mm) | 1.5219 mm | 1.5220 mm | 1.5220 mm |
| Soft bar hanging: stretch (textbook, uniaxial) | 1.2250 mm | 1.2254 mm | 1.2229 mm |
| Rod cantilever: tip sag (textbook) | 3.8281 mm | 3.7135 mm | 3.7140 mm |
| Cloth patch at rest on the ground: height (from SuperDex's own penalty law) | 0.4894 mm | 0.4894 mm | 0.4895 mm |
| Soft cube at rest: centre height (the same law, and the cube's own sag) | 49.659 mm | 49.660 mm | 49.659 mm |
| Cloth patch sliding at 1 m/s: distance to stop (Coulomb, at backward Euler's step) | 97.04 and 101.54 mm | 97.02 mm | 101.54 mm |
| Soft cube sliding at 1 m/s: the same | 97.04 and 101.54 mm | 96.48 mm | 101.16 mm |
| Cloth patch on a floor tilted below the friction angle: speed after 1 s | 0 | 2,286 um/s | 2,288 um/s |
| Soft cube on the same floor | 0 | 2,285 um/s | 2,247 um/s |

No solver step stopped in any case.

What the probe shows: **SuperDex's deformable bodies are right where a textbook can say what right is.** Falls are
backward Euler's own to the solver's tolerance; hanging bodies stretch to the material law's own value within two
tenths of a percent; bodies rest where the contact law puts them and slide the distance Coulomb's law and the step
give. Two departures:

- **The cantilever sags 3.0% short at 64 elements.** It is clamped the way SuperDex's own test clamps it, by holding
  the first two nodes, so the first place it can bend is one element in. A beam half an element shorter sags
  3.710 mm, which is what it does. A registered study sweeps the element count.
- **A body on a floor tilted below the friction angle creeps** at 2.3 mm/s, which is what SuperDex's regularised
  friction gives for that pull (falloff x (1 - sqrt(1 - tan(tilt) / mu))). It is the creep the earlier studies found
  on a rigid cube, on a deformable body.

With the recommended configuration and the friction correction the cloth patch moves 0.069 mm and the soft cube
0.266 mm when the floor tilts, and then stop: both inside anchored friction's stick distance of 0.3 mm. The slides
stop at 96.71 and 101.14 mm (cloth) and 96.17 and 100.70 mm (soft cube).

## 4. A gripper holding a cube

A new rig, [`tools/sdx_grip.cpp`](../../tools/sdx_grip.cpp), with a new measure (`sx_contact grip`): a
parallel-jaw gripper holding a cube under gravity, as a hand-built control and as the Franka FR3 hand shipped with
SuperDex (Apache-2.0) with its arm welded. A cube of 0.1 kg with half-size 0.01 m, friction 0.5
(`probe_16_gripper.txt`):

| | Right answer | Hand-built, stock | FR3, stock | Hand-built, corrected | FR3, corrected |
|---|---|---|---|---|---|
| Grip of 10 N: force each finger presses with, N | 10 | 10.000 | 10.000 | 10.000 | 10.000 |
| Grip of 10 N: force each finger carries the cube with, N | 0.490 | 0.490 | 0.490 | 0.490 | 0.490 |
| Grip of 10 N (ten times what is needed): the cube still slipping at the end, mm/s | 0 | 0.58 | 0.086 | 0 | 0 |
| Grip of 10 N: slip over 1.5 s, mm | 0 | 0.98 | 0.17 | 0.021 | 0.020 |
| Grip of 0.5 N (too weak): acceleration over the first 30 ms, m/s2 | 4.8 | 4.88 | 4.61 | 4.85 | 4.96 |
| Steps stopped, of 600 | 0 | 2 | 5 | 0 | 0 |

"Corrected" is the recommended configuration with the friction correction.

What the probe shows: **SuperDex holds a cube with the right forces, and stock lets it creep out of the grip.**
Each finger presses with the commanded force and carries half the weight, to within half a millinewton. As shipped,
friction that fades to zero at zero speed cannot hold a steady load, so a cube gripped ten times harder than it needs
slides out at 0.58 mm/s in the hand-built gripper and 0.086 mm/s in the FR3 hand. With the corrections it stops
within 21 micrometres and stays. The grip of 0.9 N falls too slowly for its 30 ms window to leave friction's
falloff, so the probe of a weak grip needs a longer, taller grip; the registered study uses one.

## Files

| | |
|---|---|
| `probe_14_point_cloud_floor.txt` | One cube on the ground plane and on a held cloth sheet, three configurations |
| `probe_10_ant_stops.txt` | `ant` on four sets of throwaway commands: stock, the joint limit patch, a nudge, no ground; and the patch with SuperDex's own switches |
| `probe_15_deformable.txt` | Rods, cloth and soft bodies: every case on stock, the floor cases corrected |
| `probe_16_gripper.txt` | The gripper, hand-built and FR3, stock and corrected |
