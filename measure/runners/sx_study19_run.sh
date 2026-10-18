#!/usr/bin/env bash
# The nineteenth registration (preregistrations/PREREGISTRATION_19.md), re-made by measuring alone from the play
# script's out folder (tools/plays/play_19.sh). Each rule is judged by `sx_contact rule`; the hops are read by
# `sx_contact ends` (build 14 against build 15, where the two end), `bounce`, `stop` and `hover`.
# usage: sx_study19_run.sh <out folder of play_19.sh> <out file>      (sx_contact built beside this script)
# exit 0 = every line was written (what held is in the RULE lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_study19_run.sh <out folder> <out file>}"; OUT="${2:?out file}"
B="$HERE/sx_contact"; R="$D/runs"
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the line
  local label="$1"; shift
  local line; line="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }
  echo "$label | $line" >> "$OUT"; echo "$line"
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
# S0: the contact rig with no new setting makes the 268 registered suite files
sameN=$(awk '{ s += $(NF-2); n += $NF } END { print s + 0 }' "$D/identity.txt")
allN=$(awk '{ s += $(NF-2); n += $NF } END { print n + 0 }' "$D/identity.txt")
sed 's/^/identity | /' "$D/identity.txt" >> "$OUT"
m "S0" rule S0_same eq "$sameN" 268 > /dev/null
m "S0" rule S0_files eq "$allN" 268 > /dev/null
# L: the library loaded with dlopen after the exit handler
sed 's/^/exit | /' "$D/exit.txt" >> "$OUT"
ex() { awk -v l="$1" -v s="$2" -v k="$3" '$1 == l && $2 == s { for (i = 1; i <= NF; i++) if ($i == k) print $(i + 1) }' "$D/exit.txt"; }
err() { awk -v l="$1" -v s="$2" '$1 == l && $2 == s { for (i = 1; i <= NF; i++) if ($i == "SUMMARY:") print $(i + 1) }' "$D/exit.txt"; }
m "L1" rule L1_errors ge "$(err b14 abcd)" 1 > /dev/null
m "L1" rule L1_in_ClearFrictionAnchors ge "$(ex b14 abcd invalid_in_ClearFrictionAnchors)" 1 > /dev/null
m "L2" rule L2_errors all_eq 0 "$(err b15 abcd)" "$(err b15 off)" "$(err stock off)" > /dev/null
m "L2" rule L2_exit all_eq 0 "$(ex b15 abcd exit)" "$(ex b15 off exit)" "$(ex stock off exit)" > /dev/null
m "L2" rule L2_destroyed all_eq 1 "$(ex b15 abcd destroyed)" "$(ex b15 off destroyed)" "$(ex stock off destroyed)" "$(ex b14 abcd destroyed)" "$(ex b14 off destroyed)" > /dev/null
# M: the hop on the deforming soft block
sed 's/^/soft | /' "$D/soft.txt" >> "$OUT"
m "M0" rule M0_off_is_stock eq "$(grep -c '^SAME off_against_stock' "$D/soft.txt")" 5 > /dev/null
m "M1" rule M1_reached ge "$(grep -c '^DIFFERS 14_against_15' "$D/soft.txt")" 1 > /dev/null
# reported: where builds 14 and 15 end apart, and what the hops did on build 15
for c in c abcd; do for k in 1 4 16 32 64; do
  m "ends $c 1/$k" ends "$R/hop_b14_${c}_$k.txt" "$R/hop_b15_${c}_$k.txt" > /dev/null
done; done
for c in stock b15_off b15_c b15_abcd; do for k in 1 4 16 32 64; do
  m "$c 1/$k" bounce "$R/hop_${c}_$k.txt" > /dev/null
  m "$c 1/$k" stop "$R/hop_${c}_$k.txt" > /dev/null
  m "$c 1/$k" hover "$R/hop_${c}_$k.txt" > /dev/null
done; done
[ $bad -eq 0 ] || exit 1
exit 0
