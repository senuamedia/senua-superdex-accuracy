#!/bin/bash
# Play every source of the registered design, one after another: three scenes, fifteen sources each.
# usage: tools/plays/play_01.sh <superdex assets root> [scene ...]     (from the repository root, after build_player.sh)
# writes streams/01/<scene>/<source>_enc.pcm, work/<scene>/<source>_state.f32 and validation/run_001_counts/stats_<scene>.txt
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ASSETS="${1:?usage: tools/plays/play_01.sh <superdex assets root> [scene ...]}"
shift
SCENES="${*:-cart_pole half_cheetah ant}"
mkdir -p "$ROOT/validation/run_001_counts"
for scene in $SCENES; do
  mkdir -p "$ROOT/streams/01/$scene" "$ROOT/work/$scene"
  stats="$ROOT/validation/run_001_counts/stats_$scene.txt"
  : > "$stats"
  while read -r src settings; do
    [ -z "$src" ] && continue
    # shellcheck disable=SC2086
    "$ROOT/tools/sdx_player" "$scene" "$ASSETS" "$ROOT/actions/01/$scene.txt" "$ROOT/work/$scene/$src" $settings < /dev/null \
      | sed "s/^STATS/STATS source $src/" >> "$stats"
    mv "$ROOT/work/$scene/${src}_enc.pcm" "$ROOT/streams/01/$scene/${src}_enc.pcm"
    tail -1 "$stats"
  done <<'SOURCES'
s1   integ=be maxiter=1
s2   integ=be maxiter=2
s4   integ=be maxiter=4
s8   integ=be maxiter=8
s16  integ=be maxiter=16
base integ=be maxiter=200
t2   integ=be maxiter=200 sub=2
t4   integ=be maxiter=200 sub=4
t8   integ=be maxiter=200 sub=8
tref integ=bdf2 maxiter=200 sub=16
b1   integ=bdf2 maxiter=200
c10  integ=be maxiter=200 smooth=0.010
c2   integ=be maxiter=200 smooth=0.0025
c1   integ=be maxiter=200 smooth=0.00125
cref integ=be maxiter=200 smooth=0.000625
SOURCES
done
