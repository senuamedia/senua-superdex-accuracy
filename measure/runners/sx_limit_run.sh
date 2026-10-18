#!/usr/bin/env bash
# measure/runners/sx_limit_run.sh -- preregistrations/PREREGISTRATION_08.md: joint limits,
# re-made by measuring alone. The one-joint runs under stock and under the joint limit patch (sx_contact final,
# leave), their identity with the patch off (stock against off, file by file), the benchmark chains by plain
# subtraction (sx_settings3), the solver's own status from the rig's stats, then the registered rules (sx_contact
# limits).
# usage: sx_limit_run.sh <limits dir> <streams dir> <counts out file> <out file>
#        (sx_contact and sx_settings3 built beside this script)
#   <limits dir>: stock/ off/ patched/ (the public rig's tools/limit_all.sh), nolimit_identity.txt (the sixth
#   registration's 30 runs re-played with the switch on and with it off: those counts need the library, so they are
#   given) and identity.txt (the registered benchmark streams re-played with no switch).
#   <streams dir>: <scene>/<source>_enc.pcm and stats_<scene>.txt (u1 the limit patch alone; z1 .. z16 the
#   recommended configuration corrected with the limit patch; sref the stock status line).
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
L="${1:?usage: sx_limit_run.sh <limits dir> <streams dir> <counts out file> <out file>}"; D="${2:?streams dir}"; C="${3:?counts out file}"; OUT="${4:?out file}"
B="$HERE/sx_contact"
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the line
  local label="$1"; shift
  local line; line="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$label | $line" >> "$OUT"; echo "$line"
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
tot() { awk -v k="$2" '{ for (i=1;i<=NF;i++) if ($i==k) s+=$(i+1) } END { printf "%d", s }' "$1"; }
same=0; diff=0
for x in "$L"/stock/*_[0-9]*.txt; do if cmp -s "$x" "$L/off/$(basename "$x")"; then same=$((same + 1)); else diff=$((diff + 1)); fi; done
offs="$(grep '^OFF identical' "$L/nolimit_identity.txt" | awk '{print $3}')"; offo="$(grep '^OFF identical' "$L/nolimit_identity.txt" | awk '{print $5}')"
nls="$(grep '^NOLIMIT identical' "$L/nolimit_identity.txt" | awk '{print $3}')"; nlo="$(grep '^NOLIMIT identical' "$L/nolimit_identity.txt" | awk '{print $5}')"
bi="$(grep '^IDENTITY benchmark' "$L/identity.txt" | awk '{print $3}')"; bo="$(grep '^IDENTITY benchmark' "$L/identity.txt" | awk '{print $5}')"
rest=""; rel=""; lift=""
for c in stock patched; do for k in 1 16; do rest="$rest $(f "$(m "$c rest 1/$k" final "$L/$c/rest_$k.txt")" 5)"; done; done
for c in stock patched; do for d in 20 150; do
  rel="$rel $(f "$(m "$c release, damping $d, 1/64" leave "$L/$c/rel${d}_64.txt" -300000)" 7)"
  for k in 1 16; do line="$(m "$c release, damping $d, 1/$k" leave "$L/$c/rel${d}_$k.txt" -300000)"; rel="$rel $(f "$line" 9) $(f "$line" 11)"; done
done; done
for c in stock patched; do for k in 1 16; do lift="$lift $(f "$(m "$c lift 1/$k" final "$L/$c/lift_$k.txt")" 5)"; done; done
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi
echo "solver | the patched limit runs: stopped $(tot "$L/patched/stats.txt" stopped) diverged $(tot "$L/patched/stats.txt" diverged) ; stock: stopped $(tot "$L/stock/stats.txt" stopped)" >> "$OUT"
field() { grep "^STATS source $2 " "$D/stats_$1.txt" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}'; }
bench=""; for sc in half_cheetah ant cart_pole; do bench="$bench $(field $sc sref stopped) $(field $sc u1 stopped) $(field $sc u1 solver_steps) $(field $sc u1 diverged)"; done
: > "$C"
for sc in half_cheetah ant; do
  echo "=== $sc, the fifth registration's commands: the recommended configuration corrected with the joint limit patch (z1 .. z16)" >> "$C"
  "$HERE/sx_settings3" time "$D" $sc 108 200 z1 z2 z4 z8 z16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain Z z1 z2 z4 z8 z16 >> "$C" || true
done
grep '^PLAIN' "$C" | sed 's/^/benchmark | /' >> "$OUT"
hz="$(grep '^PLAIN half_cheetah Z folds_in_order' "$C" | awk '{print $5}')"; az="$(grep '^PLAIN ant Z folds_in_order' "$C" | awk '{print $5}')"
dvg=0; for sc in half_cheetah ant; do for k in 1 2 4 8 16; do dvg=$((dvg + $(field $sc z$k diverged))); echo "benchmark | $sc z$k steps $(field $sc z$k solver_steps) stopped $(field $sc z$k stopped) diverged $(field $sc z$k diverged) most_iterations $(field $sc z$k most_iterations)" >> "$OUT"; done; done
# shellcheck disable=SC2086
"$B" limits "$((same + offs))" "$((same + diff + offo))" "$bi" "$bo" "$nls" "$nlo" $rest -303741 $rel 1434131 369401 $lift -189208 \
  "$(tot "$L/patched/stats.txt" stopped)" "$(tot "$L/patched/stats.txt" diverged)" $bench "$hz" "$az" "$dvg" "$(field half_cheetah z1 stopped)" "$(field ant z1 stopped)" >> "$OUT"
[ $? -eq 42 ] || exit 1   # a Simplex program exits 42 when it ran
exit 0
