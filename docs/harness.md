# Senua AI Robotics Core for a physics engine

A robot trained in a simulator inherits every place where the simulator departs from physics. The industry mostly
works around that gap: it randomises the simulator so the robot tolerates whatever the world turns out to be, or it
collects real data and corrects afterwards. Neither says what the gap is, where it is, or how large.

We think the sim-to-real gap is a measurement problem before it is a learning problem. You cannot close what you
cannot measure. The Senua AI Robotics Core measures it, and this repository is what that looks like on one engine.

Back to the [documentation index](README.md).

## What the Robotics Core is

The Senua AI Robotics Core is one software stack with four parts. World is the simulator. Body is the real-time
layer that runs on the robot. Mind perceives and decides. **Measure** is the part used here: an instrument that
reads two sources of the same motion and reports whether they differ, where, and by how much, together with a
harness that holds an engine to known right answers.

Here the harness is Senua AI's measuring programs: plain arithmetic on the files the rigs write, published in
[`measure/`](../measure/README.md), which use the Senua AI engine only to read files and compare strings. Every
verdict in this repository comes from those programs and from the method: known answers, every step size,
pre-registration, and byte-identical when switched off. The instrument, which is the engine's, read Meta's
benchmark streams in Studies 1 to 3, and Study 3 checked it against plain subtraction on 30 cells of 30.

## SuperDex Physics: the first deep dive

Meta's SuperDex Physics is the first engine Senua AI has been taken through end to end, and the first we have
published.

