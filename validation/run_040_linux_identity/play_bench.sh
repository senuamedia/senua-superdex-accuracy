#!/usr/bin/env bash
# Run 040, step 3: the identity check's benchmark streams played on Linux. Step 1 played play_identity.sh's parts
# rotvec, flight, suites, joints, zero and fg; the player rig was not built then, because the copy of the repository
# sent to the machine left out tools/sdx_player.cpp. Here the player is built with Clang 18 against run 039's patched
# library build, as the other rigs were, and play_identity.sh plays its parts bench (the 38 benchmark streams of the
# third and fourth studies, no switch, against stock) and benchrec (the ninth study's 7 benchmark streams under its
# switches). Not registered: a replication probe.
# usage: play_bench.sh <work folder of run 039 step 1>   (from the root of the copy of this repository step 1 played in)
set -u
WD="$(cd "${1:?usage: play_bench.sh <work folder>}" && pwd)"
O=validation/run_040_linux_identity; mkdir -p $O
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
SUPERDEX_SRC=$WD/superdex-patched-src SUPERDEX_BUILD=$WD/build-patched SRC=sdx_player.cpp OUT=sdx_player64 \
  LIB=mochi_physics_double tools/build_player.sh > $O/build_player.txt 2>&1
sha256sum tools/sdx_player64 > $O/player.sha256
# the benchmark scenes are in the top-level assets folder of the SuperDex tree (a first attempt pointed at
# superdex_physics/assets, which holds the rigs' scenes but not the benchmarks; its output is kept as first_attempt_*)
export SUPERDEX_ASSETS=$WD/superdex-src/assets
date -u +%FT%TZ > $O/bench_started.txt
tools/play_identity.sh $O/identity_bench.txt bench benchrec > $O/play_bench.txt 2>&1
date -u +%FT%TZ > $O/bench_finished.txt
