#!/usr/bin/env bash
# measure/runners/sx_link.sh -- the benchmark link of preregistrations/PREREGISTRATION_04.md
# (rule L1): half_cheetah and ant with contact damping 5 on the third registration's commands, each time-step chain by
# part of the episode and by plain subtraction. No instrument.
# usage: sx_link.sh <streams dir> <out file>      (sx_settings3 built beside this script)
# exit 0 = every line was written (the folds in order are the PLAIN lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_link.sh <streams dir> <out file>}"; OUT="${2:?out file}"
B="$HERE/sx_settings3"; EP=108; RD=200
: > "$OUT"
bad=0
run() { "$B" "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }; }   # a Simplex program exits 42 when it ran
for sc in half_cheetah ant; do
  echo "=== $sc, contact damping 5, the third registration's commands" >> "$OUT"
  if [ $sc = ant ]; then all="d1 d2 d4 d8 d16 d32 d64"; else all="d1 d2 d4 d8 d16 d32"; fi
  # shellcheck disable=SC2086
  run time "$D" $sc $EP $RD $all
  run plain "$D" $sc $EP $RD chain D5 d1 d2 d4 d8 d16
  # shellcheck disable=SC2086
  run plain "$D" $sc $EP $RD chain D $all
done
[ $bad -eq 0 ] || { echo "counting incomplete" >&2; exit 1; }
exit 0
