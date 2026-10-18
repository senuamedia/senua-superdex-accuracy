#!/usr/bin/env bash
# Run 040: the record's own identity check (tools/play_identity.sh) played on Linux. Run 039 found the seventh study's
# 134 registered suite files made again byte for byte by SuperDex built on Linux with Clang 18. Here every rig is built
# on Linux against run 039's patched library build and play_identity.sh plays its parts against the registered files,
# as Study 16 played them on the laptop: rotvec (the ninth study's 40 rotations), flight (two free cubes at four steps),
# suites (both suites with no switch, with patches A to D, with patch E alone, and with A to E), joints (the 40
# one-joint runs of the sixth and eighth studies), zero (every switch set to 0), fg (the configurations with patch G).
# The benchmark streams (bench, benchrec) are a later step. Not registered: a replication probe.
# usage: play.sh <work folder of run 039 step 1>   (from the root of a copy of this repository)
set -u
WD="$(cd "${1:?usage: play.sh <work folder>}" && pwd)"
O=validation/run_040_linux_identity; mkdir -p $O
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
for r in contact pair joint rotvec chain player; do
  SUPERDEX_SRC=$WD/superdex-patched-src SUPERDEX_BUILD=$WD/build-patched SRC=sdx_$r.cpp OUT=sdx_${r}64 \
    LIB=mochi_physics_double tools/build_player.sh > /dev/null
done
sha256sum tools/sdx_*64 > $O/rigs.sha256
export SUPERDEX_ASSETS=$WD/superdex-src/superdex_physics/assets
date -u +%FT%TZ > $O/started.txt
tools/play_identity.sh $O/identity.txt rotvec flight suites joints zero fg > $O/play.txt 2>&1
date -u +%FT%TZ > $O/finished.txt
