#!/bin/bash
# Fourth registration (PREREGISTRATION_04.md), part B: the time-step chain of half_cheetah and ant with the ground,
# with a contact that has a loss of its own (SuperDex's normal viscous damping coefficient at 5 on every actor;
# shipped: 0). Played on the THIRD registration's commands (actions/03/), so each source differs from that
# registration's shipped source of the same step by the damping alone.
# usage: tools/plays/play_04.sh <superdex assets root> [scene ...]     (from the repository root)
# needs tools/sdx_player64 (the 64-bit rig). Writes streams/04/<scene>/<source>_enc.pcm, work/04/<scene>/ and
# validation/run_011_counts/stats_<scene>.txt. A source already played is skipped.
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ASSETS="${1:?usage: tools/plays/play_04.sh <superdex assets root> [scene ...]}"
shift
SCENES="${*:-ant half_cheetah}"
OUTDIR="$ROOT/validation/run_011_counts"
mkdir -p "$OUTDIR"
for scene in $SCENES; do
  mkdir -p "$ROOT/streams/04/$scene" "$ROOT/work/04/$scene"
  stats="$OUTDIR/stats_$scene.txt"
  touch "$stats"
  while read -r src where settings; do
    [ -z "$src" ] && continue
    if [ "$where" != all ] && [ "$where" != "$scene" ]; then continue; fi
    if [ -f "$ROOT/streams/04/$scene/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then continue; fi
    # shellcheck disable=SC2086
    "$ROOT/tools/sdx_player64" "$scene" "$ASSETS" "$ROOT/actions/03/$scene.txt" "$ROOT/work/04/$scene/$src" $settings < /dev/null \
      > "$ROOT/work/04/$scene/$src.out"
    sed "s/^STATS/STATS source $src/" "$ROOT/work/04/$scene/$src.out" | grep '^STATS' >> "$stats"
    mv "$ROOT/work/04/$scene/${src}_enc.pcm" "$ROOT/streams/04/$scene/${src}_enc.pcm"
    tail -1 "$stats" | cut -c1-220
  done <<'SOURCES'
d1     all  integ=be maxiter=200 ndamp=5
d2     all  integ=be maxiter=200 ndamp=5 sub=2
d4     all  integ=be maxiter=200 ndamp=5 sub=4
d8     all  integ=be maxiter=200 ndamp=5 sub=8
d16    all  integ=be maxiter=200 ndamp=5 sub=16
d32    all  integ=be maxiter=200 ndamp=5 sub=32
d64    ant  integ=be maxiter=200 ndamp=5 sub=64
SOURCES
done
(cd "$ROOT/streams/04" && shasum -a 256 */*.pcm > SHA256SUMS)
