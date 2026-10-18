#!/bin/bash
# control.sh: two checks that the comparison can see a difference and that the stock-built rig runs a library with no
# patches in it. Two registered plays of run 029's final configuration (play_13.sh with F and G: deform fc
# shell_hold_0.01, grip fc built_8), made (a) with the build-15 rig and every switch, against the registered file;
# (b) with the stock-built rig and every switch (stock SuperDex has no switches, so they must do nothing); (c) with the
# stock-built rig, the same settings and no switch. Expected: (a) SAME as registered; (b) == (c); (b) DIFFERS from (a).
set -u
S=$HOME/code/superdex-stock-rig-check; V=$HOME/code/senua-superdex-accuracy/validation
O="$S/out/control"; rm -rf "$O"; mkdir -p "$O"
A=$HOME/code/superdex-src/superdex_physics/assets
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
final() { clear_switches; export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1; }
c() { if cmp -s "$1" "$2"; then echo "SAME    $3"; else echo "DIFFERS $3"; fi; }
for arm in a b c; do
  case $arm in a) final; SUF=b15 ;; b) final; SUF=stock ;; c) clear_switches; SUF=stock ;; esac
  "$S/bin/sdx_deform64_$SUF" "$O/${arm}_shell_hold_0.01.txt" dt=0.01 case=shell_hold mu=0.4 tilt=0.25 ndamp=5 falloff=0.03 > "$O/${arm}_deform.out" 2>&1
  SDX_TRACE="$O/${arm}_built_8.tr" "$S/bin/sdx_grip64_$SUF" "$O/${arm}_built_8.txt" gripper=built assets="$A" mass=0.15 half=0.012 mu=0.45 grip=8 ndamp=5 falloff=0.03 newtoneuler=1 > "$O/${arm}_grip.out" 2>&1
done
clear_switches
{
  c "$O/a_shell_hold_0.01.txt" "$V/run_029_end_to_end/runs/deform_fc/shell_hold_0.01.txt" "(a) build-15 rig, every switch, vs registered deform_fc/shell_hold_0.01"
  c "$O/a_built_8.txt" "$V/run_029_end_to_end/runs/grip_fc/built_8.txt" "(a) build-15 rig, every switch, vs registered grip_fc/built_8"
  c "$O/b_shell_hold_0.01.txt" "$O/c_shell_hold_0.01.txt" "(b) stock rig with every switch vs (c) stock rig, no switch: deform"
  c "$O/b_built_8.txt" "$O/c_built_8.txt" "(b) stock rig with every switch vs (c) stock rig, no switch: grip"
  c "$O/b_shell_hold_0.01.txt" "$O/a_shell_hold_0.01.txt" "(b) stock rig with every switch vs (a) build-15 with every switch: deform"
  c "$O/b_built_8.txt" "$O/a_built_8.txt" "(b) stock rig with every switch vs (a) build-15 with every switch: grip"
  c "$O/c_shell_hold_0.01.txt" "$V/run_029_end_to_end/runs/deform_stock/shell_hold_0.01.txt" "(c) vs registered deform_stock/shell_hold_0.01 (different settings: ndamp, falloff)"
} | tee "$O/control.txt"
