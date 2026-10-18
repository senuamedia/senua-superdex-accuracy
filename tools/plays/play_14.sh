#!/usr/bin/env bash
# The fourteenth registration's plays (PREREGISTRATION_14.md): the five open items fixed, and two configurations
# end to end. One play after another, one thread.
#   final       the shipped step (10 ms), backward Euler: patches A to G with SuperDex's Newton-Euler inertia, contact
#               damping 5, friction falloff 0.03 m/s, the solver's tolerances at 1e-4 (absolute) and 1e-8
#               (relative), each mesh body's grid cell 1/32 of its side, smoothing 1 mm on a body that meets a point
#               cloud
#   accurate    the same with BDF2 and patch G's BDF2 share, at 1/16 of the step (0.625 ms), at SuperDex's shipped
#               solver tolerances
# usage: tools/plays/play_14.sh <part> ...        (from the repository root)
#   parts: items suites joints limits rotvec cloud deform grip bench accurate
# Needs: library build 13, the patched rigs and the *_stock rigs; SUPERDEX_ASSETS = the assets directory of the
# SuperDex source tree (grip, bench, accurate).
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
O="$R/validation/run_032_open_items"; mkdir -p "$O/runs"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
final() {  # every switch of patches A to G
  clear_switches
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1
}
TOL="abstol=1e-4 reltol=1e-8"
CON="ndamp=5 falloff=0.03"                # the contact settings of both configurations
dt_of() { echo "scale=12; 0.01/$1" | bc; }
SUITE1="mass=0.8 radius=0.035"
s7() {  # the seventh registration's cubes for both contact suites
  export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
  export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
}
s7_unset() { unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP; }
for part in "$@"; do
case "$part" in
items)
  W="$O/runs/items"; mkdir -p "$W"; : > "$W/stats.txt"
  final
  # item 1: the light cube's slip (T15) on three pairs, SuperDex's own grid and each cube's cell at 1/32 of its side
  slip() { local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    "$R/tools/sdx_pair64" "$W/${name}_$k" dt="$(dt_of "$k")" layout=stack pushat=0.5 secs=0.9 $CON $TOL "$@" | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
  P11="massa=3 ra=0.25 massb=0.5 rb=0.03 mu=0.45 pusha=23.1525"
  P7="massa=4 ra=0.3 massb=0.6 rb=0.03 mu=0.4 pusha=27.048"
  PF="massa=3.5 ra=0.28 massb=0.45 rb=0.028 mu=0.42 pusha=24.3873"
  for k in 1 16; do
    # shellcheck disable=SC2086
    { slip p11_own $k $P11; slip p11_div $k $P11 sdfdiv=32; slip p7_div $k $P7 sdfdiv=32; slip pf_own $k $PF; slip pf_div $k $PF sdfdiv=32; slip p11_box $k $P11 collider=box; }
  done
  # item 2: the twelfth registration's arm and free chain at the tight tolerances
  for w in 1.5 3.5 6; do for k in 1 4 16; do
    "$R/tools/sdx_joint64" "$W/spin${w}_$k.txt" dt="$(dt_of "$k")" mass=2.4 radius=0.05 arm=0.45 gravity=0 omega0=$w secs=1 newtoneuler=1 $TOL | sed "s/^STATS/STATS run spin${w}_$k/" >> "$W/stats.txt"
  done; done
  ARMS="mass1=1.2 mass2=0.6 radius=0.04 arm1=0.25 len1=0.5 arm2=0.2"
  # shellcheck disable=SC2086
  for k in 1 4 16; do "$R/tools/sdx_chain64" "$W/chainfree_$k.txt" dt="$(dt_of "$k")" $ARMS gravity=0 angle2=-0.9 omega1=2.5 omega2=1.5 secs=2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run chainfree_$k/" >> "$W/stats.txt"; done
  # item 4: the thirteenth registration's rod and a fresh one as cantilevers, both clamps, stock
  clear_switches
  for n in 32 64 128; do
    for cm in 0 1; do
      "$R/tools/sdx_deform64" "$W/cant13_c${cm}_n$n.txt" case=rod_cantilever dt=0.01 lin=0.12 ea=150 len=0.6 ei=3 n=$n clampmid=$cm | sed "s/^STATS/STATS run cant13_c${cm}_n$n/" >> "$W/stats.txt"
      "$R/tools/sdx_deform64" "$W/cantf_c${cm}_n$n.txt" case=rod_cantilever dt=0.01 lin=0.15 ea=250 len=0.45 ei=1.2 n=$n clampmid=$cm | sed "s/^STATS/STATS run cantf_c${cm}_n$n/" >> "$W/stats.txt"
    done
  done
  # item 5: a fresh arm and chain under BDF2, with patch G's share and without patch G
  for g in g nog; do
    final; [ $g = nog ] && unset SUPERDEX_INERTIA_TRANSPORT
    for k in 1 4 16; do
      "$R/tools/sdx_joint64" "$W/b2${g}_swing_$k.txt" dt="$(dt_of "$k")" mass=1.5 radius=0.05 arm=0.35 secs=3 integ=bdf2 newtoneuler=1 | sed "s/^STATS/STATS run b2${g}_swing_$k/" >> "$W/stats.txt"
      "$R/tools/sdx_joint64" "$W/b2${g}_spin_$k.txt" dt="$(dt_of "$k")" mass=1.5 radius=0.05 arm=0.35 gravity=0 omega0=4 secs=1 integ=bdf2 newtoneuler=1 | sed "s/^STATS/STATS run b2${g}_spin_$k/" >> "$W/stats.txt"
      "$R/tools/sdx_chain64" "$W/b2${g}_chainswing_$k.txt" dt="$(dt_of "$k")" mass1=1 mass2=0.8 radius=0.04 arm1=0.3 len1=0.55 arm2=0.25 gravity=1 angle1=0.5 angle2=-0.6 secs=2 integ=bdf2 newtoneuler=1 | sed "s/^STATS/STATS run b2${g}_chainswing_$k/" >> "$W/stats.txt"
      "$R/tools/sdx_chain64" "$W/b2${g}_chainfree_$k.txt" dt="$(dt_of "$k")" mass1=1 mass2=0.8 radius=0.04 arm1=0.3 len1=0.55 arm2=0.25 gravity=0 angle2=-0.8 omega1=2 omega2=1.2 secs=2 integ=bdf2 newtoneuler=1 | sed "s/^STATS/STATS run b2${g}_chainfree_$k/" >> "$W/stats.txt"
    done
  done
  # and the same fresh arm and chain under backward Euler with patch G, for the comparison
  final
  for k in 1 4 16; do
    "$R/tools/sdx_joint64" "$W/be_swing_$k.txt" dt="$(dt_of "$k")" mass=1.5 radius=0.05 arm=0.35 secs=3 newtoneuler=1 $TOL | sed "s/^STATS/STATS run be_swing_$k/" >> "$W/stats.txt"
    "$R/tools/sdx_chain64" "$W/be_chainswing_$k.txt" dt="$(dt_of "$k")" mass1=1 mass2=0.8 radius=0.04 arm1=0.3 len1=0.55 arm2=0.25 gravity=1 angle1=0.5 angle2=-0.6 secs=2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run be_chainswing_$k/" >> "$W/stats.txt"
  done
  clear_switches
  ;;
suites)
  for cfg in final accurate; do
    integ=be; FT="$TOL"; [ $cfg = accurate ] && { integ=bdf2; FT=""; }
    ( s7; final; cd "$R" || exit 2
      # shellcheck disable=SC2086
      RIG="$R/tools/sdx_contact64" tools/contact_suite.sh v14_$cfg $CON $FT sdfdiv=32 integ=$integ || exit 1
      # shellcheck disable=SC2086
      RIG="$R/tools/sdx_contact64" RIGPAIR="$R/tools/sdx_pair64" tools/contact_suite2.sh v14_$cfg $CON $FT sdfdiv=32 integ=$integ || exit 1
    ) > /dev/null 2>&1 || echo "PLAY FAILED suites $cfg"
    mkdir -p "$O/runs/s1" "$O/runs/s2"; rm -rf "$O/runs/s1/$cfg" "$O/runs/s2/$cfg"
    cp -R "$R/suites/1/v14_$cfg" "$O/runs/s1/$cfg"; cp -R "$R/suites/2/v14_$cfg" "$O/runs/s2/$cfg"
  done
  ;;
