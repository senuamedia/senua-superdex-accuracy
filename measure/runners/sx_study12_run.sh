#!/usr/bin/env bash
# measure/runners/sx_study12_run.sh -- preregistrations/PREREGISTRATION_12.md: the twelfth
# registration, re-made by measuring alone. One arm on one joint (sx_contact final), two arms on two joints
# (sx_contact chain), the sixth registration's tests with both corrections (sx_contact final, creep), the solver's
# own counts from the rigs' stats lines, the benchmark with both corrections (plain subtraction by sx_settings3),
# and every registered rule judged by sx_contact rule.
# usage: sx_study12_run.sh <public record root> <counts out file> <out file>
#        (sx_contact and sx_settings3 built beside this script)
#   Read under the root: validation/run_025_identity/identity.txt; validation/run_028_joint_motion/ (arm/<cfg>/,
#   chain/<cfg>/, joints_neg/, stats_<scene>.txt, bench_base.txt); streams/12/; joints/ (the sixth registration's
#   stock files).
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study12_run.sh <public record root> <counts out file> <out file>}"; C="${2:?counts out file}"; OUT="${3:?out file}"
B="$HERE/sx_contact"
V="$R/validation/run_028_joint_motion"; ID="$R/validation/run_025_identity/identity.txt"; D="$R/streams/12"
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the measure's LAST line
  local label="$1"; shift
  local lines; lines="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> "$OUT"; echo "$lines" | tail -1
}
MISSF="$(mktemp "${TMPDIR:-/tmp}/sx_miss.XXXXXX")"
# the number after a name; a name a measured line does not hold counts as missing and stands as 999999999
nv() { local x; x="$(echo "$1" | awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) { print $(i + 1); exit } }')"; if [ -z "$x" ]; then echo "$2" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
rule() { "$B" rule "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "rule failed to run: $*" >&2; bad=1; }; }
stat() { awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$1"; }   # a count summed over a stats file
# a value the stats do not hold counts as missing and stands as 999999999, which no registered bound admits
field() { local x; x="$(grep "^STATS source $2 " "$1" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }

# ---- G0: safe when off ----
ids=""; idn=""
while read -r _ part same _ played; do ids="$ids $same"; idn="$idn $played"; echo "identity | $part $same of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
differs="$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID")"
n_parts="$(grep -c '^IDENTITY ' "$ID")"

# ---- G1, G2: one arm ----
g1=""; g2=""
for w in 1.5 3.5 6; do
  for cfg in stock ne g neg; do for k in 1 4 16; do
    l="$(m "one arm, $cfg, released at $w rad/s, 1/$k" final "$V/arm/$cfg/spin${w}_$k.txt")"; s="$(nv "$l" speed_urads)"
    [ "$cfg" = stock ] && [ "$k" = 1 ] && g1="$g1 $s"
    [ "$cfg" = neg ] && g2="$g2 $w:$s"
  done; done
done

# ---- G3 to G6: two arms ----
ch() { m "two arms, $1, $2, 1/$3" chain "$V/chain/$1/${2}_$3.txt"; }
for cfg in off ne g neg; do for case in free swing; do for k in 1 4 16; do
  l="$(ch $cfg $case $k)"
  eval "E_${cfg}_${case}_$k=\"$(nv "$l" kinetic_end_per_million_of_start)\"; D_${cfg}_${case}_$k=\"$(nv "$l" energy_drift_ppm_of_most_kinetic)\"; M_${cfg}_${case}_$k=\"$(nv "$l" momentum_drift_ppm)\"; L_${cfg}_${case}_$k=\"$(nv "$l" energy_lost_ppm_of_most_kinetic)\"; X_${cfg}_${case}_$k=\"$(nv "$l" energy_largest_drift_ppm)\""
done; done; done
for k in 1 4 16; do
  l="$(ch neg_tight free $k)"
  eval "M_tight_$k=\"$(nv "$l" momentum_drift_ppm)\"; X_tight_$k=\"$(nv "$l" energy_largest_drift_ppm)\""
done

# ---- G7: the solver, shipped tolerances, both corrections ----
g7s=$(( $(stat "$V/arm/neg/stats.txt" stopped) + $(stat "$V/chain/neg/stats.txt" stopped) ))
g7d=$(( $(stat "$V/arm/neg/stats.txt" diverged) + $(stat "$V/chain/neg/stats.txt" diverged) ))
echo "solver | one arm and two arms with both corrections at the shipped tolerances: steps stopped $g7s diverged $g7d" >> "$OUT"

# ---- G8: the sixth registration's tests with both corrections ----
J="$V/joints_neg"; J0="$R/joints"
jt1="$(nv "$(m "sixth registration's spin with both corrections 1/1" final "$J/spin_be_1.txt")" speed_urads)"
jt2="$(nv "$(m "sixth registration's driven arm with both corrections 1/1" final "$J/torque_be_1.txt")" speed_urads)"
m "sixth registration's pendulum with both corrections 1/1 (reported)" swing "$J/swing_be_1.txt" > /dev/null
m "sixth registration's pendulum, stock 1/1 (reported)" swing "$J0/swing_be_1.txt" > /dev/null
h1="$(nv "$(m "hold with both corrections 1/1" creep "$J/hold_shipped_1.txt")" mean_speed_ums)"; h0="$(nv "$(m "hold, stock 1/1" creep "$J0/hold_shipped_1.txt")" mean_speed_ums)"
p1="$(nv "$(m "slip with both corrections 1/1" final "$J/slip_shipped_1.txt")" speed_urads)"; p0="$(nv "$(m "slip, stock 1/1" final "$J0/slip_shipped_1.txt")" speed_urads)"
p16="$(nv "$(m "slip with both corrections 1/16" final "$J/slip_shipped_16.txt")" speed_urads)"; p016="$(nv "$(m "slip, stock 1/16" final "$J0/slip_shipped_16.txt")" speed_urads)"
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi

# ---- G9 and the decision: the benchmark ----
for sc in half_cheetah ant cart_pole; do for src in b1 g1; do
  echo "benchmark | $sc $src steps $(field "$V/stats_$sc.txt" $src solver_steps) stopped $(field "$V/stats_$sc.txt" $src stopped) diverged $(field "$V/stats_$sc.txt" $src diverged) most_iterations $(field "$V/stats_$sc.txt" $src most_iterations)" >> "$OUT"
done; done
: > "$C"
for sc in half_cheetah ant; do
  echo "=== $sc, the fifth registration's commands: the configuration as it stands ($(cat "$V/bench_base.txt")) with both corrections added (g1 .. g16)" >> "$C"
  "$HERE/sx_settings3" time "$D" $sc 108 200 g1 g2 g4 g8 g16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain G g1 g2 g4 g8 g16 >> "$C" || true
done
grep '^PLAIN' "$C" | sed 's/^/benchmark | /' >> "$OUT"
hy="$(grep '^PLAIN half_cheetah G folds_in_order' "$C" | awk '{print $5}')"; ay="$(grep '^PLAIN ant G folds_in_order' "$C" | awk '{print $5}')"
dvg=0; for sc in half_cheetah ant; do for k in 1 2 4 8 16; do
  dvg=$((dvg + $(field "$V/stats_$sc.txt" g$k diverged)))
  echo "benchmark | $sc g$k steps $(field "$V/stats_$sc.txt" g$k solver_steps) stopped $(field "$V/stats_$sc.txt" g$k stopped) diverged $(field "$V/stats_$sc.txt" g$k diverged) most_iterations $(field "$V/stats_$sc.txt" g$k most_iterations)" >> "$OUT"
done; done

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
# shellcheck disable=SC2086
rule "G0_every_part_identical_in_full" eq "$differs" 0
rule "G0_parts_played" eq "$n_parts" 9
# G1: the law's prediction at the shipped step for 1.5, 3.5 and 6 rad/s
set -- $g1
rule "G1_law_at_1.5" within "$1" 1467348 100; rule "G1_law_at_3.5" within "$2" 3136775 100; rule "G1_law_at_6" within "$3" 4574957 100
# G2: between 9,990 and 10,010 per 10,000 of the release speed, nine plays
lo15=1498500; hi15=1501500; lo35=3496500; hi35=3503500; lo6=5994000; hi6=6006000
a15=""; a35=""; a6=""
for x in $g2; do case "${x%%:*}" in 1.5) a15="$a15 ${x#*:}" ;; 3.5) a35="$a35 ${x#*:}" ;; 6) a6="$a6 ${x#*:}" ;; esac; done
# shellcheck disable=SC2086
rule "G2_one_arm_keeps_its_speed_1.5" all_in $lo15 $hi15 $a15
# shellcheck disable=SC2086
rule "G2_one_arm_keeps_its_speed_3.5" all_in $lo35 $hi35 $a35
# shellcheck disable=SC2086
rule "G2_one_arm_keeps_its_speed_6" all_in $lo6 $hi6 $a6
rule "G3_stock_loses_energy" le "$E_off_free_1" 900000
rule "G3_stock_loses_momentum" le "$M_off_free_1" -30000
rule "G4_momentum_kept_solver_converged" all_in -100 100 "$M_tight_1" "$M_tight_4" "$M_tight_16"
rule "G4_energy_drift_shipped_step" le "$X_tight_1" 5000
rule "G4_energy_drift_quarter_step" le "$X_tight_4" 1000
rule "G4_energy_drift_sixteenth_step" le "$X_tight_16" 500
rule "G5_energy_as_shipped" all_in 990000 1010000 "$E_neg_free_1" "$E_neg_free_4" "$E_neg_free_16"
rule "G5_momentum_as_shipped" all_in -5000 5000 "$M_neg_free_1" "$M_neg_free_4" "$M_neg_free_16"
# G6: with both corrections the energy lost is no more than 6 tenths of what is lost with no switch, and it falls
for k in 1 4 16; do eval "ls=\$L_off_swing_$k; ln=\$L_neg_swing_$k"; rule "G6_loss_under_gravity_1/$k" share "$ln" "$ls" 6 10; done
rule "G6_loss_falls_with_the_step" falls "$L_neg_swing_1" "$L_neg_swing_4" "$L_neg_swing_16"
rule "G7_no_step_stops" eq "$g7s" 0
rule "G7_no_step_diverges" eq "$g7d" 0
rule "G8_JT1_a_free_arm_keeps_its_speed" ge "$jt1" 2970000
rule "G8_JT2_a_driven_arm" within "$jt2" 4656457 100
rule "G8_JT4_hold_as_stock" near "$h1" "$h0" 10
rule "G8_JT5_slip_as_stock_shipped_step" within "$p1" "$p0" 100
rule "G8_JT5_slip_as_stock_sixteenth_step" within "$p16" "$p016" 100
for sc in half_cheetah ant cart_pole; do
  rule "G9_${sc}_no_step_diverges" eq "$(field "$V/stats_$sc.txt" g1 diverged)" 0
  rule "G9_${sc}_stops_no_more_than_without_plus_21" le_plus "$(field "$V/stats_$sc.txt" g1 stopped)" "$(field "$V/stats_$sc.txt" b1 stopped)" 21
done
rule "DECISION_half_cheetah_in_order_3_folds_of_3" eq "${hy:-0}" 3
rule "DECISION_ant_in_order_3_folds_of_3" eq "${ay:-0}" 3
rule "DECISION_no_step_diverges_in_the_chains" eq "$dvg" 0
held="$(grep -c '^RULE G.* : HELD$' "$OUT")"; failed="$(grep -c '^RULE G.* : FAILED$' "$OUT")"
dheld="$(grep -c '^RULE DECISION.* : HELD$' "$OUT")"
echo "STUDY12 rules held $held failed $failed ; decision lines held $dheld of 3 ; values missing $(wc -l < "$MISSF" | tr -d " ") ; measuring complete $(( 1 - bad ))" >> "$OUT"
rm -f "$MISSF"
[ $bad -eq 0 ] || exit 1
exit 0
