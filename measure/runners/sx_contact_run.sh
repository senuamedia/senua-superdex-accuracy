#!/usr/bin/env bash
# measure/runners/sx_contact_run.sh -- preregistrations/PREREGISTRATION_04.md: every registered
# measurement on the smallest contact scene (the public rig's runs, contact/<test>_<setting>_<k>.txt), then the
# registered rules (sx_contact verdict). The benchmark link (L1) is measured by sx_settings3 plain on the registered
# streams; its four numbers are given here.
# usage: sx_contact_run.sh <contact dir> <half_cheetah shipped folds in order> <half_cheetah damped> <ant shipped>
#        <ant damped> <out file>      (sx_contact built beside this script)
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_contact_run.sh <contact dir> <hc shipped> <hc damped> <ant shipped> <ant damped> <out file>}"
HS="${2:?}"; HD="${3:?}"; AS="${4:?}"; AD="${5:?}"; OUT="${6:?out file}"
B="$HERE/sx_contact"; BASE=10000000
: > "$OUT"
bad=0
m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the line
  local label="$1"; shift
  local line; line="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$label | $line" >> "$OUT"; echo "$line"
}
f() { echo "$1" | awk -v n="$2" '{print $n}'; }
ks="1 2 4 8 16 32 64"
reb=""; for k in $ks; do reb="$reb $(f "$(m "drop shipped 1/$k" bounce "$D/drop_shipped_$k.txt")" 13)"; done
for k in $ks; do l="$(m "drop third-order 1/$k" bounce "$D/drop_dirk33_$k.txt")"; [ $k = 64 ] && rh="$(f "$l" 13)"; done
for k in $ks; do m "drop damped 1/$k" bounce "$D/drop_damped_$k.txt" > /dev/null; done
slidemin=""
l="$(m "oblique shipped 1/1" impact "$D/oblique_shipped_1.txt")"; s0="$(f "$l" 11)"; slidemin="$(f "$l" 15)"
for k in 2 4 8 16 32 64; do m "oblique shipped 1/$k" impact "$D/oblique_shipped_$k.txt" > /dev/null; done
imp=""; for k in $ks; do l="$(m "oblique implicit 1/$k" impact "$D/oblique_implicit_$k.txt")"; imp="$imp $(f "$l" 11)"; v="$(f "$l" 15)"; [ "$v" -lt "$slidemin" ] && slidemin="$v"; done
for s in damped dampedimplicit; do for k in $ks; do m "oblique $s 1/$k (reported)" impact "$D/oblique_${s}_$k.txt" > /dev/null; done; done
sl="$(f "$(m "slide shipped 1/1" creep "$D/slide_shipped_1.txt")" 9) $(f "$(m "slide shipped 1/16" creep "$D/slide_shipped_16.txt")" 9)"
cr=""; for s in shipped cinf implicit expnormals nofade armijo falloff001 viscous100; do cr="$cr $(f "$(m "creep $s" creep "$D/creep_${s}_1.txt")" 7)"; done
chain() { local s="$1" out=""; for k in 1 2 4 8 16 32; do out="$out $(f "$(m "chain $s 1/$k against 1/$((k*2))" gap $BASE "$D/chain_${s}_$k.txt" "$D/chain_${s}_$((k*2)).txt")" 12)"; done; echo "$out"; }
gf="$(chain freefall)"; gs="$(chain shipped)"; gd="$(chain damped)"
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; exit 1; fi
# shellcheck disable=SC2086
"$B" verdict 4000 3675 3750 $gf $sl $reb $rh $s0 $imp $slidemin $cr $gs $gd "$HS" "$HD" "$AS" "$AD" >> "$OUT"
[ $? -eq 42 ] || exit 1
exit 0
