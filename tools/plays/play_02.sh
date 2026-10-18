#!/bin/bash
# Second registration (PREREGISTRATION_02.md): play every source of every scene, one after another, one thread.
# usage: tools/plays/play_02.sh <superdex assets root> [scene ...]     (from the repository root)
# needs two rigs: tools/sdx_player   built against SuperDex as shipped (32-bit arithmetic), and
#                 tools/sdx_player64 built against SuperDex with MOCHI_USE_DOUBLE_PRECISION=ON:
#                   OUT=sdx_player64 LIB=mochi_physics_double SUPERDEX_BUILD=<the 64-bit build> tools/build_player.sh
# writes streams/02/<scene>/<source>_enc.pcm, work/02/<scene>/<source>_state.f32 and
# validation/run_004_counts/stats_<scene>.txt. A source already played (its stream and its STATS line exist) is
# skipped, so an interrupted run can be started again; SuperDex is deterministic within a build.
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ASSETS="${1:?usage: tools/plays/play_02.sh <superdex assets root> [scene ...]}"
shift
SCENES="${*:-cart_pole ant half_cheetah}"
OUTDIR="$ROOT/validation/run_004_counts"
mkdir -p "$OUTDIR"
for scene in $SCENES; do
  mkdir -p "$ROOT/streams/02/$scene" "$ROOT/work/02/$scene"
  stats="$OUTDIR/stats_$scene.txt"
  touch "$stats"
  while read -r src bits settings; do
    [ -z "$src" ] && continue
    if [ -f "$ROOT/streams/02/$scene/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then continue; fi
    rig="$ROOT/tools/sdx_player64"; [ "$bits" = 32 ] && rig="$ROOT/tools/sdx_player"
    # shellcheck disable=SC2086
    "$rig" "$scene" "$ASSETS" "$ROOT/actions/02/$scene.txt" "$ROOT/work/02/$scene/$src" $settings < /dev/null \
      > "$ROOT/work/02/$scene/$src.out"
    sed "s/^STATS/STATS source $src/" "$ROOT/work/02/$scene/$src.out" | grep '^STATS' >> "$stats"
    mv "$ROOT/work/02/$scene/${src}_enc.pcm" "$ROOT/streams/02/$scene/${src}_enc.pcm"
    tail -1 "$stats" | cut -c1-220
  done <<'SOURCES'
ship32 32 integ=be maxiter=4
s1     64 integ=be maxiter=1
s2     64 integ=be maxiter=2
s4     64 integ=be maxiter=4
s8     64 integ=be maxiter=8
s16    64 integ=be maxiter=16
sref   64 integ=be maxiter=200
sref2  64 integ=be maxiter=1000
nref   64 integ=be maxiter=200 exacth=1
tight  64 integ=be maxiter=200 abstol=1e-6 reltol=1e-9
t2     64 integ=be maxiter=200 sub=2
t4     64 integ=be maxiter=200 sub=4
t8     64 integ=be maxiter=200 sub=8
t16    64 integ=be maxiter=200 sub=16
b16    64 integ=bdf2 maxiter=200 sub=16
b32    64 integ=bdf2 maxiter=200 sub=32
c10    64 integ=be maxiter=200 smooth=0.010
c2     64 integ=be maxiter=200 smooth=0.0025
c1     64 integ=be maxiter=200 smooth=0.00125
c06    64 integ=be maxiter=200 smooth=0.000625
c03    64 integ=be maxiter=200 smooth=0.0003125
SOURCES
done
