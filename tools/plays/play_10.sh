#!/usr/bin/env bash
# The tenth registration's plays (PREREGISTRATION_10.md): why SuperDex's solver stops on ant. One play after
# another, one thread. Every play is ant at the shipped step with the solver's trace of every step kept.
# usage: tools/plays/play_10.sh <set> ...        (from the repository root; sets are 0 1 2 3)
#   For each registered command set (actions/10/ant_set<i>.txt, 108 episodes) it plays:
#     stock          the stock library
#     expn           stock with SuperDex's explicitNormals on
#     implicit       stock with SuperDex's implicitNormalForceForDissipation on
#     armijo         stock with SuperDex's Armijo line search on (the control)
#     nudge          stock with the first command of every episode larger by 1 N m (a change of the motion alone)
#     d              the joint limit patch alone (patch D)
#     d_expn         patch D with explicitNormals on
#     ng_stock       stock with no ground
#     ng_d           patch D with no ground
#     rec, rec_f     reported: the recommended configuration (patches A to E), and the same with the friction
#                    correction (patch F)
# Needs: tools/sdx_player64 and tools/sdx_player64_stock; SUPERDEX_ASSETS = the assets directory of the SuperDex
# source tree. Writes validation/run_026_ant_stops/set<i>/<label>.tr (the trace), <label>_enc.pcm and stats.txt.
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
O="$R/validation/run_026_ant_stops"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
REC="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_LIMIT_UNILATERAL=1"
for i in "$@"; do
  W="$O/set$i"; mkdir -p "$W" "$R/work/10/set$i"; touch "$W/stats.txt"
  play() {  # play <label> <rig> <switches or -> <settings...>
    local label="$1" rig="$2" envs="$3"; shift 3
    if [ -f "$W/$label.tr" ] && grep -q "^STATS source $label " "$W/stats.txt"; then return; fi
    clear_switches; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    SDX_TRACE="$W/$label.tr" "$rig" ant "$A" "$R/actions/10/ant_set$i.txt" "$R/work/10/set$i/$label" integ=be maxiter=200 "$@" < /dev/null > "$R/work/10/set$i/$label.out" 2>&1
    clear_switches
    sed "s/^STATS/STATS source $label/" "$R/work/10/set$i/$label.out" | grep '^STATS' >> "$W/stats.txt"
    mv "$R/work/10/set$i/${label}_enc.pcm" "$W/${label}_enc.pcm"
    tail -1 "$W/stats.txt" | cut -c1-150
  }
  ST="$R/tools/sdx_player64_stock"; PT="$R/tools/sdx_player64"
  play stock "$ST" -
  play expn "$ST" - expnormals=1
  play implicit "$ST" - implicitn=1
  play armijo "$ST" - armijo=1
  play nudge "$ST" - nudge=1
  play d "$PT" "SUPERDEX_LIMIT_UNILATERAL=1"
  play d_expn "$PT" "SUPERDEX_LIMIT_UNILATERAL=1" expnormals=1
  play ng_stock "$ST" - ground=0
  play ng_d "$PT" "SUPERDEX_LIMIT_UNILATERAL=1" ground=0
  play rec "$PT" "$REC" ndamp=5 falloff=0.03
  play rec_f "$PT" "$REC SUPERDEX_FRICTION_STEP_NORMAL=1" ndamp=5 falloff=0.03
done
