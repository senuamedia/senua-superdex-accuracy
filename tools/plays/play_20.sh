#!/usr/bin/env bash
# The twentieth registration's plays (preregistrations/PREREGISTRATION_20.md): the corrections switched on in
# SuperDex's shipped 32-bit precision, beside 64-bit, on fresh cubes, on the Linux machine of runs 039 to 043. The
# libraries are run 041's 32-bit builds (stock and patched) and run 039's 64-bit builds; the 32-bit rigs are built here
# from the contact and pair rigs as in this commit, the 64-bit rigs are run 042's.
# usage: bash tools/plays/play_20.sh <work folder of run 039 step 1> <out folder>   (from the repository root)
#   writes <out>/rigs.sha256, identity.txt, played.txt and the plays under suites/1 and suites/2 (labels s20_*);
#   the measuring is measure/runners/sx_study20_run.sh
set -u
WD="$(cd "${1:?usage: play_20.sh <work folder> <out folder>}" && pwd)"; O="${2:?out folder}"; mkdir -p "$O"
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
rig() { SUPERDEX_SRC=$WD/$4 SUPERDEX_BUILD=$WD/$3 SRC=$1 OUT=$2 LIB=$5 tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $2"; }
for r in contact pair; do
  rig sdx_$r.cpp sdx_${r}32 build-patched32 superdex-patched-src mochi_physics
  rig sdx_$r.cpp sdx_${r}32_stock build-stock32 superdex-src mochi_physics
done
sha256sum -c --quiet <(grep -E 'tools/sdx_(contact64|contact64_stock)$' validation/run_042_two_corrections/rigs4.sha256) \
  > "$O/rigs_check.txt" 2>&1 || { echo "the 64-bit rigs are not run 042's" >&2; exit 2; }
sha256sum tools/sdx_contact.cpp tools/sdx_pair.cpp tools/sdx_contact32 tools/sdx_pair32 tools/sdx_contact32_stock \
  tools/sdx_pair32_stock tools/sdx_contact64 tools/sdx_pair64 tools/sdx_contact64_stock tools/sdx_pair64_stock > "$O/rigs.sha256"
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
FG="SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1"
FINAL="ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8"
conf() {  # conf <label> <rig suffix> <switches or -> <rig settings...>
  local label="$1" suf="$2" envs="$3"; shift 3
  ( unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
      SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT
    if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
    RIG="$PWD/tools/sdx_contact$suf" tools/contact_suite.sh "$label" "$@" &&
    RIG="$PWD/tools/sdx_contact$suf" RIGPAIR="$PWD/tools/sdx_pair$suf" tools/contact_suite2.sh "$label" "$@"
  ) > "$O/log_$label.txt" 2>&1
  echo "PLAYED $label rc $?" >> "$O/played.txt"
}
date -u +%FT%TZ > "$O/started.txt"
: > "$O/played.txt"
# S0: the 32-bit rigs built from this commit's sources make run 041's 32-bit plays of the seventh study's cubes again
export SUITE_CUBE="mass=0.8 radius=0.035" SUITE_H0=0.1 SUITE_VX=2.5 SUITE_VXCHAIN=0.9 SUITE_MU=0.35 SUITE_VSLIDE=3 SUITE_MUHOLD=0.45 SUITE_HOLD=2.117 SUITE_SLIP=4.234 SUITE_LIFT=23.52
export S2_CUBE="mass=0.8 radius=0.035" S2_MU=0.35 S2_VSTOP=0.9 S2_H0=0.07 S2_PAIR="massa=4 ra=0.3 massb=0.6 rb=0.03" S2_MUP=0.4 S2_CARRY=9.016 S2_SLIP=27.048 S2_VSIDE=1.2 S2_VTOP=0.8
conf s20_id32_stock 32_stock - & conf s20_id32_final 32 "$AB $CD $E $FG" $FINAL &
wait
same() { local s=0 n=0 x; for x in "$2"/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$x" "$3/$(basename "$x")" && s=$((s + 1)); done; echo "$1 $s of $n"; }
P41=validation/run_041_corrections_32bit/runs
{ for s in 1 2; do
    same "suite $s 32-bit stock against run 041:" $P41/s$s/r41_32_stock suites/$s/s20_id32_stock
    same "suite $s 32-bit final against run 041:" $P41/s$s/r41_32_final suites/$s/s20_id32_final
  done; } > "$O/identity.txt"
# the fresh cubes: a cube of 1.1 kg and half-size 0.04 m; friction 0.4 for the impact, the chain, the slide and the
# second suite's single cube, 0.5 for the hold and the slip; the hold pushed at 0.6 of the limit (3.234 N), the slip at
# 1.2 of it (6.468 N), the lift at three times the weight (32.34 N); the second suite's pair a block of 3.5 kg and
# half-size 0.28 m with a cube of 0.7 kg and half-size 0.035 m on it, friction 0.35 between them, the carry push half
# of what friction can carry the cube at (7.203 N), the slip push one and a half times it (21.609 N)
export SUITE_CUBE="mass=1.1 radius=0.04" SUITE_H0=0.08 SUITE_VX=2 SUITE_VXCHAIN=1.2 SUITE_MU=0.4 SUITE_VSLIDE=3.5 SUITE_MUHOLD=0.5 SUITE_HOLD=3.234 SUITE_SLIP=6.468 SUITE_LIFT=32.34
export S2_CUBE="mass=1.1 radius=0.04" S2_MU=0.4 S2_VSTOP=1 S2_H0=0.06 S2_PAIR="massa=3.5 ra=0.28 massb=0.7 rb=0.035" S2_MUP=0.35 S2_CARRY=7.203 S2_SLIP=21.609 S2_VSIDE=1 S2_VTOP=0.9
conf s20_32_stock 32_stock - & conf s20_32_off 32 - & conf s20_32_final 32 "$AB $CD $E $FG" $FINAL &
conf s20_64_stock 64_stock - & conf s20_64_final 64 "$AB $CD $E $FG" $FINAL &
wait
date -u +%FT%TZ > "$O/finished.txt"
