#!/usr/bin/env bash
# Builds the rigs (the record's sdx_joint, sdx_chain, sdx_player, and this review's sdx_probe) against one library,
# as tools/build_player.sh does (clang++ as c++), into ~/work/probeG/rigs/<name>/.
# usage: build_rigs.sh <name> <superdex source> <superdex build>
set -eu
N="$1"; SRCDIR="$2"; BLD="$3"; P="$HOME/work/probeG"; T="$P/rigs/$N"
mkdir -p "$T" "$P/cxx"; ln -sf "$(command -v clang++)" "$P/cxx/c++"; export PATH="$P/cxx:$PATH"
cp "$P/record/tools/build_player.sh" "$P/record/tools/sdx_joint.cpp" "$P/record/tools/sdx_chain.cpp" "$P/record/tools/sdx_player.cpp" "$P/rigs/sdx_probe.cpp" "$T/"
cd "$T"
for r in sdx_joint sdx_chain sdx_player sdx_probe; do
  SUPERDEX_SRC="$SRCDIR" SUPERDEX_BUILD="$BLD" SRC=$r.cpp OUT=${r}64 LIB=mochi_physics_double ./build_player.sh > build_$r.log 2>&1 || { echo "FAILED $r"; tail -5 build_$r.log; }
done
sha256sum *64 > rigs.sha256; cat rigs.sha256
