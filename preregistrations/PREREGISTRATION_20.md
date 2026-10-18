# Twentieth pre-registration: the corrections switched on in SuperDex's shipped 32-bit precision

Registered 15 October 2026, before any run of this registration existed.

## The question

SuperDex builds in 32-bit unless told otherwise. Every reading of the corrections in Studies 5 to 19 is 64-bit; in
32-bit only "safe when off" was measured (Study 16, and run 041 on both contact suites). Do the corrections, switched
on, do in 32-bit what they do in 64-bit?

## What the design probe found (run 041, not registered)

On the seventh study's cubes, on Linux, under the final configuration (every switch, contact damping 5,
frictionFalloffVel 0.03, abstol 1e-4, reltol 1e-8): 8 of the first suite's ten tests in 32-bit against 10 of 10 in
64-bit. T01, free flight, fails in 32-bit with the same reading with and without the corrections. T08, the refinement
chain, falls to 1/16 of the step and then rises once. Measured afterwards with that cube's own answers (the dry run
below), the second suite's tests T11 to T17 pass in 32-bit as in 64-bit.

## What is played

**Run 044**, on the Linux machine of runs 039 to 043 (AWS EC2, Ubuntu 24.04, Clang 18), by
[`tools/plays/play_20.sh`](../tools/plays/play_20.sh), from the root of the copy of this repository runs 040 to 043
played in:

    bash tools/plays/play_20.sh <work folder of run 039> validation/run_044_study20

The libraries, all built on that machine from SuperDex at the commit in `UPSTREAM_COMMIT`, the patched ones with the four
patch files of library build 15: 32-bit stock (5cda843a4cf2ba2e...) and patched (3366a7bf36fae858...), from run 041; 64-bit stock
(75def9201a45216a...) and patched (eee7cca1423650df...), from run 039. The 32-bit contact and pair rigs are built by
the play script from the sources as in this commit; the 64-bit contact rigs are run 042's and are checked against its
checksums.

- **S**, the rigs: the 32-bit rigs built here play run 041's 32-bit plays of the seventh study's cubes (stock and the
  final configuration, both suites) again.
- **The fresh cubes**, both suites, in 32-bit stock, 32-bit patched with no switch, 32-bit under the final
  configuration, 64-bit stock and 64-bit under the final configuration:
  - First suite: a cube of 1.1 kg and half-size 0.04 m; dropped 0.08 m; the oblique impact at 2 m/s and the chain at
    1.2 m/s with friction 0.4; the steady slide at 3.5 m/s with friction 0.4; hold and slip with friction 0.5, pushed
    with 3.234 N (0.6 of the limit) and 6.468 N (1.2 of it); lifted with 32.34 N (three times the weight).
  - Second suite: the same cube with friction 0.4, slid at 1 m/s and dropped 0.06 m to land; the pair a block of
    3.5 kg and half-size 0.28 m with a cube of 0.7 kg and half-size 0.035 m on it, friction 0.35 between them, the
    carry push 7.203 N (half of what friction can carry the cube at), the slip push 21.609 N (one and a half times
    it); the side run at 1 m/s and the top run at 0.9 m/s.

The measuring is [`measure/runners/sx_study20_run.sh`](../measure/runners/sx_study20_run.sh): the first suite by the
record's suite runner with friction 4,000 per 10,000 and the slip push 6,468 mN; the second by `sx_contact stop`,
`pair`, `accel` and `suite2` with the answers 34,300 and 6,860 mN (the block's and the cube's weight), 5,488 and
3,430 mm/s2 (the block's and the cube's slip); every rule by `sx_contact rule`.

## The rules, fixed in advance

| Rule | It holds when |
|---|---|
| **S0** | The 32-bit rigs built here make run 041's 32-bit plays again, 134 of 134 files |
| **Z0** safe when off | In 32-bit, the patched library with no switch is byte-identical to stock on every file of both suites (39 and 28) |
| **Z1** | In 32-bit under the final configuration, all ten tests of the first suite pass, as the record finds in 64-bit |
| **Z2** | In 32-bit under the final configuration, the tests of what the corrections do pass: T02 to T07, T09 and T10 |
| **Z3** | In 32-bit, T01's reading under the final configuration is stock's, gap by gap: free flight is the arithmetic's own |
| **Z4** | In 32-bit under the final configuration, the second suite's tests T11 to T17 all pass |
| **Z5** | The control, in 64-bit under the final configuration on the fresh cubes: all ten tests of the first suite and T11 to T17 pass |

Reported, not deciding: every measured line; the first suite's code under every configuration; 64-bit stock.

## Predictions, from the probe

Z1 fails, on T01 and T08. S0, Z0, Z2, Z3, Z4 and Z5 hold. The predictions do not decide anything; the rules do.

## Decisions fixed in advance

- **If Z0, Z2, Z3, Z4 and Z5 hold**, the corrections are validated in 32-bit for what they do: contact, friction and
  the ground, on fresh cubes. The open list records the 32-bit item as closed for the contact corrections, with
  whatever Z1 shows recorded beside it.
- **If Z1 fails on T01 alone, or on T01 and T08**, those are recorded as limits of 32-bit SuperDex: free flight with Z3
  as its evidence, and the refinement chain as measured. Neither becomes a rule of a later study by this registration.
- **If Z5 fails**, the record's 64-bit claim does not carry to the fresh cubes, and that is recorded first, before
  anything about 32-bit.
- **If Z2 or Z4 fails**, that correction is recorded as not carrying over to 32-bit, on these cubes, and stays open.

## Known risks, stated before the run

- **The fresh cubes may meet a test's tolerance differently.** The first suite's tolerances are the record's own
  (sx_contact_suite.sh); a heavier cube on a different friction can land on the other side of one.
- **The final configuration's reltol of 1e-8 is below 32-bit's resolution** (about 1.2e-7). The solver then stops on
  its small-update rule rather than on the tolerance; the probe still passed eight tests.
- **T01 and T08 read free flight and refinement**, which 32-bit rounding may decide on its own, as the probe found.
- The joints, limits, rotation and benchmark corrections (patches D, E, G and F on Meta's scenes) are not played in
  32-bit here. This registration is about contact, friction and the ground.

## The dry run, before registering

No play was made. The runner was run on run 041's plays, arranged as the play script writes them. With this
registration's answers (for the fresh cubes) the answer-dependent tests failed, as they must on other cubes; with run
041's cube's own answers it read Z1 failed on T01 and T08, and Z2, Z3, Z4 and Z5 held. That dry run also found that run
041's README said free flight was byte for byte the same with and without the corrections; two of the seven
free-flight files differ by 1 um/s under the final configuration's tolerances, and the reading is the same. Run 041's
README was corrected, in a commit before this registration, and Z3 compares the reading.

## As registered

Play script `tools/plays/play_20.sh` and runner `measure/runners/sx_study20_run.sh` as in this commit; the libraries
and rigs as above; the measure `sx_contact.sx` as run 87e921cd4d2c03bf....
