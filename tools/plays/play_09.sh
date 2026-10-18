#!/usr/bin/env bash
# The ninth registration's plays (PREREGISTRATION_09.md): the rotation vector of a small rotation, and the solver steps
# it stops. One play after another, one thread.
# usage: tools/plays/play_09.sh rotvec | flight | suites | joints | identity | bench        (from the repository root)
#   rotvec    the registered rotations through SuperDex's quaternion: stock, the patched library with no switch,
#             and the patched library with SUPERDEX_ROTATION_AXIS_EXACT=1
#   flight    two free cubes that collide and part, at steps 1, 1/4, 1/16 and 1/64, under the same three, with the
#             solver's trace of every step
#   suites    both contact suites on the seventh registration's cubes: the patched library with no switch (to compare
#             with stock), the recommended configuration with no rotation switch (to compare with the seventh
#             registration's files), stock contact with the rotation switch, and the recommended configuration with it
#   joints    the 40 registered one-joint runs (sixth and eighth registrations) on the patched library with no switch,
#             and with the rotation switch
#   identity  the 38 registered benchmark streams re-played on the patched library with no switch set
#   bench     the three scenes at the shipped step with the rotation switch alone (source e1), then half_cheetah and
#             ant at steps 1 to 1/16 under the recommended configuration with the rotation switch added (sources
#             y1 .. y16); commands: the fifth registration's (half_cheetah, ant) and the third's (cart_pole)
# Needs: the four patched rigs and the four *_stock rigs, tools/sdx_rotvec64 and tools/sdx_rotvec64_stock (the stock
# one built against an unpatched SuperDex source tree); SUPERDEX_ASSETS = the assets directory of the SuperDex source
# (identity and bench only).
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
O="$R/validation/run_021_rotation"; D="$R/rotation"; mkdir -p "$O" "$D"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT; }
dt_of() { echo "scale=12; 0.01/$1" | bc; }
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
case "${1:-}" in
rotvec)
  clear_switches
  # the registered rotations: five axes (the last is x, the control) by eight angles
  CASES=""
  for ax in 0,-1,0 0,0.6,-0.8 0.36,0.48,0.8 -1,2,2 1,0,0; do
    for an in 8,-4 3,-7 6,-9 2.2,-9 1.8,-9 4,-10 5,-12 2,-14; do CASES="$CASES $ax,$an"; done
  done
  # shellcheck disable=SC2086
  "$R/tools/sdx_rotvec64_stock" "$D/rotvec_stock.txt" $CASES || exit 1
  # shellcheck disable=SC2086
  "$R/tools/sdx_rotvec64" "$D/rotvec_off.txt" $CASES || exit 1
  # shellcheck disable=SC2086
  SUPERDEX_ROTATION_AXIS_EXACT=1 "$R/tools/sdx_rotvec64" "$D/rotvec_patched.txt" $CASES || exit 1
  ;;
flight)
  # the registered cubes: A 5 kg and half-size 0.2 m, B 0.8 kg and half-size 0.05 m, B at 1.5 m/s into A's side
  PAIR="massa=5 ra=0.2 massb=0.8 rb=0.05"
  : > "$O/stats_flight.txt"
  for cfg in stock off patched; do
    clear_switches
    case $cfg in
      stock) T="$R/tools/sdx_pair64_stock" ;;
      off) T="$R/tools/sdx_pair64" ;;
      patched) T="$R/tools/sdx_pair64"; export SUPERDEX_ROTATION_AXIS_EXACT=1 ;;
    esac
    for k in 1 4 16 64; do
      # shellcheck disable=SC2086
      SDX_TRACE="$D/flight_${cfg}_$k.tr" "$T" "$D/flight_${cfg}_$k" dt="$(dt_of "$k")" $PAIR layout=side vxb=1.5 secs=0.5 \
        | sed "s/^STATS/STATS run flight_${cfg}_$k/" >> "$O/stats_flight.txt"
    done
  done
  clear_switches
  ;;
suites)
  # the seventh registration's cubes
  export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
  export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
  conf() {  # conf <label> <switches or -> <rig settings...>
    local label="$1" envs="$2"; shift 2
    ( clear_switches
      if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
      cd "$R" || exit 2
      RIG="$R/tools/sdx_contact64" tools/contact_suite.sh "v9_$label" "$@" || exit 1
      RIG="$R/tools/sdx_contact64" RIGPAIR="$R/tools/sdx_pair64" tools/contact_suite2.sh "v9_$label" "$@" || exit 1
    ) > /dev/null 2>&1 || echo "PLAY FAILED $label"
    echo "played $label"
  }
  conf off -
  conf rec "$AB $CD" ndamp=5 falloff=0.03
  conf stock_e "$E"
  conf rec_e "$AB $CD $E" ndamp=5 falloff=0.03
  ;;
