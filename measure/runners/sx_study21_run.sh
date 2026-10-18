#!/usr/bin/env bash
# measure/runners/sx_study21_run.sh -- preregistrations/PREREGISTRATION_21.md: patches F and G held again to every rule
# of the eleventh and twelfth registrations, and the recommended configuration to every backward-Euler end-to-end rule
# of the thirteenth to fifteenth, and the order of the eleventh and twelfth registrations' decisions, on fresh
# numbers; re-made by measuring alone. Every registered rule is judged by sx_contact rule; the order is read by the
# record's instrument sx_settings3 (time and plain chain) as sx_study11_run.sh and sx_study12_run.sh read it.
# usage: sx_study21_run.sh <out folder of play_21.sh> <out file>
#        (sx_contact, sx_contact_suite.sh and sx_settings3 beside this script)
#   as registered: sx_study21_run.sh validation/run_051_study21 validation/run_051_study21/reading.txt
#   Read under the out folder: identity.txt and, on Linux, identity_linux.txt; runs/ (s1, s2, items, arm_*, chain_*,
#   joints_*, limits_final, rotvec_final.txt, cloud_*, deform_*, grip_*, bench, order).
#   Writes the out file and, beside it, counts.txt (the instrument's lines for the order, as runs 027 and 028 keep them).
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_study21_run.sh <out folder of play_21.sh> <out file>}"; OUT="${2:?out file}"
D="$(cd "$D" && pwd)"; U="$D/runs"
B="$HERE/sx_contact"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s21.XXXXXX")"; MISSF="$P/missing"; : > "$MISSF"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0

# ---- the registered right answers and bounds, from the fresh numbers of play_21.sh ----
N_PARTS=11                                  # the identity parts rotvec flight suites (4 lines) joints zero fg bench benchrec
MU1=3410; SLIP1_MN=9693; F1_BOUND=2728      # the first suite's friction per 10,000, its slip push in mN; 8 tenths of the law
S2_ANSWERS="40935 6840 0 6471 4087"         # the second suite: block's and cube's weight (mN), the shipped law's creep (not
                                            # read by T11 to T17), the block's and the cube's slip (mm/s2)
PA_CUBE=3842; PA_BLOCK=5946; PB_CUBE=4822; PB_BLOCK=7433   # item 1's slips, mm/s2
W_LIST="1.56 2.93 4.51"; LAW="1523368 2706822 3802420"      # the release speeds; the law's prediction for stock, um/s
JT1=2180000; JT1_99=2158200; JT1_999=2177820                 # the sixth's spin: the release speed, 99 and 999 in 1,000 of it
JT2_ANSWER=6082196; JT5_ANSWER=3610288                       # torque over inertia, (torque - friction) over inertia, x 1 s
L_REST_LO=-343009; L_REST_HI=-342951; L_LIMIT=-340000; L_REL1=1782622; L_REL2=371520
L_PAST=-339000; L_MOVING1=178263; L_MOVING2=37152; L_LIFTED=-238350
CL_LAW=3910; CL_OVER=4692; CL_WEIGHT=11339; CL_SLIP_MN=5524  # the cloud's friction per 10,000, 1.2 x it, weight mN, slip push mN
CANT="7851120 3848916 3448114"                                # the three cantilevers' textbook sag, nm
HANG_ROD=1456451; HANG_STRIP=395717; HANG_BAR=521417          # the hanging rod, strip and bar, nm
BE_01=57483989; BE_001=61128989; CREEP=3847                   # backward Euler's slide distance at 0.01 s and 0.001 s, nm; stock's creep, um/s
GRIP_UN=9100000; HALF_UN=818300                               # the grip on each finger and half the cube's weight, uN
G_STRONG=9.1; G_WEAK=0.67
ORDER_EP=108; ORDER_RD=200                                    # the fresh commands of half_cheetah and ant: episodes, readings an episode
# ---- end of the registered answers ----

