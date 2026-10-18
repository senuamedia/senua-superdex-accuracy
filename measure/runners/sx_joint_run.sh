#!/usr/bin/env bash
# measure/runners/sx_joint_run.sh -- preregistrations/PREREGISTRATION_06.md: every registered
# measurement on the smallest jointed scene (the public rig's runs, joints/<test>_<setting>_<k>.txt, and its
# stats.txt for the solver's own status), then the registered rules (sx_contact joints).
# usage: sx_joint_run.sh <joints dir> <stats file> <out file>      (sx_contact built beside this script)
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_joint_run.sh <joints dir> <stats file> <out file>}"; ST="${2:?stats file}"; OUT="${3:?out file}"
B="$HERE/sx_contact"
: > "$OUT"
bad=0
m() {  # m <label> <measure> <file>: one measured line, labelled; echoes the line
  local label="$1"; shift
  local line; line="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$label | $line" >> "$OUT"; echo "$line"
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
stopped() { grep "^STATS run $1 " "$ST" | awk '{for(i=1;i<=NF;i++) if ($i=="stopped") print $(i+1)}'; }
for k in 1 4 16 64; do
  l="$(m "spin backward Euler 1/$k" final "$D/spin_be_$k.txt")"; [ $k = 1 ] && s1="$(f "$l" 7)"; [ $k = 64 ] && s64="$(f "$l" 7)"
  l="$(m "torque backward Euler 1/$k" final "$D/torque_be_$k.txt")"; [ $k = 1 ] && t1="$(f "$l" 7)"; [ $k = 64 ] && t64="$(f "$l" 7)"
  l="$(m "swing backward Euler 1/$k" swing "$D/swing_be_$k.txt")"; [ $k = 1 ] && g1="$(f "$l" 9)"; [ $k = 64 ] && g64="$(f "$l" 9)"
done
for integ in bdf2 dirk33; do
  m "spin $integ 1/1 (reported)" final "$D/spin_${integ}_1.txt" > /dev/null
  m "torque $integ 1/1 (reported)" final "$D/torque_${integ}_1.txt" > /dev/null
  m "swing $integ 1/1 (reported)" swing "$D/swing_${integ}_1.txt" > /dev/null
done
for w in 1 2 4 8; do m "spin released at $w rad/s, shipped step (reported)" final "$D/spinrate${w}_1.txt" > /dev/null; done
h1="$(f "$(m "hold shipped falloff 1/1" creep "$D/hold_shipped_1.txt")" 7)"; h16="$(f "$(m "hold shipped falloff 1/16" creep "$D/hold_shipped_16.txt")" 7)"
ht1="$(f "$(m "hold falloff 1e-6 1/1" creep "$D/hold_tight_1.txt")" 7)"; ht16="$(f "$(m "hold falloff 1e-6 1/16" creep "$D/hold_tight_16.txt")" 7)"
p1="$(f "$(m "slip shipped falloff 1/1" final "$D/slip_shipped_1.txt")" 7)"; p16="$(f "$(m "slip shipped falloff 1/16" final "$D/slip_shipped_16.txt")" 7)"
pt1="$(f "$(m "slip falloff 1e-6 1/1" final "$D/slip_tight_1.txt")" 7)"; pt16="$(f "$(m "slip falloff 1e-6 1/16" final "$D/slip_tight_16.txt")" 7)"
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi
"$B" joints 3000000 4656457 411 3104308 "$s1" "$s64" "$t1" "$t64" "$g1" "$g64" "$h1" "$h16" "$ht1" "$ht16" "$(stopped hold_tight_1)" "$(stopped hold_tight_16)" "$p1" "$p16" "$pt1" "$pt16" >> "$OUT"
[ $? -eq 42 ] || exit 1
exit 0
