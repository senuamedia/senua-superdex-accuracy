#!/usr/bin/env bash
# The thirteenth registration's plays (PREREGISTRATION_13.md): the complete patch list, end to end. Every play is
# made under the final configuration: patches A to E with contact damping 5 and a friction falloff of 0.03 m/s, with
# patch F if the eleventh registration's decision took it, and patch G with SuperDex's Newton-Euler inertia if the
# twelfth registration's decision took them. Stock plays are made where a rule compares with stock. One play after
# another, one thread.
# usage: tools/plays/play_13.sh <with F: yes|no> <with G: yes|no> <part> ...        (from the repository root)
#   parts: suites joints limits rotvec cloud deform grip bench
# Needs: the patched rigs and the *_stock rigs; SUPERDEX_ASSETS = the assets directory of the SuperDex source tree
# (grip and bench).
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
O="$R/validation/run_029_end_to_end"; mkdir -p "$O/runs"
WF="${1:?usage: tools/plays/play_13.sh <with F: yes|no> <with G: yes|no> <part> ...}"; WG="${2:?with G: yes|no}"; shift 2
echo "with_f $WF with_g $WG" > "$O/configuration.txt"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
final() {  # the final configuration's switches; NE holds the Newton-Euler setting for articulated rigs
  clear_switches
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1
  [ "$WF" = yes ] && export SUPERDEX_FRICTION_STEP_NORMAL=1
  NE="newtoneuler=0"; if [ "$WG" = yes ]; then export SUPERDEX_INERTIA_TRANSPORT=1; NE="newtoneuler=1"; fi
}
dt_of() { echo "scale=12; 0.01/$1" | bc; }
for part in "$@"; do
case "$part" in
suites)
  # the seventh registration's cubes
  export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
  export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
  ( final; cd "$R" || exit 2
    RIG="$R/tools/sdx_contact64" tools/contact_suite.sh v13_fc ndamp=5 falloff=0.03 || exit 1
    RIG="$R/tools/sdx_contact64" RIGPAIR="$R/tools/sdx_pair64" tools/contact_suite2.sh v13_fc ndamp=5 falloff=0.03 || exit 1
  ) > /dev/null 2>&1 || echo "PLAY FAILED suites"
  mkdir -p "$O/runs/s1" "$O/runs/s2"; rm -rf "$O/runs/s1/fc" "$O/runs/s2/fc"
  cp -R "$R/suites/1/v13_fc" "$O/runs/s1/fc"; cp -R "$R/suites/2/v13_fc" "$O/runs/s2/fc"
  unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP
  ;;
joints)
  # the sixth registration's arm and runs
  final; W="$O/runs/joints_fc"; mkdir -p "$W"; : > "$W/stats.txt"; ARM="mass=2 radius=0.04 arm=0.4"
  play() { local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    "$R/tools/sdx_joint64" "$W/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" $NE | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
  for k in 1 4 16 64; do play spin_be $k gravity=0 omega0=3 secs=1; play torque_be $k gravity=0 torque=1.5 secs=1; play swing_be $k secs=3; done
  for k in 1 16; do play hold_shipped $k coulomb=12 secs=2; play slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; done
  clear_switches
  ;;
limits)
  # the eighth registration's arm and runs
  final; W="$O/runs/limits_fc"; mkdir -p "$W"; : > "$W/stats.txt"; ARM="mass=2 radius=0.04 arm=0.4"; LIM="lo=-0.3 hi=3 limitk=2000"
  play() { local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    "$R/tools/sdx_joint64" "$W/${name}_$k.txt" dt="$(dt_of "$k")" $ARM $LIM "$@" $NE | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
  for k in 1 16; do play rest $k secs=3 limitd=150; play lift $k secs=1.6 limitd=150 torque=15.68 torqueat=1.5; done
  for k in 1 16 64; do play rel20 $k secs=0.5 gravity=0 angle0=-0.33 limitd=20; play rel150 $k secs=0.5 gravity=0 angle0=-0.33 limitd=150; done
  clear_switches
  ;;
rotvec)
  final
  CASES=""
  for ax in 0,-1,0 0,0.6,-0.8 0.36,0.48,0.8 -1,2,2 1,0,0; do
    for an in 8,-4 3,-7 6,-9 2.2,-9 1.8,-9 4,-10 5,-12 2,-14; do CASES="$CASES $ax,$an"; done
  done
  # shellcheck disable=SC2086
  "$R/tools/sdx_rotvec64" "$O/runs/rotvec_fc.txt" $CASES > /dev/null
  clear_switches
  ;;
