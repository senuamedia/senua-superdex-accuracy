#!/usr/bin/env bash
# G9 on probe commands (fresh, from awk's generator with seeds no study used; uniform in -32767..32767 as the record's
# commands are), Meta's three scenes at the shipped step: the full recommended configuration with patch G and
# Newton-Euler inertia, and the same without them. Also the same plays with no switch at all, for safe-when-off.
# usage: probe_bench.sh <library: stock | cur | g3> <configurations...: rec nog off>
set -u
P="$HOME/work/probeG"; LIB="${1:?library}"; shift; RG="$P/rigs/$LIB"; O="$P/out/bench_$LIB"; mkdir -p "$O" "$P/actions"
A="$HOME/work/sdx/superdex-src/assets"
ALL="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1"
NOG="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1"
gen() {  # gen <scene> <episodes> <steps> <per> <seed>
  local f="$P/actions/$1.txt"; [ -f "$f" ] && return
  awk -v e=$2 -v s=$3 -v p=$4 -v seed=$5 'BEGIN { srand(seed); print e, s, p; for (i = 0; i < e*s; i++) { l = ""; for (j = 0; j < p; j++) l = l (j ? " " : "") (int(rand()*65535) - 32767); print l } }' > "$f"
}
gen half_cheetah 108 40 6 9104417; gen ant 108 40 8 9104423; gen cart_pole 108 100 1 9104431
for cfg in "$@"; do for sc in half_cheetah ant cart_pole; do
  case $cfg in
    rec) envs="$ALL"; set_="ndamp=5 falloff=0.03 newtoneuler=1 abstol=1e-4 reltol=1e-8" ;;
    nog) envs="$NOG"; set_="ndamp=5 falloff=0.03 newtoneuler=0 abstol=1e-4 reltol=1e-8" ;;
    off) envs=""; set_="" ;;
  esac
  # shellcheck disable=SC2086
  env -i PATH="$PATH" $envs "$RG/sdx_player64" $sc "$A" "$P/actions/$sc.txt" "$O/${sc}_$cfg" integ=be maxiter=200 $set_ < /dev/null 2>&1 \
    | grep '^STATS' | sed "s/^STATS/STATS $cfg/" >> "$O/stats.txt"
done; done
