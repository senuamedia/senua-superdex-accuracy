#!/usr/bin/env bash
# Safe when off, for any build of the patched library: every registered play of the record is made again and
# compared byte for byte with the registered file. Part one uses no switch at all, against stock's registered files.
# Part two sets the switches of each registered configuration, against that configuration's registered files, so a
# new build cannot quietly change a correction that is already registered. One play after another, one thread.
# usage: tools/play_identity.sh <out file> [part ...]        (from the repository root)
#   parts (default: all): rotvec flight suites joints zero fg bench benchrec r032 r034
#   rotvec    the ninth study's 40 rotations, no switch, against stock (1 file)
#   flight    the ninth study's two free cubes at steps 1, 1/4, 1/16 and 1/64, no switch, against stock (8 files)
#   suites    both contact suites on the seventh study's cubes: no switch against stock (67 files); patches A to D
#             against the seventh study's recommended files (67); patch E alone and patches A to E against the ninth
#             study's files (67 and 67)
#   joints    the 40 one-joint runs of the sixth and eighth studies, no switch, against stock
#   fg        the registered configurations with patch G: the twelfth study's arm and chain under its two
#             corrections, and the thirteenth's arm and limit runs under patches A to G (44 files)
#   zero      every switch set to 0, which must mean off: both suites and the 40 one-joint runs, against stock (107)
#   r032      the fourteenth registration's whole run made again and compared file by file with run 032
#   r034      the fifteenth registration's whole run made again and compared file by file with run 034
#   bench     the 38 benchmark streams of the third and fourth studies, no switch, against stock
#   benchrec  the ninth study's benchmark streams under its switches: patch E alone at the shipped step on the
#             three scenes, and patches A to E on half_cheetah and ant at the shipped step and at 1/4 of it (7)
# Appends one line a part to <out file>: "IDENTITY <part> <identical> of <played>", and a line for every file that
# differs. Needs the patched rigs (tools/sdx_*64), tools/sdx_rotvec64, and for bench and benchrec
# SUPERDEX_ASSETS = the assets directory of the SuperDex source tree.
set -u
R="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:?usage: tools/play_identity.sh <out file> [part ...]}"; shift
PARTS="${*:-rotvec flight suites joints zero fg bench benchrec r032 r034}"
W="$R/work/_identity"; mkdir -p "$W"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
dt_of() { echo "scale=12; 0.01/$1" | bc; }
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
same=0; diff=0
tally() {  # tally <label> <played file> <registered file>
  if cmp -s "$2" "$3"; then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS $1" >> "$OUT"; fi
}
report() { echo "IDENTITY $1 $same of $((same + diff))" | tee -a "$OUT"; same=0; diff=0; }
for part in $PARTS; do
case "$part" in
rotvec)
  clear_switches
  CASES=""
  for ax in 0,-1,0 0,0.6,-0.8 0.36,0.48,0.8 -1,2,2 1,0,0; do
    for an in 8,-4 3,-7 6,-9 2.2,-9 1.8,-9 4,-10 5,-12 2,-14; do CASES="$CASES $ax,$an"; done
  done
  # shellcheck disable=SC2086
  "$R/tools/sdx_rotvec64" "$W/rotvec.txt" $CASES > /dev/null 2>&1
  tally "rotvec" "$W/rotvec.txt" "$R/rotation/rotvec_stock.txt"
  report rotvec
  ;;
flight)
  clear_switches
  for k in 1 4 16 64; do
    "$R/tools/sdx_pair64" "$W/flight_$k" dt="$(dt_of "$k")" massa=5 ra=0.2 massb=0.8 rb=0.05 layout=side vxb=1.5 secs=0.5 > /dev/null 2>&1
    for c in a b; do tally "flight_${k}_$c" "$W/flight_${k}_$c.txt" "$R/rotation/flight_stock_${k}_$c.txt"; done
  done
  report flight
  ;;
