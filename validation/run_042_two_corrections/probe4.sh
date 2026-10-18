#!/usr/bin/env bash
# Run 042, step 4, after step 3 showed why neither defect was reached. Two plays that can reach them:
#   a. tools/sdx_exit, new: the program registers its exit handler and then loads the library with dlopen, as a plugin
#      or a Python extension does, so at exit the library's static objects are destroyed before the handler destroys
#      the scene; under valgrind's memcheck with stock, build 14 and build 15, with no switch and with patches A to D;
#   b. the soft block held only along its bottom (softhold=bottom), which deforms under the cube, so the tetrahedral
#      map can miss a sample where the block moved within the step: drop, slide, hold and hop, at steps 1, 1/4 and 1/16
#      (the hop also 1/64), under patch C alone and under patches A to D, on builds 14 and 15 and on stock; build 14
#      against build 15 file by file.
# The contact rig gains softhold for this step and is checked a third time against the registered suites. Not
# registered: a design probe.
# usage: probe4.sh <work folder of run 039 step 1>   (from the root of the copy of this repository run 040 played in)
set -u
WD="$(cd "${1:?usage: probe4.sh <work folder>}" && pwd)"
O=validation/run_042_two_corrections; R4=$O/runs4; mkdir -p $R4
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
rig() { SUPERDEX_SRC=$WD/$4 SUPERDEX_BUILD=$WD/$3 SRC=$1 OUT=$2 LIB=mochi_physics_double tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $2"; }
rig sdx_contact.cpp sdx_contact64 build-patched superdex-patched-src
rig sdx_contact.cpp sdx_contact64_stock build-stock superdex-src
rig sdx_contact.cpp sdx_contact64_b14 build-patched14 superdex-b14-src
# sdx_exit compiles with the library's flags and headers, and does not link it
FM="$WD/build-patched/mochi/mochi_physics/CMakeFiles/mochi_physics.dir/flags.make"
DEFS="$(grep '^CXX_DEFINES' "$FM" | sed 's/^CXX_DEFINES = //; s/-DMOCHI_PHYSICS_EXPORTS=1/-DMOCHI_PHYSICS_EXPORTS=0/; s/-Dmochi_physics_EXPORTS//')"
FLAGS="$(grep '^CXX_FLAGS' "$FM" | sed 's/^CXX_FLAGS = //')"; INCS="$(grep '^CXX_INCLUDES' "$FM" | sed 's/^CXX_INCLUDES = //')"
# shellcheck disable=SC2086
c++ $FLAGS $DEFS $INCS -I "$WD/superdex-patched-src/superdex_physics/include" -o tools/sdx_exit tools/sdx_exit.cpp -ldl || echo "RIG FAILED sdx_exit"
sha256sum tools/sdx_contact.cpp tools/sdx_exit.cpp tools/sdx_contact64 tools/sdx_contact64_stock tools/sdx_contact64_b14 tools/sdx_exit > $O/rigs4.sha256
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
clear_sw() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
  SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
date -u +%FT%TZ > $O/started4.txt
# the rebuilt contact rig against the registered suites
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
conf() { local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    RIG="$PWD/tools/sdx_contact64$suf" tools/contact_suite.sh "r42d_$label" "$@" &&
    RIG="$PWD/tools/sdx_contact64$suf" RIGPAIR="$PWD/tools/sdx_pair64$suf" tools/contact_suite2.sh "r42d_$label" "$@" ) > /dev/null 2>&1
  echo "PLAYED identity4 $label rc $?" >> $O/played4.txt; }
conf stock _stock - & conf off "" - & conf abcd "" "$AB $CD" ndamp=5 falloff=0.03 & conf abcde "" "$AB $CD $E" ndamp=5 falloff=0.03 &
wait
same() { local s=0 n=0 x; for x in "$2"/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$x" "$3/$(basename "$x")" && s=$((s + 1)); done; echo "$1 $s of $n"; }
S7=validation/run_017_counts/runs; S9=validation/run_021_rotation/runs
{ for s in 1 2; do
    same "suite $s stock against registered:" $S7/s$s/stock suites/$s/r42d_stock
    same "suite $s off against registered stock:" $S7/s$s/stock suites/$s/r42d_off
    same "suite $s A to D against registered:" $S7/s$s/rec_new suites/$s/r42d_abcd
    same "suite $s A to E against registered:" $S9/s$s/rec_e suites/$s/r42d_abcde
  done; } > $O/identity4.txt
unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP
# a. the library loaded after the exit handler
: > $O/exitdlopen.txt
for lib in stock b14 b15; do for sw in off abcd; do
  case $lib in stock) L=$WD/build-stock ;; b14) L=$WD/build-patched14 ;; b15) L=$WD/build-patched ;; esac
  [ $lib = stock ] && [ $sw = abcd ] && continue
  ( clear_sw; [ $sw = abcd ] && for kv in $AB $CD; do export "$kv"; done
    valgrind --tool=memcheck --error-exitcode=99 --log-file=$R4/valgrind_dlopen_${lib}_$sw.txt tools/sdx_exit \
      $L/bin/libmochi_physics_double.so 10 > $R4/dlopen_${lib}_$sw.out 2>&1
    echo "$lib $sw exit $? $(grep -o 'ERROR SUMMARY: [0-9]* errors' $R4/valgrind_dlopen_${lib}_$sw.txt) $(grep -c 'sdx_exit: destroyed' $R4/dlopen_${lib}_$sw.out) destroyed" >> $O/exitdlopen.txt )
done; done
# b. the block held only along its bottom
CUBE="mass=0.8 radius=0.035"
soft() {  # soft <label> <rig suffix> <switches or -> <rig settings...>
  local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    for k in 1 4 16 64; do
      dt=$(awk -v k=$k 'BEGIN { printf "%.10g", 0.01 / k }')
      T=tools/sdx_contact64$suf; B="mu=0.35 $CUBE floor=soft softhold=bottom"
      if [ $k != 64 ]; then
        # shellcheck disable=SC2086
        { $T $R4/sb_${label}_drop_$k.txt dt=$dt secs=1 h0=0.05 $B "$@"; $T $R4/sb_${label}_slide_$k.txt dt=$dt secs=1.5 h0=0 vx0=1 $B "$@"
          $T $R4/sb_${label}_hold_$k.txt dt=$dt secs=1 h0=0 push=1.646 $B "$@"; } >> $R4/sb_${label}.stats 2>&1
      fi
      # shellcheck disable=SC2086
      $T $R4/sb_${label}_hop_$k.txt dt=$dt secs=1 h0=0.05 vx0=0.02 $B "$@" >> $R4/sb_${label}.stats 2>&1
    done )
  echo "PLAYED softbottom $label rc $?" >> $O/played4.txt; }
soft stock _stock - &
soft b14_c _b14 "$CD" & soft b15_c "" "$CD" &
soft b14_abcd _b14 "$AB $CD" falloff=0.03 & soft b15_abcd "" "$AB $CD" falloff=0.03 &
wait
{ for f in $R4/sb_b14_*_[a-z]*_[0-9]*.txt; do b=$(basename "$f"); g=$R4/${b/b14_/b15_}; if cmp -s "$f" "$g"; then echo "SAME $b"; else echo "DIFFERS $b $(cmp "$f" "$g" | sed 's/.*differ: //')"; fi; done; } > $O/softbottom_14_15.txt
date -u +%FT%TZ > $O/finished4.txt