| What Senua AI did | On SuperDex v1.0.0 |
|---|---|
| Measured | Known-answer tests on one cube, two cubes, one and two arms, rods, cloth, soft bodies, a point-cloud floor and a gripper, and Meta's 3 benchmark scenes, at every step size from the shipped 10 ms to 1/64 of it |
| Found | 12 departures from the right answer, among them a bounce set by the time step, friction that cannot hold a load, a ground that pulls once contact damping is on, a damped joint limit that holds a joint back, and a rotation whose axis is lost when it is small |
| Placed the cause | Cleared the instrument and the scene first and showed the rig repeats exactly (its stepping was not cleared: one rule fired on `cart_pole`), then traced the benchmark's disorder down to one cube and the ground |
| Corrected | 7 patches, each only adding lines and off unless switched on, each shown required and held to its rules in a pre-registered study, and played together end to end, with every rule that failed listed |
| Validated | Each patch required, correct on its own rules, and byte-identical to stock when switched off; for patches F and G a rule failed (F3; G2 and G8), so their registrations record them as measured; F3's cause is SuperDex's default grid, not patch F (run 048); G2's is SuperDex's shipped solver tolerance and G8 was posed against stock's value, which patch G moved to the right answer, and under backward Euler patch G has no defect (run 049). On fresh numbers Study 21 recorded patch G as required, correct and safe under backward Euler, and by Study 22's decision patch G under BDF2 takes a derived form that makes a chain second order; Study 21's F3 failed again, on the measuring program's reading of momentum between two cubes, not on patch F, and on fresh numbers Study 23 recorded patch F as required, correct and safe under the recommended configuration, every rule F1 to F6 holding. One of our own patches was caught ringing and corrected, and a cost we had put on our patches was traced to the engine instead |
| Proved on Meta's benchmark | `half_cheetah`'s time-step settings in order in 3 folds of 3, where stock has 0 of 3 (Studies 11 and 12, at SuperDex's shipped tolerances) |

SuperDex came first because it is open, deterministic, and unusually candid about where it trades accuracy for speed
and stability. That makes it a fair engine to measure and a useful one to improve. **It is the first use case, not
the only one.** Nothing below is specific to it.

## Our difference

- **We do not use models. No LLMs and no SLMs, of any kind.** The Senua AI engine learns the structure of a signal
  directly from the signal itself.
- **No GPU and no data centre.** Every run in this repository, SuperDex included, was played and measured on CPUs:
  one laptop, and rented cloud CPU machines for the Linux runs. The engine runs on low-end CPUs.
- **No AI token costs, ever.**
- **Your engine and your data stay with you.** Senua AI runs on your own machine. Nothing is shipped to a third
  party.
- **Fully auditable.** Every rule is written before its data exists, every run's record is kept, and every reading is published
  beside the raw files it was read from.

## Three abilities, for any engine

### Measurement

**The smallest scene that has a right answer.** One cube and the ground. One arm on one joint. Two cubes. A failure
there belongs to one part of the engine and to nothing else, so a maintainer knows where to look. Each test is held
to physics that does not depend on the time step: a dropped body's bounce, Coulomb's law, momentum, a pendulum's
energy. Here: 27 tests in five suites, described in [what was built](what-was-built.md).

**Every step size, not only the shipped one.** An implicit integrator can hide a fault at the shipped step. It hid
one of ours. At 10 ms our first friction patch looked right, and at 1/64 of the step it rang. The known-answer test
at every step size found it, and the patch was withdrawn and corrected. Here: [Study 7](studies/07-slide-and-two-bodies.md).

**Motion that has no textbook answer.** A full scene has no closed-form answer. For that there is the gap
instrument. It reads two recordings of the same commanded motion and reports whether they differ, where in the
motion, and by how much. Its false-alarm rate is measured on noise alone, and nobody sets a threshold by hand. The
two recordings can be:

- an engine against its own finer settings, which is what Studies 1 to 3 do;
- one release of an engine against the next, so a regression is caught before it reaches a user;
- a simulator against a recording of a real machine, which is the sim-to-real gap itself.

### Validation

**It answers "whose failure is it?" before it points at an engine.** When a benchmark comes out wrong there are four
possible owners: the instrument, the rig, the scene and the engine. Senua AI tests each one. Here the rig replayed
byte for byte, a tiny nudge to the input changed nothing, and the instrument agreed with plain subtraction on 30
cells of 30. The rule on the rig's stepping fired on `cart_pole` in one fold, so the registered conclusion, that the
failure belongs to ground contact, did not fire; Study 4 places the cause in the engine's contact on one cube and
the ground, where the right answer is known. Here: [Study 3](studies/03-whose-failure.md) and
[Study 4](studies/04-one-cube-and-the-ground.md).

**It keeps a record that holds.** Every study is registered before its data exists and run once (one disclosed exception: Study 13's four FR3
gripper plays, made once with a wrong path set right). When a result
falls short, the rule stays and the idea changes. That is how the cause was traced from three benchmark scenes down
to one cube, and how the fault in our own patch was caught. A maintainer can check every number against the raw
runs. Here: [the studies](studies/README.md).

### Patching

**It turns a finding into a correction a maintainer can merge.** Each patch is held to five checks: required, correct,
nothing else gets worse, byte-identical when switched off, and the solver keeps converging (patch D, used alone on `ant`, stops the solver more often; it is used with the rest). With no switch set, SuperDex's output is byte-identical to stock on every play compared:
that is measured, not assumed. Here: [the patches](patches.md).

## What your engine gets back

| You get | What it is |
|---|---|
| A known-answer suite for your engine | The smallest scenes, each with its right answer and pass line, played at every step size |
| A findings ledger | What your engine gets right, where it departs from the right answer, at which step, and by how much |
| What each accuracy setting costs | Your shipped settings against your own more accurate ones, one change at a time |
| Corrections held to five checks | Offered as patches that are byte-identical when switched off |
| A plain open list | What was not fixed and what was not tested |
| The whole record | Rules, runs, raw files and checksums, so anyone can check every reading against the files it was read from and make every play again |

This repository is that set, for SuperDex.

## What your engine needs

Very little. The measuring side never sees the engine. It reads a plain text file of what a body did at each step,
or an encoder stream.

| Needed | Why |
|---|---|
| A way to play a scene from a program | The rig is the only adapter. Each rig here is a single C++ file against SuperDex's public API |
| Repeatable output | The same commands give the same motion, so two settings can be compared step for step |
| Access to its accuracy settings | The time step, the solver's limits, the contact parameters |

The same measurement, validation and patching then apply to MuJoCo, Isaac Sim, Bullet, Drake or an in-house engine,
and to a robotics framework built on top of one.

## Where this goes next

The [open list](open-items.md) is the work in line on SuperDex: patch F and the recommended configuration end to end, held back by a rule that failed on our own measure of momentum between two cubes, the point-cloud fix whose rule failed on one stopped step, two known costs, and two limits of SuperDex's 32-bit precision itself. Beyond that list is the
measurement the whole approach points at: a recorded real machine read against its simulation.

## Talk to us

If you maintain a simulator or a physics library, or you are building a robot and want to know how far your
simulation is from the right answer, we would like to run Senua AI on your engine. You can reach us through
[senuaai.com](https://senuaai.com).
