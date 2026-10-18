#!/usr/bin/env bash
# measure/runners/sx_study10_run.sh -- preregistrations/PREREGISTRATION_10.md: the tenth
# registration, re-made by measuring alone. The solver's own trace of every step of ant on four registered command
# sets under eleven configurations (sx_contact trace), and every registered rule judged by sx_contact rule.
# usage: sx_study10_run.sh <public record root> <out file>        (sx_contact built beside this script)
#   Read under the root: validation/run_025_identity/identity.txt; validation/run_026_ant_stops/set<i>/<label>.tr
#   and <label>_enc.pcm for i = 0 to 3.
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study10_run.sh <public record root> <out file>}"; OUT="${2:?out file}"
B="$HERE/sx_contact"
V="$R/validation/run_026_ant_stops"; ID="$R/validation/run_025_identity/identity.txt"
: > "$OUT"
bad=0
MISSF="$(mktemp "${TMPDIR:-/tmp}/sx_miss.XXXXXX")"
# the number after a name; a name a measured line does not hold counts as missing and stands as 999999999
nv() { local x; x="$(echo "$1" | awk -v k="$2" '{ for (i = 1; i < NF; i++) if ($i == k) { print $(i + 1); exit } }')"; if [ -z "$x" ]; then echo "$2" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
rule() { "$B" rule "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "rule failed to run: $*" >&2; bad=1; }; }
LABELS="stock expn implicit armijo nudge d d_expn ng_stock ng_d rec rec_f"

# ---- S0: safe when off ----
while read -r _ part same _ played; do echo "identity | $part $same of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
differs="$(grep -c '^DIFFERS\|^PLAY FAILED' "$ID")"; n_parts="$(grep -c '^IDENTITY ' "$ID")"

# ---- every trace ----
for i in 0 1 2 3; do for l in $LABELS; do
  line="$("$B" trace "$V/set$i/$l.tr" 200 0)"; [ $? -eq 42 ] || { echo "failed: trace set $i $l" >&2; bad=1; }
  echo "set $i $l | $line" >> "$OUT"
  eval "ST_${l}_$i=\"$(nv "$line" stopped)\"; LIM_${l}_$i=\"$(nv "$line" at_the_limit)\"; LO_${l}_$i=\"$(nv "$line" stopped_residual_u)\"; DV_${l}_$i=\"$(nv "$line" diverged)\""
done; done
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
rule "S0_every_part_identical_in_full" eq "$differs" 0
rule "S0_parts_played" eq "$n_parts" 9
for i in 0 1 2 3; do
  eval "st=\$ST_stock_$i; lim=\$LIM_stock_$i; lo=\$LO_stock_$i; ex=\$ST_expn_$i; im=\$ST_implicit_$i; ar=\$ST_armijo_$i; d=\$ST_d_$i; dx=\$ST_d_expn_$i; ns=\$ST_ng_stock_$i; nd=\$ST_ng_d_$i"
  rule "S1_stock_stops_at_least_100_set$i" ge "$st" 100
  rule "S2_every_stop_at_the_limit_set$i" eq "$lim" "$st"
  rule "S2_no_stop_near_the_tolerance_set$i" ge "$lo" 2000
  rule "S3_explicit_normals_leave_a_fifth_set$i" share "$ex" "$st" 1 5
  rule "S4_implicit_normal_force_leaves_a_tenth_set$i" share "$im" "$st" 1 10
  rule "S5_armijo_alone_leaves_half_set$i" share "$st" "$ar" 2 1
  rule "S6_no_ground_no_stop_set$i" all_eq 0 "$ns" "$nd"
  rule "S7_joint_limit_patch_with_explicit_normals_a_fifth_set$i" share "$dx" "$d" 1 5
  rule "S8_its_extra_stops_go_with_explicit_normals_set$i" le_plus "$dx" "$ex" 21
done
held="$(grep -c '^RULE S.* : HELD$' "$OUT")"; failed="$(grep -c '^RULE S.* : FAILED$' "$OUT")"
echo "STUDY10 rules held $held failed $failed ; values missing $(wc -l < "$MISSF" | tr -d " ") ; measuring complete $(( 1 - bad ))" >> "$OUT"
rm -f "$MISSF"
[ $bad -eq 0 ] || exit 1
exit 0
