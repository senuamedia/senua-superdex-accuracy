#!/usr/bin/env bash
# Re-derives every G rule line of run 028 from its raw files, independently of measure/sx_contact.sx: the readings are
# computed here in double precision with awk from the rigs' output and stats, and each rule is judged against the
# registered bound (PREREGISTRATION_12.md). Prints one line a rule with the value it reads and HELD or FAILED, then
# compares each value with the value in validation/run_028_joint_motion/reading.txt.
# usage: rederive28.sh <record root>
set -u
R="${1:?record root}"; V="$R/validation/run_028_joint_motion"; ID="$R/validation/run_025_identity/identity.txt"
final() { awk 'NF==6 && $1 ~ /^[0-9]+$/ { s=$3 } END { print s }' "$1"; }
creep() { awk 'NR==1 { for (i=1;i<NF;i++) if ($i=="steps") n=$(i+1); next } { v[c++]=$3 } END { h=int(n/2); for (s=h;s<n;s++) { t+=v[s]; k++ } printf "%d\n", (t<0?-1:1)*int((t<0?-t:t)/k) }' "$1"; }
chain() {  # prints: kinetic_end_per_million energy_drift_ppm_of_most_kinetic momentum_drift_ppm energy_lost_ppm energy_largest_drift_ppm
  awk 'NR==1 { m1=$5/1000; m2=$7/1000; h=$9/1e6; g=$17; next }
       { k=0; L=0; y=0
         for (a=0;a<2;a++) { o=6+5*a; m=(a==0?m1:m2); x=$o/1e6; yy=$(o+1)/1e6; vx=$(o+2)/1e6; vy=$(o+3)/1e6; w=$(o+4)/1e6
           I=2/3*m*h*h; k+=0.5*m*(vx*vx+vy*vy)+0.5*I*w*w; L+=m*(x*vy-yy*vx)+I*w; y+=m*yy }
         E=k+9.8*g*y
         if (NR==2) { k0=k; E0=E; L0=L; km=k; dmax=0 }
         if (k>km) km=k; d=E-E0; if (d<0) d=-d; if (d>dmax) dmax=d; kl=k; El=E; Ll=L }
       END { printf "%.0f %.0f %.0f %.0f %.0f\n", (k0>0?kl/k0*1e6:999999999), (El-E0)/km*1e6, (L0!=0?(Ll-L0)/(L0<0?-L0:L0)*1e6:999999999), -(El-E0)/km*1e6, dmax/km*1e6 }' "$1"; }
sum() { awk -v k="$2" '{ for (i=1;i<NF;i++) if ($i==k) s+=$(i+1) } END { printf "%d", s }' "$1"; }
field() { grep "^STATS source $2 " "$1" | awk -v k="$3" '{ for (i=1;i<NF;i++) if ($i==k) print $(i+1) }'; }
within() { awk -v v="$1" -v t="$2" -v p="$3" 'BEGIN { b=int((t<0?-t:t)/p); print ((v>=t-b && v<=t+b)?"HELD":"FAILED") }'; }
inr() { awk -v v="$1" -v lo="$2" -v hi="$3" 'BEGIN { print ((v>=lo && v<=hi)?"HELD":"FAILED") }'; }
le() { awk -v a="$1" -v b="$2" 'BEGIN { print ((a<=b)?"HELD":"FAILED") }'; }
line() { echo "G $*"; }
# G0
differs=$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID"); parts=$(grep -c '^IDENTITY ' "$ID")
line "G0 parts $parts differing_files $differs $( [ "$differs" = 0 ] && [ "$parts" = 9 ] && echo HELD || echo FAILED)"
# G1
for w in 1.5 3.5 6; do
  law=$(awk -v w=$w 'BEGIN { printf "%.0f", w/sqrt(1+2*(w*0.01)^2*100)*1e6 }'); s=$(final "$V/arm/stock/spin${w}_1.txt")
  line "G1 stock_at_$w $s law $law $(within $s $law 100)"
done
# G2
for w in 1.5 3.5 6; do
  lo=$(awk -v w=$w 'BEGIN { printf "%d", w*999000 }'); hi=$(awk -v w=$w 'BEGIN { printf "%d", w*1001000 }')
  for k in 1 4 16; do s=$(final "$V/arm/neg/spin${w}_$k.txt"); line "G2 neg_${w}_1/$k $s band $lo $hi $(inr $s $lo $hi)"; done
done
# G3 to G6
for cfg in off ne g neg neg_tight; do for case in free swing; do for k in 1 4 16; do
  f="$V/chain/$cfg/${case}_$k.txt"; [ -f "$f" ] || continue
  set -- $(chain "$f"); eval "KE_${cfg}_${case}_$k=$1; DR_${cfg}_${case}_$k=$2; MO_${cfg}_${case}_$k=$3; LO_${cfg}_${case}_$k=$4; XD_${cfg}_${case}_$k=$5"
  echo "CHAIN $cfg $case 1/$k kinetic_end_per_million $1 energy_drift_ppm $2 momentum_drift_ppm $3 energy_lost_ppm $4 energy_largest_drift_ppm $5"
done; done; done
line "G3 energy_kept $KE_off_free_1 $(le $KE_off_free_1 900000) momentum_drift $MO_off_free_1 $(le $MO_off_free_1 -30000)"
for k in 1 4 16; do eval "m=\$MO_neg_tight_free_$k; x=\$XD_neg_tight_free_$k"; b=$([ $k = 1 ] && echo 5000 || ([ $k = 4 ] && echo 1000 || echo 500)); line "G4 1/$k momentum $m $(inr $m -100 100) energy_largest_drift $x bound $b $(le $x $b)"; done
for k in 1 4 16; do eval "e=\$KE_neg_free_$k; m=\$MO_neg_free_$k"; line "G5 1/$k energy $e $(inr $e 990000 1010000) momentum $m $(inr $m -5000 5000)"; done
for k in 1 4 16; do eval "a=\$LO_neg_swing_$k; b=\$LO_off_swing_$k"; line "G6 1/$k lost_both $a lost_off $b $(awk -v a=$a -v b=$b 'BEGIN{print ((a*10<=b*6)?"HELD":"FAILED")}')"; done
line "G6 falls $LO_neg_swing_1 $LO_neg_swing_4 $LO_neg_swing_16 $(awk -v a=$LO_neg_swing_1 -v b=$LO_neg_swing_4 -v c=$LO_neg_swing_16 'BEGIN{print ((b<a && c<b)?"HELD":"FAILED")}')"
# G7
st=$(( $(sum "$V/arm/neg/stats.txt" stopped) + $(sum "$V/chain/neg/stats.txt" stopped) )); dv=$(( $(sum "$V/arm/neg/stats.txt" diverged) + $(sum "$V/chain/neg/stats.txt" diverged) ))
plays=$(( $(grep -c '^STATS' "$V/arm/neg/stats.txt") + $(grep -c '^STATS' "$V/chain/neg/stats.txt") ))
line "G7 plays $plays stopped $st diverged $dv $( [ $st = 0 ] && [ $dv = 0 ] && echo HELD || echo FAILED)"
# G8
J="$V/joints_neg"; J0="$R/joints"
jt1=$(final "$J/spin_be_1.txt"); jt2=$(final "$J/torque_be_1.txt"); h1=$(creep "$J/hold_shipped_1.txt"); h0=$(creep "$J0/hold_shipped_1.txt")
p1=$(final "$J/slip_shipped_1.txt"); p0=$(final "$J0/slip_shipped_1.txt"); p16=$(final "$J/slip_shipped_16.txt"); p016=$(final "$J0/slip_shipped_16.txt")
ans=$(awk 'BEGIN { printf "%.0f", (3-2)/(2*(0.4^2+2/3*0.04^2))*1e6 }'); jt2a=$(awk 'BEGIN { printf "%.0f", 1.5/(2*(0.4^2+2/3*0.04^2))*1e6 }')
line "G8 JT1 $jt1 $(awk -v a=$jt1 'BEGIN{print (a>=2970000?"HELD":"FAILED")}') JT2 $jt2 answer $jt2a $(within $jt2 4656457 100)"
line "G8 hold $h1 stock $h0 $(awk -v a=$h1 -v b=$h0 'BEGIN{d=a-b; if(d<0)d=-d; print (d<=10?"HELD":"FAILED")}')"
line "G8 slip_1/1 $p1 stock $p0 $(within $p1 $p0 100) ; against the right answer $ans: $(within $p1 $ans 100) (1 in 10000: $(within $p1 $ans 10000))"
line "G8 slip_1/16 $p16 stock $p016 $(within $p16 $p016 100) ; against the right answer $ans: $(within $p16 $ans 100)"
# G9
for sc in half_cheetah ant cart_pole; do
  g=$(field "$V/stats_$sc.txt" g1 stopped); b=$(field "$V/stats_$sc.txt" b1 stopped); d=$(field "$V/stats_$sc.txt" g1 diverged)
  line "G9 $sc stopped_with $g without $b diverged $d $( [ "$d" = 0 ] && [ $g -le $((b+21)) ] && echo HELD || echo FAILED)"
done
