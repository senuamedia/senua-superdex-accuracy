#!/usr/bin/env bash
# measure/runners/sx_study14_run.sh -- preregistrations/PREREGISTRATION_14.md: the
# fourteenth registration, the five open items fixed and two configurations end to end, re-made by measuring alone.
# Every registered rule is judged by sx_contact rule.
# usage: sx_study14_run.sh <public record root> <out file>        (sx_contact built beside this script)
#   Read under the root: validation/run_031_identity/identity.txt; validation/run_032_open_items/runs/;
#   joints/ (the sixth registration's stock files); validation/run_029_end_to_end/runs/deform_stock/ (the
#   thirteenth registration's cantilever held from x = 0).
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study14_run.sh <public record root> <out file>}"; OUT="${2:?out file}"
B="$HERE/sx_contact"
V="$R/validation/run_032_open_items"; U="$V/runs"; IT="$U/items"; ID="$R/validation/run_031_identity/identity.txt"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s14.XXXXXX")"; MISSF="$P/missing"; : > "$MISSF"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0
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
stat() { awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$1"; }
field() { local x; x="$(grep "^STATS source $2 " "$1" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
runstat() { local x; x="$(grep "^STATS run $2 " "$1" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }

# ---- E0: safe when off ----
while read -r _ part same _ played; do echo "identity | $part $same of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
differs="$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID")"; n_parts="$(grep -c '^IDENTITY ' "$ID")"

# ---- I1: the light cube's slip ----
for pr in p11_own p11_div p7_div pf_own pf_div p11_box; do for k in 1 16; do
  eval "a_${pr}_$k=\"$(nv "$(m "item 1, $pr, block 1/$k" accel "$IT/${pr}_${k}_a.txt" 700 900)" mean_acceleration_mm_s2)\""
  eval "b_${pr}_$k=\"$(nv "$(m "item 1, $pr, light cube 1/$k" accel "$IT/${pr}_${k}_b.txt" 700 900)" mean_acceleration_mm_s2)\""
done; done
for k in 1 16; do eval "e_p11_own_$k=\"$(nv "$(m "item 1, p11_own, light cube 0.55 s to 0.75 s, 1/$k" accel "$IT/p11_own_${k}_b.txt" 550 750)" mean_acceleration_mm_s2)\""; done
ist="$(stat "$IT/stats.txt" stopped)"; idv="$(stat "$IT/stats.txt" diverged)"

# ---- I2: the twelfth registration's arm and free chain at the registered tolerances ----
i2=""
for w in 1.5 3.5 6; do for k in 1 4 16; do
  s="$(nv "$(m "item 2, arm at $w rad/s, 1/$k" final "$IT/spin${w}_$k.txt")" speed_urads)"; eval "sp_${w/./_}_$k=$s"; i2="$i2 $s"
done; done
for k in 1 4 16; do l="$(m "item 2, free chain 1/$k" chain "$IT/chainfree_$k.txt")"; eval "ce_$k=\"$(nv "$l" kinetic_end_per_million_of_start)\"; cm_$k=\"$(nv "$l" momentum_largest_drift_ppm)\""; done

# ---- I4: the cantilevers ----
for rod in 13 f; do for cm in 0 1; do for n in 32 64 128; do
  eval "ct_${rod}_${cm}_$n=\"$(nv "$(m "item 4, rod $rod, clampmid $cm, $n elements" deform "$IT/cant${rod}_c${cm}_n$n.txt")" tip_drop_nm)\""
done; done; done

# ---- I5: the fresh arm and chain under BDF2 ----
for g in g nog; do for k in 1 4 16; do
  l="$(m "item 5, BDF2 $g, pendulum 1/$k" swing "$IT/b2${g}_swing_$k.txt")"
  eval "sw_${g}_${k}_1=\"$(nv "$l" swing_per_10000 1)\"; sw_${g}_${k}_2=\"$(nv "$l" swing_per_10000 2)\"; sw_${g}_${k}_3=\"$(nv "$l" swing_per_10000 3)\""
  eval "spn_${g}_$k=\"$(nv "$(m "item 5, BDF2 $g, free spin 1/$k" final "$IT/b2${g}_spin_$k.txt")" speed_urads)\""
  eval "csw_${g}_$k=\"$(nv "$(m "item 5, BDF2 $g, swinging chain 1/$k" chain "$IT/b2${g}_chainswing_$k.txt")" energy_drift_ppm_of_most_kinetic)\""
  l="$(m "item 5, BDF2 $g, free chain 1/$k" chain "$IT/b2${g}_chainfree_$k.txt")"; eval "cfe_${g}_$k=\"$(nv "$l" kinetic_end_per_million_of_start)\"; cfm_${g}_$k=\"$(nv "$l" momentum_largest_drift_ppm)\""
done; done
for k in 1 4 16; do
  m "item 5, backward Euler with patch G, pendulum 1/$k (reported)" swing "$IT/be_swing_$k.txt" > /dev/null
  eval "cbe_$k=\"$(nv "$(m "item 5, backward Euler with patch G, swinging chain 1/$k" chain "$IT/be_chainswing_$k.txt")" energy_drift_ppm_of_most_kinetic)\""
done

# ---- K: both contact suites, final configuration ----
export SUITE_MU10K=3500 SUITE_SLIPMN=4234
bash "$HERE/sx_contact_suite.sh" "$U/s1/final" "$P/suite1.txt" || { echo "measuring the first suite incomplete" >&2; bad=1; }
sed "s/^/first suite, final | /" "$P/suite1.txt" >> "$OUT"
k1="$(grep '^T[01][0-9]' "$P/suite1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n')"
d="$U/s2/final"; speeds=""; back=""; pairs=""
for run in stop land; do for k in 1 4 16 64; do line="$(m "second suite, final, $run 1/$k" stop "$d/${run}_$k.txt")"; speeds="$speeds $(f "$line" 7)"; back="$back $(f "$line" 11)"; done; done
for k in 1 16; do
  line="$(m "second suite, final, rest 1/$k" pair "$d/rest_${k}_a.txt" "$d/rest_${k}_b.txt")"; pairs="$pairs $(f "$line" 17) $(f "$line" 19)"
  line="$(m "second suite, final, carry 1/$k" pair "$d/carry_${k}_a.txt" "$d/carry_${k}_b.txt")"; pairs="$pairs $(f "$line" 15)"
  pairs="$pairs $(f "$(m "second suite, final, slip A 1/$k" accel "$d/slip_${k}_a.txt" 700 900)" 9) $(f "$(m "second suite, final, slip B 1/$k" accel "$d/slip_${k}_b.txt" 700 900)" 9)"
  line="$(m "second suite, final, side 1/$k" pair "$d/side_${k}_a.txt" "$d/side_${k}_b.txt")"; pairs="$pairs $(f "$line" 9)"
  line="$(m "second suite, final, top 1/$k" pair "$d/top_${k}_a.txt" "$d/top_${k}_b.txt")"; pairs="$pairs $(f "$line" 9) $(f "$line" 15)"
done
# shellcheck disable=SC2086
k2="$(f "$(m "second suite, final" suite2 $speeds $back $pairs 39200 5880 2929 6174 3920)" 17)"
kst=$(( $(stat "$U/s1/final/stats.txt" stopped) + $(stat "$U/s2/final/stats.txt" stopped) )); kdv=$(( $(stat "$U/s1/final/stats.txt" diverged) + $(stat "$U/s2/final/stats.txt" diverged) ))

# ---- A1: both contact suites, accurate configuration, read at 1/16 ----
a="$U/s1/accurate"
as_slide="$(nv "$(m "first suite, accurate, slide 1/16" creep "$a/slide_16.txt")" friction_over_normal_per_10000)"
as_rest="$(nv "$(m "first suite, accurate, rest 1/16" rest "$a/rest_16.txt")" mean_ground_force_mN)"
for k in 1 2 16 64; do eval "as_drop_$k=\"$(nv "$(m "first suite, accurate, drop 1/$k" bounce "$a/drop_$k.txt")" rebound_per_10000)\""; done
as_imp="$(nv "$(m "first suite, accurate, oblique impact 1/16" impact "$a/oblique_16.txt")" ratio_per_10000)"
as_set="$(nv "$(m "first suite, accurate, the 0.1 s after the impact 1/16" settle "$a/oblique_16.txt")" ratio_per_10000)"
as_hold="$(nv "$(m "first suite, accurate, hold 1/16" creep "$a/hold_16.txt")" mean_speed_ums)"
l="$(m "first suite, accurate, slip 1/16" slip "$a/slip_16.txt" 4234)"; as_slipv="$(nv "$l" mean_speed_ums)"; as_slipp="$(nv "$l" predicted_ums)"
as_lift="$(nv "$(m "first suite, accurate, lift 1/16" pull "$a/lift_16.txt")" steps_pulling)"; as_reb="$(nv "$(m "first suite, accurate, rebound 1/16" pull "$a/rebound_16.txt")" steps_pulling)"
a="$U/s2/accurate"
for run in stop land; do l="$(m "second suite, accurate, $run 1/16" stop "$a/${run}_16.txt")"; eval "a2_${run}_v=\"$(nv "$l" largest_speed_last_third_ums)\"; a2_${run}_back=\"$(nv "$l" came_back_um)\"; a2_${run}_slid=\"$(nv "$l" slid_um)\""; done
l="$(m "second suite, accurate, rest 1/16" pair "$a/rest_16_a.txt" "$a/rest_16_b.txt")"; a2_ra="$(nv "$l" force_up_a_mN)"; a2_rb="$(nv "$l" force_up_b_mN)"
a2_carry="$(nv "$(m "second suite, accurate, carry 1/16" pair "$a/carry_16_a.txt" "$a/carry_16_b.txt")" relative_mean_ums)"
a2_sa="$(nv "$(m "second suite, accurate, slip A 1/16" accel "$a/slip_16_a.txt" 700 900)" mean_acceleration_mm_s2)"; a2_sb="$(nv "$(m "second suite, accurate, slip B 1/16" accel "$a/slip_16_b.txt" 700 900)" mean_acceleration_mm_s2)"
a2_side="$(nv "$(m "second suite, accurate, side 1/16" pair "$a/side_16_a.txt" "$a/side_16_b.txt")" per_million)"
l="$(m "second suite, accurate, top 1/16" pair "$a/top_16_a.txt" "$a/top_16_b.txt")"; a2_top="$(nv "$l" per_million)"; a2_toprel="$(nv "$l" relative_mean_ums)"
ast=$(( $(stat "$U/s1/accurate/stats.txt" stopped) + $(stat "$U/s2/accurate/stats.txt" stopped) )); adv=$(( $(stat "$U/s1/accurate/stats.txt" diverged) + $(stat "$U/s2/accurate/stats.txt" diverged) ))

# ---- J: the sixth registration's arm ----
J="$U/joints_final"
jt1="$(nv "$(m "arm, final, free spin 1/1" final "$J/spin_1.txt")" speed_urads)"
jt2="$(nv "$(m "arm, final, driven 1/1" final "$J/torque_1.txt")" speed_urads)"
m "arm, final, pendulum 1/1 (reported)" swing "$J/swing_1.txt" > /dev/null
jh="$(nv "$(m "arm, final, hold 1/1" creep "$J/hold_1.txt")" mean_speed_ums)"; jh0="$(nv "$(m "arm, hold, stock 1/1" creep "$R/joints/hold_shipped_1.txt")" mean_speed_ums)"
js1="$(nv "$(m "arm, final, slip 1/1" final "$J/slip_1.txt")" speed_urads)"; js16="$(nv "$(m "arm, final, slip 1/16" final "$J/slip_16.txt")" speed_urads)"
J="$U/joints_accurate"
aj1="$(nv "$(m "arm, accurate, free spin 1/16" final "$J/spin_16.txt")" speed_urads)"
aj2="$(nv "$(m "arm, accurate, driven 1/16" final "$J/torque_16.txt")" speed_urads)"
l="$(m "arm, accurate, pendulum 1/16" swing "$J/swing_16.txt")"; aj3a="$(nv "$l" swing_per_10000 1)"; aj3b="$(nv "$l" swing_per_10000 2)"; aj3c="$(nv "$l" swing_per_10000 3)"
ajh="$(nv "$(m "arm, accurate, hold 1/16" creep "$J/hold_16.txt")" mean_speed_ums)"
ajs="$(nv "$(m "arm, accurate, slip 1/16" final "$J/slip_16.txt")" speed_urads)"
l="$(m "chain, accurate, free 1/16" chain "$J/chainfree_16.txt")"; acfe="$(nv "$l" kinetic_end_per_million_of_start)"; acfm="$(nv "$l" momentum_largest_drift_ppm)"
acsw="$(nv "$(m "chain, accurate, swinging 1/16" chain "$J/chainswing_16.txt")" energy_drift_ppm_of_most_kinetic)"

# ---- L: the eighth registration's limit runs ----
LL="$U/limits_final"
lr1="$(nv "$(m "limit, final, rest 1/1" final "$LL/rest_1.txt")" angle_urad)"; lr16="$(nv "$(m "limit, final, rest 1/16" final "$LL/rest_16.txt")" angle_urad)"
ll1="$(nv "$(m "limit, final, lift 1/1" final "$LL/lift_1.txt")" angle_urad)"; ll16="$(nv "$(m "limit, final, lift 1/16" final "$LL/lift_16.txt")" angle_urad)"
for dmp in 20 150; do
  eval "lv${dmp}=\"$(nv "$(m "limit, final, release, damping $dmp, 1/64" leave "$LL/rel${dmp}_64.txt" -300000)" speed_at_leaving_urads)\""
  for k in 1 16; do l="$(m "limit, final, release, damping $dmp, 1/$k" leave "$LL/rel${dmp}_$k.txt" -300000)"; eval "la${dmp}_$k=\"$(nv "$l" final_angle_urad)\"; ls${dmp}_$k=\"$(nv "$l" final_speed_urads)\""; done
done
AL="$U/limits_accurate"
alr="$(nv "$(m "limit, accurate, rest 1/16" final "$AL/rest_16.txt")" angle_urad)"; all_="$(nv "$(m "limit, accurate, lift 1/16" final "$AL/lift_16.txt")" angle_urad)"
for dmp in 20 150; do
  eval "alv${dmp}=\"$(nv "$(m "limit, accurate, release, damping $dmp, 1/64" leave "$AL/rel${dmp}_64.txt" -300000)" speed_at_leaving_urads)\""
  l="$(m "limit, accurate, release, damping $dmp, 1/16" leave "$AL/rel${dmp}_16.txt" -300000)"; eval "ala${dmp}=\"$(nv "$l" final_angle_urad)\"; als${dmp}=\"$(nv "$l" final_speed_urads)\""
done

# ---- R: the ninth registration's rotations ----
rv="$(m "rotations" rotvec "$U/rotvec_final.txt" 1)"
rsmall="$(echo "$rv" | awk '{ for (i=1;i<NF;i++) if ($i=="at_or_under_2e-9_rad") { print $(i+3); exit } }')"; rlarge="$(echo "$rv" | awk '{ for (i=1;i<NF;i++) if ($i=="larger") { print $(i+3); exit } }')"

# ---- P: point-cloud contact ----
for cfg in stock final accurate; do
  W="$U/cloud_$cfg"; ks="1 4"; one=1; [ $cfg = accurate ] && { ks="16"; one=16; }
  for k in $ks; do eval "pi_${cfg}_$k=\"$(nv "$(m "cloud $cfg, oblique impact 1/$k" impact "$W/oblique_$k.txt")" ratio_per_10000)\""; done
  m "cloud $cfg, the 0.1 s after the impact 1/$one (reported)" settle "$W/oblique_$one.txt" > /dev/null
  eval "ps_${cfg}=\"$(nv "$(m "cloud $cfg, slide 1/$one" creep "$W/slide_$one.txt")" friction_over_normal_per_10000)\""
  eval "pr_${cfg}=\"$(nv "$(m "cloud $cfg, rest 1/$one" rest "$W/rest_$one.txt")" mean_ground_force_mN)\""
  eval "ph_${cfg}=\"$(nv "$(m "cloud $cfg, hold 1/$one" creep "$W/hold_$one.txt")" mean_speed_ums)\""
  l="$(m "cloud $cfg, slip 1/$one" slip "$W/slip_$one.txt" 8467)"; eval "pv_${cfg}=\"$(nv "$l" mean_speed_ums)\"; pp_${cfg}=\"$(nv "$l" predicted_ums)\""
  eval "pl_${cfg}=\"$(nv "$(m "cloud $cfg, lift 1/$one" pull "$W/lift_$one.txt")" steps_pulling)\""
  eval "pst_${cfg}=\"$(stat "$W/stats.txt" stopped)\"; pdv_${cfg}=\"$(stat "$W/stats.txt" diverged)\""
done

# ---- D: deformable bodies ----
D0="$U/deform_stock"
dfw() { nv "$(m "$1" deform "$2")" "$3"; }
for dt in 0.01 0.001; do
  t="${dt#0.}"
  for b in rod shell soft; do eval "fall_${b}_$t=\"$(dfw "deform, stock, $b fall, $dt s" "$D0/${b}_fall_$dt.txt" fall_worst_nm)\""; done
  for b in rod shell soft; do eval "hang_${b}_$t=\"$(dfw "deform, stock, $b hang, $dt s" "$D0/${b}_hang_$dt.txt" tip_drop_nm)\""; done
done
for cfg in stock final accurate; do
  dts="0.01 0.001"; [ $cfg = accurate ] && dts="0.000625"
  for dt in $dts; do t="${dt#0.}"; DD="$U/deform_$cfg"; for b in shell soft; do
    eval "slide_${cfg}_${b}_$t=\"$(dfw "deform $cfg, $b slide, $dt s" "$DD/${b}_slide_$dt.txt" moved_x_nm)\""
    l="$(m "deform $cfg, $b hold, $dt s" deform "$DD/${b}_hold_$dt.txt")"; eval "holdv_${cfg}_${b}_$t=\"$(nv "$l" end_vx_ums)\"; holdc_${cfg}_${b}_$t=\"$(nv "$l" tip_along_x_nm)\""
    l="$(m "deform $cfg, $b rest, $dt s" deform "$DD/${b}_rest_$dt.txt")"; eval "restvx_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vx_ums)\"; restvy_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vy_ums)\""
  done; done
done
for n in 32 64 128; do eval "cant_$n=\"$(dfw "deform, stock, cantilever held across the clamp, $n elements" "$D0/cantilever_n${n}_0.01.txt" tip_drop_nm)\""; done
dst=$(( $(stat "$D0/stats.txt" stopped) + $(stat "$U/deform_final/stats.txt" stopped) )); ddv=$(( $(stat "$D0/stats.txt" diverged) + $(stat "$U/deform_final/stats.txt" diverged) ))
adst="$(stat "$U/deform_accurate/stats.txt" stopped)"; addv="$(stat "$U/deform_accurate/stats.txt" diverged)"

# ---- G: a gripper holding a cube ----
for cfg in stock final accurate; do for g in built fr3; do
  l="$(m "grip $cfg, $g, 8 N" grip "$U/grip_$cfg/${g}_8.txt" 3)"
  eval "gpa_${cfg}_$g=\"$(nv "$l" press_a_uN)\"; gpb_${cfg}_$g=\"$(nv "$l" press_b_uN)\"; gla_${cfg}_$g=\"$(nv "$l" lift_a_uN)\"; glb_${cfg}_$g=\"$(nv "$l" lift_b_uN)\"; gc_${cfg}_$g=\"$(nv "$l" creep_nms)\"; gs_${cfg}_$g=\"$(nv "$l" slipped_nm)\""
  m "grip $cfg, $g, 0.9 N (reported)" grip "$U/grip_$cfg/${g}_0.9.txt" 10 > /dev/null
done; done
gsc() { local s=0 x; for g in built fr3; do for gr in ${3:-8}; do x="$(runstat "$U/grip_$1/stats.txt" "${g}_$gr" "$2")"; s=$(( s + x )); done; done; echo "$s"; }
gst="$(gsc final stopped)"; gdv="$(gsc final diverged)"; agst="$(gsc accurate stopped)"; agdv="$(gsc accurate diverged)"
echo "grip | stopped steps of the weak grip (reported): final $(gsc final stopped 0.9), accurate $(gsc accurate stopped 0.9)" >> "$OUT"

# ---- B: the benchmark on fresh commands ----
BS="$U/bench/stats.txt"
for sc in half_cheetah ant cart_pole; do for cfg in stock final accurate; do
  echo "benchmark | $sc $cfg steps $(field "$BS" ${sc}_$cfg solver_steps) stopped $(field "$BS" ${sc}_$cfg stopped) diverged $(field "$BS" ${sc}_$cfg diverged) most_iterations $(field "$BS" ${sc}_$cfg most_iterations) wall_s $(field "$BS" ${sc}_$cfg wall_s)" >> "$OUT"
done; done
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; fi

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
rule "E0_every_part_identical_in_full" eq "$differs" 0
rule "E0_parts_played" eq "$n_parts" 10
# item 1
rule "I1a_own_grid_short_at_the_sixteenth" le "$b_p11_own_16" 4322
rule "I1b_own_grid_right_before_the_last_cell" all_within 4410 100 "$e_p11_own_1" "$e_p11_own_16"
rule "I1c_eleventh_pair_at_1_32" all_within 4410 100 "$b_p11_div_1" "$b_p11_div_16"
rule "I1c_eleventh_pair_block" all_within 6982 100 "$a_p11_div_1" "$a_p11_div_16"
rule "I1c_seventh_pair_at_1_32" all_within 3920 100 "$b_p7_div_1" "$b_p7_div_16"
rule "I1c_seventh_pair_block" all_within 6174 100 "$a_p7_div_1" "$a_p7_div_16"
rule "I1c_fresh_pair_at_1_32" all_within 4116 100 "$b_pf_div_1" "$b_pf_div_16"
rule "I1c_fresh_pair_block" all_within 6439 100 "$a_pf_div_1" "$a_pf_div_16"
rule "I1d_no_step_stops_or_diverges" all_eq 0 "$ist" "$idv"
# item 2
rule "I2a_arm_1_5_rad_s" all_within 1500000 10000 "$sp_1_5_1" "$sp_1_5_4" "$sp_1_5_16"
rule "I2a_arm_3_5_rad_s" all_within 3500000 10000 "$sp_3_5_1" "$sp_3_5_4" "$sp_3_5_16"
rule "I2a_arm_6_rad_s" all_within 6000000 10000 "$sp_6_1" "$sp_6_4" "$sp_6_16"
rule "I2b_free_chain_energy" all_within 1000000 1000 "$ce_1" "$ce_4" "$ce_16"
rule "I2b_free_chain_momentum" all_le 100 "$cm_1" "$cm_4" "$cm_16"
# item 4
rule "I4a_thirteenth_rod_across_the_clamp_64_128" all_within 6350400 1000 "$ct_13_1_64" "$ct_13_1_128"
rule "I4a_thirteenth_rod_across_the_clamp_32" within "$ct_13_1_32" 6350400 200
rule "I4a_fresh_rod_across_the_clamp_64_128" all_within 6279082 1000 "$ct_f_1_64" "$ct_f_1_128"
rule "I4a_fresh_rod_across_the_clamp_32" within "$ct_f_1_32" 6279082 200
# the first clamp's shortfall against the half-element prediction, within 1 in 10 of it, at 32 and 64 elements
for rod in 13 f; do
  tb=6350400; [ $rod = f ] && tb=6279082
  for n in 32 64; do
    pred=0; [ $n = 32 ] && pred=$(( tb * 610504 / 10000000 )); [ $n = 64 ] && pred=$(( tb * 308857 / 10000000 ))
    short=$(( tb - $(eval echo \$ct_${rod}_0_$n) ))
    rule "I4b_rod_${rod}_held_from_zero_short_by_half_an_element_$n" within "$short" "$pred" 10
  done
done
rule "I4c_the_end_to_end_cantilever_across_the_clamp" all_within 6350400 1000 "$cant_64" "$cant_128"
# item 5
rule "I5a_bdf2_without_patch_g_loses_speed" le "$spn_nog_1" 3960000
rule "I5b_bdf2_with_patch_g_free_spin" all_ge 3996000 "$spn_g_1" "$spn_g_4" "$spn_g_16"
rule "I5b_pendulum_shipped_step" all_in 9950 10010 "$sw_g_1_1" "$sw_g_1_2" "$sw_g_1_3"
rule "I5b_pendulum_quarter_step" all_in 9990 10010 "$sw_g_4_1" "$sw_g_4_2" "$sw_g_4_3"
rule "I5b_pendulum_sixteenth_step" all_in 9995 10005 "$sw_g_16_1" "$sw_g_16_2" "$sw_g_16_3"
rule "I5c_swinging_chain_quarter_step" in "$csw_g_4" -10000 10000
rule "I5c_swinging_chain_sixteenth_step" in "$csw_g_16" -5000 5000
rule "I5c_backward_euler_loses_more_at_the_quarter_step" le "$cbe_4" "$(( 0 - ${csw_g_4#-} ))"
rule "I5c_free_chain_sixteenth_step" within "$cfe_g_16" 1000000 100
rule "I5c_free_chain_momentum_sixteenth_step" le "$cfm_g_16" 1000
rule "I5d_bdf2_bounces_at_the_coarse_steps" ge "$(( as_drop_1 > as_drop_2 ? as_drop_1 : as_drop_2 ))" 500
# end to end, the final configuration
rule "K1_first_suite_all_ten" eq "$k1" 1111111111
rule "K2_second_suite_all_seven" eq "$k2" 1111111
rule "K3_no_suite_step_stops_or_diverges" all_eq 0 "$kst" "$kdv"
rule "J1_a_free_arm_keeps_its_speed" ge "$jt1" 2997000
rule "J2_a_driven_arm" within "$jt2" 4656457 100
rule "J3_joint_friction_holds_as_stock" near "$jh" "$jh0" 10
rule "J4_slip_at_its_right_answer" all_within 3104308 100 "$js1" "$js16"
rule "J5_no_arm_step_stops_or_diverges" all_eq 0 "$(stat "$U/joints_final/stats.txt" stopped)" "$(stat "$U/joints_final/stats.txt" diverged)"
rule "L1_the_limit_at_rest_band" all_in -303778 -303704 "$lr1" "$lr16"
rule "L2_release_speed_damping_20" within "$lv20" 1434131 50
rule "L2_release_speed_damping_150" within "$lv150" 369401 50
rule "L2_released_at_the_coarser_steps" all_ge -299000 "$la20_1" "$la20_16" "$la150_1" "$la150_16"
rule "L2_moving_at_the_end_damping_20" all_ge 143414 "$ls20_1" "$ls20_16"
rule "L2_moving_at_the_end_damping_150" all_ge 36941 "$ls150_1" "$ls150_16"
rule "L3_lifted_off_the_limit" all_ge -189208 "$ll1" "$ll16"
rule "L4_no_limit_step_stops_or_diverges" all_eq 0 "$(stat "$LL/stats.txt" stopped)" "$(stat "$LL/stats.txt" diverged)"
rule "R1_every_rotation_vector_right" all_eq 20 "$rsmall" "$rlarge"
rule "P1_stock_friction_at_the_impact_over_the_law" ge "$pi_stock_1" 4200
rule "P1_stock_slip_short_of_the_law" share "$pv_stock" "$pp_stock" 8 10
rule "P2_rest_carries_the_weight" within "$pr_final" 15680 100
rule "P2_lift_never_pulls" eq "$pl_final" 0
rule "P2_hold_does_not_creep" in "$ph_final" -10 10
rule "P2_slide_friction_within_1_in_100" within "$ps_final" 3500 100
rule "P2_slip_reaches_95_in_100" share "$pp_final" "$pv_final" 100 95
rule "P2_friction_at_the_impact_within_1_in_25" all_within 3500 25 "$pi_final_1" "$pi_final_4"
rule "P2_no_step_stops_or_diverges" all_eq 0 "$pst_final" "$pdv_final"
rule "D1_falls_rod_and_shell" all_le 1000 "$fall_rod_01" "$fall_rod_001" "$fall_shell_01" "$fall_shell_001"
rule "D1_falls_soft" all_le 50000 "$fall_soft_01" "$fall_soft_001"
rule "D2_rod_hangs" all_within 1404624 200 "$hang_rod_01" "$hang_rod_001"
rule "D2_strip_hangs" all_within 936416 200 "$hang_shell_01" "$hang_shell_001"
rule "D2_bar_hangs" all_within 431200 200 "$hang_soft_01" "$hang_soft_001"
for cfg in stock final; do
  rule "D4_slides_${cfg}_shipped_step" all_within 52055556 100 "$(eval echo \$slide_${cfg}_shell_01)" "$(eval echo \$slide_${cfg}_soft_01)"
  rule "D4_slides_${cfg}_tenth_step" all_within 55205556 100 "$(eval echo \$slide_${cfg}_shell_001)" "$(eval echo \$slide_${cfg}_soft_001)"
  rule "D7_rests_${cfg}" all_in -10 10 "$(eval echo \$restvx_${cfg}_shell_01)" "$(eval echo \$restvy_${cfg}_shell_01)" "$(eval echo \$restvx_${cfg}_soft_01)" "$(eval echo \$restvy_${cfg}_soft_01)" "$(eval echo \$restvx_${cfg}_shell_001)" "$(eval echo \$restvy_${cfg}_shell_001)" "$(eval echo \$restvx_${cfg}_soft_001)" "$(eval echo \$restvy_${cfg}_soft_001)"
done
rule "D5_stock_creeps_as_its_law_says" all_within 4409 10 "$holdv_stock_shell_01" "$holdv_stock_shell_001" "$holdv_stock_soft_01" "$holdv_stock_soft_001"
rule "D6_final_holds" all_in -10 10 "$holdv_final_shell_01" "$holdv_final_shell_001" "$holdv_final_soft_01" "$holdv_final_soft_001"
rule "D6_final_contact_within_the_stick_distance" all_in -300000 300000 "$holdc_final_shell_01" "$holdc_final_shell_001" "$holdc_final_soft_01" "$holdc_final_soft_001"
rule "D8_no_step_stops_or_diverges" all_eq 0 "$dst" "$ddv"
for g in built fr3; do
  rule "G1_grip_force_final_$g" all_within 8000000 100 "$(eval echo \$gpa_final_$g)" "$(eval echo \$gpb_final_$g)"
  rule "G2_each_finger_carries_half_final_$g" all_within 735000 100 "$(eval echo \$gla_final_$g)" "$(eval echo \$glb_final_$g)"
done
rule "G3_stock_lets_it_creep" all_le -10000 "$gc_stock_built" "$gc_stock_fr3"
rule "G4_final_holds" all_in -1000 1000 "$gc_final_built" "$gc_final_fr3"
rule "G4_final_slips_under_a_tenth_of_a_millimetre" all_in -100000 100000 "$gs_final_built" "$gs_final_fr3"
rule "G5_no_final_grip_step_stops_or_diverges" all_eq 0 "$gst" "$gdv"
for sc in half_cheetah ant cart_pole; do
  rule "B1_${sc}_final_no_step_diverges" eq "$(field "$BS" ${sc}_final diverged)" 0
  rule "B2_${sc}_final_stops_no_more_than_1_in_1000" share "$(field "$BS" ${sc}_final stopped)" "$(field "$BS" ${sc}_final solver_steps)" 1 1000
done
# end to end, the accurate configuration (BDF2 at 1/16)
rule "A1_slide_friction" within "$as_slide" 3500 100
rule "A1_rest_carries_the_weight" within "$as_rest" 7840 100
rule "A1_friction_at_the_impact" within "$as_imp" 3500 100
rule "A1_friction_over_the_impact_and_after" within "$as_set" 3500 100
rule "A1_hold_does_not_creep" in "$as_hold" -10 10
rule "A1_slip_within_2_in_100" within "$as_slipv" "$as_slipp" 50
rule "A1_lift_and_rebound_never_pull" all_eq 0 "$as_lift" "$as_reb"
rule "A1_bounce_resolved" near "$as_drop_16" "$as_drop_64" 100
rule "A1_slide_and_landing_stay_stopped" all_le 100 "$a2_stop_v" "$a2_land_v"
rule "A1_come_back_no_more_than_330_um" all_le 330 "$a2_stop_back" "$a2_land_back"
rule "A1_slide_stops_at_coulombs_distance" within "$a2_stop_slid" 118076 100
rule "A1_each_contact_carries_its_weight" all_within 39200 100 "$a2_ra"
rule "A1_the_top_cube_carries_its_weight" within "$a2_rb" 5880 100
rule "A1_the_carried_cube_rides" in "$a2_carry" -100 100
rule "A1_slip_block" within "$a2_sa" 6174 50
rule "A1_slip_cube" within "$a2_sb" 3920 50
rule "A1_momentum_kept" all_in -500 500 "$a2_side" "$a2_top"
rule "A1_the_top_cube_ends_with_the_lower" in "$a2_toprel" -100 100
rule "A1_no_suite_step_stops_or_diverges" all_eq 0 "$ast" "$adv"
rule "A2_a_free_arm_keeps_its_speed" ge "$aj1" 2999700
rule "A2_a_driven_arm" within "$aj2" 4656457 1000
rule "A2_the_pendulum_keeps_its_swing" all_in 9990 10010 "$aj3a" "$aj3b" "$aj3c"
rule "A2_joint_friction_holds_as_stock" near "$ajh" "$jh0" 10
rule "A2_slip_at_its_right_answer" within "$ajs" 3104308 100
rule "A2_free_chain" within "$acfe" 1000000 200
rule "A2_free_chain_momentum" le "$acfm" 1000
rule "A2_swinging_chain_keeps_its_energy" in "$acsw" -5000 5000
rule "A2_no_arm_step_stops_or_diverges" all_eq 0 "$(stat "$U/joints_accurate/stats.txt" stopped)" "$(stat "$U/joints_accurate/stats.txt" diverged)"
rule "A3_the_limit_at_rest_band" in "$alr" -303778 -303704
rule "A3_release_speed_damping_20" within "$alv20" 1434131 50
rule "A3_release_speed_damping_150" within "$alv150" 369401 50
rule "A3_released_and_moving" all_ge -299000 "$ala20" "$ala150"
rule "A3_moving_at_the_end" all_ge 36941 "$als20" "$als150"
rule "A3_lifted_off_the_limit" ge "$all_" -189208
rule "A3_no_limit_step_stops_or_diverges" all_eq 0 "$(stat "$AL/stats.txt" stopped)" "$(stat "$AL/stats.txt" diverged)"
rule "A4_cloud_rest" within "$pr_accurate" 15680 100
rule "A4_cloud_lift_never_pulls" eq "$pl_accurate" 0
rule "A4_cloud_hold" in "$ph_accurate" -10 10
rule "A4_cloud_slide" within "$ps_accurate" 3500 100
rule "A4_cloud_slip" share "$pp_accurate" "$pv_accurate" 100 95
rule "A4_cloud_impact" within "$pi_accurate_16" 3500 25
rule "A4_cloud_no_step_stops_or_diverges" all_eq 0 "$pst_accurate" "$pdv_accurate"
rule "A5_slides_stop_at_coulombs_distance" all_within 55555556 100 "$slide_accurate_shell_000625" "$slide_accurate_soft_000625"
rule "A5_contact_within_the_stick_distance" all_in -300000 300000 "$holdc_accurate_shell_000625" "$holdc_accurate_soft_000625"
rule "A5_rests" all_in -10 10 "$restvx_accurate_shell_000625" "$restvy_accurate_shell_000625" "$restvx_accurate_soft_000625" "$restvy_accurate_soft_000625"
rule "A5_no_step_stops_or_diverges" all_eq 0 "$adst" "$addv"
for g in built fr3; do
  rule "A6_grip_force_$g" all_within 8000000 100 "$(eval echo \$gpa_accurate_$g)" "$(eval echo \$gpb_accurate_$g)"
  rule "A6_each_finger_carries_half_$g" all_within 735000 100 "$(eval echo \$gla_accurate_$g)" "$(eval echo \$glb_accurate_$g)"
done
rule "A6_holds" all_in -1000 1000 "$gc_accurate_built" "$gc_accurate_fr3"
rule "A6_slips_under_a_tenth_of_a_millimetre" all_in -100000 100000 "$gs_accurate_built" "$gs_accurate_fr3"
rule "A6_no_grip_step_stops_or_diverges" all_eq 0 "$agst" "$agdv"
for sc in half_cheetah ant cart_pole; do
  rule "A7_${sc}_no_step_diverges" eq "$(field "$BS" ${sc}_accurate diverged)" 0
  rule "A7_${sc}_stops_no_more_than_1_in_1000" share "$(field "$BS" ${sc}_accurate stopped)" "$(field "$BS" ${sc}_accurate solver_steps)" 1 1000
done
held="$(grep -c '^RULE [A-Z][0-9].* : HELD$' "$OUT")"; failed="$(grep -c '^RULE [A-Z][0-9].* : FAILED$' "$OUT")"
echo "STUDY14 rules held $held failed $failed ; values missing $(wc -l < "$MISSF" | tr -d ' ') ; measuring complete $(( 1 - bad ))" >> "$OUT"
[ $bad -eq 0 ] || exit 1
exit 0
