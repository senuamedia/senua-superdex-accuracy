#!/usr/bin/env bash
# Order probe for the design of Study 21's order rule (not registered, decides nothing).
# Plays half_cheetah and ant at steps 1, 1/2, 1/4, 1/8 and 1/16 of the shipped 10 ms step (sub=1 .. 16) on the
# fifth registration's commands (actions/05), with the Linux player rig built against library build 15, under:
#   rec  the recommended configuration: patches A to G, Newton-Euler inertia, contact damping 5, falloff 0.03,
#        backward Euler, iteration limit 200, solver tolerances absTol 1e-4 and relTol 1e-8
#   nof  the same without patch F (SUPERDEX_FRICTION_STEP_NORMAL unset)
#   nog  the same without patch G and Newton-Euler inertia (Study 21's registered variant "nog")
#   shp  control: rec at SuperDex's shipped tolerances (1e-3, 1e-6), which is Study 12's g chain exactly
# Each play writes <streams>/<scene>/<cfg><k>_enc.pcm, appends its STATS line to stats/<scene>.txt, and keeps the
# solver steps its trace reports as stopped (2) or diverged (3) in stops/<scene>_<cfg><k>.txt; the trace and the state
# file are then removed.
# usage: play_probe.sh worker <n>      one of the parallel workers; takes jobs from jobs.txt in order
#        play_probe.sh one <cfg> <scene> <k>
set -u
P="${PROBE_DIR:-$HOME/work/orderprobe}"
A="${SUPERDEX_ASSETS:-$HOME/work/sdx/superdex-src/assets}"
ACT="${PROBE_ACTIONS:-$P/record/actions/05}"
PLAYER="$P/bin/sdx_player64"
S="$P/streams"; mkdir -p "$S" "$P/stats" "$P/stops" "$P/log" "$P/tmp"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
one() {  # one <cfg> <scene> <k>
  local cfg="$1" sc="$2" k="$3" src="$1$3" X
  ( clear_switches
    # patches A to E: every configuration
    export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1
    case "$cfg" in
      rec) export SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1; X="newtoneuler=1 abstol=1e-4 reltol=1e-8" ;;
      nof) export SUPERDEX_INERTIA_TRANSPORT=1; X="newtoneuler=1 abstol=1e-4 reltol=1e-8" ;;
      nog) export SUPERDEX_FRICTION_STEP_NORMAL=1; X="abstol=1e-4 reltol=1e-8" ;;
      shp) export SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1; X="newtoneuler=1" ;;
      *) echo "unknown configuration $cfg" >&2; exit 2 ;;
    esac
    mkdir -p "$S/$sc"
    local t0; t0="$(date +%s)"
    echo "$(date -u +%FT%TZ) start $src $sc" >> "$P/log/plays.txt"
    # shellcheck disable=SC2086
    SDX_TRACE="$P/tmp/${sc}_$src.tr" "$PLAYER" "$sc" "$A" "$ACT/$sc.txt" "$P/tmp/${sc}_$src" integ=be maxiter=200 ndamp=5 falloff=0.03 $X sub=$k \
      < /dev/null > "$P/tmp/${sc}_$src.out" 2>&1
    local rc=$?
    sed "s/^STATS/STATS source $src/" "$P/tmp/${sc}_$src.out" | grep '^STATS' >> "$P/stats/$sc.txt"
    awk '$2 == 2 || $2 == 3' "$P/tmp/${sc}_$src.tr" > "$P/stops/${sc}_$src.txt"
    mv "$P/tmp/${sc}_${src}_enc.pcm" "$S/$sc/${src}_enc.pcm"
    rm -f "$P/tmp/${sc}_$src.tr" "$P/tmp/${sc}_${src}_state.f32"
    echo "$(date -u +%FT%TZ) end $src $sc rc $rc wall_s $(( $(date +%s) - t0 ))" >> "$P/log/plays.txt"
  )
}
case "${1:-}" in
one) one "$2" "$3" "$4" ;;
worker)
  n="$2"
  while :; do
    # take the next job under a lock: jobs.txt is the queue, next.txt the index of the next job to take
    job="$(flock "$P/queue.lock" bash -c 'i=$(cat "'"$P"'/next.txt"); j=$(sed -n "$((i + 1))p" "'"$P"'/jobs.txt"); [ -n "$j" ] && echo $((i + 1)) > "'"$P"'/next.txt"; echo "$j"')"
    [ -z "$job" ] && break
    # shellcheck disable=SC2086
    one $job
  done
  echo "$(date -u +%FT%TZ) worker $n done" >> "$P/log/plays.txt"
  ;;
*) echo "usage: play_probe.sh worker <n> | one <cfg> <scene> <k>"; exit 2 ;;
esac
