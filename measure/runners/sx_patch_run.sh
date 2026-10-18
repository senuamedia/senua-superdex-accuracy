#!/usr/bin/env bash
# measure/runners/sx_patch_run.sh -- preregistrations/PREREGISTRATION_05.md: the patch ledger,
# re-made by measuring alone. Every suite run of every configuration against its right answer (sx_contact_suite.sh),
# the suite's identity when the patch is off (stock against patched_off, file by file), the benchmark on fresh
# commands by plain subtraction (sx_settings3), the solver's own status from the rig's stats, then the registered
# rules (sx_contact ledger).
# usage: sx_patch_run.sh <suite dir> <streams dir> <counts out file> <out file>
#        (sx_contact and sx_settings3 built beside this script)
#   <suite dir>: one directory a configuration (the public rig's tools/contact_suite.sh), and identity.txt, the rig's
#   record of the registered benchmark streams re-played with the patch off (that count needs the library, so it is
#   given, as the state files are in sx_count3.sh).
#   <streams dir>: <scene>/<source>_enc.pcm and stats_<scene>.txt.
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
S="${1:?usage: sx_patch_run.sh <suite dir> <streams dir> <counts out file> <out file>}"; D="${2:?streams dir}"; C="${3:?counts out file}"; OUT="${4:?out file}"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_patch.XXXXXX")"
trap 'rm -rf "$P"' EXIT
export SUITE_MU10K=3000 SUITE_SLIPMN=3528      # the registered cube of the fifth registration
labels="stock implicit damped damped_a damped_ab stick recommended recommended_implicit"
for l in $labels; do bash "$HERE/sx_contact_suite.sh" "$S/$l" "$P/suite_$l.txt" || { echo "measuring $l incomplete" >&2; exit 1; }; done
code() { grep '^T[01][0-9]' "$P/suite_$1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n'; }
same=0; diff=0
for f in "$S"/stock/*_[0-9]*.txt; do if cmp -s "$f" "$S/patched_off/$(basename "$f")"; then same=$((same + 1)); else diff=$((diff + 1)); fi; done
bi="$(grep '^IDENTITY benchmark' "$S/identity.txt" | awk '{print $3}')"; bo="$(grep '^IDENTITY benchmark' "$S/identity.txt" | awk '{print $5}')"
: > "$C"
for sc in half_cheetah ant; do
  echo "=== $sc, fresh commands (seeds 4602, 4603): shipped (sref t2 t4 t8 t16) and the recommended configuration (q1 .. q16)" >> "$C"
  "$HERE/sx_settings3" time "$D" $sc 108 200 sref t2 t4 t8 t16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain T4 sref t2 t4 t8 t16 >> "$C" || true
  "$HERE/sx_settings3" time "$D" $sc 108 200 q1 q2 q4 q8 q16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain Q q1 q2 q4 q8 q16 >> "$C" || true
done
hs="$(grep '^PLAIN half_cheetah T4 folds_in_order' "$C" | awk '{print $5}')"; hp="$(grep '^PLAIN half_cheetah Q folds_in_order' "$C" | awk '{print $5}')"
field() { grep "^STATS source $2 " "$D/stats_$1.txt" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}'; }
dvg=0; for sc in half_cheetah ant; do for k in 1 2 4 8 16; do dvg=$((dvg + $(field $sc q$k diverged))); done; done
: > "$OUT"
echo "IDENTITY-RECORD IDENTITY suite $same of $((same + diff))" >> "$OUT"
echo "IDENTITY-RECORD IDENTITY benchmark $bi of $bo" >> "$OUT"
for l in $labels; do echo "SUITE-RESULT $l $(code $l) $(grep '^SUITE' "$P/suite_$l.txt")" >> "$OUT"; done
"$HERE/sx_contact" ledger "$same" "$((same + diff))" "$bi" "$bo" "$(code stock)" "$(code implicit)" "$(code damped)" "$(code damped_a)" "$(code damped_ab)" "$(code stick)" "$(code recommended)" \
  "$hs" "$hp" "$dvg" "$(field half_cheetah sref stopped)" "$(field half_cheetah q1 stopped)" "$(field half_cheetah q1 solver_steps)" \
  "$(field ant sref stopped)" "$(field ant q1 stopped)" "$(field ant q1 solver_steps)" >> "$OUT"
[ $? -eq 42 ] || exit 1   # a Simplex program exits 42 when it ran
exit 0
