#!/usr/bin/env bash
# measure/runners/sx_study13_run.sh -- preregistrations/PREREGISTRATION_13.md: the
# thirteenth registration, the complete patch list end to end, re-made by measuring alone. Every earlier known-answer
# test under the final configuration, the three areas not tested before (point-cloud contact, deformable bodies, a
# gripper), and the benchmark on fresh commands. Every registered rule is judged by sx_contact rule.
# usage: sx_study13_run.sh <public record root> <out file>        (sx_contact built beside this script)
#   Read under the root: validation/run_025_identity/identity.txt; validation/run_027_friction/reading.txt and
#   validation/run_028_joint_motion/reading.txt (the two decisions); validation/run_029_end_to_end/ (runs/,
#   configuration.txt); joints/ (the sixth registration's stock files).
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study13_run.sh <public record root> <out file>}"; OUT="${2:?out file}"
B="$HERE/sx_contact"
V="$R/validation/run_029_end_to_end"; U="$V/runs"; ID="$R/validation/run_025_identity/identity.txt"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s13.XXXXXX")"; MISSF="$P/missing"; : > "$MISSF"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the measure's LAST line
  local label="$1"; shift
  local lines; lines="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> "$OUT"; echo "$lines" | tail -1
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
# the number after a name; a name a measured line does not hold counts as missing and stands as 999999999
nv() { local x; x="$(echo "$1" | awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) { print $(i + 1); exit } }')"; if [ -z "$x" ]; then echo "$2" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
rule() { "$B" rule "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "rule failed to run: $*" >&2; bad=1; }; }
stat() { awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$1"; }
field() { local x; x="$(grep "^STATS source $2 " "$1" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
dec() { grep -o 'decision lines held [0-9] of 3' "$1" | awk '{ if ($4 == 3) print "yes"; else print "no" }'; }

# ---- the configuration and the decisions it follows ----
WF="$(awk '{print $2}' "$V/configuration.txt")"; WG="$(awk '{print $4}' "$V/configuration.txt")"
DF="$(dec "$R/validation/run_027_friction/reading.txt")"; DG="$(dec "$R/validation/run_028_joint_motion/reading.txt")"
echo "configuration | played with patch F: $WF ; with patch G and Newton-Euler inertia: $WG ; the eleventh registration's decision: $DF ; the twelfth's: $DG" >> "$OUT"
yn() { if [ "$1" = yes ]; then echo 1; else echo 0; fi; }

# ---- E0: safe when off ----
while read -r _ part same _ played; do echo "identity | $part $same of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
differs="$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID")"; n_parts="$(grep -c '^IDENTITY ' "$ID")"

# ---- K: both contact suites, the seventh registration's cubes ----
export SUITE_MU10K=3500 SUITE_SLIPMN=4234
bash "$HERE/sx_contact_suite.sh" "$U/s1/fc" "$P/suite1.txt" || { echo "measuring the first suite incomplete" >&2; bad=1; }
sed "s/^/first suite | /" "$P/suite1.txt" >> "$OUT"
k1="$(grep '^T[01][0-9]' "$P/suite1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n')"
d="$U/s2/fc"; speeds=""; back=""; pairs=""
for run in stop land; do for k in 1 4 16 64; do line="$(m "second suite $run 1/$k" stop "$d/${run}_$k.txt")"; speeds="$speeds $(f "$line" 7)"; back="$back $(f "$line" 11)"; done; done
for k in 1 16; do
  line="$(m "second suite rest 1/$k" pair "$d/rest_${k}_a.txt" "$d/rest_${k}_b.txt")"; pairs="$pairs $(f "$line" 17) $(f "$line" 19)"
  line="$(m "second suite carry 1/$k" pair "$d/carry_${k}_a.txt" "$d/carry_${k}_b.txt")"; pairs="$pairs $(f "$line" 15)"
  pairs="$pairs $(f "$(m "second suite slip A 1/$k" accel "$d/slip_${k}_a.txt" 700 900)" 9) $(f "$(m "second suite slip B 1/$k" accel "$d/slip_${k}_b.txt" 700 900)" 9)"
  line="$(m "second suite side 1/$k" pair "$d/side_${k}_a.txt" "$d/side_${k}_b.txt")"; pairs="$pairs $(f "$line" 9)"
  line="$(m "second suite top 1/$k" pair "$d/top_${k}_a.txt" "$d/top_${k}_b.txt")"; pairs="$pairs $(f "$line" 9) $(f "$line" 15)"
done
# shellcheck disable=SC2086
k2="$(f "$(m "second suite" suite2 $speeds $back $pairs 39200 5880 2929 6174 3920)" 17)"
kst=$(( $(stat "$U/s1/fc/stats.txt" stopped) + $(stat "$U/s2/fc/stats.txt" stopped) )); kdv=$(( $(stat "$U/s1/fc/stats.txt" diverged) + $(stat "$U/s2/fc/stats.txt" diverged) ))

# ---- J: the sixth registration's arm ----
J="$U/joints_fc"
jt1="$(nv "$(m "arm, free spin 1/1" final "$J/spin_be_1.txt")" speed_urads)"
jt2="$(nv "$(m "arm, driven 1/1" final "$J/torque_be_1.txt")" speed_urads)"
m "arm, pendulum 1/1 (reported)" swing "$J/swing_be_1.txt" > /dev/null
jh="$(nv "$(m "arm, hold 1/1" creep "$J/hold_shipped_1.txt")" mean_speed_ums)"; jh0="$(nv "$(m "arm, hold, stock 1/1" creep "$R/joints/hold_shipped_1.txt")" mean_speed_ums)"
js1="$(nv "$(m "arm, slip 1/1" final "$J/slip_shipped_1.txt")" speed_urads)"; js16="$(nv "$(m "arm, slip 1/16" final "$J/slip_shipped_16.txt")" speed_urads)"

# ---- L: the eighth registration's limit runs ----
LL="$U/limits_fc"
lr1="$(nv "$(m "limit, rest 1/1" final "$LL/rest_1.txt")" angle_urad)"; lr16="$(nv "$(m "limit, rest 1/16" final "$LL/rest_16.txt")" angle_urad)"
ll1="$(nv "$(m "limit, lift 1/1" final "$LL/lift_1.txt")" angle_urad)"; ll16="$(nv "$(m "limit, lift 1/16" final "$LL/lift_16.txt")" angle_urad)"
for dmp in 20 150; do
  eval "lv${dmp}=\"$(nv "$(m "limit, release, damping $dmp, 1/64" leave "$LL/rel${dmp}_64.txt" -300000)" speed_at_leaving_urads)\""
  for k in 1 16; do l="$(m "limit, release, damping $dmp, 1/$k" leave "$LL/rel${dmp}_$k.txt" -300000)"; eval "la${dmp}_$k=\"$(nv "$l" final_angle_urad)\"; ls${dmp}_$k=\"$(nv "$l" final_speed_urads)\""; done
done

# ---- R: the ninth registration's rotations ----
rv="$(m "rotations" rotvec "$U/rotvec_fc.txt" 1)"
rsmall="$(echo "$rv" | awk '{ for (i=1;i<NF;i++) if ($i=="at_or_under_2e-9_rad") { print $(i+3); exit } }')"; rlarge="$(echo "$rv" | awk '{ for (i=1;i<NF;i++) if ($i=="larger") { print $(i+3); exit } }')"

# ---- P: point-cloud contact ----
for cfg in stock fc; do
  W="$U/cloud_$cfg"
  for k in 1 4; do eval "pi_${cfg}_$k=\"$(nv "$(m "cloud $cfg, oblique impact 1/$k" impact "$W/oblique_$k.txt")" ratio_per_10000)\""; done
  m "cloud $cfg, the 0.1 s after the impact 1/1 (reported)" settle "$W/oblique_1.txt" > /dev/null
  eval "ps_${cfg}=\"$(nv "$(m "cloud $cfg, slide 1/1" creep "$W/slide_1.txt")" friction_over_normal_per_10000)\""
  l="$(m "cloud $cfg, rest 1/1" rest "$W/rest_1.txt")"; eval "pr_${cfg}=\"$(nv "$l" mean_ground_force_mN)\""
  eval "ph_${cfg}=\"$(nv "$(m "cloud $cfg, hold 1/1" creep "$W/hold_1.txt")" mean_speed_ums)\""
  l="$(m "cloud $cfg, slip 1/1" slip "$W/slip_1.txt" 8467)"; eval "pv_${cfg}=\"$(nv "$l" mean_speed_ums)\"; pp_${cfg}=\"$(nv "$l" predicted_ums)\""
  eval "pl_${cfg}=\"$(nv "$(m "cloud $cfg, lift 1/1" pull "$W/lift_1.txt")" steps_pulling)\""
done
pst="$(stat "$U/cloud_fc/stats.txt" stopped)"; pdv="$(stat "$U/cloud_fc/stats.txt" diverged)"

# ---- D: deformable bodies ----
D0="$U/deform_stock"; D1="$U/deform_fc"
dfw() { nv "$(m "$1" deform "$2")" "$3"; }
for dt in 0.01 0.001; do
  t="${dt#0.}"
  for b in rod shell soft; do eval "fall_${b}_$t=\"$(dfw "deform, $b fall, $dt s" "$D0/${b}_fall_$dt.txt" fall_worst_nm)\""; done
  for b in rod shell soft; do eval "hang_${b}_$t=\"$(dfw "deform, $b hang, $dt s" "$D0/${b}_hang_$dt.txt" tip_drop_nm)\""; done
  for cfg in stock fc; do DD="$U/deform_$cfg"; for b in shell soft; do
    eval "slide_${cfg}_${b}_$t=\"$(dfw "deform $cfg, $b slide, $dt s" "$DD/${b}_slide_$dt.txt" moved_x_nm)\""
    l="$(m "deform $cfg, $b hold, $dt s" deform "$DD/${b}_hold_$dt.txt")"; eval "holdv_${cfg}_${b}_$t=\"$(nv "$l" end_vx_ums)\"; holdx_${cfg}_${b}_$t=\"$(nv "$l" moved_x_nm)\""
    l="$(m "deform $cfg, $b rest, $dt s" deform "$DD/${b}_rest_$dt.txt")"; eval "restvx_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vx_ums)\"; restvy_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vy_ums)\""
  done; done
done
for n in 32 64 128; do eval "cant_$n=\"$(dfw "deform, cantilever, $n elements" "$D0/cantilever_n${n}_0.01.txt" tip_drop_nm)\""; done
dst=$(( $(stat "$D0/stats.txt" stopped) + $(stat "$D1/stats.txt" stopped) )); ddv=$(( $(stat "$D0/stats.txt" diverged) + $(stat "$D1/stats.txt" diverged) ))

# ---- G: a gripper holding a cube ----
for cfg in stock fc; do for g in built fr3; do
  l="$(m "grip $cfg, $g, 8 N" grip "$U/grip_$cfg/${g}_8.txt" 3)"
  eval "gpa_${cfg}_$g=\"$(nv "$l" press_a_uN)\"; gpb_${cfg}_$g=\"$(nv "$l" press_b_uN)\"; gla_${cfg}_$g=\"$(nv "$l" lift_a_uN)\"; glb_${cfg}_$g=\"$(nv "$l" lift_b_uN)\"; gc_${cfg}_$g=\"$(nv "$l" creep_nms)\"; gs_${cfg}_$g=\"$(nv "$l" slipped_nm)\""
  m "grip $cfg, $g, 0.9 N (reported)" grip "$U/grip_$cfg/${g}_0.9.txt" 10 > /dev/null
done; done
gst=0; gdv=0; for g in built fr3; do for x in 8 0.9; do
  gst=$(( gst + $(grep "^STATS run ${g}_$x " "$U/grip_fc/stats.txt" | awk '{for(i=1;i<NF;i++) if ($i=="stopped") print $(i+1)}') ))
  gdv=$(( gdv + $(grep "^STATS run ${g}_$x " "$U/grip_fc/stats.txt" | awk '{for(i=1;i<NF;i++) if ($i=="diverged") print $(i+1)}') ))
done; done

# ---- B: the benchmark on fresh commands ----
BS="$U/bench/stats.txt"
for sc in half_cheetah ant cart_pole; do for cfg in stock fc; do
  echo "benchmark | $sc $cfg steps $(field "$BS" ${sc}_$cfg solver_steps) stopped $(field "$BS" ${sc}_$cfg stopped) diverged $(field "$BS" ${sc}_$cfg diverged) most_iterations $(field "$BS" ${sc}_$cfg most_iterations)" >> "$OUT"
done; done
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; fi

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
rule "C0_played_as_the_decisions_say" eq "$(yn "$WF")$(yn "$WG")" "$(yn "$DF")$(yn "$DG")"
rule "E0_every_part_identical_in_full" eq "$differs" 0
rule "E0_parts_played" eq "$n_parts" 9
if [ "$WF" = yes ]; then rule "K1_first_suite_all_ten" eq "$k1" 1111111111; else rule "K1_first_suite_all_but_T05" eq "$k1" 1111011111; fi
rule "K2_second_suite_all_seven" eq "$k2" 1111111
rule "K3_no_suite_step_stops" eq "$kst" 0
rule "K3_no_suite_step_diverges" eq "$kdv" 0
if [ "$WG" = yes ]; then
  rule "J1_a_free_arm_keeps_its_speed" ge "$jt1" 2970000
  rule "J2_a_driven_arm" within "$jt2" 4656457 100
fi
rule "J3_joint_friction_holds_as_stock" near "$jh" "$jh0" 10
rule "J4_slip_as_stock_shipped_step" within "$js1" 3032560 100
rule "J4_slip_as_stock_sixteenth_step" within "$js16" 3100074 100
rule "J5_no_arm_step_stops_or_diverges" all_eq 0 "$(stat "$J/stats.txt" stopped)" "$(stat "$J/stats.txt" diverged)"
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
rule "P2_rest_carries_the_weight" within "$pr_fc" 15680 100
rule "P2_lift_never_pulls" eq "$pl_fc" 0
rule "P2_hold_does_not_creep" in "$ph_fc" -10 10
rule "P2_slide_friction_within_a_tenth" within "$ps_fc" 3500 10
rule "P2_slip_reaches_8_tenths" share "$pp_fc" "$pv_fc" 10 8
if [ "$WF" = yes ]; then rule "P2_friction_at_the_impact_within_a_tenth" all_within 3500 10 "$pi_fc_1" "$pi_fc_4"; fi
rule "P2_no_step_stops_or_diverges" all_eq 0 "$pst" "$pdv"
rule "D1_falls_rod_and_shell" all_le 1000 "$fall_rod_01" "$fall_rod_001" "$fall_shell_01" "$fall_shell_001"
rule "D1_falls_soft" all_le 50000 "$fall_soft_01" "$fall_soft_001"
rule "D2_rod_hangs" all_within 1404624 200 "$hang_rod_01" "$hang_rod_001"
rule "D2_strip_hangs" all_within 936416 200 "$hang_shell_01" "$hang_shell_001"
rule "D2_bar_hangs" all_within 431200 200 "$hang_soft_01" "$hang_soft_001"
rule "D3_cantilever_rises_with_the_mesh" falls "$(( 0 - cant_32 ))" "$(( 0 - cant_64 ))" "$(( 0 - cant_128 ))"
rule "D3_cantilever_below_the_textbook" all_le 6350400 "$cant_32" "$cant_64" "$cant_128"
rule "D3_cantilever_at_128_within_3_in_100" within "$cant_128" 6350400 33
for cfg in stock fc; do
  rule "D4_slides_${cfg}_shipped_step" all_within 77632653 100 "$(eval echo \$slide_${cfg}_shell_01)" "$(eval echo \$slide_${cfg}_soft_01)"
  rule "D4_slides_${cfg}_tenth_step" all_within 81232653 100 "$(eval echo \$slide_${cfg}_shell_001)" "$(eval echo \$slide_${cfg}_soft_001)"
  rule "D7_rests_${cfg}" all_in -10 10 "$(eval echo \$restvx_${cfg}_shell_01)" "$(eval echo \$restvy_${cfg}_shell_01)" "$(eval echo \$restvx_${cfg}_soft_01)" "$(eval echo \$restvy_${cfg}_soft_01)" "$(eval echo \$restvx_${cfg}_shell_001)" "$(eval echo \$restvy_${cfg}_shell_001)" "$(eval echo \$restvx_${cfg}_soft_001)" "$(eval echo \$restvy_${cfg}_soft_001)"
done
rule "D5_stock_creeps_as_its_law_says" all_within 3986 10 "$holdv_stock_shell_01" "$holdv_stock_shell_001" "$holdv_stock_soft_01" "$holdv_stock_soft_001"
rule "D6_corrected_holds" all_in -10 10 "$holdv_fc_shell_01" "$holdv_fc_shell_001" "$holdv_fc_soft_01" "$holdv_fc_soft_001"
rule "D6_corrected_within_the_stick_distance" all_in -300000 300000 "$holdx_fc_shell_01" "$holdx_fc_shell_001" "$holdx_fc_soft_01" "$holdx_fc_soft_001"
rule "D8_no_step_stops_or_diverges" all_eq 0 "$dst" "$ddv"
for cfg in stock fc; do for g in built fr3; do
  rule "G1_grip_force_${cfg}_$g" all_within 8000000 100 "$(eval echo \$gpa_${cfg}_$g)" "$(eval echo \$gpb_${cfg}_$g)"
  rule "G2_each_finger_carries_half_${cfg}_$g" all_within 735000 100 "$(eval echo \$gla_${cfg}_$g)" "$(eval echo \$glb_${cfg}_$g)"
done; done
rule "G3_stock_lets_it_creep_built" le "$gc_stock_built" -10000
rule "G3_stock_lets_it_creep_fr3" le "$gc_stock_fr3" -10000
rule "G4_corrected_holds" all_in -1000 1000 "$gc_fc_built" "$gc_fc_fr3"
rule "G4_corrected_slips_under_a_tenth_of_a_millimetre" all_in -100000 100000 "$gs_fc_built" "$gs_fc_fr3"
rule "G5_no_grip_step_stops_or_diverges" all_eq 0 "$gst" "$gdv"
for sc in half_cheetah ant cart_pole; do
  rule "B1_${sc}_no_step_diverges" eq "$(field "$BS" ${sc}_fc diverged)" 0
  rule "B2_${sc}_stops_no_more_than_1_in_1000" share "$(field "$BS" ${sc}_fc stopped)" "$(field "$BS" ${sc}_fc solver_steps)" 1 1000
done
held="$(grep -c '^RULE [A-Z][0-9].* : HELD$' "$OUT")"; failed="$(grep -c '^RULE [A-Z][0-9].* : FAILED$' "$OUT")"
echo "STUDY13 rules held $held failed $failed ; values missing $(wc -l < "$MISSF" | tr -d ' ') ; measuring complete $(( 1 - bad ))" >> "$OUT"
[ $bad -eq 0 ] || exit 1
exit 0
