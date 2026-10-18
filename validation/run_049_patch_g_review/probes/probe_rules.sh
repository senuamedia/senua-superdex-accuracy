#!/usr/bin/env bash
# Patch G under the full recommended configuration, on probe numbers (none registered by any study): every rule of
# the twelfth registration, G1 to G9, at every registered step, read by the record's own measure (sx_contact) where
# it has one. G8's slip is read against its right answer (the registration read it against stock's value).
# Configuration (docs/recommended-configuration.md): patches A to G (switches), Newton-Euler inertia, absTol 1e-4,
# relTol 1e-8, backward Euler; contact damping 5 and friction falloff 0.03 on the benchmark (the arm and the chain
# have no contact, and no mesh body meets another, so the grid cell and the smoothing do not enter).
# usage: probe_rules.sh <library: cur | g3>          writes ~/work/probeG/out/rules_<lib>/
set -u
P="$HOME/work/probeG"; LIB="${1:?library}"; B="$P/bin/sx_contact"; RG="$P/rigs/$LIB"; ST="$P/rigs/stock"
O="$P/out/rules_$LIB"; rm -rf "$O"; mkdir -p "$O"
ALL="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1"
NOG="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1"
REC="newtoneuler=1 abstol=1e-4 reltol=1e-8"; TIGHT="newtoneuler=1 abstol=1e-9 reltol=1e-12"
dt_of() { echo "scale=12; 0.01/$1" | bc; }
nv() { echo "$1" | awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) { print $(i + 1); exit } }'; }
m() { "$B" "$@" | tail -1; }
judge() { echo "RULE $*" >> "$O/rules.txt"; }
inr() { awk -v v="$1" -v lo="$2" -v hi="$3" 'BEGIN { print ((v>=lo && v<=hi)?"HELD":"FAILED") }'; }
within() { awk -v v="$1" -v t="$2" -v p="$3" 'BEGIN { b=int((t<0?-t:t)/p); print ((v>=t-b && v<=t+b)?"HELD":"FAILED") }'; }
le() { awk -v a="$1" -v b="$2" 'BEGIN { print ((a<=b)?"HELD":"FAILED") }'; }
: > "$O/rules.txt"
# ---- the arm: mass 1.3 kg, half-size 0.055 m, centre 0.33 m; released at 1.8, 3.9 and 5.5 rad/s, 1 s, no gravity
ARM="mass=1.3 radius=0.055 arm=0.33 gravity=0 secs=1"
for w in 1.8 3.9 5.5; do
  env -i PATH="$PATH" "$ST/sdx_joint64" "$O/arm_stock_$w.txt" dt=0.01 $ARM omega0=$w > "$O/arm_stock_$w.stats"
  s=$(nv "$(m final "$O/arm_stock_$w.txt")" speed_urads); law=$(awk -v w=$w 'BEGIN { printf "%.0f", w/sqrt(1+2*(w*0.01)^2*100)*1e6 }')
  judge "G1 stock arm at $w rad/s, shipped step: $s, the law $law, within 1 in 100: $(within $s $law 100)"
  for k in 1 4 16; do
    env -i PATH="$PATH" $ALL "$RG/sdx_joint64" "$O/arm_rec_${w}_$k.txt" dt="$(dt_of $k)" $ARM omega0=$w $REC > "$O/arm_rec_${w}_$k.stats"
    s=$(nv "$(m final "$O/arm_rec_${w}_$k.txt")" speed_urads)
    lo=$(awk -v w=$w 'BEGIN { printf "%d", w*999000 }'); hi=$(awk -v w=$w 'BEGIN { printf "%d", w*1001000 }')
    judge "G2 arm at $w rad/s, 1/$k: $s, between $lo and $hi: $(inr $s $lo $hi)"
  done
