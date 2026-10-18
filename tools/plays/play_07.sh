#!/bin/bash
# The seventh registration's plays (PREREGISTRATION_07.md). One play after another, one thread.
# usage: tools/plays/play_07.sh suites | identity | bench        (from the repository root)
#   suites    both suites on the registered cubes under every configuration of the registration
#   identity  the 38 registered benchmark streams of the fifth registration's check, re-played on the patched
#             library with no switch set, each compared with its registered stream
#   bench     half_cheetah and ant on the fifth registration's commands under the recommended configuration
#             corrected, at steps 1 to 1/16
# Needs: tools/sdx_contact64, sdx_pair64, sdx_player64 (the patched library) and the three *_stock rigs (stock);
# SUPERDEX_ASSETS = the assets directory of the SuperDex source tree.
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
O="$R/validation/run_017_counts"; mkdir -p "$O"
clear_switches() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL; }
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
C="SUPERDEX_STICK_DISTANCE=0.0003"
CD="$C SUPERDEX_STICK_DAMPING=1"
# the registered cubes
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
conf() {  # conf <which suites: 1, 2 or 12> <label> <rig suffix: _stock or empty> <switches or -> <rig settings...>
  local which="$1" label="$2" suf="$3" envs="$4"; shift 4
  ( clear_switches
    if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    cd "$R" || exit 2
    case $which in *1*) RIG="$R/tools/sdx_contact64$suf" tools/contact_suite.sh "v7_$label" "$@" || exit 1 ;; esac
    case $which in *2*) RIG="$R/tools/sdx_contact64$suf" RIGPAIR="$R/tools/sdx_pair64$suf" tools/contact_suite2.sh "v7_$label" "$@" || exit 1 ;; esac
  ) > /dev/null 2>&1 || echo "PLAY FAILED $label"
  echo "played $label"
}
case "${1:-}" in
suites)
  conf 12 stock _stock -
  conf 12 off "" -
  conf 2 stick "" "$C"
  conf 2 stickd "" "$CD" falloff=0.03
  conf 12 rec_old "" "$AB $C" ndamp=5
  conf 12 rec_new "" "$AB $CD" ndamp=5 falloff=0.03
  ;;
identity)
  clear_switches
  W="$R/work/_v7_identity"; mkdir -p "$W"; bs=0; bd=0; : > "$O/identity.txt"
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
  clear_switches
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1
  for sc in half_cheetah ant; do
    mkdir -p "$R/streams/07/$sc" "$R/work/07/$sc"; stats="$O/stats_$sc.txt"; touch "$stats"
    for k in 1 2 4 8 16; do
      src="r$k"
      if [ -f "$R/streams/07/$sc/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then continue; fi
      "$R/tools/sdx_player64" "$sc" "$A" "$R/actions/05/$sc.txt" "$R/work/07/$sc/$src" integ=be maxiter=200 ndamp=5 falloff=0.03 sub=$k < /dev/null > "$R/work/07/$sc/$src.out" 2>&1
      sed "s/^STATS/STATS source $src/" "$R/work/07/$sc/$src.out" | grep '^STATS' >> "$stats"
      mv "$R/work/07/$sc/${src}_enc.pcm" "$R/streams/07/$sc/${src}_enc.pcm"
      tail -1 "$stats" | cut -c1-170
    done
  done
  (cd "$R/streams/07" && shasum -a 256 */*.pcm > SHA256SUMS)
  ;;
*) echo "usage: tools/plays/play_07.sh suites | identity | bench"; exit 2 ;;
esac
