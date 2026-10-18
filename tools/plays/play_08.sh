#!/bin/bash
# The eighth registration's benchmark plays (PREREGISTRATION_08.md). One play after another, one thread.
# usage: tools/plays/play_08.sh identity | bench        (from the repository root)
#   identity  the 38 registered benchmark streams re-played on the patched library with no switch set
#   bench     the three scenes at the shipped step with the joint limit patch alone (source u1), then half_cheetah
#             and ant at steps 1 to 1/16 under the recommended configuration corrected with the joint limit patch
#             added (sources z1 .. z16); commands: the fifth registration's (half_cheetah, ant) and the third's
#             (cart_pole)
# Needs: tools/sdx_player64 (the patched library); SUPERDEX_ASSETS = the assets directory of the SuperDex source.
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
O="$R/validation/run_019_limits"; mkdir -p "$O"
clear_switches() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL; }
case "${1:-}" in
identity)
  clear_switches
  W="$R/work/_v8_identity"; mkdir -p "$W"; bs=0; bd=0; : > "$O/identity.txt"
  chk() {  # chk <scene> <source> <registered streams dir> <settings...>
    local sc="$1" src="$2" dir="$3"; shift 3
    "$R/tools/sdx_player64" "$sc" "$A" "$R/actions/03/$sc.txt" "$W/${sc}_$src" "$@" < /dev/null > "$W/${sc}_$src.out" 2>&1
    if cmp -s "$W/${sc}_${src}_enc.pcm" "$R/$dir/$sc/${src}_enc.pcm"; then bs=$((bs+1)); echo "SAME $sc $src" >> "$O/identity.txt"; else bd=$((bd+1)); echo "DIFFERS $sc $src" | tee -a "$O/identity.txt"; fi
  }
  B="integ=be maxiter=200"
  for sc in cart_pole ant half_cheetah; do
    case $sc in
      cart_pole) L="sref srefb z n9 n6 n3 n0 t2 t4 t8 t16 t32 t64 s1 s2 s4 s8 s16" ;;
      ant) L="sref t2 s4 s16 c10 c2 c1 c06 c03 g1 m1 d1 d2" ;;
      half_cheetah) L="sref t2 s1 s16 c03 m1 d1" ;;
    esac
    for src in $L; do
      case $src in
        sref|srefb) chk $sc $src streams/03 $B ;;
        z) chk $sc $src streams/03 $B nudge=0 ;;
        n9) chk $sc $src streams/03 $B nudge=1e-9 ;; n6) chk $sc $src streams/03 $B nudge=1e-6 ;;
        n3) chk $sc $src streams/03 $B nudge=1e-3 ;; n0) chk $sc $src streams/03 $B nudge=1 ;;
        t2|t4|t8|t16|t32|t64) chk $sc $src streams/03 $B sub=${src#t} ;;
        s1|s2|s4|s8|s16) chk $sc $src streams/03 integ=be maxiter=${src#s} ;;
        c10) chk $sc $src streams/03 $B smooth=0.010 ;; c2) chk $sc $src streams/03 $B smooth=0.0025 ;;
        c1) chk $sc $src streams/03 $B smooth=0.00125 ;; c06) chk $sc $src streams/03 $B smooth=0.000625 ;;
        c03) chk $sc $src streams/03 $B smooth=0.0003125 ;;
        g1) chk $sc $src streams/03 $B ground=0 ;; m1) chk $sc $src streams/03 $B mu=0 ;;
        d1) chk $sc $src streams/04 $B ndamp=5 ;; d2) chk $sc $src streams/04 $B ndamp=5 sub=2 ;;
      esac
    done
  done
  echo "IDENTITY benchmark $bs of $((bs+bd))" | tee -a "$O/identity.txt"
  ;;
bench)
  one() {  # one <scene> <source> <commands file> <settings...>
    local sc="$1" src="$2" act="$3"; shift 3
    mkdir -p "$R/streams/08/$sc" "$R/work/08/$sc"; local stats="$O/stats_$sc.txt"; touch "$stats"
    if [ -f "$R/streams/08/$sc/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then return; fi
    "$R/tools/sdx_player64" "$sc" "$A" "$act" "$R/work/08/$sc/$src" integ=be maxiter=200 "$@" < /dev/null > "$R/work/08/$sc/$src.out" 2>&1
    sed "s/^STATS/STATS source $src/" "$R/work/08/$sc/$src.out" | grep '^STATS' >> "$stats"
    mv "$R/work/08/$sc/${src}_enc.pcm" "$R/streams/08/$sc/${src}_enc.pcm"
    tail -1 "$stats" | cut -c1-170
  }
  clear_switches; export SUPERDEX_LIMIT_UNILATERAL=1
  one half_cheetah u1 "$R/actions/05/half_cheetah.txt"
  one ant u1 "$R/actions/05/ant.txt"
  one cart_pole u1 "$R/actions/03/cart_pole.txt"
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1
  for sc in half_cheetah ant; do for k in 1 2 4 8 16; do one $sc z$k "$R/actions/05/$sc.txt" ndamp=5 falloff=0.03 sub=$k; done; done
  (cd "$R/streams/08" && shasum -a 256 */*.pcm > SHA256SUMS)
  ;;
*) echo "usage: tools/plays/play_08.sh identity | bench"; exit 2 ;;
esac
