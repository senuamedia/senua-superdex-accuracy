#!/usr/bin/env bash
# build_rig.sh <source .cpp> <out name> <superdex src dir> <superdex build dir> : PROBE ONLY. Builds one rig with the
# record's tools/build_player.sh (clang++ on the path as c++, as run 040's play_bench.sh does) into ~/work/probeF/rigs.
set -euo pipefail
SRC="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"; OUTN="$2"; SSRC="$3"; SBLD="$4"
W=~/work/probeF; mkdir -p "$W/rigs" "$W/cxx"
ln -sf "$(command -v clang++)" "$W/cxx/c++"; export PATH="$W/cxx:$PATH"
T="$W/rigtmp.$$"; rm -rf "$T"; mkdir -p "$T"; cp "$W/record/tools/build_player.sh" "$T/"; cp "$SRC" "$T/rig.cpp"
SUPERDEX_SRC="$SSRC" SUPERDEX_BUILD="$SBLD" SRC=rig.cpp OUT="$OUTN" LIB=mochi_physics_double bash "$T/build_player.sh" > "$W/rigs/$OUTN.build.txt" 2>&1
mv "$T/$OUTN" "$W/rigs/$OUTN"; rm -rf "$T"
sha256sum "$W/rigs/$OUTN"
