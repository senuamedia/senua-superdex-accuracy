# Documentation

The Senua AI Robotics Core, and its first deep dive: Meta's SuperDex Physics v1.0.0, measured, validated and
corrected. SuperDex is the first engine taken through it. The same work can be done on any physics engine or
robotics framework. Start with the page that matches your question.

Back to the [front page](../README.md).

## The pages

| Page | What it answers |
|---|---|
| [Senua AI Robotics Core for a physics engine](harness.md) | What is the tool, what did it do on SuperDex, and what would it do for another engine? |
| [What was built](what-was-built.md) | What are the rigs, the test suites, the patches and the measuring programs, and what does each one take and write? |
| [What was found](findings.md) | What does stock SuperDex get right, and where does it depart from the right answer, with the numbers at every step size? |
| [The patches](patches.md) | What does each of the seven patches correct, how, what was it held to, and what does it cost? |
| [The recommended configuration](recommended-configuration.md) | Which settings and switches are recommended, on which registered decision each, what do they do on Meta's benchmark, and what do they cost? |
| [What is not fixed or not tested yet](open-items.md) | What is still open, what is known about each item, and what has not been looked at? |
| [Reproduce it](reproduce.md) | How do I build, play and compare byte for byte? |
| [Change log](changelog.md) | What changed in the patches, the rigs and the measuring programs, when, and for which study? |

## The studies

Each study is one pre-registration: rules committed first, run once (one disclosed exception, Study 13's four FR3
gripper plays, made once with a wrong path set right), recorded as it fell.
The [index](studies/README.md) says how one led to the next.

| | Study | Outcome |
|---|---|---|
| 1 | [What SuperDex's accuracy settings cost](studies/01-accuracy-settings.md) | 16 of 27 cells held |
| 2 | [The same, with independent calibration](studies/02-independent-calibration.md) | 25 of 36 cells held |
| 3 | [Whose failure is it](studies/03-whose-failure.md) | 5 rules of 6 held |
| 4 | [The cause, on one cube and the ground](studies/04-one-cube-and-the-ground.md) | Every rule held |
| 5 | [One setting and three contact patches](studies/05-contact-patches.md) | Every rule held |
| 6 | [Joints and the integrator](studies/06-joints.md) | Every rule held |
| 7 | [A slide that ends, and two moving bodies](studies/07-slide-and-two-bodies.md) | Every rule held |
| 8 | [Joint limits](studies/08-joint-limits.md) | 5 rules of 6 held |
| 9 | [The rotation vector of a small rotation](studies/09-rotation-axis.md) | Every rule held |
| 10 | [Why the solver stops on ant](studies/10-ant-stops.md) | Every rule held |
| 11 | [Friction at an impact](studies/11-friction-at-impact.md) | 16 rule lines of 17 held (6 rules of 7). Patch F joins the recommended configuration; F3's shortfall is SuperDex's default grid, not patch F (run 048) |
| 12 | [The loss on joint motion](studies/12-joint-motion.md) | 8 of its 10 rules held (31 of 33 lines of the record). Patch G joins the recommended configuration; G2's shortfall is SuperDex's shipped solver tolerance, G8's a rule posed against stock's value, and patch G has no defect under backward Euler (run 049) |
| 13 | [The complete patch list, end to end](studies/13-end-to-end.md) | 65 rule lines of 68 held. The decision to record the patch list as validated end to end did not fire |
| 14 | [The fixes for the five open items](studies/14-open-items.md) | 142 rule lines of 150 held. Neither decision fired: items 1 to 4 joining, the accurate configuration recommended |
| 15 | [Replication, and the code review's corrections](studies/15-replication.md) | 117 rule lines of 121 held (7 rules of 10). The decisions recording every fix as replicated and the accurate configuration as validated end to end did not fire |
| 16 | [The second code review's corrections, and 32-bit](studies/16-second-review.md) | Every rule held as its registered runner reads them (26 rule lines, 10 rules); read literally over every play made on build 15, C3 would fail |
| 17 | [The whole record made again on the library of record](studies/17-whole-record.md) | 3 rules of 4 held |
| 18 | [The stock plays of Studies 14 and 15 on the library of record](studies/18-stock-plays.md) | Both rules held |
| 19 | [The two corrections no rig had played](studies/19-two-corrections.md) | Every rule held |
| 20 | [The corrections in 32-bit](studies/20-thirty-two-bit.md) | 6 rules of 7 held, as predicted |
| 21 | [Patches F and G and the recommended configuration on fresh numbers](studies/21-recommended-configuration.md) | 117 rule lines of 118 held (44 rules of 45). Patch G recorded as required, correct and safe under backward Euler; F3 failed on the measuring program's reading of momentum between two cubes, so the decisions on patch F and on the configuration end to end did not fire |
| 22 | [Patch G under BDF2 on a chain](studies/22-bdf2-chain.md) | Every rule held (66 rule lines of 66). The derived form is patch G under BDF2 (library build 16) |
| 23 | [Patches F and G and the recommended configuration on fresh numbers, on library build 16](studies/23-recommended-configuration-again.md) | 117 rule lines of 118 held. Patch F recorded as required, correct and safe; patch G's decision replicated; one line of P2 failed, so the configuration is not recorded as validated end to end |

## The record underneath

The pages above are written from these, and every number in them can be traced to one.

| Where | What it is |
|---|---|
| [`preregistrations/`](../preregistrations/), `PREREGISTRATION_01.md` to `PREREGISTRATION_22.md` | The designs and their rules, as committed before their runs |
| [`validation/`](../validation/) | Runs 001 to 053: the design probes, the counts and the readings, the checks and reviews made for publication, each with its own README |
| [`patches/README.md`](../patches/README.md) | The patch ledger: every patch, its form at each registration, and its checksums |
| [`measure/`](../measure/) | The measuring programs |
| [`tools/`](../tools/) | The rigs and the play scripts |

## Which page for which reader

| If you are | Read |
|---|---|
| A SuperDex user who wants better contact today | [The recommended configuration](recommended-configuration.md), then [the patches](patches.md) |
| A SuperDex maintainer | [What was found](findings.md), [the patches](patches.md), then the study behind each finding |
| A maintainer of another engine or framework | [Senua AI Robotics Core for a physics engine](harness.md), then [what was built](what-was-built.md) |
| Someone checking our work | [Reproduce it](reproduce.md), then [the studies](studies/README.md) |
| Someone deciding what to trust | [What is not fixed or not tested yet](open-items.md) |
