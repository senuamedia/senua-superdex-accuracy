# Run 045: the record checked end to end before publication

15 October 2026, 05:52 to 07:18 UTC (`steps.txt`; step 7 after it), by [`verify.sh`](verify.sh), on the Linux machine of runs 039 to
044 (AWS EC2, Intel Xeon Platinum 8488C, Ubuntu 24.04, Clang 18), from a fresh copy of the record (its commit is
named in the first line of `steps.txt`; it names a commit of the private history) and a fresh clone of SuperDex at
the commit in [`UPSTREAM_COMMIT`](../../UPSTREAM_COMMIT). The folders runs 039 to 044 had used were set aside first,
so every library and rig was built again from nothing. Not registered: a check of the record as it will be published.
A seventh step, [`linux_readings.sh`](linux_readings.sh), was added after the fifth found that 43 files of runs 032
and 034 are made differently on Linux.

## The result

| Step | What it checks | Result |
|---|---|---|
| 1. The patch files | Every registered form applies to SuperDex v1.0.0 and only adds lines (`patches_apply.txt`, checksums in `patch_checksums.txt`) | Every form applies; none removes a line. Library build 15: 14 files, 1,458 lines added |
| 2. The libraries | Built by the record's own build scripts (runs 039, 041, 042) and compared with the checksums those runs recorded (`libraries.txt`) | 5 of 5 the same: stock and build 15 in 64-bit, stock and patched in 32-bit, library build 14. Library build 13 has no registered Linux build |
| 3. The rigs | Built again and compared with the checksums runs 040 and 042 recorded (`rigs_check.txt`) | Every rig the same but one: `sdx_contact64` differs from run 040's and is the same as run 042's, because its source gained Study 19's settings between the two runs (both sources' checksums in run 042's `rigs4.sha256` match). Run 041 kept no rig checksums |
| 4. Studies 19 and 20 | Played again by their own play scripts, every file against the registered one (`studies_19_20.txt`) | 41 of 41 and 497 of 497 files the same, and both identity files |
| 5. The identity check | Every part, every file against the registered one (`identity.txt`) | The same as run 040 found on Linux in the parts it played, 12 files, and 43 of the 616 files of runs 032 and 034, below |
| 6. The readings | Every reading of registrations 1 to 16, 19 and 20 re-made from the record's own files by [`remake.sh`](../../measure/runners/remake.sh) (`remake.txt`) | 26 of 26 byte for byte |
| 7. Runs 032 and 034 from the Linux plays | Their readings re-made with their play files replaced by the ones step 5 made on Linux, every rule line against the registered reading (`linux_readings.txt`) | Run 032: 150 of 150 rule lines read as registered. Run 034: 120 of 121; the one that differs compares values, below |

### The files Linux makes differently

On the Mac every file of the identity check is the same as registered (Studies 16 and 17). On Linux:

- **In the parts run 040 played**, the same 12 files as run 040, file for file: five long joint and chain plays that
  differ in the last printed digit on one to four lines (`joint swing_be_64`, also played in the `zero` part; the
  `fg` part's `chain swing_16`, `chain tight free_16`, `joints_fc swing_be_64` and `limits_fc rel20_64`), four `ant`
  benchmark streams with no switch (s4, c1, c06, c03), and two `half_cheetah` streams under switches (y1, y4).
  [Run 047](../run_047_linux_bench_off/README.md) showed the four `ant` streams differ the same way with the stock
  library on Linux: they are Linux's own, not the patches.
- **In runs 032 and 034, made again whole for the first time on Linux:** 25 of 391 and 18 of 225 files: deformable
  bodies, grippers, chains and long swings, and the benchmark's traces and one stream. They are the plays that run
  long or turn a body through large angles, where SuperDex's `-ffp-contract=fast` and the maths library may change
  the last digit (the reproduce guide says so).

### Step 7: what the differences change

Every rule of run 032 reads as registered on the Linux files: 150 of 150 lines, the same verdict on each. The values
that change are two deformable slides by 1 and 8 nm (of about 51.8 mm and 51.3 mm), with the soft cube's other readings
by 1 to 10 nm and its rocking period by 10 microseconds, and the benchmark's wall-clock times.

Run 034 reads the same on 120 of its 121 rule lines. The one that differs, `V8_the_tree_reads_every_other_rule_as_run_032`,
compares the whole text of the rule lines run 034's tree makes with run 032's registered reading, values included, so
it fails when any value moves: on Linux the shell's slide reads 1 nm further (77,946,793 against 77,946,792). Every
verdict of those rule lines is the same as registered. Run 034's other values that change are that slide and the
benchmark's wall-clock times.

## What it shows

- **The published record rebuilds from nothing.** Every patch form applies and only adds lines, and the libraries
  built from them by the record's own scripts are byte for byte the ones registered on Linux.
- **Studies 19 and 20 replay byte for byte**, and every reading of the record re-makes byte for byte from the record's
  own files (26 of 26, the gap instrument's three included).
- **On Linux, no verdict of the identity runs changes.** Linux makes some long and rotating plays differently in the
  last digit, the same files run 040 found plus 43 of runs 032 and 034; read as their registrations read them, every
  rule gives the verdict it gave on the Mac.

The play outputs of steps 4 and 5 are not kept, since each is compared with a file the record keeps; the lists of
what differs are.
