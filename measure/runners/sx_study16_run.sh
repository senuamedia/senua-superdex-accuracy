#!/usr/bin/env bash
# measure/runners/sx_study16_run.sh -- preregistrations/PREREGISTRATION_16.md: the sixteenth
# registration, library build 15 (the second code review's corrections) safe when off in 64-bit and in SuperDex's
# shipped 32-bit build, its corrections put to plays of their own, and the deformable bodies on a fresh floor read as
# the fifteenth registration's failures said they should be; re-made by measuring alone. Every registered rule is
# judged by sx_contact rule.
# usage: sx_study16_run.sh <public record root> <out file>        (sx_contact built beside this script)
#   Read under the root: validation/run_035_identity/identity.txt; validation/run_036_registration16/runs/.
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study16_run.sh <public record root> <out file>}"; OUT="${2:?out file}"
B="$HERE/sx_contact"
U="$R/validation/run_036_registration16/runs"; ID="$R/validation/run_035_identity/identity.txt"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s16.XXXXXX")"; MISSF="$P/missing"; : > "$MISSF"
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
# the sum of one statistic over the plays of a statistics file whose name starts with a prefix
statp() { grep "^STATS run $2" "$1" | awk -v k="$3" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }'; }
# the most iterations any step of the given statistics files took (the iteration limit is 200)
most() { awk '{ for (i = 1; i < NF; i++) if ($i == "most_iterations" && $(i + 1) > m) m = $(i + 1) } END { printf "%d", m + 0 }' "$@"; }
same() { if cmp -s "$1" "$2"; then echo 1; else echo 0; fi; }
# a count of identical parts: the number of IDENTITY lines whose two counts agree
ident() { local c; c="$(grep "^IDENTITY $2 " "$1" | awk '{ print $3, $5 }')"; if [ -z "$c" ]; then echo "$2" >> "$MISSF"; echo "999999999 0"; else echo "$c"; fi; }

# ---- E0: library build 15 safe when off in 64-bit (run 035) ----
while read -r _ part same_ _ played; do echo "identity | $part $same_ of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
differs="$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID")"; n_parts="$(grep -c '^IDENTITY ' "$ID")"

# ---- F: the first two studies in 32-bit and 64-bit on library build 15 ----
I32="$U/identity32.txt"
while read -r _ part same_ _ played; do echo "identity32 | $part $same_ of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$I32")
read -r f0s f0n < <(ident "$I32" study1_32bit); read -r f1s f1n < <(ident "$I32" study2); read -r f2s f2n < <(ident "$I32" zero_32bit)

# ---- C: the corrections, on build 15 and build 14 ----
CW="$U/corrections"
for lib in b15 b14; do
  eval "hold_$lib=\"$(nv "$(m "corrections $lib, hold" creep "$CW/${lib}_hold.txt")" mean_speed_ums)\""
  eval "tele_$lib=\"$(nv "$(m "corrections $lib, the second after a teleport of 2 mm" creep "$CW/${lib}_teleport.txt")" mean_speed_ums)\""
  for k in 1 4; do
    eval "visc_same_${lib}_$k=\"$(same "$CW/${lib}_visc_f_$k.txt" "$CW/${lib}_visc_nof_$k.txt")\""
    echo "corrections | $lib: viscous friction with no Coulomb friction, 1/$k of the step: the landing with patch F is byte-identical to the landing without it: $(eval echo \$visc_same_${lib}_$k)" >> "$OUT"
    m "corrections $lib, viscous landing with patch F, 1/$k (reported)" impact "$CW/${lib}_visc_f_$k.txt" > /dev/null
    m "corrections $lib, viscous landing without patch F, 1/$k (reported)" impact "$CW/${lib}_visc_nof_$k.txt" > /dev/null
  done
done
cst="$(statp "$CW/stats.txt" b15_ stopped)"; cdv="$(statp "$CW/stats.txt" b15_ diverged)"
echo "corrections | build 15: stopped $cst diverged $cdv; build 14: stopped $(statp "$CW/stats.txt" b14_ stopped) diverged $(statp "$CW/stats.txt" b14_ diverged)" >> "$OUT"