m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the measure's LAST line
  local label="$1"; shift
  local lines; lines="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> "$OUT"; echo "$lines" | tail -1
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
# the number after a name (its n-th occurrence, default the first); a name a measured line does not hold counts as
# missing and stands as 999999999
nv() { local x; x="$(echo "$1" | awk -v k="$2" -v n="${3:-1}" '{ c = 0; for (i = 1; i < NF; i++) if ($i == k) { c++; if (c == n) { print $(i + 1); exit } } }')"; if [ -z "$x" ]; then echo "$2" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
rule() { "$B" rule "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "rule failed to run: $*" >&2; bad=1; }; }
# a statistic summed over the plays of a statistics file, all of them or those whose name does or does not start with
# a prefix; a file that does not exist counts as missing
stat() { [ -f "$1" ] || { echo "$1" >> "$MISSF"; echo 999999999; return; }; awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$1"; }
statp() { [ -f "$1" ] || { echo "$1" >> "$MISSF"; echo 999999999; return; }; grep "^STATS run $2" "$1" | awk -v k="$3" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }'; }
statn() { [ -f "$1" ] || { echo "$1" >> "$MISSF"; echo 999999999; return; }; grep -v "^STATS run $2" "$1" | awk -v k="$3" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }'; }
# the most iterations any step of the plays took (the iteration limit is 200: a step that took 200 stopped at the limit;
# one that stopped with fewer stopped on SuperDex's rule for an update too small to matter)
most() { awk '{ for (i = 1; i < NF; i++) if ($i == "most_iterations" && $(i + 1) > m) m = $(i + 1) } END { printf "%d", m + 0 }' "$@"; }
field() { local x; x="$(grep "^STATS source $2 " "$1" 2>/dev/null | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
runstat() { local x; x="$(grep "^STATS run $2 " "$1" 2>/dev/null | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }

# ---- E0 (F0, G0): safe when off ----
ID="$D/identity.txt"; IL="$D/identity_linux.txt"
[ -f "$ID" ] || { echo "$ID" >> "$MISSF"; : > "$P/id_empty"; ID="$P/id_empty"; }
while read -r _ part same_ _ played; do echo "identity | $part $same_ of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
[ -f "$IL" ] && sed 's/^/identity, the plays Linux makes differently from the laptop | /' "$IL" >> "$OUT"
n_parts="$(grep -c '^IDENTITY ' "$ID")"
# a play that differs from its registered file counts against the rule unless it is one of the plays named for Linux
# and is the same as the file run 040 kept from Linux and, with no switch, as the same play on Linux's stock library
unexplained=0
while IFS= read -r line; do
  case "$line" in
    "PLAY FAILED"*) unexplained=$((unexplained + 1)) ;;
    DIFFERS*) lab="${line#DIFFERS }"
      if [ -f "$IL" ] && grep -qxF "LINUX $lab | kept SAME | stock SAME" "$IL"; then :
      elif [ -f "$IL" ] && grep -qxF "LINUX $lab | kept SAME | stock -" "$IL"; then :
      else unexplained=$((unexplained + 1)); echo "identity | differs and is not explained: $lab" >> "$OUT"; fi ;;
  esac
done < <(grep -E '^(DIFFERS|PLAY FAILED)' "$ID")

# ---- both contact suites: the recommended configuration (final) and without patch F (nof) ----
export SUITE_MU10K=$MU1 SUITE_SLIPMN=$SLIP1_MN
code1() {  # code1 <label>: the first suite's code; its lines go to the out file and to $P/suite1_<label>.txt
  bash "$HERE/sx_contact_suite.sh" "$U/s1/$1" "$P/suite1_$1.txt" || { echo "measuring the first suite incomplete: $1" >&2; bad=1; }
  sed "s/^/first suite, $1 | /" "$P/suite1_$1.txt" >> "$OUT"
  grep '^T[01][0-9]' "$P/suite1_$1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n'
}
seven() { grep "^$2 " "$P/suite1_$1.txt" | sed -E 's/^.*\): ([-0-9 ]+) ;.*$/\1/; s/^.*\): ([-0-9 ]+) : (PASS|FAIL)$/\1/'; }   # the seven numbers of a test line
code2() {  # code2 <label>: the second suite's tests T11 to T17
  local l="$1" d="$U/s2/$1" speeds="" back="" pairs="" line run k
  for run in stop land; do for k in 1 4 16 64; do
    line="$(m "second suite, $l, $run 1/$k" stop "$d/${run}_$k.txt")"; speeds="$speeds $(f "$line" 7)"; back="$back $(f "$line" 11)"
  done; done
  for k in 1 16; do
    line="$(m "second suite, $l, rest 1/$k" pair "$d/rest_${k}_a.txt" "$d/rest_${k}_b.txt")"; pairs="$pairs $(f "$line" 17) $(f "$line" 19)"
    line="$(m "second suite, $l, carry 1/$k" pair "$d/carry_${k}_a.txt" "$d/carry_${k}_b.txt")"; pairs="$pairs $(f "$line" 15)"
    pairs="$pairs $(f "$(m "second suite, $l, slip A 1/$k" accel "$d/slip_${k}_a.txt" 700 900)" 9) $(f "$(m "second suite, $l, slip B 1/$k" accel "$d/slip_${k}_b.txt" 700 900)" 9)"
    line="$(m "second suite, $l, side 1/$k" pair "$d/side_${k}_a.txt" "$d/side_${k}_b.txt")"; pairs="$pairs $(f "$line" 9)"
    line="$(m "second suite, $l, top 1/$k" pair "$d/top_${k}_a.txt" "$d/top_${k}_b.txt")"; pairs="$pairs $(f "$line" 9) $(f "$line" 15)"
  done
  # shellcheck disable=SC2086
  line="$(m "second suite, $l" suite2 $speeds $back $pairs $S2_ANSWERS)"
  f "$line" 17
}
c1f="$(code1 final)"; c1n="$(code1 nof)"; c2f="$(code2 final)"; c2n="$(code2 nof)"
t5f="$(seven final T05)"; t5n="$(seven nof T05)"
echo "codes | first suite: recommended $c1f ; without patch F $c1n" >> "$OUT"
echo "codes | second suite: recommended $c2f ; without patch F $c2n (reported)" >> "$OUT"
sstop=$(( $(stat "$U/s1/final/stats.txt" stopped) + $(stat "$U/s2/final/stats.txt" stopped) ))
sdiv=$(( $(stat "$U/s1/final/stats.txt" diverged) + $(stat "$U/s2/final/stats.txt" diverged) ))
echo "solver on the suites | recommended: stopped $sstop diverged $sdiv ; without patch F: stopped $(( $(stat "$U/s1/nof/stats.txt" stopped) + $(stat "$U/s2/nof/stats.txt" stopped) ))" >> "$OUT"

# ---- item 1: the two pairs; the three cantilevers ----
IT="$U/items"
for pr in pa pb; do for k in 1 16; do
  eval "a_${pr}_$k=\"$(nv "$(m "item 1, $pr, block 1/$k" accel "$IT/${pr}_${k}_a.txt" 700 900)" mean_acceleration_mm_s2)\""
  eval "b_${pr}_$k=\"$(nv "$(m "item 1, $pr, light cube 1/$k" accel "$IT/${pr}_${k}_b.txt" 700 900)" mean_acceleration_mm_s2)\""
done; done
ist="$(statp "$IT/stats.txt" p stopped)"; idv="$(statp "$IT/stats.txt" p diverged)"
for c in 1 2 3; do for n in 32 64 128; do
  eval "ct_${c}_$n=\"$(nv "$(m "cantilever $c, $n elements" deform "$IT/cant${c}_n$n.txt")" tip_drop_nm)\""
done; done
echo "cantilevers | stopped (reported) $(statp "$IT/stats.txt" cant stopped) diverged $(statp "$IT/stats.txt" cant diverged) most_iterations $(grep '^STATS run cant' "$IT/stats.txt" 2>/dev/null | most /dev/stdin)" >> "$OUT"

# ---- one arm: stock (the law) and the recommended configuration ----
for w in $W_LIST; do for cfg in stock final; do for k in 1 4 16; do
  eval "sp_${cfg}_${w/./_}_$k=\"$(nv "$(m "one arm, $cfg, released at $w rad/s, 1/$k" final "$U/arm_$cfg/spin${w}_$k.txt")" speed_urads)\""
done; done; done

# ---- two arms ----
for cfg in off final; do for case in free swing; do for k in 1 4 16; do
  l="$(m "two arms, $cfg, $case, 1/$k" chain "$U/chain_$cfg/${case}_$k.txt")"
  eval "E_${cfg}_${case}_$k=\"$(nv "$l" kinetic_end_per_million_of_start)\"; M_${cfg}_${case}_$k=\"$(nv "$l" momentum_drift_ppm)\"; ML_${cfg}_${case}_$k=\"$(nv "$l" momentum_largest_drift_ppm)\"; L_${cfg}_${case}_$k=\"$(nv "$l" energy_lost_ppm_of_most_kinetic)\""
done; done; done
for k in 1 4 16; do
  l="$(m "two arms, solver converged, free, 1/$k" chain "$U/chain_tight/free_$k.txt")"
  eval "M_tight_$k=\"$(nv "$l" momentum_drift_ppm)\"; X_tight_$k=\"$(nv "$l" energy_largest_drift_ppm)\""
done
g7s=$(( $(stat "$U/arm_final/stats.txt" stopped) + $(stat "$U/chain_final/stats.txt" stopped) ))
g7d=$(( $(stat "$U/arm_final/stats.txt" diverged) + $(stat "$U/chain_final/stats.txt" diverged) ))
echo "solver | one arm and two arms, recommended configuration: steps stopped $g7s diverged $g7d ; solver converged: stopped (reported) $(stat "$U/chain_tight/stats.txt" stopped)" >> "$OUT"

# ---- the sixth registration's tests on the fresh arm, and the swing of 20 s ----
J="$U/joints_final"; J0="$U/joints_stock"
m "arm, stock, free spin 1/1 (reported)" final "$J0/spin_1.txt" > /dev/null
jt1="$(nv "$(m "arm, final, free spin 1/1" final "$J/spin_1.txt")" speed_urads)"
jt2="$(nv "$(m "arm, final, driven 1/1" final "$J/torque_1.txt")" speed_urads)"
for k in 4 16 64; do m "arm, final, free spin 1/$k (reported)" final "$J/spin_$k.txt" > /dev/null; m "arm, final, driven 1/$k (reported)" final "$J/torque_$k.txt" > /dev/null; done
for k in 1 4 16 64; do m "arm, final, pendulum 1/$k (reported)" swing "$J/swing_$k.txt" > /dev/null; done
jh="$(nv "$(m "arm, final, hold 1/1" creep "$J/hold_1.txt")" mean_speed_ums)"; jh0="$(nv "$(m "arm, stock, hold 1/1" creep "$J0/hold_1.txt")" mean_speed_ums)"
m "arm, final, hold 1/16 (reported)" creep "$J/hold_16.txt" > /dev/null; m "arm, stock, hold 1/16 (reported)" creep "$J0/hold_16.txt" > /dev/null
js1="$(nv "$(m "arm, final, slip 1/1" final "$J/slip_1.txt")" speed_urads)"; js16="$(nv "$(m "arm, final, slip 1/16" final "$J/slip_16.txt")" speed_urads)"
m "arm, stock, slip 1/1 (reported)" final "$J0/slip_1.txt" > /dev/null; m "arm, stock, slip 1/16 (reported)" final "$J0/slip_16.txt" > /dev/null
for k in 1 16; do
  l="$(m "arm, final, swing of 20 s, 1/$k, turns placed between the steps" swingq "$J/long_$k.txt")"; eval "lq_most_$k=\"$(nv "$l" most_per_10000)\""
done
j5s="$(statn "$J/stats.txt" long_ stopped)"; j5d="$(statn "$J/stats.txt" long_ diverged)"
lgdv="$(statp "$J/stats.txt" long_ diverged)"; lgmost="$(grep '^STATS run long_' "$J/stats.txt" 2>/dev/null | most /dev/stdin)"
echo "swing of 20 s | steps stopped (reported) $(statp "$J/stats.txt" long_ stopped), diverged $lgdv, most iterations of any step $lgmost" >> "$OUT"

# ---- the eighth registration's limit tests ----
LL="$U/limits_final"
lr1="$(nv "$(m "limit, rest 1/1" final "$LL/rest_1.txt")" angle_urad)"; lr16="$(nv "$(m "limit, rest 1/16" final "$LL/rest_16.txt")" angle_urad)"
ll1="$(nv "$(m "limit, lift 1/1" final "$LL/lift_1.txt")" angle_urad)"; ll16="$(nv "$(m "limit, lift 1/16" final "$LL/lift_16.txt")" angle_urad)"
for c in 1 2; do
  eval "lv$c=\"$(nv "$(m "limit, release, damping $c, 1/64" leave "$LL/rel${c}_64.txt" $L_LIMIT)" speed_at_leaving_urads)\""
  for k in 1 16; do l="$(m "limit, release, damping $c, 1/$k" leave "$LL/rel${c}_$k.txt" $L_LIMIT)"; eval "la${c}_$k=\"$(nv "$l" final_angle_urad)\"; ls${c}_$k=\"$(nv "$l" final_speed_urads)\""; done
done

# ---- the rotations ----
rv="$(m "rotations" rotvec "$U/rotvec_final.txt" 1)"
rsmall="$(echo "$rv" | awk '{ for (i=1;i<NF;i++) if ($i=="at_or_under_2e-9_rad") { print $(i+3); exit } }')"; rlarge="$(echo "$rv" | awk '{ for (i=1;i<NF;i++) if ($i=="larger") { print $(i+3); exit } }')"
[ -n "$rsmall" ] || { echo rsmall >> "$MISSF"; rsmall=999999999; }; [ -n "$rlarge" ] || { echo rlarge >> "$MISSF"; rlarge=999999999; }

# ---- point-cloud contact ----
for cfg in stock final; do
  W="$U/cloud_$cfg"
  for k in 1 4; do eval "pi_${cfg}_$k=\"$(nv "$(m "cloud $cfg, oblique impact 1/$k" impact "$W/oblique_$k.txt")" ratio_per_10000)\""; done
  m "cloud $cfg, the 0.1 s after the impact 1/1 (reported)" settle "$W/oblique_1.txt" > /dev/null
  eval "ps_${cfg}=\"$(nv "$(m "cloud $cfg, slide 1/1" creep "$W/slide_1.txt")" friction_over_normal_per_10000)\""
  eval "pr_${cfg}=\"$(nv "$(m "cloud $cfg, rest 1/1" rest "$W/rest_1.txt")" mean_ground_force_mN)\""
  eval "ph_${cfg}=\"$(nv "$(m "cloud $cfg, hold 1/1" creep "$W/hold_1.txt")" mean_speed_ums)\""
  l="$(m "cloud $cfg, slip 1/1" slip "$W/slip_1.txt" $CL_SLIP_MN)"; eval "pv_${cfg}=\"$(nv "$l" mean_speed_ums)\"; pp_${cfg}=\"$(nv "$l" predicted_ums)\""
  eval "pl_${cfg}=\"$(nv "$(m "cloud $cfg, lift 1/1" pull "$W/lift_1.txt")" steps_pulling)\""
  eval "pst_${cfg}=\"$(stat "$W/stats.txt" stopped)\"; pdv_${cfg}=\"$(stat "$W/stats.txt" diverged)\"; pn_${cfg}=\"$(stat "$W/stats.txt" steps)\"; pmost_${cfg}=\"$([ -f "$W/stats.txt" ] && most "$W/stats.txt" || echo 999999999)\""
  echo "cloud $cfg | steps $(eval echo \$pn_$cfg) stopped $(eval echo \$pst_$cfg) diverged $(eval echo \$pdv_$cfg) most_iterations $(eval echo \$pmost_$cfg)" >> "$OUT"
done

# ---- deformable bodies ----
D0="$U/deform_stock"
dfw() { nv "$(m "$1" deform "$2")" "$3"; }
for dt in 0.01 0.001; do
  t="${dt#0.}"
  for b in rod shell soft; do eval "fall_${b}_$t=\"$(dfw "deform, stock, $b fall, $dt s" "$D0/${b}_fall_$dt.txt" fall_worst_nm)\""; done
  for b in rod shell soft; do eval "hang_${b}_$t=\"$(dfw "deform, stock, $b hang, $dt s" "$D0/${b}_hang_$dt.txt" tip_drop_nm)\""; done
done
for cfg in stock final; do for dt in 0.01 0.001; do t="${dt#0.}"; DD="$U/deform_$cfg"; for b in shell soft; do
  l="$(m "deform $cfg, $b slide, $dt s, where it stopped" deformstop "$DD/${b}_slide_$dt.txt")"; eval "far_${cfg}_${b}_$t=\"$(nv "$l" furthest_nm)\""
  m "deform $cfg, $b slide, $dt s (reported)" deform "$DD/${b}_slide_$dt.txt" > /dev/null
  l="$(m "deform $cfg, $b hold, $dt s" deform "$DD/${b}_hold_$dt.txt")"; eval "holdv_${cfg}_${b}_$t=\"$(nv "$l" end_vx_ums)\""
  eval "drift_${cfg}_${b}_$t=\"$(nv "$(m "deform $cfg, $b hold, $dt s, between the second and the last quarter" deformdrift "$DD/${b}_hold_$dt.txt")" drift_nm)\""
  l="$(m "deform $cfg, $b rest, $dt s" deform "$DD/${b}_rest_$dt.txt")"; eval "restvx_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vx_ums)\"; restvy_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vy_ums)\""
done; done; done
dst=$(( $(stat "$D0/stats.txt" stopped) + $(stat "$U/deform_final/stats.txt" stopped) )); ddv=$(( $(stat "$D0/stats.txt" diverged) + $(stat "$U/deform_final/stats.txt" diverged) ))
echo "deform | stock and final: stopped $dst diverged $ddv" >> "$OUT"

# ---- a gripper holding the cube ----
for cfg in stock final; do for g in built fr3; do
  l="$(m "grip $cfg, $g, $G_STRONG N" grip "$U/grip_$cfg/${g}_$G_STRONG.txt" 3)"
  eval "gpa_${cfg}_$g=\"$(nv "$l" press_a_uN)\"; gpb_${cfg}_$g=\"$(nv "$l" press_b_uN)\"; gla_${cfg}_$g=\"$(nv "$l" lift_a_uN)\"; glb_${cfg}_$g=\"$(nv "$l" lift_b_uN)\"; gc_${cfg}_$g=\"$(nv "$l" creep_nms)\"; gs_${cfg}_$g=\"$(nv "$l" slipped_nm)\""
  m "grip $cfg, $g, $G_WEAK N (reported)" grip "$U/grip_$cfg/${g}_$G_WEAK.txt" 10 > /dev/null
done; done
gst=0; gdv=0; for g in built fr3; do gst=$(( gst + $(runstat "$U/grip_final/stats.txt" "${g}_$G_STRONG" stopped) )); gdv=$(( gdv + $(runstat "$U/grip_final/stats.txt" "${g}_$G_STRONG" diverged) )); done
echo "grip | stopped steps of the weak grip (reported): final $(statp "$U/grip_final/stats.txt" "built_$G_WEAK " stopped) and $(statp "$U/grip_final/stats.txt" "fr3_$G_WEAK " stopped)" >> "$OUT"

# ---- Meta's three scenes on the fresh commands ----
BS="$U/bench/stats.txt"
for sc in half_cheetah ant cart_pole; do for cfg in stock final nof nog; do
  echo "benchmark | $sc $cfg steps $(field "$BS" ${sc}_$cfg solver_steps) stopped $(field "$BS" ${sc}_$cfg stopped) diverged $(field "$BS" ${sc}_$cfg diverged) most_iterations $(field "$BS" ${sc}_$cfg most_iterations) wall_s $(field "$BS" ${sc}_$cfg wall_s)" >> "$OUT"
done; done

# ---- the order (B3): half_cheetah and ant at steps 1 to 1/16 under the recommended configuration, read as runs 027
# and 028 read it: sx_settings3 time over the chain, then sx_settings3 plain chain (a fold is in order when each plain
# gap between successive halvings is smaller than the one before) ----
OR="$U/order"; C="$(dirname "$OUT")/counts.txt"; : > "$C"
for sc in half_cheetah ant; do
  echo "=== $sc, the twenty-first registration's commands: the recommended configuration (o1 .. o16)" >> "$C"
  "$HERE/sx_settings3" time "$OR" $sc $ORDER_EP $ORDER_RD o1 o2 o4 o8 o16 >> "$C"; [ $? -eq 42 ] || { echo "failed: sx_settings3 time $sc" >&2; bad=1; }
  "$HERE/sx_settings3" plain "$OR" $sc $ORDER_EP $ORDER_RD chain O o1 o2 o4 o8 o16 >> "$C"; [ $? -eq 42 ] || { echo "failed: sx_settings3 plain $sc" >&2; bad=1; }
done
grep '^PLAIN' "$C" | sed 's/^/order | /' >> "$OUT"
oin() { local x; x="$(grep "^PLAIN $1 O folds_in_order " "$C" | awk '{print $5}')"; if [ -z "$x" ]; then echo "order $1 folds_in_order" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
ohy="$(oin half_cheetah)"; oay="$(oin ant)"
odv=0; ost=0; olim=0
for sc in half_cheetah ant; do for k in 1 2 4 8 16; do
  sf="$OR/stats_$sc.txt"; tf="$OR/stops/${sc}_o$k.txt"
  odv=$(( odv + $(field "$sf" o$k diverged) )); ost=$(( ost + $(field "$sf" o$k stopped) ))
  if [ -f "$tf" ]; then atl="$(awk '$2 == 2 && $3 >= 200' "$tf" | wc -l | tr -d ' ')"; bel="$(awk '$2 == 2 && $3 < 200' "$tf" | wc -l | tr -d ' ')"
  else echo "$tf" >> "$MISSF"; atl=999999999; bel=999999999; fi
  olim=$(( olim + atl ))
  echo "order | $sc 1/$k steps $(field "$sf" o$k solver_steps) stopped $(field "$sf" o$k stopped) (at the iteration limit $atl, below it $bel) diverged $(field "$sf" o$k diverged) most_iterations $(field "$sf" o$k most_iterations) wall_s $(field "$sf" o$k wall_s)" >> "$OUT"
done; done
echo "order | the chains: steps stopped (reported) $ost, at the iteration limit $olim ; diverged $odv" >> "$OUT"
for sc in half_cheetah ant; do
  if [ -f "$OR/$sc/o1_enc.pcm" ] && cmp -s "$OR/$sc/o1_enc.pcm" "$U/bench/${sc}_final_enc.pcm"; then s=same; else s=differs; fi
  echo "order | $sc at step 1 against the benchmark's play under the configuration (reported): $s" >> "$OUT"
done
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; fi

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
# safe when off
rule "E0_F0_G0_every_play_identical_or_the_linux_play_named" eq "$unexplained" 0
rule "E0_F0_G0_parts_played" eq "$n_parts" $N_PARTS
# patch F: the eleventh registration's rules
rule "F1_T05_fails_without_patch_f" eq "$(echo "$c1n" | cut -c5)" 0
# shellcheck disable=SC2086
set -- $t5n
echo "reported, not a rule (change 4) | F1 without patch F, the shipped step's friction over the impact per 10,000: ${1:-missing}, 8 tenths of the law $F1_BOUND" >> "$OUT"
# shellcheck disable=SC2086
rule "F2_T05_within_1_in_100_of_the_law" all_within $MU1 100 $t5f
rule "F2_T10_passes" eq "$(echo "$c1f" | cut -c10)" 1
rule "F3_K1_first_suite_all_ten" eq "${c1f:-0}" 1111111111
rule "F3_K2_second_suite_all_seven" eq "${c2f:-0}" 1111111
rule "F4_K3_no_suite_step_stops" eq "$sstop" 0
rule "F4_K3_no_suite_step_diverges" eq "$sdiv" 0
for sc in half_cheetah ant cart_pole; do
  rule "F5_${sc}_no_step_diverges" eq "$(field "$BS" ${sc}_final diverged)" 0
  rule "F5_${sc}_stops_no_more_than_without_patch_f_plus_21" le_plus "$(field "$BS" ${sc}_final stopped)" "$(field "$BS" ${sc}_nof stopped)" 21
done
rule "F6_the_other_eight_tests_read_the_same" eq "1$(echo "$c1f" | cut -c1-4,6-9)" "1$(echo "$c1n" | cut -c1-4,6-9)"
# patch G: the twelfth registration's rules
i=0; for w in $W_LIST; do i=$((i + 1)); law="$(echo "$LAW" | awk -v i=$i '{print $i}')"
  rule "G1_stock_at_the_law_at_$w" within "$(eval echo \$sp_stock_${w/./_}_1)" "$law" 100
done
for w in $W_LIST; do lo=$(awk -v w="$w" 'BEGIN { printf "%d", w * 999000 + 0.5 }'); hi=$(awk -v w="$w" 'BEGIN { printf "%d", w * 1001000 + 0.5 }')
  rule "G2_one_arm_keeps_its_speed_$w" all_in "$lo" "$hi" "$(eval echo \$sp_final_${w/./_}_1)" "$(eval echo \$sp_final_${w/./_}_4)" "$(eval echo \$sp_final_${w/./_}_16)"
done
rule "G3_no_switch_loses_energy" le "$E_off_free_1" 900000
rule "G3_no_switch_loses_momentum" le "$M_off_free_1" -30000
rule "G4_momentum_kept_solver_converged" all_in -100 100 "$M_tight_1" "$M_tight_4" "$M_tight_16"
rule "G4_energy_drift_shipped_step" le "$X_tight_1" 5000
rule "G4_energy_drift_quarter_step" le "$X_tight_4" 1000
rule "G4_energy_drift_sixteenth_step" le "$X_tight_16" 500
rule "G5_energy" all_in 990000 1010000 "$E_final_free_1" "$E_final_free_4" "$E_final_free_16"
rule "G5_momentum" all_in -5000 5000 "$M_final_free_1" "$M_final_free_4" "$M_final_free_16"
for k in 1 4 16; do eval "ls=\$L_off_swing_$k; ln=\$L_final_swing_$k"; rule "G6_loss_under_gravity_1/$k" share "$ln" "$ls" 6 10; done
rule "G6_loss_falls_with_the_step" falls "$L_final_swing_1" "$L_final_swing_4" "$L_final_swing_16"
rule "G7_no_step_stops" eq "$g7s" 0
rule "G7_no_step_diverges" eq "$g7d" 0
rule "G8_JT1_a_free_arm_keeps_its_speed" ge "$jt1" $JT1_99
rule "G8_J2_a_driven_arm" within "$jt2" $JT2_ANSWER 100
rule "G8_J3_joint_friction_holds_as_stock" near "$jh" "$jh0" 10
# changed before the run, as the fourteenth registration's J4 did: against the slip's right answer, not stock's value
rule "G8_J4_slip_at_its_right_answer" all_within $JT5_ANSWER 100 "$js1" "$js16"
for sc in half_cheetah ant cart_pole; do
  rule "G9_${sc}_no_step_diverges" eq "$(field "$BS" ${sc}_final diverged)" 0
  rule "G9_${sc}_stops_no_more_than_without_patch_g_plus_21" le_plus "$(field "$BS" ${sc}_final stopped)" "$(field "$BS" ${sc}_nog stopped)" 21
done
# the recommended configuration end to end: the thirteenth to fifteenth registrations' backward-Euler rules
rule "J1_a_free_arm_keeps_999_in_1000" ge "$jt1" $JT1_999
rule "J5_no_arm_step_stops_or_diverges" all_eq 0 "$j5s" "$j5d"
rule "L1_the_limit_at_rest_band" all_in $L_REST_LO $L_REST_HI "$lr1" "$lr16"
rule "L2_release_speed_damping_1" within "$lv1" $L_REL1 50
rule "L2_release_speed_damping_2" within "$lv2" $L_REL2 50
rule "L2_released_at_the_coarser_steps" all_ge $L_PAST "$la1_1" "$la1_16" "$la2_1" "$la2_16"
rule "L2_moving_at_the_end_damping_1" all_ge $L_MOVING1 "$ls1_1" "$ls1_16"
rule "L2_moving_at_the_end_damping_2" all_ge $L_MOVING2 "$ls2_1" "$ls2_16"
rule "L3_lifted_off_the_limit" all_ge $L_LIFTED "$ll1" "$ll16"
rule "L4_no_limit_step_stops_or_diverges" all_eq 0 "$(stat "$LL/stats.txt" stopped)" "$(stat "$LL/stats.txt" diverged)"
rule "R1_every_rotation_vector_right" all_eq 20 "$rsmall" "$rlarge"
rule "P1_stock_friction_at_the_impact_over_the_law" ge "$pi_stock_1" $CL_OVER
rule "P1_stock_slip_short_of_the_law" share "$pv_stock" "$pp_stock" 8 10
rule "P2_rest_carries_the_weight" within "$pr_final" $CL_WEIGHT 100
rule "P2_lift_never_pulls" eq "$pl_final" 0
rule "P2_hold_does_not_creep" in "$ph_final" -10 10
rule "P2_slide_friction_within_1_in_100" within "$ps_final" $CL_LAW 100
rule "P2_slip_reaches_95_in_100" share "$pp_final" "$pv_final" 100 95
rule "P2_friction_at_the_impact_within_1_in_25" all_within $CL_LAW 25 "$pi_final_1" "$pi_final_4"
rule "P2_no_step_diverges" eq "$pdv_final" 0
# changed before the run, as the fifteenth registration's amendment changed it for the accurate configuration: a step
# may stop on SuperDex's rule for an update too small to matter (reported above); none may stop at the iteration limit
rule "P2_no_step_stops_at_the_iteration_limit" le "$pmost_final" 199
rule "V1_pair_a_cube" all_within $PA_CUBE 100 "$b_pa_1" "$b_pa_16"
rule "V1_pair_a_block" all_within $PA_BLOCK 100 "$a_pa_1" "$a_pa_16"
rule "V1_pair_b_cube" all_within $PB_CUBE 100 "$b_pb_1" "$b_pb_16"
rule "V1_pair_b_block" all_within $PB_BLOCK 100 "$a_pb_1" "$a_pb_16"
rule "I1d_no_pair_step_stops_or_diverges" all_eq 0 "$ist" "$idv"
for w in $W_LIST; do rule "V2_arm_${w}_within_1_in_10000" all_within "$(awk -v w="$w" 'BEGIN { printf "%d", w * 1000000 + 0.5 }')" 10000 "$(eval echo \$sp_final_${w/./_}_1)" "$(eval echo \$sp_final_${w/./_}_4)" "$(eval echo \$sp_final_${w/./_}_16)"; done
rule "V2_free_chain_energy" all_within 1000000 1000 "$E_final_free_1" "$E_final_free_4" "$E_final_free_16"
rule "V2_free_chain_momentum" all_le 100 "$ML_final_free_1" "$ML_final_free_4" "$ML_final_free_16"
c=0; for tb in $CANT; do c=$((c + 1))
  rule "V4_cantilever_${c}_64_128_within_1_in_1000" all_within "$tb" 1000 "$(eval echo \$ct_${c}_64)" "$(eval echo \$ct_${c}_128)"
  rule "V4_cantilever_${c}_32_within_1_in_200" within "$(eval echo \$ct_${c}_32)" "$tb" 200
done
rule "V9_final_never_gains" all_le 10000 "$lq_most_1" "$lq_most_16"
rule "V9_no_step_diverges" eq "$lgdv" 0
rule "V9_no_step_stops_at_the_iteration_limit" le "$lgmost" 199
rule "D1_falls_rod_and_strip" all_le 1000 "$fall_rod_01" "$fall_rod_001" "$fall_shell_01" "$fall_shell_001"
rule "D1_falls_soft" all_le 50000 "$fall_soft_01" "$fall_soft_001"
rule "D2_rod_hangs" all_within $HANG_ROD 200 "$hang_rod_01" "$hang_rod_001"
rule "D2_strip_hangs" all_within $HANG_STRIP 200 "$hang_shell_01" "$hang_shell_001"
rule "D2_bar_hangs" all_within $HANG_BAR 200 "$hang_soft_01" "$hang_soft_001"
for cfg in stock final; do
  # read by its furthest point (deformstop), as the sixteenth registration's H1 read it
  rule "D4_slides_reach_${cfg}_shipped_step" all_within $BE_01 100 "$(eval echo \$far_${cfg}_shell_01)" "$(eval echo \$far_${cfg}_soft_01)"
  rule "D4_slides_reach_${cfg}_tenth_step" all_within $BE_001 100 "$(eval echo \$far_${cfg}_shell_001)" "$(eval echo \$far_${cfg}_soft_001)"
  rule "D7_rests_${cfg}" all_in -10 10 "$(eval echo \$restvx_${cfg}_shell_01)" "$(eval echo \$restvy_${cfg}_shell_01)" "$(eval echo \$restvx_${cfg}_soft_01)" "$(eval echo \$restvy_${cfg}_soft_01)" "$(eval echo \$restvx_${cfg}_shell_001)" "$(eval echo \$restvy_${cfg}_shell_001)" "$(eval echo \$restvx_${cfg}_soft_001)" "$(eval echo \$restvy_${cfg}_soft_001)"
done
rule "D5_stock_creeps_as_its_law_says" all_within $CREEP 10 "$holdv_stock_shell_01" "$holdv_stock_shell_001" "$holdv_stock_soft_01" "$holdv_stock_soft_001"
# read by the centre's drift between the second and the last quarter (deformdrift), as the sixteenth registration's H2
rule "D6_stock_drifts" all_ge 1000000 "$drift_stock_shell_01" "$drift_stock_shell_001" "$drift_stock_soft_01" "$drift_stock_soft_001"
rule "D6_final_holds_within_the_stick_distance" all_in -300000 300000 "$drift_final_shell_01" "$drift_final_shell_001" "$drift_final_soft_01" "$drift_final_soft_001"
rule "D8_no_step_stops_or_diverges" all_eq 0 "$dst" "$ddv"
for g in built fr3; do
  rule "GR1_grip_force_final_$g" all_within $GRIP_UN 100 "$(eval echo \$gpa_final_$g)" "$(eval echo \$gpb_final_$g)"
  rule "GR2_each_finger_carries_half_final_$g" all_within $HALF_UN 100 "$(eval echo \$gla_final_$g)" "$(eval echo \$glb_final_$g)"
done
rule "GR3_stock_lets_it_creep" all_le -10000 "$gc_stock_built" "$gc_stock_fr3"
rule "GR4_final_holds" all_in -1000 1000 "$gc_final_built" "$gc_final_fr3"
rule "GR4_final_slips_under_a_tenth_of_a_millimetre" all_in -100000 100000 "$gs_final_built" "$gs_final_fr3"
rule "GR5_no_final_grip_step_stops_or_diverges" all_eq 0 "$gst" "$gdv"
for sc in half_cheetah ant cart_pole; do
  rule "B1_${sc}_final_no_step_diverges" eq "$(field "$BS" ${sc}_final diverged)" 0
  rule "B2_${sc}_final_stops_no_more_than_1_in_1000" share "$(field "$BS" ${sc}_final stopped)" "$(field "$BS" ${sc}_final solver_steps)" 1 1000
done
# the eleventh and twelfth registrations' decisions on the order, carried on the configuration as it stands; stopped
# steps are reported above, not ruled, as the decisions did not rule them
rule "B3_half_cheetah_in_order_3_folds_of_3" eq "$ohy" 3
rule "B3_ant_in_order_3_folds_of_3" eq "$oay" 3
rule "B3_no_step_diverges_in_the_chains" eq "$odv" 0
held="$(grep -c '^RULE [A-Z][A-Za-z0-9]*_.* : HELD$' "$OUT")"; failed="$(grep -c '^RULE [A-Z][A-Za-z0-9]*_.* : FAILED$' "$OUT")"
fh="$(grep -c '^RULE F[0-9]_.* : HELD$' "$OUT")"; ff="$(grep -c '^RULE F[0-9]_.* : FAILED$' "$OUT")"
gh="$(grep -c '^RULE G[0-9]_.* : HELD$' "$OUT")"; gf="$(grep -c '^RULE G[0-9]_.* : FAILED$' "$OUT")"
echo "STUDY21 rule lines held $held failed $failed ; patch F's (F1 to F6) held $fh failed $ff ; patch G's (G1 to G9) held $gh failed $gf ; values missing $(wc -l < "$MISSF" | tr -d ' ') ; measuring complete $(( 1 - bad ))" >> "$OUT"
[ -s "$MISSF" ] && sed 's/^/missing | /' "$MISSF" >> "$OUT"
[ $bad -eq 0 ] || exit 1
exit 0
