#!/bin/bash
# Third registration (PREREGISTRATION_03.md): play every source of every scene, one after another, one thread.
# usage: tools/plays/play_03.sh <superdex assets root> [scene ...]     (from the repository root)
# needs tools/sdx_player64, built against SuperDex with MOCHI_USE_DOUBLE_PRECISION=ON:
#   OUT=sdx_player64 LIB=mochi_physics_double SUPERDEX_BUILD=<the 64-bit build> tools/build_player.sh
# writes streams/03/<scene>/<source>_enc.pcm, work/03/<scene>/<source>_state.f32,
# validation/run_007_counts/stats_<scene>.txt and validation/run_007_counts/identity_<scene>.txt (rule R1: the
# reference played twice, and with the nudge at zero, compared byte for byte, encoder stream and state file).
# A source already played (its stream and its STATS line exist) is skipped, so an interrupted run can be started
# again; SuperDex is deterministic within a build. A source marked "ground" is played only on the scenes whose
# environment adds a ground plane (half_cheetah, ant).
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ASSETS="${1:?usage: tools/plays/play_03.sh <superdex assets root> [scene ...]}"
shift
SCENES="${*:-cart_pole ant half_cheetah}"
OUTDIR="$ROOT/validation/run_007_counts"
mkdir -p "$OUTDIR"
for scene in $SCENES; do
  mkdir -p "$ROOT/streams/03/$scene" "$ROOT/work/03/$scene"
  stats="$OUTDIR/stats_$scene.txt"
  touch "$stats"
  while read -r src where settings; do
    [ -z "$src" ] && continue
    if [ "$where" = ground ] && [ "$scene" = cart_pole ]; then continue; fi
    if [ -f "$ROOT/streams/03/$scene/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then continue; fi
    # shellcheck disable=SC2086
    "$ROOT/tools/sdx_player64" "$scene" "$ASSETS" "$ROOT/actions/03/$scene.txt" "$ROOT/work/03/$scene/$src" $settings < /dev/null \
      > "$ROOT/work/03/$scene/$src.out"
    sed "s/^STATS/STATS source $src/" "$ROOT/work/03/$scene/$src.out" | grep '^STATS' >> "$stats"
    mv "$ROOT/work/03/$scene/${src}_enc.pcm" "$ROOT/streams/03/$scene/${src}_enc.pcm"
    tail -1 "$stats" | cut -c1-220
  done <<'SOURCES'
sref   all    integ=be maxiter=200
srefb  all    integ=be maxiter=200
z      all    integ=be maxiter=200 nudge=0
n9     all    integ=be maxiter=200 nudge=1e-9
n6     all    integ=be maxiter=200 nudge=1e-6
n3     all    integ=be maxiter=200 nudge=1e-3
n0     all    integ=be maxiter=200 nudge=1
t2     all    integ=be maxiter=200 sub=2
t4     all    integ=be maxiter=200 sub=4
t8     all    integ=be maxiter=200 sub=8
t16    all    integ=be maxiter=200 sub=16
t32    all    integ=be maxiter=200 sub=32
t64    all    integ=be maxiter=200 sub=64
g1     ground integ=be maxiter=200 ground=0
g2     ground integ=be maxiter=200 ground=0 sub=2
g4     ground integ=be maxiter=200 ground=0 sub=4
g8     ground integ=be maxiter=200 ground=0 sub=8
g16    ground integ=be maxiter=200 ground=0 sub=16
m1     ground integ=be maxiter=200 mu=0
m2     ground integ=be maxiter=200 mu=0 sub=2
m4     ground integ=be maxiter=200 mu=0 sub=4
m8     ground integ=be maxiter=200 mu=0 sub=8
m16    ground integ=be maxiter=200 mu=0 sub=16
c10    ground integ=be maxiter=200 smooth=0.010
c2     ground integ=be maxiter=200 smooth=0.0025
c1     ground integ=be maxiter=200 smooth=0.00125
c06    ground integ=be maxiter=200 smooth=0.000625
c03    ground integ=be maxiter=200 smooth=0.0003125
s1     all    integ=be maxiter=1
s2     all    integ=be maxiter=2
s4     all    integ=be maxiter=4
s8     all    integ=be maxiter=8
s16    all    integ=be maxiter=16
SOURCES
  id="$OUTDIR/identity_$scene.txt"; : > "$id"
  for other in srefb z; do
    e=0; s=0
    cmp -s "$ROOT/streams/03/$scene/sref_enc.pcm" "$ROOT/streams/03/$scene/${other}_enc.pcm" && e=1
    cmp -s "$ROOT/work/03/$scene/sref_state.f32" "$ROOT/work/03/$scene/${other}_state.f32" && s=1
    echo "IDENTITY $scene sref $other encoder_identical $e state_identical $s" >> "$id"
  done
  cat "$id"
done
