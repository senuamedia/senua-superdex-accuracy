# Run 046: the "stock" chain, deformable and gripper plays made again on stock SuperDex

15 October 2026, 06:20 to 06:24 UTC, on the laptop. Not registered: a check made for publication, after the second
audit asked whether the plays the record calls stock were stock.

## Why

The chain, deformable-body and gripper rigs (`tools/sdx_chain.cpp`, `tools/sdx_deform.cpp`, `tools/sdx_grip.cpp`) were
built against the patched library, and their plays with no switch set are what Studies 12 to 16 call stock. That
rests on the patches being safe when off: these plays had not been made on the stock library itself.

## What was done

- **The rigs.** The three rigs were built twice from the record's `tools/*.cpp` with `tools/build_player.sh`: once
  against the stock 64-bit library (sha256 5a213c925bc86b61..., the stock library the seventh to twelfth and
  seventeenth registrations cite), and once against library build 15 (471d5d5bd856f37c...) as a control. The
  stock rigs were compiled against SuperDex's headers at its upstream commit, taken unpatched with `git archive`; a
  second stock build against the patched checkout's headers came out identical apart from the 16-byte build id
  ([`bincmp.sh`](bincmp.sh), `bincmp.txt`; checksums in `rigs.txt`). The build-15 rigs are identical to the record's
  `tools/sdx_*64` apart from the same id.
- **The plays.** Every registered play of these rigs made with no switch: 116 plays of runs 028, 029, 032, 034 and
  036, each with the settings and argument order of its play script ([`replay.sh`](replay.sh); every command is in
  `stock/manifest.tsv`). Each play ran with the loader printing the libraries it loaded, so the library is read,
  not assumed.
- **The comparison.** Each output (116 play files and 20 traces) compared byte for byte with the registered file
  ([`compare.sh`](compare.sh), `compare.tsv`), and each play's statistics line with the registered one
  (`stats_compare.txt`).
- **A positive control** ([`control.sh`](control.sh), `control/control.txt`): two of run 029's final-configuration
  plays made (a) on build 15 with every switch, (b) on the stock rig with every switch, and (c) on the stock rig with
  none.

## The result

| Comparison | Files |
|---|---|
| Stock rig against the registered file | **136 of 136 the same** |
| Build-15 rig against the registered file | 136 of 136 the same |
| Stock rig against build-15 rig | 136 of 136 the same |
| Statistics lines, stock and build 15 against the registered | 116 of 116 the same, each |
| Library each play loaded | 136 the stock library (stock rigs); 136 build 15 (build-15 rigs) |
| Plays that exited other than 0 | none |

By run (`compare.tsv`): run 028's chain with SuperDex's Newton-Euler inertia off and on (24 files), run 029's
deformable bodies and grippers (35), run 032's cantilevers, deformable bodies and grippers (47), run 034's
cantilevers and deformable bodies (18), and run 036's deformable bodies (12).

The control: (a) gives the registered files; (b) is the same as (c), so the stock library ignores the switches, as
it holds no patch code; and (b) differs from (a), so the comparison sees a difference when there is one.

## What it shows

**The plays the record calls stock are stock.** Every one of them is made byte for byte by stock SuperDex itself, so
the chain, deformable-body and gripper results of Studies 12 to 16 that are labelled stock need no assumption about
the patches being safe when off.

The design probes that used these rigs with no switch (run 024's `probe_15_deformable.txt` and
`probe_16_gripper.txt`, run 030's `probe_19c_chain.txt` and `probe_21_cantilever.txt`, run 032's
`probes/probe_26_soft_slide.txt`) are summaries, not registered play files, and were not played again.

The scripts are kept as they ran, with the home folder written as `$HOME`; the outputs of the plays are not kept,
since every one is the registered file.