joints)
  ARM="mass=2 radius=0.04 arm=0.4"; LIM="lo=-0.3 hi=3 limitk=2000"
  T="$R/tools/sdx_joint64"
  for cfg in off patched; do
    clear_switches; [ "$cfg" = patched ] && export SUPERDEX_ROTATION_AXIS_EXACT=1
    W="$R/work/09/joints_$cfg"; mkdir -p "$W"; same=0; diff=0
    chk() {  # chk <registered folder> <name> <k> <settings...>
      local dir="$1" name="$2" k="$3"; shift 3
      # shellcheck disable=SC2086
      "$T" "$W/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" > /dev/null 2>&1
      if cmp -s "$W/${name}_$k.txt" "$R/$dir/${name}_$k.txt"; then same=$((same+1)); else diff=$((diff+1)); echo "DIFFERS $cfg ${name}_$k"; fi
    }
    for k in 1 4 16 64; do chk joints spin_be $k gravity=0 omega0=3 secs=1; chk joints torque_be $k gravity=0 torque=1.5 secs=1; chk joints swing_be $k secs=3; done
    for integ in bdf2 dirk33; do chk joints spin_$integ 1 gravity=0 omega0=3 secs=1 integ=$integ; chk joints torque_$integ 1 gravity=0 torque=1.5 secs=1 integ=$integ; chk joints swing_$integ 1 secs=3 integ=$integ; done
    for w in 1 2 4 8; do chk joints spinrate$w 1 gravity=0 omega0=$w secs=1; done
    for k in 1 16; do chk joints hold_shipped $k coulomb=12 secs=2; chk joints hold_tight $k coulomb=12 secs=2 falloff=0.000001; chk joints slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; chk joints slip_tight $k gravity=0 coulomb=2 torque=3 secs=1 falloff=0.000001; done
    # shellcheck disable=SC2086
    for k in 1 16; do chk limits/stock rest $k $LIM secs=3 limitd=150; chk limits/stock lift $k $LIM secs=1.6 limitd=150 torque=15.68 torqueat=1.5; done
    # shellcheck disable=SC2086
    for k in 1 16 64; do chk limits/stock rel20 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=20; chk limits/stock rel150 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=150; done
    echo "JOINTS $cfg identical to the registered stock files $same of $((same+diff))" | tee "$O/joints_identity_$cfg.txt"
  done
  clear_switches
  ;;
identity)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  clear_switches
  W="$R/work/_v9_identity"; mkdir -p "$W"; bs=0; bd=0; : > "$O/identity.txt"
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
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  one() {  # one <scene> <source> <commands file> <settings...>
    local sc="$1" src="$2" act="$3"; shift 3
    mkdir -p "$R/streams/09/$sc" "$R/work/09/$sc"; local stats="$O/stats_$sc.txt"; touch "$stats"
    if [ -f "$R/streams/09/$sc/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then return; fi
    SDX_TRACE="$R/work/09/$sc/$src.tr" "$R/tools/sdx_player64" "$sc" "$A" "$act" "$R/work/09/$sc/$src" integ=be maxiter=200 "$@" < /dev/null > "$R/work/09/$sc/$src.out" 2>&1
    sed "s/^STATS/STATS source $src/" "$R/work/09/$sc/$src.out" | grep '^STATS' >> "$stats"
    mv "$R/work/09/$sc/${src}_enc.pcm" "$R/streams/09/$sc/${src}_enc.pcm"
    tail -1 "$stats" | cut -c1-170
  }
  clear_switches; export SUPERDEX_ROTATION_AXIS_EXACT=1
  one half_cheetah e1 "$R/actions/05/half_cheetah.txt"
  one ant e1 "$R/actions/05/ant.txt"
  one cart_pole e1 "$R/actions/03/cart_pole.txt"
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1
  for sc in half_cheetah ant; do for k in 1 2 4 8 16; do one $sc y$k "$R/actions/05/$sc.txt" ndamp=5 falloff=0.03 sub=$k; done; done
  (cd "$R/streams/09" && shasum -a 256 */*.pcm > SHA256SUMS)
  clear_switches
  ;;
*) echo "usage: tools/plays/play_09.sh rotvec | flight | suites | joints | identity | bench"; exit 2 ;;
esac
