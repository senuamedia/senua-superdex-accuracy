#!/usr/bin/env bash
# The twentieth registration (preregistrations/PREREGISTRATION_20.md), re-made by measuring alone. The first suite by
# sx_contact_suite.sh (the ten tests and their pass lines), the second by sx_contact stop, pair and accel and its
# tests T11 to T17 (sx_contact suite2, the seventh registration's pass lines), and every rule by sx_contact rule.
# usage: sx_study20_run.sh <suites root, holding 1/ and 2/> <out folder of play_20.sh> <out file>
#        (sx_contact and sx_contact_suite.sh beside this script)
# exit 0 = every line was written (what held is in the RULE lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SR="${1:?usage: sx_study20_run.sh <suites root> <out folder> <out file>}"; D="${2:?out folder}"; OUT="${3:?out file}"
B="$HERE/sx_contact"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s20.XXXXXX")"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0
m() { local label="$1"; shift
  local line; line="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }
  echo "$label | $line" >> "$OUT"; echo "$line"; }
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
# the fresh cubes' friction and slip push for the first suite
export SUITE_MU10K=4000 SUITE_SLIPMN=6468
code1() {  # code1 <label>: the first suite's ten verdicts, 1 or 0 each, as one string
  bash "$HERE/sx_contact_suite.sh" "$SR/1/$1" "$P/suite1_$1.txt" || { echo "measuring the first suite incomplete: $1" >&2; bad=1; }
  sed "s/^/first suite, $1 | /" "$P/suite1_$1.txt" >> "$OUT"
  grep '^T[01][0-9]' "$P/suite1_$1.txt" | sed -E 's/^T[01][0-9].* : (PASS|FAIL)$/\1/' | sed 's/PASS/1/; s/FAIL/0/' | tr -d '\n'
}
# the second suite's answers: weight on the block and on the cube (mN), the shipped law's creep (not read by T11 to
# T17, given as 0), the slip of the block and of the cube (mm/s2)
code2() {  # code2 <label>: the second suite's tests T11 to T17, as sx_contact suite2 prints them (its 17th field)
  local l="$1" d="$SR/2/$1" speeds="" back="" pairs="" line run k
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
  line="$(m "second suite, $l" suite2 $speeds $back $pairs 34300 6860 0 5488 3430)"
  f "$line" 17
}
c32s=$(code1 s20_32_stock); c32o=$(code1 s20_32_off); c32f=$(code1 s20_32_final); c64s=$(code1 s20_64_stock); c64f=$(code1 s20_64_final)
k32s=$(code2 s20_32_stock); k32f=$(code2 s20_32_final); k64s=$(code2 s20_64_stock); k64f=$(code2 s20_64_final)
echo "codes | first suite T01..T10: 32 stock $c32s, 32 off $c32o, 32 final $c32f, 64 stock $c64s, 64 final $c64f; second suite T11..T17: 32 stock $k32s, 32 final $k32f, 64 stock $k64s, 64 final $k64f" >> "$OUT"
digit() { echo "$1" | cut -c"$2"; }
same() { local s=0 n=0 x; for x in "$1"/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$x" "$2/$(basename "$x")" && s=$((s + 1)); done; echo "$s $n"; }
sed 's/^/identity | /' "$D/identity.txt" >> "$OUT"
# S0: the 32-bit rigs make run 041's 32-bit plays again
s0=$(awk '{ s += $(NF-2); n += $NF } END { print s + 0, n + 0 }' "$D/identity.txt")
m "S0" rule S0 eq $s0 > /dev/null
# Z0: 32-bit patched with no switch against 32-bit stock, both suites, every file
z0a=$(same "$SR/1/s20_32_stock" "$SR/1/s20_32_off"); z0b=$(same "$SR/2/s20_32_stock" "$SR/2/s20_32_off")
m "Z0" rule Z0_suite1 eq $z0a > /dev/null
m "Z0" rule Z0_suite2 eq $z0b > /dev/null
# Z1: 32-bit, final configuration: all ten tests of the first suite
m "Z1" rule Z1 all_eq 1 $(echo "$c32f" | sed 's/./& /g') > /dev/null
# Z2: 32-bit, final configuration: T02 to T07, T09 and T10
m "Z2" rule Z2 all_eq 1 $(digit "$c32f" 2) $(digit "$c32f" 3) $(digit "$c32f" 4) $(digit "$c32f" 5) $(digit "$c32f" 6) $(digit "$c32f" 7) $(digit "$c32f" 9) $(digit "$c32f" 10) > /dev/null
# Z3: free flight in 32-bit: T01's reading under the final configuration is stock's, gap by gap (the five ratios)
t01() { grep '^T01' "$P/suite1_$1.txt" | sed -E 's/^.*\): ([-0-9 ]+) : (PASS|FAIL)$/\1/'; }
set -- $(t01 s20_32_stock); a1=$1; a2=$2; a3=$3; a4=$4; a5=$5
set -- $(t01 s20_32_final)
m "Z3" rule Z3_gap1 eq "$a1" "$1" > /dev/null; m "Z3" rule Z3_gap2 eq "$a2" "$2" > /dev/null
m "Z3" rule Z3_gap3 eq "$a3" "$3" > /dev/null; m "Z3" rule Z3_gap4 eq "$a4" "$4" > /dev/null
m "Z3" rule Z3_gap5 eq "$a5" "$5" > /dev/null
# Z4: 32-bit, final configuration: T11 to T17
m "Z4" rule Z4 eq "$k32f" 1111111 > /dev/null
# Z5: the 64-bit control on the fresh cubes, final configuration: all ten, and T11 to T17
m "Z5" rule Z5_first all_eq 1 $(echo "$c64f" | sed 's/./& /g') > /dev/null
m "Z5" rule Z5_second eq "$k64f" 1111111 > /dev/null
[ $bad -eq 0 ] || exit 1
exit 0
