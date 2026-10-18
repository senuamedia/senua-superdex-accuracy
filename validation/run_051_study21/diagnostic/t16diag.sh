#!/usr/bin/env bash
# Run 051 diagnostic, after the run and changing no verdict: what moves T16 (momentum between two cubes) on the
# twenty-first registration's second suite. The suite is played again with one thing changed at a time.
set -u
cd ~/work/rec51 || exit 2
R=$(pwd); O=~/work/t16diag; rm -rf $O; mkdir -p $O
clear_switches() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
final() { clear_switches; export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1; }
TOL="abstol=1e-4 reltol=1e-8"; CON="ndamp=5 falloff=0.03"
export S2_CUBE="mass=1.75 radius=0.0388" S2_MU=0.449 S2_VSTOP=1.04 S2_H0=0.058 S2_MUP=0.417 S2_CARRY=9.9610875 S2_SLIP=29.8832625 S2_VSIDE=1.16 S2_VTOP=0.87
P21="massa=4.177 ra=0.244 massb=0.698 rb=0.0328"
run() {  # run <label> <switches fn> <rig suffix> <pair> <extra...>
  local lab="$1" sw="$2" suf="$3" pr="$4"; shift 4
  ( $sw; export S2_PAIR="$pr"; RIG="$R/tools/sdx_contact64$suf" RIGPAIR="$R/tools/sdx_pair64$suf" tools/contact_suite2.sh diag_$lab "$@" ) > $O/log_$lab.txt 2>&1
  bash ~/sxbuild/sx_contact_suite.sh suites/2/diag_$lab $O/suite_$lab.txt > /dev/null 2>&1
  echo "$lab | $(grep -o 'SUITE2.*' $O/suite_$lab.txt | head -1)" >> $O/summary.txt
  grep -E 'side|top' $O/suite_$lab.txt | sed "s/^/$lab | /" >> $O/sidetop.txt
}
run registered final "" "$P21" $CON $TOL sdfdiv=32 integ=be
run default_grid final "" "$P21" $CON $TOL integ=be
run shipped_tol final "" "$P21" $CON sdfdiv=32 integ=be
run off_patched clear_switches "" "$P21" $CON $TOL sdfdiv=32 integ=be
run stock_same clear_switches "_stock" "$P21" $CON $TOL sdfdiv=32 integ=be
run stock_shipped clear_switches "_stock" "$P21" integ=be
run old_pair final "" "massa=3 ra=0.25 massb=0.5 rb=0.03" $CON $TOL sdfdiv=32 integ=be
run no_damping final "" "$P21" falloff=0.03 $TOL sdfdiv=32 integ=be
echo done >> $O/summary.txt