joints)
  # the sixth registration's arm and runs: final at every step it was played at; accurate at 1/16
  final; ARM="mass=2 radius=0.04 arm=0.4"
  for cfg in final accurate; do
    W="$O/runs/joints_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    X="newtoneuler=1 $TOL"; ks="1 4 16 64"; [ $cfg = accurate ] && { X="newtoneuler=1 integ=bdf2"; ks="16"; }
    play() { local name="$1" k="$2"; shift 2
      # shellcheck disable=SC2086
      "$R/tools/sdx_joint64" "$W/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" $X | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
    for k in $ks; do play spin $k gravity=0 omega0=3 secs=1; play torque $k gravity=0 torque=1.5 secs=1; play swing $k secs=3; done
    for k in 1 16; do [ $cfg = accurate ] && [ $k = 1 ] && continue; play hold $k coulomb=12 secs=2; play slip $k gravity=0 coulomb=2 torque=3 secs=1; done
  done
  # the twelfth registration's chain under the accurate configuration at 1/16
  W="$O/runs/joints_accurate"; ARMS="mass1=1.2 mass2=0.6 radius=0.04 arm1=0.25 len1=0.5 arm2=0.2"
  # shellcheck disable=SC2086
  { "$R/tools/sdx_chain64" "$W/chainfree_16.txt" dt="$(dt_of 16)" $ARMS gravity=0 angle2=-0.9 omega1=2.5 omega2=1.5 secs=2 newtoneuler=1 integ=bdf2 | sed "s/^STATS/STATS run chainfree_16/" >> "$W/stats.txt"
    "$R/tools/sdx_chain64" "$W/chainswing_16.txt" dt="$(dt_of 16)" $ARMS gravity=1 angle1=0.4 angle2=-0.7 secs=2 newtoneuler=1 integ=bdf2 | sed "s/^STATS/STATS run chainswing_16/" >> "$W/stats.txt"; }
  clear_switches
  ;;
limits)
  # the eighth registration's arm and runs: final at its steps; accurate at 1/16 and 1/64
  final; ARM="mass=2 radius=0.04 arm=0.4"; LIM="lo=-0.3 hi=3 limitk=2000"
  for cfg in final accurate; do
    W="$O/runs/limits_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    X="newtoneuler=1 $TOL"; [ $cfg = accurate ] && X="newtoneuler=1 integ=bdf2"
    play() { local name="$1" k="$2"; shift 2
      # shellcheck disable=SC2086
      "$R/tools/sdx_joint64" "$W/${name}_$k.txt" dt="$(dt_of "$k")" $ARM $LIM "$@" $X | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
    for k in 1 16; do [ $cfg = accurate ] && [ $k = 1 ] && continue; play rest $k secs=3 limitd=150; play lift $k secs=1.6 limitd=150 torque=15.68 torqueat=1.5; done
    for k in 1 16 64; do [ $cfg = accurate ] && [ $k = 1 ] && continue; play rel20 $k secs=0.5 gravity=0 angle0=-0.33 limitd=20; play rel150 $k secs=0.5 gravity=0 angle0=-0.33 limitd=150; done
  done
  clear_switches
  ;;
rotvec)
  final
  CASES=""
  for ax in 0,-1,0 0,0.6,-0.8 0.36,0.48,0.8 -1,2,2 1,0,0; do
    for an in 8,-4 3,-7 6,-9 2.2,-9 1.8,-9 4,-10 5,-12 2,-14; do CASES="$CASES $ax,$an"; done
  done
  # shellcheck disable=SC2086
  "$R/tools/sdx_rotvec64" "$O/runs/rotvec_final.txt" $CASES > /dev/null
  clear_switches
  ;;
