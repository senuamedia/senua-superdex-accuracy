# Run 050: the line of patch C's correction that changed one play of Study 5

15 October 2026, on the second Linux machine of the deep dives (AWS EC2, Intel Xeon Platinum 8488C, Ubuntu 24.04.5,
Clang 18.1.3; `host/traceC_machine.txt`). Not registered: a trace made for publication, to close the question
[Study 17](../../docs/studies/17-whole-record.md) left open. Nothing here decides anything.

## The question

Study 17 ([run 037](../run_037_whole_record/README.md)) made the whole record again on library build 15. One play
differed: Study 5's `ant` benchmark under the recommended configuration of that time (patches A, B and C, contact
damping 5) with SuperDex's own `implicitNormalForceForDissipation`, source `qi1`. Library build 4, the fifth
registration's, makes the registered files; library build 5, the first built with the seventh registration's
correction of patch C, and every build after it, make run 037's. The seventh registration said that with
`SUPERDEX_STICK_DAMPING` unset the anchored friction is the recorded one, bit for bit. Which line changes this play,
and why, with that switch unset?

## The two forms

- **Build 4** was built from the fifth registration's contact patch,
  [`patches/superseded/senua_contact_registration5.patch`](../../patches/superseded/senua_contact_registration5.patch)
  (sha256 08b13968fe9c2a2b...; library 77708fa8b023ed18... on the laptop), kept here as
  `forms/build4_form_registration5.patch`.
- **Build 5** was that tree with the seventh registration's damped-stick edits to `contact_utils.h` only; build 6
  added the fresh-anchor edit to `mochi_contact.cpp`, and the ninth registration's patch file carries that hunk too. The
  record kept no patch file of build 5's form, so it is reconstructed here as
  `forms/build5_form_reconstructed.patch` (the ninth registration's file less its `mochi_contact.cpp` hunk); it
  applies to SuperDex v1.0.0. The two forms differ in one file, `contact_utils.h` (`forms/build4_to_build5.diff`).

Every hunk between them, and whether it runs with `SUPERDEX_STICK_DAMPING` unset:

| # | Hunk | Runs with the switch unset? |
|---|---|---|
| 1 | The switch read (`FrictionStickDamped()`) | Yes: a lookup, no arithmetic |
| 2 | A new kernel parameter, the step's displacement, passed at the call | Yes: no arithmetic |
| 3 | The step's tangential displacement and its norm | Yes: used only by viscous friction, and by the anchor when the switch is set |
| 4 | The stick's damping rate (0) and its Hessian scale (1); the friction offset set to the anchored offset | Yes: copies only |
| 5 | The smoother, force, mask and tangent read from that offset | Yes: the same values |
| 6, 7, 8 | The energy factor, `eigP` and `eigT` scaled inside `if (stickRate > 0)` | The tests run; the bodies do not |
| 9 | The energy factor's derivative | Only for gradients to the previous step, not in forward plays |
| 10 | Viscous friction taken on the step's displacement, not on the anchored offset | Yes, when viscous friction is above 0 (shipped 0, and 0 in this play) |

## The bisect

On Linux, SuperDex at the upstream commit with the contact patch alone, 64-bit, the player built by
`tools/build_player.sh`, `qi1` played as Study 5 and run 037's bisect played it (patches A, B and C at a stick
distance of 0.0003, `integ=be maxiter=200 ndamp=5 implicitn=1`, `actions/05/ant.txt`), and `q1`, the same play
without the implicit setting. A private copy of the player (`host/rig/sdx_player_f64.cpp`) also writes the whole
double-precision state each step. Each play's library was read from the loader. Linux builds were compared only
with each other: Linux `ant` streams can differ from the macOS record ([run 047](../run_047_linux_bench_off/README.md)).

| Variant | `qi1` stream | `qi1` converged, stopped, diverged | Double state |
|---|---|---|---|
| Build 4's form | c37ccefa... | 21,446, 33, 121 | the reference |
| Build 5's form | **ef5b8d6f...** | 21,447, 33, 120 | differs |
| Build 5's form without the `eigT` block | c37ccefa... | as build 4 | build 4's, bit for bit |
| Build 4's form with only the `eigT` block and the rate it reads | ef5b8d6f... | as build 5 | build 5's, bit for bit |
| Build 4's form with hunks 2, 3 and 10 (viscous friction) | c37ccefa... | as build 4 | build 4's |
| Build 5's form with the scale folded into the product, no `if` | c37ccefa... | as build 4 | build 4's |

`q1`'s stream is the same in every variant. Build 4's form built again after the others gave the same library as its
first build (`host/logs/variants.txt`), so the rebuilds can be trusted. Every play is in `linux_plays/` and
`host/logs/plays.txt`.

## What changes the play

Hunk 8, three lines:

```
          V eigT = ((-coulombCoefficient) * fFriction) * ddSmoother;
+         if (stickRate > 0_r) {
+           eigT = stickHessScale * eigT;
+         }
          ...
          eigDeltaT = Select(ptMask, eigT - eigP, V{});
```

With the switch unset its body never runs. Its presence changes how the compiler rounds `eigT - eigP`, the tangent
term of anchored friction's Hessian. SuperDex is built with `-ffp-contract=fast`: in build 4's form the compiler
fuses the last multiplication into the subtraction, one rounding (a fused multiply-subtract on macOS and on Linux);
in build 5's form the product has a second use, or a branch between it and the subtraction, so it is rounded on its
own and the subtraction rounds again (`disasm_macos/`, `disasm_linux/`). The algebra is the same, nothing is scaled,
and the friction force, its energy and the residual are not touched: with every other hunk of build 5 in place the
double state is build 4's exactly.

**Why this play shows it.** The rounding changes on every patch C play: in `q1` every reading of the double state
differs, by 2e-16 to 3.5e-11, yet its solver's status, iterations and residual are the same on every step and its
stream is identical, because a converged Newton step absorbs a last-bit change in its matrix. `qi1`, with the implicit
setting, has about 154 steps that stop or diverge. The two forms run identically until step 297, where build 4's
form stops at the iteration limit and build 5's converges in 122 iterations, and from there the states part. Each
episode starts from the same pose; in 40 episodes a step's outcome differs, and in 12 of them the difference reaches
the 14-bit stream.

## What it shows

- **The cause is floating-point regrouping, not a logic difference.** The seventh registration's "bit for bit" holds
  for the friction force and its energy, and for every other play made under the recorded form that the record
  compares; it does not hold for the rounding of one Hessian term, which only a play whose solver fails can carry into
  its output.
- **No correction is made.** Folding the scale into the product (the last row above) makes the recorded form bit
  for bit with build 4's again, but it would change the rounding of the damped stick, the form every later study and
  the recommended configuration use, against builds 5 to 15. That would trade one record for the other.
- **One real logic difference, which no registered play reaches.** With a stick distance set,
  `SUPERDEX_STICK_DAMPING` unset and viscous friction above 0, build 4's form applies viscous friction to the anchored
  offset and build 5's to the step's displacement, as stock does. Build 5's is the right form. No registered play of
  the recorded form uses viscous friction.
- Study 5's conclusion on this play (the implicit setting is not safe to add to the recommended configuration with
  contact damping) holds on every build.

The double-precision state files (2.4 MB each) stay on the machine; their checksums are in `host/logs/plays.txt`.
