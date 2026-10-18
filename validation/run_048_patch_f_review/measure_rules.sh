#!/usr/bin/env bash
# measure_rules.sh : PROBE ONLY. Reads probe_rules.sh's plays with the record's measuring program (sx_contact, the
# Linux build of measure/sx_contact.sx) and the record's suite runner, and judges F0 to F6 as the eleventh
# registration words them, on the probe numbers. The probe pair's right answers: weight on A 31,360 mN, on B 5,390 mN;
# slip accelerations A 5,751 and B 3,626 mm/s2 (mu 0.37, g 9.8). The probe cube's friction: 0.32 (3,200 per 10,000).
set -u
W=~/work/probeF; R=$W/record; B=$W/bin/sx_contact; O=$W/rules; OUT=$O/reading.txt; : > $OUT
export SUITE_MU10K=3200 SUITE_SLIPMN=8085
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
m() { local label="$1"; shift; local lines; lines="$("$B" "$@")"; echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> $OUT; echo "$lines" | tail -1; }
code1() { bash $W/bin/sx_contact_suite.sh "$R/suites/1/$1" "$O/suite1_$1.txt" || echo "measuring suite 1 incomplete: $1" >&2
  sed "s/^/first suite, $1 | /" "$O/suite1_$1.txt" >> $OUT
  grep '^T[01][0-9]' "$O/suite1_$1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n'; }
seven() { grep "^$2 " "$O/suite1_$1.txt" | sed -E 's/^.*\): ([-0-9 ]+) ;.*$/\1/; s/^.*\): ([-0-9 ]+) : (PASS|FAIL)$/\1/'; }
code2() { local l="$1" d="$R/suites/2/$1" speeds="" back="" pairs="" line run k
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
  # shellcheck disable=SC2086
  line="$(m "second suite, $l" suite2 $speeds $back $pairs 31360 5390 0 5751 3626)"; f "$line" 17; }
stat() { awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$1"; }
rule() { "$B" rule "$@" >> $OUT; }
labels="pf_stock pf_rec_nof pf_rec_f pf_rec_nof_owngrid pf_rec_f_owngrid"
for l in $labels; do eval "c1_$l=\$(code1 $l)"; eval "c2_$l=\$(code2 $l)"; done
for l in $labels; do eval "echo \"codes | $l first suite \$c1_$l ; second suite \$c2_$l\"" >> $OUT; done
t5n="$(seven pf_rec_nof T05)"; t5f="$(seven pf_rec_f T05)"
sstop=$(( $(stat "$R/suites/1/pf_rec_f/stats.txt" stopped) + $(stat "$R/suites/2/pf_rec_f/stats.txt" stopped) ))
sdiv=$(( $(stat "$R/suites/1/pf_rec_f/stats.txt" diverged) + $(stat "$R/suites/2/pf_rec_f/stats.txt" diverged) ))
nstop=$(( $(stat "$R/suites/1/pf_rec_nof/stats.txt" stopped) + $(stat "$R/suites/2/pf_rec_nof/stats.txt" stopped) ))
echo "solver on the suites | without F: stopped $nstop ; with F: stopped $sstop diverged $sdiv" >> $OUT
# F0: identity
grep -h "^SAME\|^BENCH" $O/identity_suites.txt $O/identity_bench.txt | sed 's/^/identity | /' >> $OUT
ndiff=$(grep -h "^SAME\|^BENCH" $O/identity_suites.txt $O/identity_bench.txt | grep -c "differ\|DIFFERS")
rule "F0_probe_every_comparison_identical" eq "$ndiff" 0
# F1 (bound: 8 tenths of the law, 2,560 per 10,000 on the probe cube)
# shellcheck disable=SC2086
set -- $t5n
rule "F1_T05_fails_without_the_correction" eq "$(echo "$c1_pf_rec_nof" | cut -c5)" 0
rule "F1_friction_at_the_impact_short_of_the_law" le "$1" 2560
# shellcheck disable=SC2086
rule "F2_T05_within_1_in_100_of_the_law" all_within 3200 100 $t5f
rule "F2_T10_passes" eq "$(echo "$c1_pf_rec_f" | cut -c10)" 1
rule "F3_first_suite_code" eq "$c1_pf_rec_f" 1111111111
rule "F3_second_suite_code" eq "$c2_pf_rec_f" 1111111
rule "F4_no_step_of_the_suites_stops" eq "$sstop" 0
rule "F4_no_step_of_the_suites_diverges" eq "$sdiv" 0
BS=$O/bench/stats.txt
for sc in half_cheetah ant cart_pole; do
  fl="$(grep "^STATS source rec_f " $BS | grep " scene $sc ")"; nl="$(grep "^STATS source rec_nof " $BS | grep " scene $sc ")"
  fd="$(echo "$fl" | awk '{for(i=1;i<=NF;i++) if ($i=="diverged") print $(i+1)}')"; fs="$(echo "$fl" | awk '{for(i=1;i<=NF;i++) if ($i=="stopped") print $(i+1)}')"
  ns="$(echo "$nl" | awk '{for(i=1;i<=NF;i++) if ($i=="stopped") print $(i+1)}')"; nd="$(echo "$nl" | awk '{for(i=1;i<=NF;i++) if ($i=="diverged") print $(i+1)}')"
  echo "benchmark | $sc without F: stopped $ns diverged $nd ; with F: stopped $fs diverged $fd" >> $OUT
  rule "F5_${sc}_no_step_diverges" eq "${fd:-999}" 0
  rule "F5_${sc}_stops_no_more_than_without_plus_21" le_plus "${fs:-999}" "${ns:-0}" 21
done
rule "F6_the_other_eight_tests_read_the_same" eq "1$(echo "$c1_pf_rec_f" | cut -c1-4,6-9)" "1$(echo "$c1_pf_rec_nof" | cut -c1-4,6-9)"
grep "^RULE\|^codes\|^solver\|^benchmark\|^identity" $OUT
