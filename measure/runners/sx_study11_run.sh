#!/usr/bin/env bash
# measure/runners/sx_study11_run.sh -- preregistrations/PREREGISTRATION_11.md: the eleventh
# registration, re-made by measuring alone. Both contact suites with and without the friction correction
# (sx_contact_suite.sh, sx_contact stop, pair, accel, suite2), the solver's own counts from the rigs' stats lines,
# the benchmark with the correction (plain subtraction by sx_settings3), and every registered rule judged by
# sx_contact rule.
# usage: sx_study11_run.sh <public record root> <counts out file> <out file>
#        (sx_contact and sx_settings3 built beside this script)
#   Read under the root: validation/run_025_identity/identity.txt; validation/run_027_friction/ (runs/s1/<label>/
#   and runs/s2/<label>/ for rec, rec_f and f_only; stats_<scene>.txt); streams/11/.
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study11_run.sh <public record root> <counts out file> <out file>}"; C="${2:?counts out file}"; OUT="${3:?out file}"
B="$HERE/sx_contact"
V="$R/validation/run_027_friction"; S="$V/runs"; ID="$R/validation/run_025_identity/identity.txt"; D="$R/streams/11"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s11.XXXXXX")"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the measure's LAST line
  local label="$1"; shift
  local lines; lines="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> "$OUT"; echo "$lines" | tail -1
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
rule() { "$B" rule "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "rule failed to run: $*" >&2; bad=1; }; }
stat() { awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$1"; }
MISSF="$(mktemp "${TMPDIR:-/tmp}/sx_miss.XXXXXX")"
# a value the stats do not hold counts as missing and stands as 999999999, which no registered bound admits
field() { local x; x="$(grep "^STATS source $2 " "$1" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }

# ---- F0: safe when off ----
while read -r _ part same _ played; do echo "identity | $part $same of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
differs="$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID")"; n_parts="$(grep -c '^IDENTITY ' "$ID")"

# ---- the suites on the registered cubes ----
export SUITE_MU10K=3000 SUITE_SLIPMN=6586
code1() {  # code1 <label>: the first suite's code; its lines go to the out file and to $P/suite1_<label>.txt
  bash "$HERE/sx_contact_suite.sh" "$S/s1/$1" "$P/suite1_$1.txt" || { echo "measuring the first suite incomplete: $1" >&2; bad=1; }
  sed "s/^/first suite, $1 | /" "$P/suite1_$1.txt" >> "$OUT"
  grep '^T[01][0-9]' "$P/suite1_$1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n'
}
seven() { grep "^$2 " "$P/suite1_$1.txt" | sed -E 's/^.*\): ([-0-9 ]+) ;.*$/\1/; s/^.*\): ([-0-9 ]+) : (PASS|FAIL)$/\1/'; }   # the seven numbers of a test line
code2() {  # code2 <label>: the second suite's code (T11 to T17)
  local l="$1" d="$S/s2/$1" speeds="" back="" pairs="" line run k
  for run in stop land; do for k in 1 4 16 64; do
    line="$(m "$l $run 1/$k" stop "$d/${run}_$k.txt")"; speeds="$speeds $(f "$line" 7)"; back="$back $(f "$line" 11)"
  done; done
  for k in 1 16; do
    line="$(m "$l rest 1/$k" pair "$d/rest_${k}_a.txt" "$d/rest_${k}_b.txt")"; pairs="$pairs $(f "$line" 17) $(f "$line" 19)"
    line="$(m "$l carry 1/$k" pair "$d/carry_${k}_a.txt" "$d/carry_${k}_b.txt")"; pairs="$pairs $(f "$line" 15)"
    pairs="$pairs $(f "$(m "$l slip A 1/$k" accel "$d/slip_${k}_a.txt" 700 900)" 9) $(f "$(m "$l slip B 1/$k" accel "$d/slip_${k}_b.txt" 700 900)" 9)"
    line="$(m "$l side 1/$k" pair "$d/side_${k}_a.txt" "$d/side_${k}_b.txt")"; pairs="$pairs $(f "$line" 9)"
    line="$(m "$l top 1/$k" pair "$d/top_${k}_a.txt" "$d/top_${k}_b.txt")"; pairs="$pairs $(f "$line" 9) $(f "$line" 15)"
  done
  # the registered right answers: 29,400 and 4,900 mN carried, slip accelerations 6,982 and 4,410 mm/s2 (the third
  # number is not read by the rules)
  # shellcheck disable=SC2086
  line="$(m "second suite, $l" suite2 $speeds $back $pairs 29400 4900 0 6982 4410)"
  f "$line" 17
}
c1r="$(code1 rec)"; c1f="$(code1 rec_f)"; c1o="$(code1 f_only)"
c2r="$(code2 rec)"; c2f="$(code2 rec_f)"; c2o="$(code2 f_only)"
t5r="$(seven rec T05)"; t5f="$(seven rec_f T05)"; t10f="$(seven rec_f T10)"
echo "codes | first suite: recommended $c1r ; with the correction $c1f ; the correction alone on stock contact $c1o (reported)" >> "$OUT"
echo "codes | second suite: recommended $c2r ; with the correction $c2f ; the correction alone on stock contact $c2o (reported)" >> "$OUT"
sstop=$(( $(stat "$S/s1/rec_f/stats.txt" stopped) + $(stat "$S/s2/rec_f/stats.txt" stopped) ))
sdiv=$(( $(stat "$S/s1/rec_f/stats.txt" diverged) + $(stat "$S/s2/rec_f/stats.txt" diverged) ))
echo "solver on the suites | recommended: stopped $(( $(stat "$S/s1/rec/stats.txt" stopped) + $(stat "$S/s2/rec/stats.txt" stopped) )) ; with the correction: stopped $sstop diverged $sdiv" >> "$OUT"
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi

# ---- the benchmark ----
for sc in half_cheetah ant cart_pole; do for src in r1 f1; do
  echo "benchmark | $sc $src steps $(field "$V/stats_$sc.txt" $src solver_steps) stopped $(field "$V/stats_$sc.txt" $src stopped) diverged $(field "$V/stats_$sc.txt" $src diverged) most_iterations $(field "$V/stats_$sc.txt" $src most_iterations)" >> "$OUT"
done; done
: > "$C"
for sc in half_cheetah ant; do
  echo "=== $sc, the fifth registration's commands: the recommended configuration with the friction correction added (f1 .. f16)" >> "$C"
  "$HERE/sx_settings3" time "$D" $sc 108 200 f1 f2 f4 f8 f16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain F f1 f2 f4 f8 f16 >> "$C" || true
done
grep '^PLAIN' "$C" | sed 's/^/benchmark | /' >> "$OUT"
hy="$(grep '^PLAIN half_cheetah F folds_in_order' "$C" | awk '{print $5}')"; ay="$(grep '^PLAIN ant F folds_in_order' "$C" | awk '{print $5}')"
dvg=0; for sc in half_cheetah ant; do for k in 1 2 4 8 16; do
  dvg=$((dvg + $(field "$V/stats_$sc.txt" f$k diverged)))
  echo "benchmark | $sc f$k steps $(field "$V/stats_$sc.txt" f$k solver_steps) stopped $(field "$V/stats_$sc.txt" f$k stopped) diverged $(field "$V/stats_$sc.txt" f$k diverged) most_iterations $(field "$V/stats_$sc.txt" f$k most_iterations)" >> "$OUT"
done; done

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
rule "F0_every_part_identical_in_full" eq "$differs" 0
rule "F0_parts_played" eq "$n_parts" 9
# shellcheck disable=SC2086
set -- $t5r
rule "F1_T05_fails_without_the_correction" eq "$(echo "$c1r" | cut -c5)" 0
rule "F1_friction_at_the_impact_short_of_the_law" le "$1" 2400
# shellcheck disable=SC2086
rule "F2_T05_within_1_in_100_of_the_law" all_within 3000 100 $t5f
rule "F2_T10_passes" eq "$(echo "$c1f" | cut -c10)" 1
rule "F3_first_suite_code" eq "$c1f" 1111111111
rule "F3_second_suite_code" eq "$c2f" 1111111
rule "F4_no_step_of_the_suites_stops" eq "$sstop" 0
rule "F4_no_step_of_the_suites_diverges" eq "$sdiv" 0
for sc in half_cheetah ant cart_pole; do
  rule "F5_${sc}_no_step_diverges" eq "$(field "$V/stats_$sc.txt" f1 diverged)" 0
  rule "F5_${sc}_stops_no_more_than_without_plus_21" le_plus "$(field "$V/stats_$sc.txt" f1 stopped)" "$(field "$V/stats_$sc.txt" r1 stopped)" 21
done
rule "F6_the_other_eight_tests_read_the_same" eq "1$(echo "$c1f" | cut -c1-4,6-9)" "1$(echo "$c1r" | cut -c1-4,6-9)"
rule "DECISION_half_cheetah_in_order_3_folds_of_3" eq "${hy:-0}" 3
rule "DECISION_ant_in_order_3_folds_of_3" eq "${ay:-0}" 3
rule "DECISION_no_step_diverges_in_the_chains" eq "$dvg" 0
held="$(grep -c '^RULE F.* : HELD$' "$OUT")"; failed="$(grep -c '^RULE F.* : FAILED$' "$OUT")"
dheld="$(grep -c '^RULE DECISION.* : HELD$' "$OUT")"
echo "STUDY11 rules held $held failed $failed ; decision lines held $dheld of 3 ; values missing $(wc -l < "$MISSF" | tr -d " ") ; measuring complete $(( 1 - bad ))" >> "$OUT"
rm -f "$MISSF"
[ $bad -eq 0 ] || exit 1
exit 0
