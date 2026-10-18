#!/usr/bin/env bash
# Run 042, step 2: the contact rig with its two new settings, floor=soft and exitscene=1, built against stock, library
# build 14 and library build 15 (64-bit, Linux), and played:
#   a. identity: the rig with neither setting makes the seventh and ninth studies' registered suite files again, byte
#      for byte (stock, off, patches A to D, A to E; both suites), so adding the settings changed nothing else;
#   b. exitscene: a short play whose scene is destroyed after main returns, under valgrind's memcheck, on stock, build 14
#      and build 15, with no switch and with patches A to D: the exit code and valgrind's error count;
#   c. floor=soft: a cube on a soft block, every node held, which it meets through SuperDex's tetrahedral-map (mapped)
#      collider: dropped, slid and held, at steps 1, 1/4 and 1/16, on stock, and on builds 14 and 15 under patches A to
#      D; build 14 against build 15 file by file.
# Not registered: a design probe.
# usage: probe.sh <work folder of run 039 step 1>   (from the root of the copy of this repository run 040 played in)
set -u
WD="$(cd "${1:?usage: probe.sh <work folder>}" && pwd)"
O=validation/run_042_two_corrections; mkdir -p $O/runs
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
command -v valgrind > /dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q valgrind > /dev/null
valgrind --version > $O/valgrind_version.txt
rig() {  # rig <source> <out> <build folder> <source tree>
  SUPERDEX_SRC=$WD/$4 SUPERDEX_BUILD=$WD/$3 SRC=$1 OUT=$2 LIB=mochi_physics_double tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $2"
}
rig sdx_contact.cpp sdx_contact64 build-patched superdex-patched-src
rig sdx_contact.cpp sdx_contact64_stock build-stock superdex-src
rig sdx_contact.cpp sdx_contact64_b14 build-patched14 superdex-b14-src
rig sdx_pair.cpp sdx_pair64 build-patched superdex-patched-src
rig sdx_pair.cpp sdx_pair64_stock build-stock superdex-src
sha256sum tools/sdx_contact.cpp tools/sdx_contact64 tools/sdx_contact64_stock tools/sdx_contact64_b14 tools/sdx_pair64 \
  tools/sdx_pair64_stock > $O/rigs.sha256
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
clear_sw() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
  SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
date -u +%FT%TZ > $O/started.txt
# a. identity, the four configurations side by side
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
conf() {  # conf <label> <rig suffix> <switches or -> <rig settings...>
  local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    RIG="$PWD/tools/sdx_contact64$suf" tools/contact_suite.sh "r42_$label" "$@" &&
    RIG="$PWD/tools/sdx_contact64$suf" RIGPAIR="$PWD/tools/sdx_pair64$suf" tools/contact_suite2.sh "r42_$label" "$@" ) > /dev/null 2>&1
  echo "PLAYED identity $label rc $?" >> $O/played.txt
}
conf stock _stock - & conf off "" - & conf abcd "" "$AB $CD" ndamp=5 falloff=0.03 & conf abcde "" "$AB $CD $E" ndamp=5 falloff=0.03 &
wait
same() { local s=0 n=0 x; for x in "$2"/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$x" "$3/$(basename "$x")" && s=$((s + 1)); done; echo "$1 $s of $n"; }
S7=validation/run_017_counts/runs; S9=validation/run_021_rotation/runs
{
  for s in 1 2; do
    same "suite $s stock against registered:" $S7/s$s/stock suites/$s/r42_stock
    same "suite $s off against registered stock:" $S7/s$s/stock suites/$s/r42_off
    same "suite $s A to D against registered:" $S7/s$s/rec_new suites/$s/r42_abcd
    same "suite $s A to E against registered:" $S9/s$s/rec_e suites/$s/r42_abcde
  done
} > $O/identity.txt
unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP
# b. exitscene under valgrind
CUBE="mass=0.8 radius=0.035"
: > $O/exitscene.txt
for lib in stock b14 b15; do for sw in off abcd; do
  suf=""; case $lib in stock) suf=_stock ;; b14) suf=_b14 ;; esac
  [ $lib = stock ] && [ $sw = abcd ] && continue
  ( clear_sw; [ $sw = abcd ] && for kv in $AB $CD; do export "$kv"; done
    # shellcheck disable=SC2086
    valgrind --tool=memcheck --error-exitcode=99 --log-file=$O/runs/valgrind_${lib}_$sw.txt tools/sdx_contact64$suf \
      $O/runs/exit_${lib}_$sw.txt dt=0.01 secs=0.1 h0=0 mu=0.35 $CUBE exitscene=1 > $O/runs/exit_${lib}_$sw.out 2>&1
    echo "$lib $sw exit $? $(grep -o 'ERROR SUMMARY: [0-9]* errors' $O/runs/valgrind_${lib}_$sw.txt)" >> $O/exitscene.txt )
done; done
# c. floor=soft: drop, slide and hold at three steps
soft() {  # soft <label> <rig suffix> <switches or -> <rig settings...>
  local label="$1" suf="$2" envs="$3"; shift 3
  ( clear_sw; if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    for k in 1 4 16; do
      dt=$(awk -v k=$k 'BEGIN { printf "%.10g", 0.01 / k }')
      # shellcheck disable=SC2086
      tools/sdx_contact64$suf $O/runs/soft_${label}_drop_$k.txt dt=$dt secs=1 h0=0.05 mu=0.35 $CUBE floor=soft "$@" >> $O/runs/soft_${label}.stats 2>&1
      # shellcheck disable=SC2086
      tools/sdx_contact64$suf $O/runs/soft_${label}_slide_$k.txt dt=$dt secs=1.5 h0=0 vx0=1 mu=0.35 $CUBE floor=soft "$@" >> $O/runs/soft_${label}.stats 2>&1
      # shellcheck disable=SC2086
      tools/sdx_contact64$suf $O/runs/soft_${label}_hold_$k.txt dt=$dt secs=1 h0=0 mu=0.45 push=2.117 $CUBE floor=soft "$@" >> $O/runs/soft_${label}.stats 2>&1
    done
  )
  echo "PLAYED soft $label rc $?" >> $O/played.txt
}
soft stock _stock - & soft b14_abcd _b14 "$AB $CD" ndamp=5 falloff=0.03 & soft b15_abcd "" "$AB $CD" ndamp=5 falloff=0.03 &
soft b15_off "" - &
wait
{
  for f in $O/runs/soft_b14_abcd_*.txt; do b=$(basename "$f"); g=$O/runs/${b/b14_abcd/b15_abcd}; if cmp -s "$f" "$g"; then echo "SAME $b"; else echo "DIFFERS $b $(cmp "$f" "$g" | sed 's/.*differ: //')"; fi; done
  for f in $O/runs/soft_stock_*.txt; do b=$(basename "$f"); g=$O/runs/${b/stock/b15_off}; if cmp -s "$f" "$g"; then echo "SAME off $b"; else echo "DIFFERS off $b"; fi; done
} > $O/soft_14_15.txt
date -u +%FT%TZ > $O/finished.txt