cloud)
  # a cube of 1.6 kg and half-size 0.035 m on a held cloth sheet (a node every 10 mm, the shipped range of 10 mm)
  for cfg in stock fc; do
    clear_switches; T="$R/tools/sdx_contact64_stock"; EXTRA=""
    if [ $cfg = fc ]; then final; T="$R/tools/sdx_contact64"; EXTRA="ndamp=5 falloff=0.03"; fi
    W="$O/runs/cloud_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" k="$2"; shift 2
      # shellcheck disable=SC2086
      "$T" "$W/${name}_$k.txt" dt="$(dt_of "$k")" mass=1.6 radius=0.035 "$@" floor=cloud cloudwid=0.16 $EXTRA | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
    for k in 1 4; do play oblique $k h0=0.07 secs=0.3 vx0=3.5 mu=0.35; done
    play slide 1 h0=0 secs=0.5 vx0=4 mu=0.35
    play rest 1 h0=0 secs=2
    play hold 1 h0=0 secs=2 mu=0.45 push=4.2336 pushat=0.5
    play slip 1 h0=0 secs=2 mu=0.45 push=8.4672 pushat=0.5
    play lift 1 h0=0 secs=0.4 lift=47.04 liftat=0.3
  done
  clear_switches
  ;;
deform)
  ROD="lin=0.12 ea=150 len=0.6"; STRIP="rhoa=1.2 mmu=500 mlambda=0 len=0.4"; BAR="rho=1100 young=2e6 nu=0 len=0.4"
  FLOOR="mu=0.4"
  for cfg in stock fc; do
    clear_switches; EXTRA=""
    if [ $cfg = fc ]; then final; EXTRA="ndamp=5 falloff=0.03"; fi
    W="$O/runs/deform_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" dt="$2"; shift 2
      # shellcheck disable=SC2086
      "$R/tools/sdx_deform64" "$W/${name}_$dt.txt" dt="$dt" "$@" $EXTRA | sed "s/^STATS/STATS run ${name}_$dt/" >> "$W/stats.txt"; }
    for dt in 0.01 0.001; do
      if [ $cfg = stock ]; then
        # shellcheck disable=SC2086
        { play rod_fall $dt case=rod_fall $ROD ei=3; play shell_fall $dt case=shell_fall $STRIP; play soft_fall $dt case=soft_fall $BAR
          play rod_hang $dt case=rod_hang $ROD ei=3; play shell_hang $dt case=shell_hang $STRIP; play soft_hang $dt case=soft_hang $BAR; }
      fi
      # shellcheck disable=SC2086
      for b in shell soft; do
        play ${b}_rest $dt case=${b}_rest $FLOOR; play ${b}_slide $dt case=${b}_slide $FLOOR v0=0.8; play ${b}_hold $dt case=${b}_hold $FLOOR tilt=0.25
      done
    done
    if [ $cfg = stock ]; then
      # shellcheck disable=SC2086
      for n in 32 64 128; do play cantilever_n$n 0.01 case=rod_cantilever $ROD ei=3 n=$n; done
    fi
  done
  clear_switches
  ;;
grip)
  # the FR3 hand is in SuperDex's superdex_physics/assets, beside the benchmark scenes' assets directory (corrected after
  # the registered run: the first form passed the benchmark's directory and the FR3 plays did not run)
  A="${SUPERDEX_PHYSICS_ASSETS:-${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}/../superdex_physics/assets}"
  # a cube of 0.15 kg and half-size 0.012 m, friction 0.45, a grip of 8 N on each finger (and 0.9 N, reported)
  for cfg in stock fc; do
    clear_switches; EXTRA=""; NE=""
    if [ $cfg = fc ]; then final; EXTRA="ndamp=5 falloff=0.03"; fi
    W="$O/runs/grip_$cfg"; mkdir -p "$W"; touch "$W/stats.txt"
    for g in built fr3; do for grip in 8 0.9; do
      # a play already made is not made again
      if [ -f "$W/${g}_$grip.txt" ] && grep -q "^STATS run ${g}_$grip " "$W/stats.txt"; then continue; fi
      # shellcheck disable=SC2086
      SDX_TRACE="$W/${g}_$grip.tr" "$R/tools/sdx_grip64" "$W/${g}_$grip.txt" gripper=$g assets="$A" mass=0.15 half=0.012 mu=0.45 grip=$grip $EXTRA $NE \
        | sed "s/^STATS/STATS run ${g}_$grip/" >> "$W/stats.txt"
    done; done
  done
  clear_switches
  ;;
bench)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  W="$O/runs/bench"; mkdir -p "$W"; touch "$W/stats.txt"
  for sc in half_cheetah ant cart_pole; do
    for cfg in stock fc; do
      if grep -q "^STATS source ${sc}_$cfg " "$W/stats.txt"; then continue; fi
      clear_switches; T="$R/tools/sdx_player64_stock"; EXTRA=""
      if [ $cfg = fc ]; then final; T="$R/tools/sdx_player64"; EXTRA="ndamp=5 falloff=0.03 $NE"; fi
      # shellcheck disable=SC2086
      SDX_TRACE="$W/${sc}_$cfg.tr" "$T" "$sc" "$A" "$R/actions/13/$sc.txt" "$W/${sc}_$cfg" integ=be maxiter=200 $EXTRA < /dev/null > "$W/${sc}_$cfg.out" 2>&1
      sed "s/^STATS/STATS source ${sc}_$cfg/" "$W/${sc}_$cfg.out" | grep '^STATS' >> "$W/stats.txt"
      tail -1 "$W/stats.txt" | cut -c1-160
    done
  done
  clear_switches
  ;;
*) echo "unknown part $part" >&2; exit 2 ;;
esac
done
