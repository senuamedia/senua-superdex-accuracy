#!/usr/bin/env bash
# probe_rules.sh <part> : PROBE ONLY (review of patch F). The eleventh registration's rules F0 to F6 read on PROBE
# numbers (fresh cubes, a fresh pair, fresh seeded commands; none registered by any study) under the full
# recommended configuration: patches A to G, contact damping 5, friction falloff 0.03, the solver's tolerances 1e-4
# and 1e-8, each mesh body's grid cell 1/32 of its side (Newton-Euler inertia on the benchmark's articulated agents;
# the cube rigs have none; 1 mm smoothing applies to point clouds only, and no play here has one).
# Writes only under ~/work/probeF (the record clone's suites/ folder is in ~/work/probeF/record).
#   parts: suites bench measure
set -u
W=~/work/probeF; R=$W/record; RG=$W/rigs; O=$W/rules; mkdir -p $O
clear_sw() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT SDX_KPROBE SDX_KPROBE_ON; }
nof() { clear_sw; export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_INERTIA_TRANSPORT=1; }
withf() { nof; export SUPERDEX_FRICTION_STEP_NORMAL=1; }
zero() { clear_sw; export SUPERDEX_FRICTION_FULL_NORMAL=0 SUPERDEX_DAMPING_UNILATERAL=0 SUPERDEX_STICK_DISTANCE=0 SUPERDEX_STICK_DAMPING=0 SUPERDEX_LIMIT_UNILATERAL=0 SUPERDEX_ROTATION_AXIS_EXACT=0 SUPERDEX_FRICTION_STEP_NORMAL=0 SUPERDEX_INERTIA_TRANSPORT=0; }
REC="ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8 sdfdiv=32"
# the probe cubes and pair (fresh: no registration used them)
probe_numbers() {
  export SUITE_CUBE="mass=1.25 radius=0.045" SUITE_H0=0.07 SUITE_VX=2.2 SUITE_VXCHAIN=1.3 SUITE_MU=0.32 SUITE_VSLIDE=2.8 SUITE_MUHOLD=0.55 SUITE_HOLD=4.0425 SUITE_SLIP=8.085 SUITE_LIFT=36.75
  export S2_CUBE="mass=1.25 radius=0.045" S2_MU=0.32 S2_VSTOP=1.05 S2_H0=0.055 S2_PAIR="massa=3.2 ra=0.27 massb=0.55 rb=0.032" S2_MUP=0.37 S2_CARRY=6.79875 S2_SLIP=20.39625 S2_VSIDE=1.1 S2_VTOP=0.75
}
suite() {  # suite <label> <contact rig> <pair rig> <rig settings...>
  local label="$1" rc="$2" rp="$3"; shift 3
  ( cd "$R" || exit 2; probe_numbers
    RIG="$rc" bash tools/contact_suite.sh "$label" "$@" > /dev/null || exit 1
    RIG="$rc" RIGPAIR="$rp" bash tools/contact_suite2.sh "$label" "$@" > /dev/null || exit 1 ) || echo "PLAY FAILED $label"
}
same() {  # same <label a> <label b>: run files identical, both suites
  local a="$1" b="$2" n=0 s=0 d=""
  for f in "$R"/suites/1/"$a"/*_[0-9]*.txt "$R"/suites/2/"$a"/*_[0-9]*.txt; do
    g="${f/\/$a\//\/$b\/}"; n=$((n + 1)); if cmp -s "$f" "$g"; then s=$((s + 1)); else d="$d $(basename "$f")"; fi
  done
  echo "SAME $a against $b : $s of $n${d:+ ; differ:$d}"
}
case "${1:-}" in
suites)
  clear_sw; suite pf_stock "$RG/sdx_contact64_stock" "$RG/sdx_pair64_stock"
  clear_sw; suite pf_off "$RG/sdx_contact64_b15" "$RG/sdx_pair64_b15"
  zero;     suite pf_zero "$RG/sdx_contact64_b15" "$RG/sdx_pair64_b15"
  # shellcheck disable=SC2086
  { clear_sw; suite pf_stockrec "$RG/sdx_contact64_stock" "$RG/sdx_pair64_stock" $REC
    clear_sw; suite pf_offrec "$RG/sdx_contact64_b15" "$RG/sdx_pair64_b15" $REC
    nof;      suite pf_rec_nof "$RG/sdx_contact64_b15" "$RG/sdx_pair64_b15" $REC
    nof;      suite pf_rec_nof_noFlib "$RG/sdx_contact64_noF" "$RG/sdx_pair64_noF" $REC
    withf;    suite pf_rec_f "$RG/sdx_contact64_b15" "$RG/sdx_pair64_b15" $REC
    # the same pair on SuperDex's own grid (no sdfdiv), for item 2 on fresh numbers
    nof;      suite pf_rec_nof_owngrid "$RG/sdx_contact64_b15" "$RG/sdx_pair64_b15" ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8
    withf;    suite pf_rec_f_owngrid "$RG/sdx_contact64_b15" "$RG/sdx_pair64_b15" ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8; }
  clear_sw
  { same pf_off pf_stock; same pf_zero pf_stock; same pf_offrec pf_stockrec; same pf_rec_nof pf_rec_nof_noFlib; } | tee $O/identity_suites.txt ;;
bench)
  A=~/work/sdx/superdex-src/assets; C=$W/actions; mkdir -p $O/bench
  play() {  # play <rig> <scene> <source> <settings...>
    local rig="$1" sc="$2" src="$3"; shift 3
    "$rig" "$sc" "$A" "$C/$sc.txt" "$O/bench/${sc}_$src" "$@" < /dev/null > "$O/bench/${sc}_$src.out" 2>&1
    grep '^STATS' "$O/bench/${sc}_$src.out" | sed "s/^STATS/STATS source $src/" >> "$O/bench/stats.txt"
  }
  : > "$O/bench/stats.txt"
  BR="integ=be maxiter=200 ndamp=5 falloff=0.03 newtoneuler=1 abstol=1e-4 reltol=1e-8"
  for sc in cart_pole half_cheetah ant; do
    ( clear_sw; play "$RG/sdx_player64_stock" $sc stock integ=be maxiter=200 ) &
    ( clear_sw; play "$RG/sdx_player64_b15" $sc off integ=be maxiter=200 ) &
    # shellcheck disable=SC2086
    ( nof; play "$RG/sdx_player64_b15" $sc rec_nof $BR ) &
    # shellcheck disable=SC2086
    ( withf; play "$RG/sdx_player64_b15" $sc rec_f $BR ) &
    wait
    # shellcheck disable=SC2086
    ( nof; play "$RG/sdx_player64_noF" $sc rec_nof_noFlib $BR ) &
    ( zero; play "$RG/sdx_player64_b15" $sc zero integ=be maxiter=200 ) &
    wait
  done
  clear_sw
  for sc in cart_pole half_cheetah ant; do
    for pr in "off stock" "zero stock" "rec_nof_noFlib rec_nof"; do set -- $pr
      if cmp -s "$O/bench/${sc}_$1_enc.pcm" "$O/bench/${sc}_$2_enc.pcm"; then r=identical; else r=DIFFERS; fi
      echo "BENCH $sc $1 against $2 : $r"
    done
  done | tee $O/identity_bench.txt ;;
esac