# ---- H: the deformable bodies on a fresh floor ----
for cfg in stock final accurate; do
  dts="0.01 0.001"; [ $cfg = accurate ] && dts="0.000625"
  for dt in $dts; do t="${dt#0.}"; DD="$U/deform_$cfg"; for b in shell soft; do
    l="$(m "deform $cfg, $b slide, $dt s, where it stopped" deformstop "$DD/${b}_slide_$dt.txt")"; eval "far_${cfg}_${b}_$t=\"$(nv "$l" furthest_nm)\""
    m "deform $cfg, $b slide, $dt s (reported)" deform "$DD/${b}_slide_$dt.txt" > /dev/null
    l="$(m "deform $cfg, $b hold, $dt s" deform "$DD/${b}_hold_$dt.txt")"; eval "holdv_${cfg}_${b}_$t=\"$(nv "$l" end_vx_ums)\""
    eval "drift_${cfg}_${b}_$t=\"$(nv "$(m "deform $cfg, $b hold, $dt s, between the second and the last quarter" deformdrift "$DD/${b}_hold_$dt.txt")" drift_nm)\""
    l="$(m "deform $cfg, $b rest, $dt s" deform "$DD/${b}_rest_$dt.txt")"; eval "restvx_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vx_ums)\"; restvy_${cfg}_${b}_$t=\"$(nv "$l" tail_largest_vy_ums)\""
  done; done
  eval "dst_${cfg}=\"$(stat "$U/deform_$cfg/stats.txt" stopped)\"; ddv_${cfg}=\"$(stat "$U/deform_$cfg/stats.txt" diverged)\"; dmost_${cfg}=\"$(most "$U/deform_$cfg/stats.txt")\""
  echo "deform $cfg | stopped $(eval echo \$dst_$cfg) diverged $(eval echo \$ddv_$cfg) most_iterations $(eval echo \$dmost_$cfg)" >> "$OUT"
done
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; fi

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
rule "E0_every_part_identical_in_full" eq "$differs" 0
rule "E0_parts_played" eq "$n_parts" 13
rule "F0_the_first_study_in_32_bit" all_eq 45 "$f0s" "$f0n"
rule "F1_the_second_study" all_eq 63 "$f1s" "$f1n"
rule "F2_every_switch_0_in_32_bit" all_eq 6 "$f2s" "$f2n"
rule "C1_the_hold_holds" in "$hold_b15" -10 10
rule "C1_a_teleported_body_moves_only_with_the_push" in "$tele_b15" 0 299
rule "C1_required_build_14_pulls_it_back" le "$tele_b14" -1
rule "C2_viscous_friction_keeps_the_start_of_step_force" all_eq 1 "$visc_same_b15_1" "$visc_same_b15_4"
rule "C2_required_build_14_differs" eq "$(( visc_same_b14_1 * visc_same_b14_4 ))" 0
rule "C3_no_step_stops_or_diverges" all_eq 0 "$cst" "$cdv"
for cfg in stock final; do
  rule "H1_slides_reach_${cfg}_shipped_step" all_within 75885315 100 "$(eval echo \$far_${cfg}_shell_01)" "$(eval echo \$far_${cfg}_soft_01)"
  rule "H1_slides_reach_${cfg}_tenth_step" all_within 79710315 100 "$(eval echo \$far_${cfg}_shell_001)" "$(eval echo \$far_${cfg}_soft_001)"
  rule "H3_rests_${cfg}" all_in -10 10 "$(eval echo \$restvx_${cfg}_shell_01)" "$(eval echo \$restvy_${cfg}_shell_01)" "$(eval echo \$restvx_${cfg}_soft_01)" "$(eval echo \$restvy_${cfg}_soft_01)" "$(eval echo \$restvx_${cfg}_shell_001)" "$(eval echo \$restvy_${cfg}_shell_001)" "$(eval echo \$restvx_${cfg}_soft_001)" "$(eval echo \$restvy_${cfg}_soft_001)"
done
rule "H1_slides_reach_accurate" all_within 80135315 100 "$far_accurate_shell_000625" "$far_accurate_soft_000625"
rule "H3_rests_accurate" all_in -10 10 "$restvx_accurate_shell_000625" "$restvy_accurate_shell_000625" "$restvx_accurate_soft_000625" "$restvy_accurate_soft_000625"
rule "H2_stock_creeps_as_its_law_says" all_within 4490 10 "$holdv_stock_shell_01" "$holdv_stock_shell_001" "$holdv_stock_soft_01" "$holdv_stock_soft_001"
rule "H2_stock_drifts" all_ge 1000000 "$drift_stock_shell_01" "$drift_stock_shell_001" "$drift_stock_soft_01" "$drift_stock_soft_001"
rule "H2_final_holds_within_the_stick_distance" all_in -300000 300000 "$drift_final_shell_01" "$drift_final_shell_001" "$drift_final_soft_01" "$drift_final_soft_001"
rule "H2_accurate_holds_within_the_stick_distance" all_in -300000 300000 "$drift_accurate_shell_000625" "$drift_accurate_soft_000625"
rule "H3_no_step_stops_or_diverges" all_eq 0 "$dst_stock" "$ddv_stock" "$dst_final" "$ddv_final"
rule "H3_accurate_no_step_diverges" eq "$ddv_accurate" 0
rule "H3_accurate_no_step_stops_at_the_iteration_limit" le "$dmost_accurate" 199
held="$(grep -c '^RULE [A-Z][0-9].* : HELD$' "$OUT")"; failed="$(grep -c '^RULE [A-Z][0-9].* : FAILED$' "$OUT")"
echo "STUDY16 rules held $held failed $failed ; values missing $(wc -l < "$MISSF" | tr -d ' ') ; measuring complete $(( 1 - bad ))" >> "$OUT"
[ $bad -eq 0 ] || exit 1
exit 0
