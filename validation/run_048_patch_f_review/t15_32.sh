#!/usr/bin/env bash
# PROBE ONLY: the eleventh registration pair in SuperDex 32-bit (library build 15, 32-bit), with and without patch F.
W=~/work/probeF; O=$W/t15/p32; SXC=$W/bin/sx_contact
P11="layout=stack massa=3 ra=0.25 massb=0.5 rb=0.03 mu=0.45 pusha=23.1525 pushat=0.5 secs=0.9"
acc() { "$SXC" accel "$1" 700 900 | awk "{for(i=1;i<=NF;i++) if (\$i==\"mean_acceleration_mm_s2\") print \$(i+1)}"; }
for grid in own div32; do G=""; [ $grid = div32 ] && G="sdfdiv=32"
for cfg in rec rec_f; do
  unset SUPERDEX_FRICTION_STEP_NORMAL
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_ROTATION_AXIS_EXACT=1
  [ $cfg = rec_f ] && export SUPERDEX_FRICTION_STEP_NORMAL=1
  line="32-bit $grid $cfg"
  for k in 1 2 4 8 16; do dt=$(echo "scale=12; 0.01/$k" | bc)
    $W/rigs/sdx_pair32_b15 $O/${grid}_${cfg}_$k dt=$dt $P11 ndamp=5 falloff=0.03 $G > $O/${grid}_${cfg}_$k.stats 2>&1
    line="$line | 1/$k B $(acc $O/${grid}_${cfg}_${k}_b.txt) A $(acc $O/${grid}_${cfg}_${k}_a.txt) $(grep -o "stopped [0-9]* diverged [0-9]*" $O/${grid}_${cfg}_$k.stats) bits $(grep -o "real_bits [0-9]*" $O/${grid}_${cfg}_$k.stats)"
  done; echo "$line"
done; done