suites)
  export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
  export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
  conf() {  # conf <label> <switches or -> <registered s1 dir> <registered s2 dir> <rig settings...>
    local label="$1" envs="$2" r1="$3" r2="$4" x; shift 4
    ( clear_switches
      if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
      cd "$R" || exit 2
      RIG="$R/tools/sdx_contact64" tools/contact_suite.sh "id_$label" "$@" || exit 1
      RIG="$R/tools/sdx_contact64" RIGPAIR="$R/tools/sdx_pair64" tools/contact_suite2.sh "id_$label" "$@" || exit 1
    ) > /dev/null 2>&1 || echo "PLAY FAILED suites $label" >> "$OUT"
    for x in "$r1"/*_[0-9]*.txt; do tally "suite $label $(basename "$x")" "$R/suites/1/id_$label/$(basename "$x")" "$x"; done
    for x in "$r2"/*_[0-9]*.txt; do tally "suite2 $label $(basename "$x")" "$R/suites/2/id_$label/$(basename "$x")" "$x"; done
    report "suites_$label"
  }
  S7="$R/validation/run_017_counts/runs"; S9="$R/validation/run_021_rotation/runs"
  conf off - "$S7/s1/stock" "$S7/s2/stock"
  conf abcd "$AB $CD" "$S7/s1/rec_new" "$S7/s2/rec_new" ndamp=5 falloff=0.03
  conf e "$E" "$S9/s1/stock_e" "$S9/s2/stock_e"
  conf abcde "$AB $CD $E" "$S9/s1/rec_e" "$S9/s2/rec_e" ndamp=5 falloff=0.03
  unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP
  ;;
joints)
  clear_switches
  ARM="mass=2 radius=0.04 arm=0.4"; LIM="lo=-0.3 hi=3 limitk=2000"
  T="$R/tools/sdx_joint64"; mkdir -p "$W/joints"
  chk() {  # chk <registered folder> <name> <k> <settings...>
    local dir="$1" name="$2" k="$3"; shift 3
    # shellcheck disable=SC2086
    "$T" "$W/joints/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" > /dev/null 2>&1
    tally "joint ${name}_$k" "$W/joints/${name}_$k.txt" "$R/$dir/${name}_$k.txt"
  }
  for k in 1 4 16 64; do chk joints spin_be $k gravity=0 omega0=3 secs=1; chk joints torque_be $k gravity=0 torque=1.5 secs=1; chk joints swing_be $k secs=3; done
  for integ in bdf2 dirk33; do chk joints spin_$integ 1 gravity=0 omega0=3 secs=1 integ=$integ; chk joints torque_$integ 1 gravity=0 torque=1.5 secs=1 integ=$integ; chk joints swing_$integ 1 secs=3 integ=$integ; done
  for w in 1 2 4 8; do chk joints spinrate$w 1 gravity=0 omega0=$w secs=1; done
  for k in 1 16; do chk joints hold_shipped $k coulomb=12 secs=2; chk joints hold_tight $k coulomb=12 secs=2 falloff=0.000001; chk joints slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; chk joints slip_tight $k gravity=0 coulomb=2 torque=3 secs=1 falloff=0.000001; done
  # shellcheck disable=SC2086
  for k in 1 16; do chk limits/stock rest $k $LIM secs=3 limitd=150; chk limits/stock lift $k $LIM secs=1.6 limitd=150 torque=15.68 torqueat=1.5; done
  # shellcheck disable=SC2086
  for k in 1 16 64; do chk limits/stock rel20 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=20; chk limits/stock rel150 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=150; done
  report joints
  ;;
zero)
  # every switch set to 0, which must mean off: both contact suites on the seventh study's cubes and the 40 one-joint
  # runs, against stock's registered files (107)
  ZERO="SUPERDEX_FRICTION_FULL_NORMAL=0 SUPERDEX_DAMPING_UNILATERAL=0 SUPERDEX_STICK_DISTANCE=0 SUPERDEX_STICK_DAMPING=0 SUPERDEX_LIMIT_UNILATERAL=0 SUPERDEX_ROTATION_AXIS_EXACT=0 SUPERDEX_FRICTION_STEP_NORMAL=0 SUPERDEX_INERTIA_TRANSPORT=0"
  export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
  export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
  S7="$R/validation/run_017_counts/runs"
  ( clear_switches; for kv in $ZERO; do export "$kv"; done; cd "$R" || exit 2
    RIG="$R/tools/sdx_contact64" tools/contact_suite.sh id_zero || exit 1
    RIG="$R/tools/sdx_contact64" RIGPAIR="$R/tools/sdx_pair64" tools/contact_suite2.sh id_zero || exit 1
  ) > /dev/null 2>&1 || echo "PLAY FAILED zero" >> "$OUT"
  for x in "$S7/s1/stock"/*_[0-9]*.txt; do tally "zero suite $(basename "$x")" "$R/suites/1/id_zero/$(basename "$x")" "$x"; done
  for x in "$S7/s2/stock"/*_[0-9]*.txt; do tally "zero suite2 $(basename "$x")" "$R/suites/2/id_zero/$(basename "$x")" "$x"; done
  unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP
  clear_switches; for kv in $ZERO; do export "$kv"; done
  ARM="mass=2 radius=0.04 arm=0.4"; LIM="lo=-0.3 hi=3 limitk=2000"
  T="$R/tools/sdx_joint64"; mkdir -p "$W/zero"
  zj() {  # zj <registered folder> <name> <k> <settings...>
    local dir="$1" name="$2" k="$3"; shift 3
    # shellcheck disable=SC2086
    "$T" "$W/zero/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" > /dev/null 2>&1
    tally "zero joint ${name}_$k" "$W/zero/${name}_$k.txt" "$R/$dir/${name}_$k.txt"
  }
  for k in 1 4 16 64; do zj joints spin_be $k gravity=0 omega0=3 secs=1; zj joints torque_be $k gravity=0 torque=1.5 secs=1; zj joints swing_be $k secs=3; done
  for integ in bdf2 dirk33; do zj joints spin_$integ 1 gravity=0 omega0=3 secs=1 integ=$integ; zj joints torque_$integ 1 gravity=0 torque=1.5 secs=1 integ=$integ; zj joints swing_$integ 1 secs=3 integ=$integ; done
  for w in 1 2 4 8; do zj joints spinrate$w 1 gravity=0 omega0=$w secs=1; done
  for k in 1 16; do zj joints hold_shipped $k coulomb=12 secs=2; zj joints hold_tight $k coulomb=12 secs=2 falloff=0.000001; zj joints slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; zj joints slip_tight $k gravity=0 coulomb=2 torque=3 secs=1 falloff=0.000001; done
  # shellcheck disable=SC2086
  for k in 1 16; do zj limits/stock rest $k $LIM secs=3 limitd=150; zj limits/stock lift $k $LIM secs=1.6 limitd=150 torque=15.68 torqueat=1.5; done
  # shellcheck disable=SC2086
  for k in 1 16 64; do zj limits/stock rel20 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=20; zj limits/stock rel150 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=150; done
  clear_switches
  report zero
  ;;
r032)
  # the fourteenth registration's whole run (run 032) made again from a copy of its play script that writes elsewhere,
  # every file compared with the registered one (the solver traces registered compressed are compared decompressed)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  RO="$W/r032"; rm -rf "$RO"; mkdir -p "$RO"
  sed -e "s|^R=\"\$(cd \"\$(dirname \"\$0\")/../..\" \&\& pwd)\"|R=\"$R\"|" -e "s|O=\"\$R/validation/run_032_open_items\"|O=\"$RO\"|" \
    "$R/tools/plays/play_14.sh" > "$W/play14_replay.sh"
  ( cd "$R" || exit 2; SUPERDEX_ASSETS="$A" bash "$W/play14_replay.sh" items suites joints limits rotvec cloud deform grip bench ) > "$W/r032.log" 2>&1
  REG="$R/validation/run_032_open_items/runs"
  while IFS= read -r f; do
    rel="${f#$REG/}"
    case "$rel" in
      *.tr.gz) if gzip -dc "$f" | cmp -s - "$RO/runs/${rel%.gz}"; then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS r032 $rel" >> "$OUT"; fi ;;
      # the benchmark's statistics carry the wall-clock time of the play, which is compared without that one field
      bench/*.out|bench/stats.txt) if [ -f "$RO/runs/$rel" ] && cmp -s <(sed 's/ wall_s [0-9.]*//' "$f") <(sed 's/ wall_s [0-9.]*//' "$RO/runs/$rel"); then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS r032 $rel" >> "$OUT"; fi ;;
      *) tally "r032 $rel" "$RO/runs/$rel" "$f" ;;
    esac
  done < <(find "$REG" -type f | sort)
  report r032
  ;;