done
# ---- the chain: 0.9 and 0.7 kg, half-size 0.035 m, centres 0.22 and 0.18 m, joints 0.45 m apart
ARMS="mass1=0.9 mass2=0.7 radius=0.035 arm1=0.22 len1=0.45 arm2=0.18"
FREE="gravity=0 angle2=-1.1 omega1=2.2 omega2=1.9 secs=2"; SWING="gravity=1 angle1=0.5 angle2=-0.8 secs=2"
env -i PATH="$PATH" "$ST/sdx_chain64" "$O/chain_stock_free_1.txt" dt=0.01 $ARMS $FREE > "$O/chain_stock_free_1.stats"
l=$(m chain "$O/chain_stock_free_1.txt"); e=$(nv "$l" kinetic_end_per_million_of_start); mo=$(nv "$l" momentum_drift_ppm)
judge "G3 stock free chain, shipped step: kinetic energy kept $e per million (at most 900000: $(le $e 900000)), momentum $mo ppm (at most -30000: $(le $mo -30000))"
for k in 1 4 16; do
  dt=$(dt_of $k)
  env -i PATH="$PATH" $ALL "$RG/sdx_chain64" "$O/chain_tight_free_$k.txt" dt=$dt $ARMS $FREE $TIGHT > "$O/chain_tight_free_$k.stats"
  env -i PATH="$PATH" $ALL "$RG/sdx_chain64" "$O/chain_rec_free_$k.txt" dt=$dt $ARMS $FREE $REC > "$O/chain_rec_free_$k.stats"
  env -i PATH="$PATH" $ALL "$RG/sdx_chain64" "$O/chain_rec_swing_$k.txt" dt=$dt $ARMS $SWING $REC > "$O/chain_rec_swing_$k.stats"
  env -i PATH="$PATH" "$RG/sdx_chain64" "$O/chain_off_swing_$k.txt" dt=$dt $ARMS $SWING newtoneuler=0 > "$O/chain_off_swing_$k.stats"
  lt=$(m chain "$O/chain_tight_free_$k.txt"); lr=$(m chain "$O/chain_rec_free_$k.txt")
  ls=$(m chain "$O/chain_rec_swing_$k.txt"); lo=$(m chain "$O/chain_off_swing_$k.txt")
  echo "1/$k tight free: $lt" >> "$O/chain_readings.txt"; echo "1/$k recommended free: $lr" >> "$O/chain_readings.txt"
  echo "1/$k recommended swing: $ls" >> "$O/chain_readings.txt"; echo "1/$k no switch swing: $lo" >> "$O/chain_readings.txt"
  mt=$(nv "$lt" momentum_drift_ppm); xt=$(nv "$lt" energy_largest_drift_ppm); bd=$([ $k = 1 ] && echo 5000 || ([ $k = 4 ] && echo 1000 || echo 500))
  judge "G4 1/$k tight: momentum $mt ppm (within 100: $(inr $mt -100 100)), largest energy drift $xt ppm (at most $bd: $(le $xt $bd))"
  er=$(nv "$lr" kinetic_end_per_million_of_start); mr=$(nv "$lr" momentum_drift_ppm)
  judge "G5 1/$k recommended tolerances: kinetic energy $er per million ($(inr $er 990000 1010000)), momentum $mr ppm ($(inr $mr -5000 5000))"
  a=$(nv "$ls" energy_lost_ppm_of_most_kinetic); b=$(nv "$lo" energy_lost_ppm_of_most_kinetic); eval "LS_$k=$a"
  judge "G6 1/$k swing: lost $a with the configuration, $b with no switch (at most 6 tenths: $(awk -v a=$a -v b=$b 'BEGIN{print ((a*10<=b*6)?"HELD":"FAILED")}'))"
