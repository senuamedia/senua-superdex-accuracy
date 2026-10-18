# Run 042: the two corrections no rig had played (design probe)

15 October 2026, on the Linux machine of runs 039 to 041. Not registered: a design probe for the open item "two of the
second code review's defects, corrected and not played". Library build 15 corrected both with added lines only:

- **A contact a mapped collider missed at the stage start.** A mapped collider is a soft body: SuperDex finds where
  a sample was at the start of the step through the body's tetrahedral map, and that can miss. Stock gives a missed
  sample no friction. Library build 14's patch C gave it a stick anchor anyway; build 15 gives it none and keeps none.
- **The anchor table's lifetime.** Build 14's table of stick anchors was a static object, so a scene destroyed after
  `main` returns could find it already destroyed. Build 15 makes it once and never destroys it.

What is played ([`build14.sh`](build14.sh), [`probe.sh`](probe.sh), pushed before any build or play):

1. Library build 14 in 64-bit on Linux, beside run 039's build 15, from its four patch files in this repository.
2. The contact rig with two new settings, `floor=soft` (a soft block with every node held, met through the
   tetrahedral map) and `exitscene=1` (the scene destroyed after `main` returns, by an object in static storage made
   after the context and before the scene), built against stock, build 14 and build 15. First the rig with neither
   setting is checked against the registered suite files, byte for byte.
3. `exitscene` under valgrind's memcheck on stock, build 14 and build 15, with no switch and with patches A to C.
4. A cube dropped, slid and held on the soft block at three steps, on stock and on builds 14 and 15 under patches A
   to C, build 14 against build 15 file by file.

## Steps 1 and 2 (`build14.txt`, `identity.txt`, `exitscene.txt`, `soft_14_15.txt`, `runs/`)

Library build 14 built in 6 minutes (`build14.txt`; the library's sha256, 33935ba1df6c7ebe..., recorded in
`build-patched14.sha256`; from the patch files whose checksums are in `build-patched14.patches.sha256`); every rig
built (`rigs.sha256`); every play exited 0 (`played.txt`).

- **The rig with neither new setting makes the registered suite files again, 268 of 268**: stock, off, patches A to
  C, and patches A to C and E, both suites. Adding the settings changed nothing else.
- **`exitscene=1` finds nothing on any build**: valgrind reports 0 errors and every play exits 0, on stock, build 14
  and build 15, with no switch and with patches A to C. Build 14's table is a namespace-scope object of the shared
  library (`gFrictionAnchors`, `gFrictionAnchorMutex`), made when the library loads, before `main`; an object made in
  `main` is destroyed before it. So this play cannot reach the defect, which needs a scene destroyed after the
  library's static objects are gone.
