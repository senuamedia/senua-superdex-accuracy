#!/usr/bin/env bash
# Run 041, step 2: both contact suites on the seventh study's cubes, in 32-bit and in 64-bit on the same Linux machine,
# under five configurations: stock (the stock library), off (the patched library, no switch), abcd (patches A to D
# with contact damping 5 and SuperDex's frictionFalloffVel 0.03, the seventh study's recommended configuration), abcde
# (the same with patch E, the ninth study's) and final (every switch, with the final configuration's tolerances,
# abstol 1e-4 and reltol 1e-8). The ten plays run side by side, one a core; each writes its own suite folders.
# Not registered: a design probe. The 64-bit plays of stock, off, abcd and abcde are the registered plays of the
# identity check, so their files are compared with the registered ones too.
# usage: play.sh <work folder of run 039 step 1>   (from the root of the copy of this repository runs 040 played in)
set -u
WD="$(cd "${1:?usage: play.sh <work folder>}" && pwd)"
O=validation/run_041_corrections_32bit; mkdir -p $O
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
rig() {  # rig <source> <out> <build folder> <library> <source tree>
  SUPERDEX_SRC=$WD/$5 SUPERDEX_BUILD=$WD/$3 SRC=$1 OUT=$2 LIB=$4 tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $2"
}
for r in contact pair; do
  rig sdx_$r.cpp sdx_${r}32 build-patched32 mochi_physics superdex-patched-src
  rig sdx_$r.cpp sdx_${r}32_stock build-stock32 mochi_physics superdex-src
  rig sdx_$r.cpp sdx_${r}64_stock build-stock mochi_physics_double superdex-src
done
sha256sum tools/sdx_contact32 tools/sdx_pair32 tools/sdx_contact32_stock tools/sdx_pair32_stock tools/sdx_contact64 \
  tools/sdx_pair64 tools/sdx_contact64_stock tools/sdx_pair64_stock > $O/rigs.sha256
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
FG="SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1"
conf() {  # conf <bits> <label> <rig suffix> <switches or -> <rig settings...>
  local bits="$1" label="$2" suf="$3" envs="$4"; shift 4
  ( unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
      SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT
    if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    RIG="$PWD/tools/sdx_contact$bits$suf" tools/contact_suite.sh "r41_${bits}_$label" "$@" &&
    RIG="$PWD/tools/sdx_contact$bits$suf" RIGPAIR="$PWD/tools/sdx_pair$bits$suf" tools/contact_suite2.sh "r41_${bits}_$label" "$@"
  ) > $O/log_${bits}_$label.txt 2>&1
  echo "PLAYED $bits $label rc $?" >> $O/played.txt
}
: > $O/played.txt
date -u +%FT%TZ > $O/started.txt
for bits in 32 64; do
  conf $bits stock _stock - &
  conf $bits off "" - &
  conf $bits abcd "" "$AB $CD" ndamp=5 falloff=0.03 &
  conf $bits abcde "" "$AB $CD $E" ndamp=5 falloff=0.03 &
  conf $bits final "" "$AB $CD $E $FG" ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8 &
done
wait
date -u +%FT%TZ > $O/finished.txt
