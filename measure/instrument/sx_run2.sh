#!/usr/bin/env bash
# measure/instrument/sx_run2.sh -- stage 2 of preregistrations/PREREGISTRATION_02.md: the
# instrument, once, as twelve processes (three scenes by four parts), three at a time, then the pooled verdict.
# Each process draws its own slot of the one noise sequence.
# usage: sx_run2.sh <streams dir> <bar> <out file>      (sx_settings2 must be built beside this script)
# exit 0 = every part ran and the verdict was written (PASS or FAIL is in the file's last line)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STREAMS="${1:?usage: sx_run2.sh <streams dir> <bar> <out file>}"; BAR="${2:?bar}"; OUT="${3:?out file}"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_run2.XXXXXX")"
trap 'rm -rf "$P"' EXIT
for round in "0:0 0:1 0:2" "0:3 1:0 1:1" "1:2 1:3 2:0" "2:1 2:2 2:3"; do
  for sp in $round; do
    sc="${sp%%:*}"; pt="${sp##*:}"
    ( "$HERE/sx_settings2" run "$STREAMS" 108 200 "$BAR" "$sc" "$pt" > "$P/part_${sc}_${pt}.txt" 2> /dev/null; echo "$?" > "$P/part_${sc}_${pt}.rc" ) &
  done
  wait
done
ok=1; args=""
: > "$OUT"
for sc in 0 1 2; do for pt in 0 1 2 3; do
  f="$P/part_${sc}_${pt}.txt"; rc="$(cat "$P/part_${sc}_${pt}.rc" 2>/dev/null)"
  if [ "$rc" != 42 ]; then echo "part $sc $pt exit $rc" >&2; ok=0; fi
  line="$(grep '^PART ' "$f" | tail -1)"
  if [ -z "$line" ]; then echo "part $sc $pt has no PART line" >&2; ok=0; fi
  args="$args $(echo "$line" | awk '{print $6, $8, $10}')"
  cat "$f" >> "$OUT"
done; done
if [ $ok -ne 1 ]; then echo "stage 2 incomplete" >&2; exit 1; fi
# shellcheck disable=SC2086
"$HERE/sx_settings2" verdict $args >> "$OUT"
[ $? -eq 42 ] || exit 1   # a Simplex program exits 42 when it ran
exit 0