r034)
  # the fifteenth registration's whole run (run 034) made again from a copy of its play script that writes elsewhere,
  # every play file compared with the registered one (the solver traces registered compressed are compared
  # decompressed); the copy of the fourteenth registration's script it writes, its difference and its log carry the
  # folder it was written to and are not compared. Needs SUPERDEX_BUILD13 for the review part, as the run did
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  RO="$W/r034"; mkdir -p "$RO"; [ -e "$RO/accurate14" ] && mv "$RO/accurate14" "$RO/accurate14.old.$$"
  sed -e "s|^R=\"\$(cd \"\$(dirname \"\$0\")/../..\" \&\& pwd)\"|R=\"$R\"|" -e "s|O=\"\$R/validation/run_034_replication\"|O=\"$RO\"|" \
    "$R/tools/plays/play_15.sh" > "$W/play15_replay.sh"
  ( cd "$R" || exit 2; SUPERDEX_ASSETS="$A" bash "$W/play15_replay.sh" items deform review long accurate14 ) > "$W/r034.log" 2>&1
  REG="$R/validation/run_034_replication"
  while IFS= read -r f; do
    rel="${f#$REG/}"
    case "$rel" in
      *.tr.gz) if gzip -dc "$f" | cmp -s - "$RO/${rel%.gz}"; then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS r034 $rel" >> "$OUT"; fi ;;
      accurate14/runs/bench/*.out|accurate14/runs/bench/stats.txt) if [ -f "$RO/$rel" ] && cmp -s <(sed 's/ wall_s [0-9.]*//' "$f") <(sed 's/ wall_s [0-9.]*//' "$RO/$rel"); then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS r034 $rel" >> "$OUT"; fi ;;
      *) tally "r034 $rel" "$RO/$rel" "$f" ;;
    esac
  done < <(find "$REG/runs" "$REG/accurate14/runs" -type f | sort)
  report r034
  ;;
