#!/usr/bin/env bash
# Run 042, step 3, after steps 1 and 2 reached neither defect. Two plays that should reach them:
#   a. exitscene=2: the scene destroyed from a destructor function, which runs at exit after every static object's
#      destructor, the library's own included (build 14's anchor table is a library global), under valgrind's memcheck
#      on stock, build 14 and build 15, with no switch and with patches A to D;
#   b. a hop on the soft block: a cube dropped 5 cm with a sideways speed of 2 cm/s and no added contact damping, so
#      that it bounces and lands again within 5 mm of where it first touched, at steps 1, 1/4, 1/16 and 1/64, under
#      patch C alone (the stick distance and its damped stick) and under patches A to D without contact damping, on
#      builds 14 and 15 and on stock; build 14 against build 15 file by file. A sample the map missed on landing again
#      still has its anchor from the first touch: build 14 gives it that anchor, build 15 none.
# The rig gains exitscene=2 for this step; it is rebuilt against the three libraries and checked again against the
# registered suites with neither new setting. Not registered: a design probe.
# usage: probe3.sh <work folder of run 039 step 1>   (from the root of the copy of this repository run 040 played in)
set -u
WD="$(cd "${1:?usage: probe3.sh <work folder>}" && pwd)"
O=validation/run_042_two_corrections; R3=$O/runs3; mkdir -p $R3
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
rig() { SUPERDEX_SRC=$WD/$4 SUPERDEX_BUILD=$WD/$3 SRC=$1 OUT=$2 LIB=mochi_physics_double tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $2"; }
rig sdx_contact.cpp sdx_contact64 build-patched superdex-patched-src
rig sdx_contact.cpp sdx_contact64_stock build-stock superdex-src
rig sdx_contact.cpp sdx_contact64_b14 build-patched14 superdex-b14-src
sha256sum tools/sdx_contact.cpp tools/sdx_contact64 tools/sdx_contact64_stock tools/sdx_contact64_b14 > $O/rigs3.sha256
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
clear_sw() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
  SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
date -u +%FT%TZ > $O/started3.txt
# the rebuilt rig against the registered suites, as in step 1
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
conf() { local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    RIG="$PWD/tools/sdx_contact64$suf" tools/contact_suite.sh "r42c_$label" "$@" &&
    RIG="$PWD/tools/sdx_contact64$suf" RIGPAIR="$PWD/tools/sdx_pair64$suf" tools/contact_suite2.sh "r42c_$label" "$@" ) > /dev/null 2>&1
  echo "PLAYED identity3 $label rc $?" >> $O/played3.txt; }
conf stock _stock - & conf off "" - & conf abcd "" "$AB $CD" ndamp=5 falloff=0.03 & conf abcde "" "$AB $CD $E" ndamp=5 falloff=0.03 &
wait
same() { local s=0 n=0 x; for x in "$2"/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$x" "$3/$(basename "$x")" && s=$((s + 1)); done; echo "$1 $s of $n"; }
S7=validation/run_017_counts/runs; S9=validation/run_021_rotation/runs
{ for s in 1 2; do
    same "suite $s stock against registered:" $S7/s$s/stock suites/$s/r42c_stock
    same "suite $s off against registered stock:" $S7/s$s/stock suites/$s/r42c_off
    same "suite $s A to D against registered:" $S7/s$s/rec_new suites/$s/r42c_abcd
    same "suite $s A to E against registered:" $S9/s$s/rec_e suites/$s/r42c_abcde
  done; } > $O/identity3.txt
unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP
CUBE="mass=0.8 radius=0.035"
# a. exitscene=2 under valgrind
: > $O/exitscene2.txt
for lib in stock b14 b15; do for sw in off abcd; do
  suf=""; case $lib in stock) suf=_stock ;; b14) suf=_b14 ;; esac
  [ $lib = stock ] && [ $sw = abcd ] && continue
  ( clear_sw; [ $sw = abcd ] && for kv in $AB $CD; do export "$kv"; done
    # shellcheck disable=SC2086
    valgrind --tool=memcheck --error-exitcode=99 --log-file=$R3/valgrind2_${lib}_$sw.txt tools/sdx_contact64$suf \
      $R3/exit2_${lib}_$sw.txt dt=0.01 secs=0.1 h0=0 mu=0.35 $CUBE exitscene=2 > $R3/exit2_${lib}_$sw.out 2>&1
    echo "$lib $sw exit $? $(grep -o 'ERROR SUMMARY: [0-9]* errors' $R3/valgrind2_${lib}_$sw.txt)" >> $O/exitscene2.txt )
done; done
# b. the hop on the soft block
hop() {  # hop <label> <rig suffix> <switches or -> <rig settings...>
  local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    for k in 1 4 16 64; do
      dt=$(awk -v k=$k 'BEGIN { printf "%.10g", 0.01 / k }')
      # shellcheck disable=SC2086
      tools/sdx_contact64$suf $R3/hop_${label}_$k.txt dt=$dt secs=1 h0=0.05 vx0=0.02 mu=0.35 $CUBE floor=soft "$@" >> $R3/hop_${label}.stats 2>&1
    done )
  echo "PLAYED hop $label rc $?" >> $O/played3.txt; }
hop stock _stock - &
hop b14_c _b14 "$CD" & hop b15_c "" "$CD" &
hop b14_abcd _b14 "$AB $CD" falloff=0.03 & hop b15_abcd "" "$AB $CD" falloff=0.03 &
wait
{ for f in $R3/hop_b14_*_[0-9]*.txt; do b=$(basename "$f"); g=$R3/${b/b14_/b15_}; if cmp -s "$f" "$g"; then echo "SAME $b"; else echo "DIFFERS $b $(cmp "$f" "$g" | sed 's/.*differ: //')"; fi; done; } > $O/hop_14_15.txt
date -u +%FT%TZ > $O/finished3.txt
