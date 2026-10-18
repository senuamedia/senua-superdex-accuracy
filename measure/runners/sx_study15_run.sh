#!/usr/bin/env bash
# measure/runners/sx_study15_run.sh -- preregistrations/PREREGISTRATION_15.md: the
# fifteenth registration, the fourteenth's fixes replicated on fresh numbers and the code review's three corrections
# tested (library build 14), re-made by measuring alone. Every registered rule is judged by sx_contact rule.
# usage: sx_study15_run.sh <public record root> <out file>        (sx_contact built beside this script)
#   Read under the root: validation/run_033_identity/identity.txt; validation/run_034_replication/runs/; and for V8
#   (the amendment) validation/run_034_replication/accurate14/runs/, run 032's record, and what the fourteenth
#   registration's runner (sx_study14_run.sh, beside this script) reads.
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study15_run.sh <public record root> <out file>}"; OUT="${2:?out file}"
R="$(cd "$R" && pwd)"   # absolute, so the links of the V8 tree below resolve from any folder
B="$HERE/sx_contact"
U="$R/validation/run_034_replication/runs"; IT="$U/items"; ID="$R/validation/run_033_identity/identity.txt"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s15.XXXXXX")"; MISSF="$P/missing"; : > "$MISSF"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the measure's LAST line
  local label="$1"; shift
  local lines; lines="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> "$OUT"; echo "$lines" | tail -1
}
# the number after a name (its n-th occurrence, default the first); a name a measured line does not hold counts as
# missing and stands as 999999999
nv() { local x; x="$(echo "$1" | awk -v k="$2" -v n="${3:-1}" '{ c = 0; for (i = 1; i < NF; i++) if ($i == k) { c++; if (c == n) { print $(i + 1); exit } } }')"; if [ -z "$x" ]; then echo "$2" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
rule() { "$B" rule "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "rule failed to run: $*" >&2; bad=1; }; }
stat() { awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$1"; }
same() { if cmp -s "$1" "$2"; then echo 1; else echo 0; fi; }
# the most iterations any step of the given statistics files took (the iteration limit is 200: a step that took 200
# stopped at the limit; one that stopped with fewer stopped on SuperDex's rule for an update too small to matter)
most() { awk '{ for (i = 1; i < NF; i++) if ($i == "most_iterations" && $(i + 1) > m) m = $(i + 1) } END { printf "%d", m + 0 }' "$@"; }

# ---- E0: safe when off, and run 032 made again ----
while read -r _ part same_ _ played; do echo "identity | $part $same_ of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
differs="$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID")"; n_parts="$(grep -c '^IDENTITY ' "$ID")"

# ---- V1: item 1 on two fresh pairs ----
for pr in pa pb; do for k in 1 16; do
  eval "a_${pr}_$k=\"$(nv "$(m "item 1, $pr, block 1/$k" accel "$IT/${pr}_${k}_a.txt" 700 900)" mean_acceleration_mm_s2)\""
  eval "b_${pr}_$k=\"$(nv "$(m "item 1, $pr, light cube 1/$k" accel "$IT/${pr}_${k}_b.txt" 700 900)" mean_acceleration_mm_s2)\""
done; done

# ---- V2: item 2, a fresh arm and free chain ----
for w in 2 4.5; do for k in 1 4 16; do
  eval "sp_${w/./_}_$k=\"$(nv "$(m "item 2, arm at $w rad/s, 1/$k" final "$IT/spin${w}_$k.txt")" speed_urads)\""
done; done
for k in 1 4 16; do l="$(m "item 2, free chain 1/$k" chain "$IT/chainfree_$k.txt")"; eval "ce_$k=\"$(nv "$l" kinetic_end_per_million_of_start)\"; cm_$k=\"$(nv "$l" momentum_largest_drift_ppm)\""; done

# ---- V3: item 3, a fresh cube on the point-cloud floor ----
for cfg in stock final accurate; do
  W="$IT/cloud_$cfg"; ks="1 4"; one=1; [ $cfg = accurate ] && { ks="16"; one=16; }
  for k in $ks; do eval "pi_${cfg}_$k=\"$(nv "$(m "cloud $cfg, oblique impact 1/$k" impact "$W/oblique_$k.txt")" ratio_per_10000)\""; done
  m "cloud $cfg, the 0.1 s after the impact 1/$one (reported)" settle "$W/oblique_$one.txt" > /dev/null
  eval "ps_${cfg}=\"$(nv "$(m "cloud $cfg, slide 1/$one" creep "$W/slide_$one.txt")" friction_over_normal_per_10000)\""
  eval "pr_${cfg}=\"$(nv "$(m "cloud $cfg, rest 1/$one" rest "$W/rest_$one.txt")" mean_ground_force_mN)\""
  eval "ph_${cfg}=\"$(nv "$(m "cloud $cfg, hold 1/$one" creep "$W/hold_$one.txt")" mean_speed_ums)\""
  l="$(m "cloud $cfg, slip 1/$one" slip "$W/slip_$one.txt" 4939)"; eval "pv_${cfg}=\"$(nv "$l" mean_speed_ums)\"; pp_${cfg}=\"$(nv "$l" predicted_ums)\""
  eval "pl_${cfg}=\"$(nv "$(m "cloud $cfg, lift 1/$one" pull "$W/lift_$one.txt")" steps_pulling)\""
  eval "pst_${cfg}=\"$(stat "$W/stats.txt" stopped)\"; pdv_${cfg}=\"$(stat "$W/stats.txt" diverged)\"; pn_${cfg}=\"$(stat "$W/stats.txt" steps)\"; pmost_${cfg}=\"$(most "$W/stats.txt")\""
  echo "cloud $cfg | steps $(eval echo \$pn_$cfg) stopped $(eval echo \$pst_$cfg) diverged $(eval echo \$pdv_$cfg) most_iterations $(eval echo \$pmost_$cfg)" >> "$OUT"
done

# ---- V4: item 4, three cantilevers at the final configuration's tolerances ----
for rod in 13 a b; do for n in 64 128; do
  eval "ct_${rod}_$n=\"$(nv "$(m "item 4, rod $rod, $n elements" deform "$IT/cant${rod}_n$n.txt")" tip_drop_nm)\""
done; done

# ---- V5: item 5, a fresh arm and chain under BDF2 ----
for k in 1 4 16; do
  l="$(m "item 5, BDF2, pendulum 1/$k" swing "$IT/b2_swing_$k.txt")"
  eval "sw_${k}_1=\"$(nv "$l" swing_per_10000 1)\"; sw_${k}_2=\"$(nv "$l" swing_per_10000 2)\"; sw_${k}_3=\"$(nv "$l" swing_per_10000 3)\""
  l="$(m "item 5, BDF2, pendulum 1/$k, turns placed between the steps" swingq "$IT/b2_swing_$k.txt")"
  eval "sq_${k}_1=\"$(nv "$l" swing_per_10000 1)\"; sq_${k}_2=\"$(nv "$l" swing_per_10000 2)\"; sq_${k}_3=\"$(nv "$l" swing_per_10000 3)\""
  eval "spn_$k=\"$(nv "$(m "item 5, BDF2, free spin 1/$k" final "$IT/b2_spin_$k.txt")" speed_urads)\""
  eval "csw_$k=\"$(nv "$(m "item 5, BDF2, swinging chain 1/$k" chain "$IT/b2_chainswing_$k.txt")" energy_drift_ppm_of_most_kinetic)\""
  eval "cbe_$k=\"$(nv "$(m "item 5, backward Euler with patch G, swinging chain 1/$k" chain "$IT/be_chainswing_$k.txt")" energy_drift_ppm_of_most_kinetic)\""
done
ist="$(stat "$IT/stats.txt" stopped)"; idv="$(stat "$IT/stats.txt" diverged)"

# ---- V6: deformable bodies on a fresh floor ----
for cfg in stock final accurate; do
  dts="0.01 0.001"; [ $cfg = accurate ] && dts="0.000625"
  for dt in $dts; do t="${dt#0.}"; DD="$U/deform_$cfg"; for b in shell soft; do
    l="$(m "deform $cfg, $b slide, $dt s, where it stopped" deformstop "$DD/${b}_slide_$dt.txt")"; eval "stop_${cfg}_${b}_$t=\"$(nv "$l" moved_at_stop_nm)\""
    m "deform $cfg, $b slide, $dt s (reported)" deform "$DD/${b}_slide_$dt.txt" > /dev/null
    l="$(m "deform $cfg, $b hold, $dt s" deform "$DD/${b}_hold_$dt.txt")"; eval "holdv_${cfg}_${b}_$t=\"$(nv "$l" end_vx_ums)\"; holdc_${cfg}_${b}_$t=\"$(nv "$l" tip_along_x_nm)\""
    l="$(m "deform $cfg, $b rest, $dt s" deform "$DD/${b}_rest_$dt.txt")"; eval "restvx_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vx_ums)\"; restvy_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vy_ums)\""
  done; done
  eval "dst_${cfg}=\"$(stat "$U/deform_$cfg/stats.txt" stopped)\"; ddv_${cfg}=\"$(stat "$U/deform_$cfg/stats.txt" diverged)\"; dmost_${cfg}=\"$(most "$U/deform_$cfg/stats.txt")\""
  echo "deform $cfg | stopped $(eval echo \$dst_$cfg) diverged $(eval echo \$ddv_$cfg) most_iterations $(eval echo \$dmost_$cfg)" >> "$OUT"
done

# ---- V7: the code review's corrections (library build 14), and build 13 beside them ----
RV="$U/review"
for lib in b14 b13; do
  eval "hold_$lib=\"$(nv "$(m "review $lib, hold" creep "$RV/${lib}_hold.txt")" mean_speed_ums)\""
  eval "roll_$lib=\"$(nv "$(m "review $lib, the second second after a rollout and restore" creep "$RV/${lib}_rollout.txt")" mean_speed_ums)\""
  eval "twin_same_$lib=\"$(same "$RV/${lib}_twin.txt" "$RV/${lib}_hold.txt")\""
  echo "review | $lib: the hold with a second scene made and destroyed is byte-identical to the hold alone: $(eval echo \$twin_same_$lib)" >> "$OUT"
done
rst="$(grep '^STATS run b14_' "$RV/stats.txt" | awk '{for(i=1;i<NF;i++) if ($i=="stopped") s+=$(i+1)} END {print s+0}')"
rdv="$(grep '^STATS run b14_' "$RV/stats.txt" | awk '{for(i=1;i<NF;i++) if ($i=="diverged") s+=$(i+1)} END {print s+0}')"

# ---- V8 (the amendment): the fourteenth registration's accurate plays at the final configuration's tolerances,
# judged by the fourteenth registration's runner unchanged. It reads a tree that is run 032's record with only the
# accurate configuration's folders and files replaced by this run's; every other rule it judges must read as run 032
# read it ----
N="$R/validation/run_034_replication/accurate14/runs"; O32="$R/validation/run_032_open_items/runs"
H="$P/hybrid"; HU="$H/validation/run_032_open_items/runs"; mkdir -p "$HU/bench" "$HU/s1" "$HU/s2"
ln -s "$R/validation/run_031_identity" "$H/validation/run_031_identity"; ln -s "$R/validation/run_029_end_to_end" "$H/validation/run_029_end_to_end"; ln -s "$R/joints" "$H/joints"
for e in "$O32"/*; do b="$(basename "$e")"; case "$b" in s1|s2|bench) ;; *_accurate) ln -s "$N/$b" "$HU/$b" ;; *) ln -s "$e" "$HU/$b" ;; esac; done
for s in s1 s2; do for e in "$O32/$s"/*; do b="$(basename "$e")"; if [ "$b" = accurate ]; then ln -s "$N/$s/accurate" "$HU/$s/accurate"; else ln -s "$e" "$HU/$s/$b"; fi; done; done
for e in "$O32/bench"/*; do b="$(basename "$e")"; case "$b" in *_accurate*|stats.txt) ;; *) ln -s "$e" "$HU/bench/$b" ;; esac; done
for e in "$N/bench"/*_accurate*; do ln -s "$e" "$HU/bench/$(basename "$e")"; done
{ grep -v '^STATS source [a-z_]*_accurate ' "$O32/bench/stats.txt"; grep '^STATS source [a-z_]*_accurate ' "$N/bench/stats.txt"; } > "$HU/bench/stats.txt"
bash "$HERE/sx_study14_run.sh" "$H" "$P/r14.txt" || { echo "the fourteenth registration's runner did not complete" >&2; bad=1; }
grep 'accurate' "$P/r14.txt" | grep -v '^RULE ' | awk '{ print "accurate14 | " $0 }' >> "$OUT"
# the rules on other configurations must read exactly as in run 032's record
cmp -s <(grep '^RULE [B-Z]' "$P/r14.txt") <(grep '^RULE [B-Z]' "$R/validation/run_032_open_items/reading.txt"); v8_tree=$(( 1 - $? ))
# the rules that count stopped steps, and the slide read at the end of the play, are reported here and replaced below
grep -E '^RULE A[0-9]_[a-z_0-9]*(stops_or_diverges|stops_no_more_than_1_in_1000|slides_stop_at_coulombs_distance) ' "$P/r14.txt" | awk '{ print "accurate14, replaced by the amendment (reported) | " $0 }' >> "$OUT"
grep -E '^RULE A[0-9]_' "$P/r14.txt" | grep -v -E '^RULE A[0-9]_[a-z_0-9]*(stops_or_diverges|stops_no_more_than_1_in_1000|slides_stop_at_coulombs_distance) ' | sed 's/^RULE A/RULE V8_A/' > "$P/v8_rules.txt"
for b in shell soft; do eval "a14stop_$b=\"$(nv "$(m "accurate14, deform, $b slide, where it stopped" deformstop "$N/deform_accurate/${b}_slide_0.000625.txt")" moved_at_stop_nm)\""; done
A14S="$N/s1/accurate/stats.txt $N/s2/accurate/stats.txt $N/joints_accurate/stats.txt $N/limits_accurate/stats.txt $N/cloud_accurate/stats.txt $N/deform_accurate/stats.txt"
a14dv=0; a14st=0; for f in $A14S; do a14dv=$(( a14dv + $(stat "$f" diverged) )); a14st=$(( a14st + $(stat "$f" stopped) )); done
grep -E '^STATS run (built|fr3)_8 ' "$N/grip_accurate/stats.txt" > "$P/grip8.txt"
grep '^STATS source [a-z_]*_accurate ' "$N/bench/stats.txt" > "$P/bench_acc.txt"
a14dv=$(( a14dv + $(stat "$P/grip8.txt" diverged) + $(stat "$P/bench_acc.txt" diverged) )); a14st=$(( a14st + $(stat "$P/grip8.txt" stopped) + $(stat "$P/bench_acc.txt" stopped) ))
# shellcheck disable=SC2086
a14most="$(most $A14S "$P/grip8.txt" "$P/bench_acc.txt")"
echo "accurate14 | steps stopped (reported) $a14st, diverged $a14dv, most iterations of any step $a14most" >> "$OUT"
for f in $A14S; do echo "accurate14 | ${f#"$N"/}: stopped $(stat "$f" stopped) diverged $(stat "$f" diverged) most_iterations $(most "$f")" >> "$OUT"; done
echo "accurate14 | grip_accurate, the 8 N grips: stopped $(stat "$P/grip8.txt" stopped) diverged $(stat "$P/grip8.txt" diverged) most_iterations $(most "$P/grip8.txt")" >> "$OUT"
echo "accurate14 | bench, the accurate sources: stopped $(stat "$P/bench_acc.txt" stopped) diverged $(stat "$P/bench_acc.txt" diverged) most_iterations $(most "$P/bench_acc.txt")" >> "$OUT"

# ---- V9 (the amendment): a fresh arm swinging for 20 s, and item 5's chain at 1/64 ----
LG="$U/long"
for run in accurate_16 accurate_64 final_1 final_16 shipped_tolerances_16; do
  l="$(m "long, $run" swingq "$LG/$run.txt")"
  eval "lq_${run}_least=\"$(nv "$l" least_per_10000)\"; lq_${run}_most=\"$(nv "$l" most_per_10000)\"; lq_${run}_last=\"$(nv "$l" last_per_10000)\"; lq_${run}_turns=\"$(nv "$l" turns)\""
done
lcsw64="$(nv "$(m "long, item 5's chain, BDF2, 1/64" chain "$LG/b2_chainswing_64.txt")" energy_drift_ppm_of_most_kinetic)"
lgdv="$(stat "$LG/stats.txt" diverged)"; lgmost="$(most "$LG/stats.txt")"
echo "long | steps stopped (reported) $(stat "$LG/stats.txt" stopped), diverged $lgdv, most iterations of any step $lgmost" >> "$OUT"
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; fi

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
rule "E0_every_part_identical_in_full" eq "$differs" 0
rule "E0_parts_played" eq "$n_parts" 12
rule "V1_pair_a_cube" all_within 3724 100 "$b_pa_1" "$b_pa_16"
rule "V1_pair_a_block" all_within 5837 100 "$a_pa_1" "$a_pa_16"
rule "V1_pair_b_cube" all_within 4900 100 "$b_pb_1" "$b_pb_16"
rule "V1_pair_b_block" all_within 7742 100 "$a_pb_1" "$a_pb_16"
rule "V2_arm_2_rad_s" all_within 2000000 10000 "$sp_2_1" "$sp_2_4" "$sp_2_16"
rule "V2_arm_4_5_rad_s" all_within 4500000 10000 "$sp_4_5_1" "$sp_4_5_4" "$sp_4_5_16"
rule "V2_free_chain_energy" all_within 1000000 1000 "$ce_1" "$ce_4" "$ce_16"
rule "V2_free_chain_momentum" all_le 100 "$cm_1" "$cm_4" "$cm_16"
rule "V3_stock_friction_at_the_impact_over_the_law" ge "$pi_stock_1" 5040
rule "V3_stock_slip_short_of_the_law" share "$pv_stock" "$pp_stock" 8 10
for cfg in final accurate; do
  ks="1 4"; [ $cfg = accurate ] && ks="16"
  rule "V3_${cfg}_rest_carries_the_weight" within "$(eval echo \$pr_$cfg)" 9800 100
  rule "V3_${cfg}_lift_never_pulls" eq "$(eval echo \$pl_$cfg)" 0
  rule "V3_${cfg}_hold_does_not_creep" in "$(eval echo \$ph_$cfg)" -10 10
  rule "V3_${cfg}_slide_friction_within_1_in_100" within "$(eval echo \$ps_$cfg)" 4200 100
  rule "V3_${cfg}_slip_reaches_95_in_100" share "$(eval echo \$pp_$cfg)" "$(eval echo \$pv_$cfg)" 100 95
  for k in $ks; do rule "V3_${cfg}_friction_at_the_impact_1_${k}_within_1_in_25" within "$(eval echo \$pi_${cfg}_$k)" 4200 25; done
  rule "V3_${cfg}_no_step_diverges" eq "$(eval echo \$pdv_$cfg)" 0
done
rule "V3_final_stops_no_more_than_1_in_1000" share "$pst_final" "$pn_final" 1 1000
# amended before any run: at the final configuration's tolerances the sheet's steps stop on SuperDex's small-update
# rule; none may stop at the iteration limit
rule "V3_accurate_no_step_stops_at_the_iteration_limit" le "$pmost_accurate" 199
rule "V4_thirteenth_rod" all_within 6350400 1000 "$ct_13_64" "$ct_13_128"
rule "V4_rod_a" all_within 3062500 1000 "$ct_a_64" "$ct_a_128"
rule "V4_rod_b" all_within 9411920 1000 "$ct_b_64" "$ct_b_128"
rule "V5_free_spin" all_ge 3496500 "$spn_1" "$spn_4" "$spn_16"
rule "V5_pendulum_shipped_step" all_in 9950 10010 "$sw_1_1" "$sw_1_2" "$sw_1_3"
rule "V5_pendulum_quarter_step" all_in 9990 10010 "$sw_4_1" "$sw_4_2" "$sw_4_3"
rule "V5_pendulum_sixteenth_step" all_in 9995 10005 "$sw_16_1" "$sw_16_2" "$sw_16_3"
# amended before any run: the same bounds with each turn placed between the steps (swingq)
rule "V5_pendulum_shipped_step_turns_between_steps" all_in 9950 10010 "$sq_1_1" "$sq_1_2" "$sq_1_3"
rule "V5_pendulum_quarter_step_turns_between_steps" all_in 9990 10010 "$sq_4_1" "$sq_4_2" "$sq_4_3"
rule "V5_pendulum_sixteenth_step_turns_between_steps" all_in 9995 10005 "$sq_16_1" "$sq_16_2" "$sq_16_3"
rule "V5_swinging_chain_quarter_step" in "$csw_4" -10000 10000
rule "V5_swinging_chain_sixteenth_step" in "$csw_16" -5000 5000
rule "V5_backward_euler_loses_more_at_the_quarter_step" le "$cbe_4" "$(( 0 - ${csw_4#-} ))"
for cfg in stock final; do
  rule "V6_slides_stop_${cfg}_shipped_step" all_within 78153061 100 "$(eval echo \$stop_${cfg}_shell_01)" "$(eval echo \$stop_${cfg}_soft_01)"
  rule "V6_slides_stop_${cfg}_tenth_step" all_within 82203061 100 "$(eval echo \$stop_${cfg}_shell_001)" "$(eval echo \$stop_${cfg}_soft_001)"
  rule "V6_rests_${cfg}" all_in -10 10 "$(eval echo \$restvx_${cfg}_shell_01)" "$(eval echo \$restvy_${cfg}_shell_01)" "$(eval echo \$restvx_${cfg}_soft_01)" "$(eval echo \$restvy_${cfg}_soft_01)" "$(eval echo \$restvx_${cfg}_shell_001)" "$(eval echo \$restvy_${cfg}_shell_001)" "$(eval echo \$restvx_${cfg}_soft_001)" "$(eval echo \$restvy_${cfg}_soft_001)"
done
rule "V6_slides_stop_accurate" all_within 82653061 100 "$stop_accurate_shell_000625" "$stop_accurate_soft_000625"
rule "V6_rests_accurate" all_in -10 10 "$restvx_accurate_shell_000625" "$restvy_accurate_shell_000625" "$restvx_accurate_soft_000625" "$restvy_accurate_soft_000625"
rule "V6_stock_creeps_as_its_law_says" all_within 4804 10 "$holdv_stock_shell_01" "$holdv_stock_shell_001" "$holdv_stock_soft_01" "$holdv_stock_soft_001"
rule "V6_final_contact_within_the_stick_distance" all_in -300000 300000 "$holdc_final_shell_01" "$holdc_final_shell_001" "$holdc_final_soft_01" "$holdc_final_soft_001"
rule "V6_accurate_contact_within_the_stick_distance" all_in -300000 300000 "$holdc_accurate_shell_000625" "$holdc_accurate_soft_000625"
# amended before any run: the accurate configuration's steps may stop on SuperDex's small-update rule, none at the limit
rule "V6_no_step_stops_or_diverges" all_eq 0 "$dst_stock" "$ddv_stock" "$dst_final" "$ddv_final"
rule "V6_accurate_no_step_diverges" eq "$ddv_accurate" 0
rule "V6_accurate_no_step_stops_at_the_iteration_limit" le "$dmost_accurate" 199
rule "V7_the_hold_holds" in "$hold_b14" -10 10
rule "V7_a_second_scene_changes_nothing" eq "$twin_same_b14" 1
rule "V7_a_restored_state_holds_within_the_stick_distance" in "$roll_b14" -300 300
rule "V7_required_build_13_loses_the_stick_to_a_second_scene" eq "$twin_same_b13" 0
rule "V7_required_build_13_carries_the_rollout_back" ge "$roll_b13" 300
rule "V7_no_step_stops_or_diverges" all_eq 0 "$rst" "$rdv"
# ---- the amendment's rules ----
rule "V8_the_tree_reads_every_other_rule_as_run_032" eq "$v8_tree" 1
cat "$P/v8_rules.txt" >> "$OUT"
rule "V8_A5_slides_stop_at_coulombs_distance" all_within 55555556 100 "$a14stop_shell" "$a14stop_soft"
rule "V8_no_step_diverges" eq "$a14dv" 0
rule "V8_no_step_stops_at_the_iteration_limit" le "$a14most" 199
rule "V9_accurate_every_swing" all_in 9990 10005 "$lq_accurate_16_least" "$lq_accurate_16_most" "$lq_accurate_64_least" "$lq_accurate_64_most"
rule "V9_final_never_gains" all_le 10000 "$lq_final_1_most" "$lq_final_16_most"
rule "V9_required_shipped_tolerances_gain" ge "$lq_shipped_tolerances_16_last" 10011
rule "V9_chain_at_1_64" in "$lcsw64" -1000 1000
rule "V9_no_step_diverges" eq "$lgdv" 0
rule "V9_no_step_stops_at_the_iteration_limit" le "$lgmost" 199
held="$(grep -c '^RULE [A-Z][0-9].* : HELD$' "$OUT")"; failed="$(grep -c '^RULE [A-Z][0-9].* : FAILED$' "$OUT")"
echo "STUDY15 rules held $held failed $failed ; values missing $(wc -l < "$MISSF" | tr -d ' ') ; measuring complete $(( 1 - bad ))" >> "$OUT"
[ $bad -eq 0 ] || exit 1
exit 0
