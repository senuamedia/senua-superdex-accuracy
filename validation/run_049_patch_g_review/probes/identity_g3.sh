#!/usr/bin/env bash
# Safe when off, and what the proposed patch G changes: the record's identity check (tools/play_identity.sh, every
# part) played with rigs built against the g3 library, in a copy of run 045's tree (~/work/rec40, read only), and every
# output compared byte for byte with run 045's outputs of the same plays made with library build 15 on this machine.
set -u
P="$HOME/work/probeG"; T="$P/idg3"
rm -rf "$T"; cp -a "$HOME/work/rec40" "$T"
cd "$T"
mv work/_identity work/_ref_b15
cp -a suites suites_ref_b15
mkdir -p "$P/cxx"; ln -sf "$(command -v clang++)" "$P/cxx/c++"; export PATH="$P/cxx:$PATH"
: > "$P/out/idg3_rigs.txt"
for r in contact pair joint rotvec chain player deform grip; do
  SUPERDEX_SRC="$P/g3-src" SUPERDEX_BUILD="$P/build-g3" SRC=sdx_$r.cpp OUT=sdx_${r}64 LIB=mochi_physics_double tools/build_player.sh >> "$P/out/idg3_rigs.txt" 2>&1 || echo "RIG FAILED $r" >> "$P/out/idg3_rigs.txt"
done
sha256sum tools/sdx_*64 >> "$P/out/idg3_rigs.txt"
readelf -d tools/sdx_joint64 | grep -i runpath >> "$P/out/idg3_rigs.txt"
export SUPERDEX_ASSETS="$HOME/work/sdx/superdex-src/assets"
date -u +%FT%TZ > "$P/out/idg3.started"
bash tools/play_identity.sh "$P/out/idg3_identity.txt" rotvec flight suites joints zero fg bench benchrec r032 r034 > "$P/out/idg3_play.log" 2>&1
date -u +%FT%TZ > "$P/out/idg3.finished"
# every output against run 045's (gzip files by content)
cmpall() {  # cmpall <made dir> <reference dir> <label>
  local same=0 diff=0 f rel
  while IFS= read -r f; do
    rel="${f#$1/}"
    if [ ! -f "$2/$rel" ]; then echo "ONLY_G3 $3 $rel"; continue; fi
    case "$f" in
      *.gz) if cmp -s <(zcat "$f") <(zcat "$2/$rel"); then same=$((same + 1)); else diff=$((diff + 1)); echo "CHANGED $3 $rel"; fi ;;
      *) if cmp -s "$f" "$2/$rel"; then same=$((same + 1)); else diff=$((diff + 1)); echo "CHANGED $3 $rel"; fi ;;
    esac
  done < <(find "$1" -type f | sort)
  echo "COMPARED $3 same $same changed $diff"
}
{ cmpall work/_identity work/_ref_b15 identity; cmpall suites suites_ref_b15 suites; } > "$P/out/idg3_compare.txt"