cloud)
  # the thirteenth registration's cube (1.6 kg, half-size 0.035 m) on the held sheet (a node every 10 mm)
  for cfg in stock final accurate; do
    clear_switches; T="$R/tools/sdx_contact64_stock"; X=""; ks="1 4"; one=1
    if [ $cfg != stock ]; then final; T="$R/tools/sdx_contact64"; X="$CON $TOL sdfdiv=32 smooth=0.001"; fi
    if [ $cfg = accurate ]; then X="$CON sdfdiv=32 smooth=0.001 integ=bdf2"; ks="16"; one=16; fi
    W="$O/runs/cloud_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" k="$2"; shift 2
      # shellcheck disable=SC2086
      "$T" "$W/${name}_$k.txt" dt="$(dt_of "$k")" mass=1.6 radius=0.035 "$@" floor=cloud cloudwid=0.16 $X | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
    for k in $ks; do play oblique $k h0=0.07 secs=0.3 vx0=3.5 mu=0.35; done
    play slide $one h0=0 secs=0.5 vx0=4 mu=0.35
    play rest $one h0=0 secs=2
    play hold $one h0=0 secs=2 mu=0.45 push=4.2336 pushat=0.5
    play slip $one h0=0 secs=2 mu=0.45 push=8.4672 pushat=0.5
    play lift $one h0=0 secs=0.4 lift=47.04 liftat=0.3
  done
  clear_switches
  ;;
