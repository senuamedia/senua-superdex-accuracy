#!/usr/bin/env bash
# measure/instrument/sx_count3.sh -- stage 1 of preregistrations/PREREGISTRATION_03.md: no
# instrument. For every scene: the reference against its repeat and against the nudge at zero (R1, the encoder
# streams); each nudged run against the reference (N1); every chain by part of the episode; plain subtraction and its
# order for every list; then the four stage 1 rules (sx_settings3 verdict1).
# usage: sx_count3.sh <streams dir> <state files identical, of 6> <out file>   (sx_settings3 built beside this script)
#   The state files are not kept with the streams; the rig's play script compares them when it plays
#   (identity_<scene>.txt in the public record) and the count is given here.
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_count3.sh <streams dir> <state files identical> <out file>}"; STATE="${2:?state files identical}"; OUT="${3:?out file}"
B="$HERE/sx_settings3"; EP=108; RD=200
: > "$OUT"
bad=0
run() { "$B" "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }; }   # a Simplex program exits 42 when it ran
for sc in cart_pole half_cheetah ant; do
  echo "=== $sc" >> "$OUT"
  run same "$D" $sc $EP $RD sref srefb
  run same "$D" $sc $EP $RD sref z
  for n in n9 n6 n3 n0; do run time "$D" $sc $EP $RD sref $n; done
  run time "$D" $sc $EP $RD sref t2 t4 t8 t16 t32 t64
  run plain "$D" $sc $EP $RD chain T4 sref t2 t4 t8 t16
  run plain "$D" $sc $EP $RD chain T sref t2 t4 t8 t16 t32 t64
  for s in s1 s2 s4 s8 s16; do run time "$D" $sc $EP $RD $s sref; done
  run plain "$D" $sc $EP $RD ladder S s1 s2 s4 s8 s16 sref
  if [ $sc != cart_pole ]; then
    run time "$D" $sc $EP $RD g1 g2 g4 g8 g16
    run plain "$D" $sc $EP $RD chain G g1 g2 g4 g8 g16
    run time "$D" $sc $EP $RD m1 m2 m4 m8 m16
    run plain "$D" $sc $EP $RD chain M m1 m2 m4 m8 m16
    run time "$D" $sc $EP $RD c10 sref c2 c1 c06 c03
    run plain "$D" $sc $EP $RD chain C c10 sref c2 c1 c06 c03
  fi
done
if [ $bad -ne 0 ]; then echo "stage 1 incomplete" >&2; exit 1; fi
same="$(grep -c '^SAME .* identical 1$' "$OUT")"
ord() { grep "^PLAIN $1 $2 folds_in_order " "$OUT" | awk '{print $5}'; }
never() { grep "^PARTING $1 sref against $2 " "$OUT" | awk '{print $11}'; }
"$B" verdict1 "$same" "$STATE" 6 "$(ord cart_pole T4)" "$(ord half_cheetah G)" "$(ord ant G)" "$(ord half_cheetah T4)" $EP \
  "$(never cart_pole n9)" "$(never half_cheetah n9)" "$(never ant n9)" "$(never cart_pole n6)" "$(never half_cheetah n6)" "$(never ant n6)" >> "$OUT"
[ $? -eq 42 ] || exit 1
exit 0