fg)
  # the registered configurations with patch G (and F), against their registered files: the twelfth study's arm
  # under both of its corrections (9) and its chain under both at the shipped and the tight tolerances (9); the
  # thirteenth study's arm and limit runs under the final configuration, patches A to G (16 and 10)
  T="$R/tools/sdx_joint64"; TC="$R/tools/sdx_chain64"; mkdir -p "$W/fg"
  clear_switches; export SUPERDEX_INERTIA_TRANSPORT=1
  for w in 1.5 3.5 6; do for k in 1 4 16; do
    "$T" "$W/fg/spin${w}_$k.txt" dt="$(dt_of "$k")" mass=2.4 radius=0.05 arm=0.45 gravity=0 omega0=$w secs=1 newtoneuler=1 > /dev/null 2>&1
    tally "fg arm spin${w}_$k" "$W/fg/spin${w}_$k.txt" "$R/validation/run_028_joint_motion/arm/neg/spin${w}_$k.txt"
  done; done
  ARMS="mass1=1.2 mass2=0.6 radius=0.04 arm1=0.25 len1=0.5 arm2=0.2"
  for k in 1 4 16; do
    # shellcheck disable=SC2086
    "$TC" "$W/fg/free_$k.txt" dt="$(dt_of "$k")" $ARMS gravity=0 angle2=-0.9 omega1=2.5 omega2=1.5 secs=2 newtoneuler=1 > /dev/null 2>&1
    tally "fg chain free_$k" "$W/fg/free_$k.txt" "$R/validation/run_028_joint_motion/chain/neg/free_$k.txt"
    # shellcheck disable=SC2086
    "$TC" "$W/fg/swing_$k.txt" dt="$(dt_of "$k")" $ARMS gravity=1 angle1=0.4 angle2=-0.7 secs=2 newtoneuler=1 > /dev/null 2>&1
    tally "fg chain swing_$k" "$W/fg/swing_$k.txt" "$R/validation/run_028_joint_motion/chain/neg/swing_$k.txt"
    # shellcheck disable=SC2086
    "$TC" "$W/fg/tight_$k.txt" dt="$(dt_of "$k")" $ARMS gravity=0 angle2=-0.9 omega1=2.5 omega2=1.5 secs=2 newtoneuler=1 abstol=1e-9 reltol=1e-12 > /dev/null 2>&1
    tally "fg chain tight free_$k" "$W/fg/tight_$k.txt" "$R/validation/run_028_joint_motion/chain/neg_tight/free_$k.txt"
  done
  # shellcheck disable=SC2086
  export $AB $CD $E SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_FRICTION_STEP_NORMAL=1
  ARM="mass=2 radius=0.04 arm=0.4"; LIM="lo=-0.3 hi=3 limitk=2000"; J="$R/validation/run_029_end_to_end/runs"
  fj() {  # fj <registered folder> <name> <k> <settings...>
    local dir="$1" name="$2" k="$3"; shift 3
    # shellcheck disable=SC2086
    "$T" "$W/fg/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" newtoneuler=1 > /dev/null 2>&1
    tally "fg $dir ${name}_$k" "$W/fg/${name}_$k.txt" "$J/$dir/${name}_$k.txt"
  }
  for k in 1 4 16 64; do fj joints_fc spin_be $k gravity=0 omega0=3 secs=1; fj joints_fc torque_be $k gravity=0 torque=1.5 secs=1; fj joints_fc swing_be $k secs=3; done
  for k in 1 16; do fj joints_fc hold_shipped $k coulomb=12 secs=2; fj joints_fc slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; done
  # shellcheck disable=SC2086
  for k in 1 16; do fj limits_fc rest $k $LIM secs=3 limitd=150; fj limits_fc lift $k $LIM secs=1.6 limitd=150 torque=15.68 torqueat=1.5; done
  # shellcheck disable=SC2086
  for k in 1 16 64; do fj limits_fc rel20 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=20; fj limits_fc rel150 $k $LIM secs=0.5 gravity=0 angle0=-0.33 limitd=150; done
  clear_switches
  report fg
  ;;