done
judge "G6 falls with the step: $LS_1 $LS_4 $LS_16: $(awk -v a=$LS_1 -v b=$LS_4 -v c=$LS_16 'BEGIN{print ((b<a && c<b)?"HELD":"FAILED")}')"
# G7: the nine arm plays and the six chain plays at the configuration's tolerances
st=$(cat "$O"/arm_rec_*.stats "$O"/chain_rec_*.stats | awk '{for(i=1;i<NF;i++){if($i=="stopped")s+=$(i+1); if($i=="diverged")d+=$(i+1)}} END{print s+0, d+0}')
judge "G7 arm and chain plays at the configuration's tolerances: stopped and diverged $st: $([ "$st" = "0 0" ] && echo HELD || echo FAILED)"
# ---- G8: the sixth registration's tests on a fresh arm: 2.6 kg, half-size 0.035 m, centre 0.37 m
J="mass=2.6 radius=0.035 arm=0.37"; I=$(awk 'BEGIN { printf "%.9f", 2.6*(0.37^2+2/3*0.035^2) }')
env -i PATH="$PATH" "$ST/sdx_joint64" "$O/jt1_stock.txt" dt=0.01 $J gravity=0 omega0=2.7 secs=1 > /dev/null
env -i PATH="$PATH" $ALL "$RG/sdx_joint64" "$O/jt1.txt" dt=0.01 $J gravity=0 omega0=2.7 secs=1 $REC > /dev/null
s0=$(nv "$(m final "$O/jt1_stock.txt")" speed_urads); s1=$(nv "$(m final "$O/jt1.txt")" speed_urads)
judge "G8 JT1 free arm at 2.7 rad/s, shipped step: $s1 (stock $s0); at least 99 in 100: $(le 2673000 $s1) (stock fails it: $(le 2673000 $s0))"
env -i PATH="$PATH" $ALL "$RG/sdx_joint64" "$O/jt2.txt" dt=0.01 $J gravity=0 torque=2 secs=1 $REC > /dev/null
s=$(nv "$(m final "$O/jt2.txt")" speed_urads); ans=$(awk -v I=$I 'BEGIN { printf "%.0f", 2/I*1e6 }')
judge "G8 JT2 driven arm, 2 N m: $s against $ans: within 1 in 100: $(within $s $ans 100)"
env -i PATH="$PATH" "$ST/sdx_joint64" "$O/jt4_stock.txt" dt=0.01 $J coulomb=13 secs=2 > /dev/null
env -i PATH="$PATH" $ALL "$RG/sdx_joint64" "$O/jt4.txt" dt=0.01 $J coulomb=13 secs=2 $REC > /dev/null
h0=$(nv "$(m creep "$O/jt4_stock.txt")" mean_speed_ums); h1=$(nv "$(m creep "$O/jt4.txt")" mean_speed_ums)
judge "G8 JT4 hold, 13 N m against gravity's 9.43: creep $h1 (stock $h0) within 10: $(awk -v a=$h1 -v b=$h0 'BEGIN{d=a-b; if(d<0)d=-d; print (d<=10?"HELD":"FAILED")}')"
ans=$(awk -v I=$I 'BEGIN { printf "%.0f", (4-2.5)/I*1e6 }')
for k in 1 16; do
  env -i PATH="$PATH" "$ST/sdx_joint64" "$O/jt5_stock_$k.txt" dt="$(dt_of $k)" $J gravity=0 coulomb=2.5 torque=4 secs=1 > /dev/null
  env -i PATH="$PATH" $ALL "$RG/sdx_joint64" "$O/jt5_$k.txt" dt="$(dt_of $k)" $J gravity=0 coulomb=2.5 torque=4 secs=1 $REC > /dev/null
  s0=$(nv "$(m final "$O/jt5_stock_$k.txt")" speed_urads); s1=$(nv "$(m final "$O/jt5_$k.txt")" speed_urads)
  judge "G8 JT5 slip 1/$k: $s1 against the right answer $ans: within 1 in 100: $(within $s1 $ans 100) (1 in 1,000: $(within $s1 $ans 1000)); against stock's $s0 as registered: $(within $s1 $s0 100)"
done
echo "rules held $(grep -c ': HELD\|HELD)' "$O/rules.txt") lines; FAILED anywhere: $(grep -c FAILED "$O/rules.txt")" >> "$O/rules.txt"
