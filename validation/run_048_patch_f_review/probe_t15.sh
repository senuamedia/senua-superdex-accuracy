#!/usr/bin/env bash
# probe_t15.sh : PROBE ONLY (review of patch F). The eleventh registration's pair (a past registration's scene,
# replayed to find a cause, as run 030 did): its T15 slip read with and without patch F, on SuperDex's own grid and
# with each body's cell at 1/32 of its side, at steps 1 to 1/16; then the instrumented library's per-step forces.
# Writes only under ~/work/probeF/t15.
set -u
W=~/work/probeF; O=$W/t15; mkdir -p $O/plays $O/kp; RG=$W/rigs; SXC=$W/bin/sx_contact
P11="layout=stack massa=3 ra=0.25 massb=0.5 rb=0.03 mu=0.45 pusha=23.1525 pushat=0.5 secs=0.9"
clear_sw() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT SDX_KPROBE SDX_KPROBE_ON; }
sw() {  # sw <config>: the switches and the rig's contact settings of a configuration (as play_11.sh)
  clear_sw; CS=""
  case "$1" in
    stock) ;;
    f_only) export SUPERDEX_FRICTION_STEP_NORMAL=1 ;;
    rec) export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_ROTATION_AXIS_EXACT=1; CS="ndamp=5 falloff=0.03" ;;
    rec_f) export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1; CS="ndamp=5 falloff=0.03" ;;
  esac
}
dt_of() { echo "scale=12; 0.01/$1" | bc; }
acc() { "$SXC" accel "$1" 700 900 | awk '{for(i=1;i<=NF;i++) if ($i=="mean_acceleration_mm_s2") print $(i+1)}'; }
case "${1:-plain}" in
plain)
  # the readings with the record's rig on library build 15 (stock: the record's rig on the stock library)
  : > $O/plain.txt
  for grid in own div32; do G=""; [ $grid = div32 ] && G="sdfdiv=32"
    for cfg in stock f_only rec rec_f; do
      line="$grid $cfg"
      for k in 1 2 4 8 16; do
        sw $cfg; R=$RG/sdx_pair64_b15; [ $cfg = stock ] && R=$RG/sdx_pair64_stock
        # shellcheck disable=SC2086
        "$R" $O/plays/${grid}_${cfg}_$k dt="$(dt_of $k)" $P11 $CS $G > $O/plays/${grid}_${cfg}_$k.stats 2>&1
        line="$line | 1/$k B $(acc $O/plays/${grid}_${cfg}_${k}_b.txt) A $(acc $O/plays/${grid}_${cfg}_${k}_a.txt) $(grep -o 'stopped [0-9]* diverged [0-9]*' $O/plays/${grid}_${cfg}_$k.stats)"
      done
      echo "$line" | tee -a $O/plain.txt
    done
  done
  clear_sw ;;
kp)
  # the instrumented library (probe rig), the same plays with the probe on from 0.60 s to 0.90 s
  : > $O/kp_same.txt
  for grid in own div32; do G=""; [ $grid = div32 ] && G="sdfdiv=32"
    for cfg in stock f_only rec rec_f; do for k in 1 2 4 8 16; do
      sw $cfg; export SDX_KPROBE=1
      # shellcheck disable=SC2086
      $RG/sdx_pair_probe $O/kp/${grid}_${cfg}_$k dt="$(dt_of $k)" $P11 $CS $G probefrom=0.6 probeto=0.9 > $O/kp/${grid}_${cfg}_$k.stats 2> $O/kp/${grid}_${cfg}_$k.log
      bash $W/kp_steps.sh $O/kp/${grid}_${cfg}_$k.log > $O/kp/${grid}_${cfg}_$k.steps
      # the probe must not change the play: its files against the plain play's
      s="same"; cmp -s $O/kp/${grid}_${cfg}_${k}_a.txt $O/plays/${grid}_${cfg}_${k}_a.txt || s="DIFFERS"; cmp -s $O/kp/${grid}_${cfg}_${k}_b.txt $O/plays/${grid}_${cfg}_${k}_b.txt || s="DIFFERS"
      echo "$grid $cfg 1/$k probe-library play against build 15: $s" >> $O/kp_same.txt
    done; done
  done
  clear_sw ;;
controls)
  # SuperDex's own settings as controls, on the probe rig: explicit normals (the true stage-start distance in place
  # of stock's estimate), friction fade off, the box collider, and the solver's tolerances very tight
  : > $O/controls.txt
  for spec in "rec explicitn=1" "rec_f explicitn=1" "rec nofade=1" "rec_f nofade=1" "stock nofade=1" "f_only nofade=1" "rec collider=box" "rec_f collider=box" "rec abstol=1e-9 reltol=1e-12" "rec_f abstol=1e-9 reltol=1e-12"; do
    cfg="${spec%% *}"; X="${spec#* }"; tag="$(echo "$spec" | tr ' =' '__')"
    line="$spec"
    for k in 1 2 4 8 16; do
      sw $cfg; export SDX_KPROBE=1
      # shellcheck disable=SC2086
      $RG/sdx_pair_probe $O/kp/c_${tag}_$k dt="$(dt_of $k)" $P11 $CS $X probefrom=0.6 probeto=0.9 > $O/kp/c_${tag}_$k.stats 2> $O/kp/c_${tag}_$k.log
      bash $W/kp_steps.sh $O/kp/c_${tag}_$k.log > $O/kp/c_${tag}_$k.steps
      line="$line | 1/$k B $(acc $O/kp/c_${tag}_${k}_b.txt) A $(acc $O/kp/c_${tag}_${k}_a.txt) $(grep -o 'stopped [0-9]* diverged [0-9]*' $O/kp/c_${tag}_$k.stats)"
    done
    echo "$line" | tee -a $O/controls.txt
  done
  clear_sw ;;
esac