deform)
  ROD="lin=0.12 ea=150 len=0.6"; STRIP="rhoa=1.2 mmu=500 mlambda=0 len=0.4"; BAR="rho=1100 young=2e6 nu=0 len=0.4"
  FLOOR="mu=0.45"
  for cfg in stock final accurate; do
    clear_switches; X=""; dts="0.01 0.001"
    [ $cfg != stock ] && { final; X="ndamp=5 falloff=0.03 $TOL"; }
    [ $cfg = accurate ] && { X="ndamp=5 falloff=0.03 integ=bdf2"; dts="0.000625"; }
    W="$O/runs/deform_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" dt="$2"; shift 2
      # shellcheck disable=SC2086
      "$R/tools/sdx_deform64" "$W/${name}_$dt.txt" dt="$dt" "$@" $X | sed "s/^STATS/STATS run ${name}_$dt/" >> "$W/stats.txt"; }
    for dt in $dts; do
      if [ $cfg = stock ]; then
        # shellcheck disable=SC2086
        { play rod_fall $dt case=rod_fall $ROD ei=3; play shell_fall $dt case=shell_fall $STRIP; play soft_fall $dt case=soft_fall $BAR
          play rod_hang $dt case=rod_hang $ROD ei=3; play shell_hang $dt case=shell_hang $STRIP; play soft_hang $dt case=soft_hang $BAR; }
      fi
      # shellcheck disable=SC2086
      for b in shell soft; do
        play ${b}_rest $dt case=${b}_rest $FLOOR; play ${b}_slide $dt case=${b}_slide $FLOOR v0=0.7; play ${b}_hold $dt case=${b}_hold $FLOOR tilt=0.3
      done
    done
    if [ $cfg = stock ]; then
      # shellcheck disable=SC2086
      for n in 32 64 128; do play cantilever_n$n 0.01 case=rod_cantilever $ROD ei=3 n=$n clampmid=1; done
    fi
  done
  clear_switches
  ;;
grip)
  A="${SUPERDEX_PHYSICS_ASSETS:-${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}/../superdex_physics/assets}"
  # a cube of 0.15 kg and half-size 0.012 m, friction 0.45, a grip of 8 N on each finger (and 0.9 N, reported)
  for cfg in stock final accurate; do
    clear_switches; X=""; k=1
    [ $cfg != stock ] && { final; X="ndamp=5 falloff=0.03 newtoneuler=1 $TOL"; }
    [ $cfg = accurate ] && { X="ndamp=5 falloff=0.03 newtoneuler=1 integ=bdf2"; k=16; }
    W="$O/runs/grip_$cfg"; mkdir -p "$W"; touch "$W/stats.txt"
    for g in built fr3; do for grip in 8 0.9; do
      if [ -f "$W/${g}_$grip.txt" ] && grep -q "^STATS run ${g}_$grip " "$W/stats.txt"; then continue; fi
      # shellcheck disable=SC2086
      SDX_TRACE="$W/${g}_$grip.tr" "$R/tools/sdx_grip64" "$W/${g}_$grip.txt" gripper=$g assets="$A" mass=0.15 half=0.012 mu=0.45 grip=$grip dt="$(dt_of $k)" $X \
        | sed "s/^STATS/STATS run ${g}_$grip/" >> "$W/stats.txt"
    done; done
  done
  clear_switches
  ;;
bench)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  W="$O/runs/bench"; mkdir -p "$W"; touch "$W/stats.txt"
  for sc in half_cheetah ant cart_pole; do
    for cfg in stock final accurate; do
      if grep -q "^STATS source ${sc}_$cfg " "$W/stats.txt"; then continue; fi
      clear_switches; T="$R/tools/sdx_player64_stock"; X="integ=be"
      [ $cfg != stock ] && { final; T="$R/tools/sdx_player64"; X="integ=be ndamp=5 falloff=0.03 newtoneuler=1 $TOL"; }
      [ $cfg = accurate ] && X="integ=bdf2 sub=16 ndamp=5 falloff=0.03 newtoneuler=1"
      # shellcheck disable=SC2086
      SDX_TRACE="$W/${sc}_$cfg.tr" "$T" "$sc" "$A" "$R/actions/14/$sc.txt" "$W/${sc}_$cfg" maxiter=200 $X < /dev/null > "$W/${sc}_$cfg.out" 2>&1
      sed "s/^STATS/STATS source ${sc}_$cfg/" "$W/${sc}_$cfg.out" | grep '^STATS' >> "$W/stats.txt"
      rm -f "$W/${sc}_${cfg}_state.f32"
      tail -1 "$W/stats.txt" | cut -c1-160
    done
  done
  clear_switches
  ;;
*) echo "unknown part $part" >&2; exit 2 ;;
esac
done