- **On the soft block, build 14 and build 15 under patches A to C are byte-identical, 9 of 9 plays**, and the
  patched library with no switch makes stock's plays, 9 of 9. The cube meets the block: under patches A to C it
  carries its weight (7,834 to 7,842 mN against 7,840, the mean over the second half of each play; 7,837 to 7,841 at
  the shipped step), and dropped or held it rests 0.81 mm into it. Stock reads 7,832 to 7,846 mN but for its drop at
  1/16 of the step, 8,013, still moving at the end. Under patches A to C a slide at 1 m/s goes 139.8 mm at the
  shipped step (Coulomb's law: 145.8 mm), stops and stays stopped, and a push of 0.6 of the friction limit is held
  after 0.5 mm; stock slides 106.6 mm and then creeps at 224 um/s, and creeps at 3,624 um/s under the push. The
  corrections work on the mapped collider. The defect needs a sample the map missed that still has an anchor from
  an earlier contact within 5 mm: a cube that leaves the block and lands again nearby. No play here leaves it.

## Step 3 ([`probe3.sh`](probe3.sh); `identity3.txt`, `exitscene2.txt`, `hop_14_15.txt`, `runs3/`)

The rig gained `exitscene=2`, the scene destroyed from a destructor function.

- **The rebuilt rig makes the registered suites again, 268 of 268.**
- **`exitscene=2` finds nothing either**: 0 valgrind errors and exit 0 on every build and switch. On Linux the
  destructor functions of the program run before a linked library's static objects are destroyed: the exit
  handler that runs them is registered after the library's destructors, and exit handlers run last in, first out.
  No program that links the library can destroy a scene after build 14's table. A program that loads the library
  after registering its own exit handler can: a plugin, or a Python extension, loaded with `dlopen`.
- **The hop: builds 14 and 15 byte-identical, 8 of 8**, under patch C alone and under patches A to C. The cube does
  hop: at 1/64 of the step it rebounds 7,565 per 10,000 of the drop and touches down 7 times. The plays record no
  place along the block; its speed along it, summed over the steps (`runs3/hop_*_64.txt`), puts the second touchdown
  about 0.05 mm from the first on stock, 0.22 mm under patch C alone and 0.56 mm under patches A to C. The reason it
  makes no difference is in SuperDex's source: the tetrahedral map is asked where a sample sits in the collider's
  shape at the start of the step, and it misses only points outside every tetrahedron of that shape
  (`tetrahedral_map.cpp`, the barycentric test). A block with every node held never changes shape, so a sample inside
  it now was inside it then: the map cannot miss. The defect needs a mapped collider that moves or deforms within the
  step.

## Step 4 ([`probe4.sh`](probe4.sh); `identity4.txt`, `exitdlopen.txt`, `softbottom_14_15.txt`, `runs4/`)

The contact rig gained `softhold=bottom` (the block held only along its bottom face, so it deforms under the cube),
and a new program, [`tools/sdx_exit.cpp`](../../tools/sdx_exit.cpp), registers its exit handler and then loads the
library with `dlopen`, as a plugin or a Python extension does, and destroys its scene in that handler.

- **The rebuilt contact rig makes the registered suites again, 268 of 268.**
- **The table's lifetime: the defect is reached, and build 15 corrects it** (`exitdlopen.txt`, `runs4/valgrind_*`).
  With build 14 and patches A to C, valgrind reports 120 errors (33 invalid reads and 12 invalid writes among them),
  every one in `mochi::ClearFrictionAnchors`, called by `ContextImpl::DestroyScene` from the exit handler, on memory
  the table's own destructor had freed. With build 15 and patches A to C: 0 errors. With no switch, on builds 14 and
  15 and on stock: 0 errors (likely because a table that never held an anchor has no node to read). Every program destroyed
  its scene and exited.
- **The mapped collider: the corrected path is played, and its effect here is below a micrometre**
  (`softbottom_14_15.txt`). On the deforming block builds 14 and 15 differ on 3 of 26 plays, all hops: patch C alone at
  1/16 and 1/64 of the step, patches A to C at 1/64. Every drop, slide and hold is byte-identical. Where they differ,
  the largest difference is 198 nm in height, 1 um/s along the slide, 29 um/s up and down and 1 mN of friction; the
  plays end at the same speed along the slide, and up and down at most 3 um/s apart (319,007 against 319,004 um/s
  under patches A to C, 193,702 against 193,701 under patch C alone, both at 1/64). A missed sample's anchor in
  build 14 lies within the stick distance of where the sample is, so the friction it adds lasts a step and is small.
- **The corrections on the deforming block** (reported, not deciding): under patch C alone and under patches A to C a
  slide stops and stays stopped at steps 1, 1/4 and 1/16 (stock creeps after it at 490 to 502 um/s at the first two),
  sliding at the shipped step 109.7 mm under patch C alone and 112.8 mm under patches A to C, and under both 142.8 and
  145.5 mm at the finer ones (Coulomb's law: 145.8 mm; stock: 107.4, 142.8 and 145.5); a push of 0.6 of the
  friction limit is held at steps 1 and 1/4 (stock creeps at 3,640 to 4,751 um/s), and at 1/16 the cube moves at up
  to 1,778 um/s while the block itself rings.

## What it shows

- Both corrections are reached by a play only under particular conditions, which no earlier rig met: a scene
  destroyed after the library's own static objects are gone, which needs the library loaded with `dlopen` after the
  program's exit handler; and a contact the tetrahedral map missed, which needs a soft collider that changes shape
  within the step and a sample that lands again near where it last stuck.
- The lifetime defect is a real use-after-free in build 14, found by valgrind, and build 15 removes it.
- The mapped-collider defect is real in build 14's code and reached, and on these plays it changes the motion by less
  than a micrometre.

A study of both can be registered from this, on fresh numbers.
