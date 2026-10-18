#!/usr/bin/env bash
# measure/runners/sx_study9_run.sh -- preregistrations/PREREGISTRATION_09.md: the ninth
# registration, re-made by measuring alone. The rotations through SuperDex's quaternion (sx_contact rotvec), two free
# cubes after they part from the solver's own trace (sx_contact flight, ends), both contact suites with and without
# the correction (sx_contact_suite.sh, sx_contact stop, pair, accel, suite2), the identity of everything with the
# patch off, the benchmark with the correction (the rig's stats, plain subtraction by sx_settings3), then the
# registered rules (sx_contact study9).
# usage: sx_study9_run.sh <public record root> <counts out file> <out file>
#        (sx_contact and sx_settings3 built beside this script)
#   Read under the root: rotation/ (the public rig's tools/plays/play_09.sh rotvec and flight);
#   validation/run_021_rotation/ (runs/s1/<configuration>/ and runs/s2/<configuration>/ for off, rec, stock_e and
#   rec_e; identity.txt; joints_identity_off.txt; joints_identity_patched.txt; stats_<scene>.txt);
#   validation/run_017_counts/runs/ (the seventh registration's stock and rec_new); streams/09/ and, to compare with,
#   streams/03/, streams/05/ and streams/08/; validation/run_013_counts/ and validation/run_007_counts/ for stock's status.
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R="${1:?usage: sx_study9_run.sh <public record root> <counts out file> <out file>}"; C="${2:?counts out file}"; OUT="${3:?out file}"
B="$HERE/sx_contact"
RO="$R/rotation"; V="$R/validation/run_021_rotation"; S="$V/runs"; S7="$R/validation/run_017_counts/runs"; D="$R/streams/09"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s9.XXXXXX")"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the measure's LAST line
  local label="$1"; shift
  local lines; lines="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> "$OUT"; echo "$lines" | tail -1
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
stops() { awk '{ for (i=1;i<=NF;i++) if ($i=="stopped") s+=$(i+1) } END { printf "%d", s }' "$1/stats.txt"; }
ident() {  # ident <registered dir> <replayed dir>: files of the first that are byte-identical in the second, and how many
  local same=0 diff=0 x
  for x in "$1"/*_[0-9]*.txt; do if cmp -s "$x" "$2/$(basename "$x")"; then same=$((same + 1)); else diff=$((diff + 1)); fi; done
  echo "$same $((same + diff))"
}
add2() { echo "$(( $1 + $3 )) $(( $2 + $4 ))"; }
bigger() { if [ "$1" -gt "$2" ]; then echo "$1"; else echo "$2"; fi; }

# ---- E0: safe when off ----
if cmp -s "$RO/rotvec_stock.txt" "$RO/rotvec_off.txt"; then rv="1 1"; else rv="0 1"; fi
fs=0; fn=0
for k in 1 4 16 64; do for c in a b; do fn=$((fn + 1)); cmp -s "$RO/flight_stock_${k}_$c.txt" "$RO/flight_off_${k}_$c.txt" && fs=$((fs + 1)); done; done
# shellcheck disable=SC2046
so="$(add2 $(ident "$S7/s1/stock" "$S/s1/off") $(ident "$S7/s2/stock" "$S/s2/off"))"
# shellcheck disable=SC2046
sr="$(add2 $(ident "$S7/s1/rec_new" "$S/s1/rec") $(ident "$S7/s2/rec_new" "$S/s2/rec"))"
ji="$(awk '{print $(NF-2)}' "$V/joints_identity_off.txt")"; jo="$(awk '{print $NF}' "$V/joints_identity_off.txt")"
bi="$(grep '^IDENTITY benchmark' "$V/identity.txt" | awk '{print $3}')"; bo="$(grep '^IDENTITY benchmark' "$V/identity.txt" | awk '{print $5}')"
echo "identity | rotations $rv ; flight $fs $fn ; suites against stock $so ; suites under the recommended configuration $sr ; one-joint $ji $jo ; benchmark $bi $bo" >> "$OUT"
echo "identity | one-joint files with the correction switched on: $(cat "$V/joints_identity_patched.txt")" >> "$OUT"

# ---- E1, E2: the function ----
ls_="$(m "rotations, stock" rotvec "$RO/rotvec_stock.txt" 1)"; lp="$(m "rotations, corrected" rotvec "$RO/rotvec_patched.txt" 1)"
e1="$(f "$ls_" 10) $(f "$ls_" 12) $(f "$ls_" 15) $(f "$ls_" 17) $(f "$ls_" 23)"
e2="$(f "$lp" 10) $(f "$lp" 12) $(f "$lp" 15) $(f "$lp" 17)"

# ---- E3, E4, E5: two free cubes after they part ----
for cfg in stock off patched; do for k in 1 4 16 64; do
  line="$(m "flight $cfg 1/$k" flight "$RO/flight_${cfg}_${k}_a.txt" "$RO/flight_${cfg}_$k.tr" 200)"
  [ "$cfg" = stock ] && [ "$k" = 64 ] && e3="$(f "$line" 7) $(f "$line" 13) $(f "$line" 19) $(f "$line" 27)"
  [ "$cfg" = patched ] && e4="${e4:-} $(f "$line" 7) $(f "$line" 11) $(f "$line" 19)"
done; done
e5=""
for k in 1 4 16 64; do
  la="$(m "ends A 1/$k" ends "$RO/flight_stock_${k}_a.txt" "$RO/flight_patched_${k}_a.txt")"; lb="$(m "ends B 1/$k" ends "$RO/flight_stock_${k}_b.txt" "$RO/flight_patched_${k}_b.txt")"
  e5="$e5 $(bigger "$(f "$la" 5)" "$(f "$lb" 5)") $(bigger "$(f "$la" 7)" "$(f "$lb" 7)")"
done

# ---- E6: both suites, with and without the correction (the seventh registration's cubes) ----
export SUITE_MU10K=3500 SUITE_SLIPMN=4234
code1() {  # code1 <label> <suite dir>: the first suite's code
  bash "$HERE/sx_contact_suite.sh" "$2" "$P/suite1_$1.txt" || { echo "measuring the first suite incomplete: $1" >&2; bad=1; }
  sed "s/^/first suite, $1 | /" "$P/suite1_$1.txt" >> "$OUT"
  grep '^T[01][0-9]' "$P/suite1_$1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n'
}
code2() {  # code2 <label> <second suite dir>: the second suite's code (T11 to T17)
  local l="$1" d="$2" speeds="" back="" pairs="" line run k
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
  line="$(m "second suite, $l" suite2 $speeds $back $pairs 39200 5880 2929 6174 3920)"
  f "$line" 17
}
c1a="$(code1 "stock" "$S7/s1/stock")"; c1b="$(code1 "stock with the correction" "$S/s1/stock_e")"
c1c="$(code1 "recommended" "$S7/s1/rec_new")"; c1d="$(code1 "recommended with the correction" "$S/s1/rec_e")"
c2a="$(code2 "stock" "$S7/s2/stock")"; c2b="$(code2 "stock with the correction" "$S/s2/stock_e")"
c2c="$(code2 "recommended" "$S7/s2/rec_new")"; c2d="$(code2 "recommended with the correction" "$S/s2/rec_e")"

# ---- E7: the solver on the suites ----
e7="$(stops "$S7/s1/stock") $(stops "$S/s1/stock_e") $(stops "$S7/s1/rec_new") $(stops "$S/s1/rec_e") $(stops "$S7/s2/stock") $(stops "$S/s2/stock_e") $(stops "$S7/s2/rec_new") $(stops "$S/s2/rec_e")"
echo "solver on the suites | steps stopped: first suite stock, with the correction, recommended, with the correction; then the second suite: $e7" >> "$OUT"
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi

# ---- E8 and the decision: the benchmark ----
field() { grep "^STATS source $2 " "$1" | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}'; }
e8=""; for sc in half_cheetah ant cart_pole; do e8="$e8 $(field "$V/stats_$sc.txt" e1 stopped) $(field "$V/stats_$sc.txt" e1 diverged)"; done
e8="$e8 $(field "$R/validation/run_013_counts/stats_half_cheetah.txt" sref stopped) $(field "$R/validation/run_013_counts/stats_ant.txt" sref stopped) $(field "$R/validation/run_007_counts/stats_cart_pole.txt" sref stopped)"
for sc in half_cheetah ant cart_pole; do echo "benchmark | $sc e1 steps $(field "$V/stats_$sc.txt" e1 solver_steps) stopped $(field "$V/stats_$sc.txt" e1 stopped) diverged $(field "$V/stats_$sc.txt" e1 diverged) most_iterations $(field "$V/stats_$sc.txt" e1 most_iterations)" >> "$OUT"; done
: > "$C"
for sc in half_cheetah ant; do
  echo "=== $sc, the fifth registration's commands: the recommended configuration with the rotation correction added (y1 .. y16)" >> "$C"
  "$HERE/sx_settings3" time "$D" $sc 108 200 y1 y2 y4 y8 y16 >> "$C" || true
  "$HERE/sx_settings3" plain "$D" $sc 108 200 chain Y y1 y2 y4 y8 y16 >> "$C" || true
done
grep '^PLAIN' "$C" | sed 's/^/benchmark | /' >> "$OUT"
hy="$(grep '^PLAIN half_cheetah Y folds_in_order' "$C" | awk '{print $5}')"; ay="$(grep '^PLAIN ant Y folds_in_order' "$C" | awk '{print $5}')"
dvg=0; for sc in half_cheetah ant; do for k in 1 2 4 8 16; do dvg=$((dvg + $(field "$V/stats_$sc.txt" y$k diverged))); echo "benchmark | $sc y$k steps $(field "$V/stats_$sc.txt" y$k solver_steps) stopped $(field "$V/stats_$sc.txt" y$k stopped) diverged $(field "$V/stats_$sc.txt" y$k diverged) most_iterations $(field "$V/stats_$sc.txt" y$k most_iterations)" >> "$OUT"; done; done
ie=0
cmp -s "$D/half_cheetah/e1_enc.pcm" "$R/streams/05/half_cheetah/sref_enc.pcm" && ie=$((ie + 1))
cmp -s "$D/ant/e1_enc.pcm" "$R/streams/05/ant/sref_enc.pcm" && ie=$((ie + 1))
cmp -s "$D/cart_pole/e1_enc.pcm" "$R/streams/03/cart_pole/sref_enc.pcm" && ie=$((ie + 1))
iy=0; for sc in half_cheetah ant; do for k in 1 2 4 8 16; do cmp -s "$D/$sc/y${k}_enc.pcm" "$R/streams/08/$sc/z${k}_enc.pcm" && iy=$((iy + 1)); done; done

# shellcheck disable=SC2086
"$B" study9 $rv "$fs" "$fn" $so $sr "$ji" "$jo" "$bi" "$bo" $e1 $e2 $e3 $e4 $e5 "$c1a" "$c1b" "$c1c" "$c1d" "$c2a" "$c2b" "$c2c" "$c2d" $e7 $e8 "$hy" "$ay" "$dvg" "$ie" "$iy" >> "$OUT"
[ $? -eq 42 ] || exit 1   # a Simplex program exits 42 when it ran
exit 0
