#!/usr/bin/env bash
# Run 039, step 3: the byte comparison step 2 meant to make. Step 2 played the suites' default scenes, while the
# record's id_off and dry14_final plays it compared with were played on other scenes, so its byte comparison and its
# readings of those two labels compared different scenes and count for nothing. Here both suites are played on the
# seventh study's cubes, exactly as tools/play_identity.sh plays them (its SUITE_ and S2_ settings), on the Linux
# builds of step 1, and each play file is compared with the seventh study's registered file (run 017), which Study
# 16 found library build 15 makes again byte for byte on the laptop:
#   linux_s7_stock  stock, no setting and no switch, against run 017's stock files
#   linux_s7_abc    patches A to C (the identity script's AB and CD switches) with contact damping 5 and falloff 0.03,
#                   against run 017's rec_new files (the seventh study's recommended configuration)
# and both read by the record's runner with the seventh study's constants (friction 0.35, slip push 4,234 mN).
# usage: play3.sh <work folder of step 1> <run 017's runs folder, copied>   (from the root of a copy of the repository)
set -u
WD="$(cd "${1:?usage: play3.sh <work folder> <run 017 runs>}" && pwd)"; S7="$(cd "${2:?run 017 runs}" && pwd)"
O=validation/run_039_linux_replication
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
RIG=$PWD/tools/sdx_contact64_stock tools/contact_suite.sh linux_s7_stock > /dev/null
RIG=$PWD/tools/sdx_contact64_stock RIGPAIR=$PWD/tools/sdx_pair64_stock tools/contact_suite2.sh linux_s7_stock > /dev/null
( export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1
  RIG=$PWD/tools/sdx_contact64 tools/contact_suite.sh linux_s7_abc ndamp=5 falloff=0.03 > /dev/null
  RIG=$PWD/tools/sdx_contact64 RIGPAIR=$PWD/tools/sdx_pair64 tools/contact_suite2.sh linux_s7_abc ndamp=5 falloff=0.03 > /dev/null )
compare() {  # <label> <run 017's configuration>: every registered play file against the Linux one
  local n=0 s=0 f
  for f in "$S7"/s1/$2/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$f" suites/1/$1/$(basename "$f") && s=$((s + 1)); done
  for f in "$S7"/s2/$2/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$f" suites/2/$1/$(basename "$f") && s=$((s + 1)); done
  echo "$1 against run 017's $2: $s of $n play files byte-identical"
}
export SUITE_MU10K=3500 SUITE_SLIPMN=4234
for l in linux_s7_stock linux_s7_abc; do bash measure/runners/sx_contact_suite.sh suites/1/$l $O/suite1_$l.txt > /dev/null 2>&1; done
mkdir -p $O/s7_registered && cp -R "$S7"/s1/stock $O/s7_registered/s1_stock && cp -R "$S7"/s1/rec_new $O/s7_registered/s1_rec_new
for c in s1_stock s1_rec_new; do bash measure/runners/sx_contact_suite.sh $O/s7_registered/$c $O/suite1_registered_$c.txt > /dev/null 2>&1; done
rm -rf $O/s7_registered
{ compare linux_s7_stock stock; compare linux_s7_abc rec_new
  for f in linux_s7_stock registered_s1_stock linux_s7_abc registered_s1_rec_new; do
    echo "== suite 1, $f"; grep '^T[01][0-9]\|^SUITE' $O/suite1_$f.txt
  done; } > $O/reading3.txt
