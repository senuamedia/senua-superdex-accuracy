#!/usr/bin/env bash
# measure/runners/sx_ledger7_run.sh -- preregistrations/PREREGISTRATION_07.md: the seventh
# registration, re-made by measuring alone. The first suite under the recommended configuration corrected
# (sx_contact_suite.sh), the second suite under every configuration (sx_contact stop, pair, accel), the identity of
# both suites with the patch off (stock against off, file by file), the benchmark by plain subtraction
# (sx_settings3), the solver's own status from the rig's stats, then the registered rules (sx_contact ledger7).
# usage: sx_ledger7_run.sh <suite dir> <streams dir> <counts out file> <out file>
#        (sx_contact and sx_settings3 built beside this script)
#   <suite dir>: s1/<configuration>/ and s2/<configuration>/ (the public rig's tools/contact_suite.sh and
#   contact_suite2.sh; configurations stock off stick stickd rec_old rec_new), and identity.txt, the rig's record of
#   the registered benchmark streams re-played with the patch off (that count needs the library, so it is given).
#   <streams dir>: <scene>/<source>_enc.pcm and stats_<scene>.txt (sources sref t2 t4 t8 t16 stock, r1 .. r16 the
#   recommended configuration corrected).
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
S="${1:?usage: sx_ledger7_run.sh <suite dir> <streams dir> <counts out file> <out file>}"; D="${2:?streams dir}"; C="${3:?counts out file}"; OUT="${4:?out file}"
B="$HERE/sx_contact"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_l7.XXXXXX")"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the line
  local label="$1"; shift
  local line; line="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$label | $line" >> "$OUT"; echo "$line"
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
stops() { awk '{ for (i=1;i<=NF;i++) if ($i=="stopped") s+=$(i+1) } END { printf "%d", s }' "$1/stats.txt"; }
ident() { local same=0 diff=0 x; for x in "$1"/stock/*_[0-9]*.txt; do if cmp -s "$x" "$1/off/$(basename "$x")"; then same=$((same + 1)); else diff=$((diff + 1)); fi; done; echo "$same $((same + diff))"; }
# the first suite: the registered cube of the seventh registration
export SUITE_MU10K=3500 SUITE_SLIPMN=4234
bash "$HERE/sx_contact_suite.sh" "$S/s1/rec_new" "$P/suite1_rec_new.txt" || { echo "measuring the first suite incomplete" >&2; exit 1; }
sed 's/^/first suite, recommended corrected | /' "$P/suite1_rec_new.txt" >> "$OUT"
code="$(grep '^T[01][0-9]' "$P/suite1_rec_new.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n')"
# the second suite: a slide that ends, under every configuration
speeds=""; back=""
for l in stock stick stickd rec_old rec_new; do
  for run in stop land; do for k in 1 4 16 64; do
    line="$(m "$l $run 1/$k" stop "$S/s2/$l/${run}_$k.txt")"; speeds="$speeds $(f "$line" 7)"
    [ $l = rec_new ] && back="$back $(f "$line" 11)"
  done; done
done
# two moving cubes, under stock and the recommended configuration corrected
pairs=""
for l in stock rec_new; do for k in 1 16; do
  d="$S/s2/$l"
  line="$(m "$l rest 1/$k" pair "$d/rest_${k}_a.txt" "$d/rest_${k}_b.txt")"; pairs="$pairs $(f "$line" 17) $(f "$line" 19)"
  line="$(m "$l carry 1/$k" pair "$d/carry_${k}_a.txt" "$d/carry_${k}_b.txt")"; pairs="$pairs $(f "$line" 15)"
  pairs="$pairs $(f "$(m "$l slip A 1/$k" accel "$d/slip_${k}_a.txt" 700 900)" 9) $(f "$(m "$l slip B 1/$k" accel "$d/slip_${k}_b.txt" 700 900)" 9)"
  line="$(m "$l side 1/$k" pair "$d/side_${k}_a.txt" "$d/side_${k}_b.txt")"; pairs="$pairs $(f "$line" 9)"
  line="$(m "$l top 1/$k" pair "$d/top_${k}_a.txt" "$d/top_${k}_b.txt")"; pairs="$pairs $(f "$line" 9) $(f "$line" 15)"
done; done
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi
for s in s1 s2; do for l in stock stick stickd rec_old rec_new; do [ -f "$S/$s/$l/stats.txt" ] && echo "solver $s $l | steps stopped without converging $(stops "$S/$s/$l")" >> "$OUT"; done; done
# the benchmark on the fifth registration's commands, by plain subtraction
: > "$C"
for sc in half_cheetah ant; do
  echo "=== $sc, the fifth registration's commands (seeds 4602, 4603): shipped (sref t2 t4 t8 t16) and the recommended configuration corrected (r1 .. r16)" >> "$C"
  "$HERE/sx_settings3" time "$D" $sc 108 200 sref t2 t4 t8 t16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain T4 sref t2 t4 t8 t16 >> "$C" || true
  "$HERE/sx_settings3" time "$D" $sc 108 200 r1 r2 r4 r8 r16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain R r1 r2 r4 r8 r16 >> "$C" || true
done
grep '^PLAIN' "$C" | sed 's/^/benchmark | /' >> "$OUT"
hs="$(grep '^PLAIN half_cheetah T4 folds_in_order' "$C" | awk '{print $5}')"; hn="$(grep '^PLAIN half_cheetah R folds_in_order' "$C" | awk '{print $5}')"
field() { grep "^STATS source $2 " "$D/stats_$1.txt" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}'; }
dvg=0; for sc in half_cheetah ant; do for k in 1 2 4 8 16; do dvg=$((dvg + $(field $sc r$k diverged))); echo "benchmark | $sc r$k steps $(field $sc r$k solver_steps) stopped $(field $sc r$k stopped) diverged $(field $sc r$k diverged) most_iterations $(field $sc r$k most_iterations)" >> "$OUT"; done; done
bi="$(grep '^IDENTITY benchmark' "$S/identity.txt" | awk '{print $3}')"; bo="$(grep '^IDENTITY benchmark' "$S/identity.txt" | awk '{print $5}')"
# shellcheck disable=SC2046,SC2086
"$B" ledger7 $(ident "$S/s1") $(ident "$S/s2") "$bi" "$bo" $speeds $back $pairs 39200 5880 2929 6174 3920 "$code" \
  "$hs" "$hn" "$dvg" "$(field half_cheetah sref stopped)" "$(field half_cheetah r1 stopped)" "$(field half_cheetah r1 solver_steps)" \
  "$(field ant sref stopped)" "$(field ant r1 stopped)" "$(field ant r1 solver_steps)" \
  "$(stops "$S/s1/rec_old")" "$(stops "$S/s1/rec_new")" "$(stops "$S/s2/rec_old")" "$(stops "$S/s2/rec_new")" >> "$OUT"
[ $? -eq 42 ] || exit 1   # a Simplex program exits 42 when it ran
exit 0
