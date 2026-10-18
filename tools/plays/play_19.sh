#!/usr/bin/env bash
# The nineteenth registration's plays (preregistrations/PREREGISTRATION_19.md): the two corrections of library build
# 15 that no earlier rig played, on the Linux machine of runs 039 to 042, with stock, library build 14 and library
# build 15 in 64-bit (run 039's and run 042's builds). The rigs are run 042's, and are checked against its checksums
# (validation/run_042_two_corrections/rigs4.sha256) before anything plays.
# usage: bash tools/plays/play_19.sh <work folder of run 039 step 1> <out folder>   (from the repository root)
#   writes <out>/identity.txt, exit.txt, soft.txt, played.txt and runs/; the measuring is measure/runners/sx_study19_run.sh
set -u
WD="$(cd "${1:?usage: play_19.sh <work folder> <out folder>}" && pwd)"; O="${2:?out folder}"; mkdir -p "$O/runs"
R=$O/runs
# the registered rigs
sha256sum -c --quiet <(grep -E 'tools/sdx_(contact64|contact64_stock|contact64_b14|exit)$' \
  validation/run_042_two_corrections/rigs4.sha256) > "$O/rigs_check.txt" 2>&1 || { echo "the rigs are not run 042's" >&2; exit 2; }
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
clear_sw() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
  SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
date -u +%FT%TZ > "$O/started.txt"
: > "$O/played.txt"

# S0: the contact rig with no new setting against the registered suites (stock, off, A to D, A to E; both suites)
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
conf() { local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    RIG="$PWD/tools/sdx_contact64$suf" tools/contact_suite.sh "s19_$label" "$@" &&
    RIG="$PWD/tools/sdx_contact64$suf" RIGPAIR="$PWD/tools/sdx_pair64$suf" tools/contact_suite2.sh "s19_$label" "$@" ) > /dev/null 2>&1
  echo "PLAYED identity $label rc $?" >> "$O/played.txt"; }
conf stock _stock - & conf off "" - & conf abcd "" "$AB $CD" ndamp=5 falloff=0.03 & conf abcde "" "$AB $CD $E" ndamp=5 falloff=0.03 &
wait
same() { local s=0 n=0 x; for x in "$2"/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$x" "$3/$(basename "$x")" && s=$((s + 1)); done; echo "$1 $s of $n"; }
S7=validation/run_017_counts/runs; S9=validation/run_021_rotation/runs
{ for s in 1 2; do
    same "suite $s stock against registered:" $S7/s$s/stock suites/$s/s19_stock
    same "suite $s off against registered stock:" $S7/s$s/stock suites/$s/s19_off
    same "suite $s A to D against registered:" $S7/s$s/rec_new suites/$s/s19_abcd
    same "suite $s A to E against registered:" $S9/s$s/rec_e suites/$s/s19_abcde
  done; } > "$O/identity.txt"
unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP

# L: the library loaded with dlopen after the exit handler, the scene destroyed in that handler, 25 steps
: > "$O/exit.txt"
for lib in stock b14 b15; do for sw in off abcd; do
  case $lib in stock) L=$WD/build-stock ;; b14) L=$WD/build-patched14 ;; b15) L=$WD/build-patched ;; esac
  [ $lib = stock ] && [ $sw = abcd ] && continue
  ( clear_sw; [ $sw = abcd ] && for kv in $AB $CD; do export "$kv"; done
    valgrind --tool=memcheck --error-exitcode=99 --log-file=$R/valgrind_${lib}_$sw.txt tools/sdx_exit \
      $L/bin/libmochi_physics_double.so 25 > $R/exit_${lib}_$sw.out 2>&1
    rc=$?
    echo "$lib $sw exit $rc $(grep -o 'ERROR SUMMARY: [0-9]* errors' $R/valgrind_${lib}_$sw.txt) destroyed $(grep -c 'sdx_exit: destroyed' $R/exit_${lib}_$sw.out) invalid_in_ClearFrictionAnchors $(grep -A1 'Invalid \(read\|write\)' $R/valgrind_${lib}_$sw.txt | grep -c 'ClearFrictionAnchors')" >> "$O/exit.txt" )
done; done

# M: the hop on the soft block held along its bottom, fresh numbers: a cube of 1.1 kg and half-size 0.04 m, friction
# 0.4, dropped 6 cm with a sideways speed of 1.5 cm/s, at steps 1, 1/4, 1/16, 1/32 and 1/64 of 10 ms
CUBE="mass=1.1 radius=0.04"
hop() { local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    for k in 1 4 16 32 64; do
      dt=$(awk -v k=$k 'BEGIN { printf "%.10g", 0.01 / k }')
      # shellcheck disable=SC2086
      tools/sdx_contact64$suf $R/hop_${label}_$k.txt dt=$dt secs=1 h0=0.06 vx0=0.015 mu=0.4 $CUBE floor=soft softhold=bottom "$@" >> $R/hop_${label}.stats 2>&1
    done )
  echo "PLAYED hop $label rc $?" >> "$O/played.txt"; }
hop stock _stock - & hop b15_off "" - &
hop b14_c _b14 "$CD" & hop b15_c "" "$CD" &
hop b14_abcd _b14 "$AB $CD" falloff=0.03 & hop b15_abcd "" "$AB $CD" falloff=0.03 &
wait
{ for k in 1 4 16 32 64; do
    if cmp -s $R/hop_stock_$k.txt $R/hop_b15_off_$k.txt; then echo "SAME off_against_stock $k"; else echo "DIFFERS off_against_stock $k"; fi
    for c in c abcd; do
      if cmp -s $R/hop_b14_${c}_$k.txt $R/hop_b15_${c}_$k.txt; then echo "SAME 14_against_15 $c $k"; else echo "DIFFERS 14_against_15 $c $k $(cmp $R/hop_b14_${c}_$k.txt $R/hop_b15_${c}_$k.txt | sed 's/.*differ: //')"; fi
    done
  done; } > "$O/soft.txt"
date -u +%FT%TZ > "$O/finished.txt"
