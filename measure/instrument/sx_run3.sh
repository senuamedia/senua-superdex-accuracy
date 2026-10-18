#!/usr/bin/env bash
# measure/instrument/sx_run3.sh -- stage 2 of preregistrations/PREREGISTRATION_03.md: the
# instrument, once, beside plain subtraction on the same gaps. Ten processes (one list of one scene each), three at a
# time, then the pooled verdict. Each process draws its own slot of the one noise sequence (slots 18 to 27).
# usage: sx_run3.sh <streams dir> <bar> <stage 1 all held: 0 or 1> <out file>   (sx_settings3 built beside this script)
# exit 0 = every list ran and the verdict was written (PASS or FAIL is in the file's last line)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_run3.sh <streams dir> <bar> <stage 1 held> <out file>}"; BAR="${2:?bar}"; ST1="${3:?stage 1 held}"; OUT="${4:?out file}"
B="$HERE/sx_settings3"; EP=108; RD=200
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_run3.XXXXXX")"
trap 'rm -rf "$P"' EXIT
T="sref t2 t4 t8 t16 t32 t64"; G="g1 g2 g4 g8 g16"; C="c10 sref c2 c1 c06 c03"; S="s1 s2 s4 s8 s16 sref"
one() {  # one <slot> <scene> <chain|ladder> <label> <sources...>
  local slot="$1" sc="$2" kind="$3" label="$4"; shift 4
  ( "$B" read "$D" "$sc" $EP $RD "$BAR" "$slot" "$kind" "$label" "$@" > "$P/list_$slot.txt" 2> /dev/null; echo "$?" > "$P/list_$slot.rc" ) &
}
# shellcheck disable=SC2086
{
one 18 cart_pole chain T $T; one 19 cart_pole ladder S $S; one 20 half_cheetah chain T $T; wait
one 21 half_cheetah chain G $G; one 22 half_cheetah chain C $C; one 23 half_cheetah ladder S $S; wait
one 24 ant chain T $T; one 25 ant chain G $G; one 26 ant chain C $C; wait
one 27 ant ladder S $S; wait
}
ok=1; args=""
: > "$OUT"
for slot in 18 19 20 21 22 23 24 25 26 27; do
  f="$P/list_$slot.txt"; rc="$(cat "$P/list_$slot.rc" 2>/dev/null)"
  if [ "$rc" != 42 ]; then echo "list $slot exit $rc" >&2; ok=0; fi
  line="$(grep '^PART ' "$f" | tail -1)"
  if [ -z "$line" ]; then echo "list $slot has no PART line" >&2; ok=0; fi
  args="$args $(echo "$line" | awk '{print $5, $9, $11}')"
  cat "$f" >> "$OUT"
done
if [ $ok -ne 1 ]; then echo "stage 2 incomplete" >&2; exit 1; fi
# shellcheck disable=SC2086
"$B" verdict2 "$ST1" $args >> "$OUT"
[ $? -eq 42 ] || exit 1   # a Simplex program exits 42 when it ran
exit 0
