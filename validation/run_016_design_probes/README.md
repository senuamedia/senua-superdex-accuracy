# Run 016: design probes for the seventh registration

14 October 2026. Throwaway parameters and throwaway commands; nothing here decides anything. Probe cubes: one cube
of 1 kg, half-size 0.05 m, friction 0.4, set sliding at 1.2 m/s; two cubes, A of 3 kg and half-size 0.4 m, B of
0.4 kg and half-size 0.025 m, friction 0.5 between them, no friction under A. Benchmark probes use the 12-episode
command files of run 009's probes, which were not kept. The probes' output was not kept either: this folder holds
only this README, so the numbers below are as noted at the time and cannot be checked from the record.

## What the probes were for

The fifth registration's tests never asked two things: does a cube that slides to a stop stay stopped, and is
contact right between two bodies that both move. `tools/sdx_pair.cpp` (two cubes) and `tools/contact_suite2.sh`
were written to ask them.

## What they showed

**Stock SuperDex, two moving bodies.** Momentum is kept in a collision and in a slide of one cube on the other
(change 30 to 80 parts per million, the resolution of the measure). A stack at rest carries its weights. A cube that
slips on a pushed cube accelerates at Coulomb's value (4,901 against 4,900 mm/s2) and the pushed cube at its own
(7,676 against 7,677). A cube that should ride on a gently pushed cube does not: it falls behind at 2,927 micrometres
a second, the speed the shipped friction law gives (2,929). The absence of stick is the same between two bodies as
on the ground.

**Stock SuperDex, the solver after a collision.** At 1/16 and 1/32 of the step, after two free cubes have collided
and separated, the solver stops without converging on 47% and 63% of all later steps (375 of 800, 1,014 of 1,600),
although nothing touches and both cubes move uniformly. The motion is right. Not pursued here.

**The anchored friction as recorded (patch C of the fifth registration) does not stay stopped.** A cube that slides
to a stop on stock SuperDex stops dead: its speed over the last third of the run is 0 at every step. With patch C
it comes back by the stick distance (300 micrometres) and then rings on it. The ringing is hidden at the shipped
step, where the integrator damps it, and grows as the step is refined: 228 micrometres a second left at 1/16 of the
step, 11,404 at 1/64. When the cube also bounces (patch C without contact damping, a landing at 1/64 of the step) it
is left moving at 191,814 micrometres a second and ends 16 mm from where it stopped. The recommended configuration
as recorded has the same fault: 226 at 1/16 and 13,538 at 1/64. The solver also stops without converging on 1,731 to
1,820 of 35,530 steps of these runs, against stock's 424.

Cause: the anchored friction is a spring between the contact and its anchor with no loss of its own, and its anchor
was kept while the contact was open.

**The correction.** Two additions to the patch, both off unless `SUPERDEX_STICK_DAMPING` is set.

- *A damped stick.* Friction acts on the offset from the anchor over the stick distance plus the sliding speed over
  SuperDex's own `frictionFalloffVel`, inside the one saturation. At rest it holds as before. While sliding it is the
  friction coefficient times the normal force as before. In between, the speed term is the loss. This is the bristle
  damping of the LuGre friction law (Canudas de Wit and others 1995).
- *A fresh anchor when the contact is open.* A contact that carries no normal force at the start of a step holds no
  stick. This is the return mapping of penalty friction onto a friction limit of zero.

With both, the cube stays stopped at every step in every configuration probed (0, with 2 micrometres a second in one
bouncing run), and the anchored friction as recorded is reproduced bit for bit when the switch is off (28 of 28
files against the fifth registration's library).

**How stiff, and how damped.** With the shipped `frictionFalloffVel` (0.01) the corrected stick is stiffer per step
than shipped friction, and half_cheetah's solver stops on 2 of 2,400 steps at a 300 micrometre stick, 6 at 100, 24
at 30 and 62 at 10. With `frictionFalloffVel` at 0.03 and the stick at 300 micrometres it is softer per 10 ms step
than shipped friction, and close to critically damped for friction 0.3 to 0.4 under gravity: half_cheetah 0 of
2,400 at every step from 1 to 1/16 (most iterations 14), ant 1 of 2,400. Both scenes' time-step chains are in order
in 3 folds of 3 on the throwaway commands. The first contact suite passes 9 of 10 as before (the fourth
registration's cube), with 212 of 48,090 solver steps stopped.

**What the correction does not remove.** A cube that slides to a stop comes back by about the stick distance (286 to
300 micrometres), once, and stays. That is the elastic part of any friction law that can hold a load. A smaller
stick distance makes it smaller (9 micrometres at a 10 micrometre stick) and costs the solver on half_cheetah.

## The candidate configuration

Contact damping 5, `frictionFalloffVel` 0.03, patches A and B, anchored friction with a 300 micrometre stick and
`SUPERDEX_STICK_DAMPING=1`. Library build 6 (sha256 675522c786608721...), patch
`patches/superseded/senua_contact_registration9.patch` (sha256 5cf3c66296270d0c..., additions only), the form the
ninth registration names as `patches/senua_contact.patch`. The patch of the fifth registration is kept as
`patches/superseded/senua_contact_registration5.patch`.