bench)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  clear_switches
  mkdir -p "$W/bench"
  chk() {  # chk <scene> <source> <registered streams dir> <settings...>
    local sc="$1" src="$2" dir="$3"; shift 3
    "$R/tools/sdx_player64" "$sc" "$A" "$R/actions/03/$sc.txt" "$W/bench/${sc}_$src" "$@" < /dev/null > "$W/bench/${sc}_$src.out" 2>&1
    tally "benchmark $sc $src" "$W/bench/${sc}_${src}_enc.pcm" "$R/$dir/$sc/${src}_enc.pcm"
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
  report bench
  ;;
benchrec)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  mkdir -p "$W/benchrec"
  one() {  # one <scene> <source> <commands file> <settings...>
    local sc="$1" src="$2" act="$3"; shift 3
    "$R/tools/sdx_player64" "$sc" "$A" "$act" "$W/benchrec/${sc}_$src" integ=be maxiter=200 "$@" < /dev/null > "$W/benchrec/${sc}_$src.out" 2>&1
    tally "benchmark under its switches $sc $src" "$W/benchrec/${sc}_${src}_enc.pcm" "$R/streams/09/$sc/${src}_enc.pcm"
  }
  clear_switches; export SUPERDEX_ROTATION_AXIS_EXACT=1
  one half_cheetah e1 "$R/actions/05/half_cheetah.txt"
  one ant e1 "$R/actions/05/ant.txt"
  one cart_pole e1 "$R/actions/03/cart_pole.txt"
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1
  for sc in half_cheetah ant; do for k in 1 4; do one $sc y$k "$R/actions/05/$sc.txt" ndamp=5 falloff=0.03 sub=$k; done; done
  clear_switches
  report benchrec
  ;;
*) echo "unknown part $part" >&2; exit 2 ;;
esac
done
