#!/usr/bin/env bash
# variant.sh <name> [play ...]: put variants/<name>.h in place of the patched kernel header, rebuild the library
# incrementally in the one build directory, keep the library as lib/<name>/, and play the named sources
# (default qi1) on it exactly as tools/plays/play_05.sh plays them, with the solver trace on.
set -u
T=~/work/traceC; cd $T
n="${1:?usage: variant.sh <name> [source ...]}"; shift
H=src/superdex_physics/libraries/mochi/mochi_core/include/mochi_core/contact/contact_utils.h
if ! cmp -s variants/$n.h $H; then cp variants/$n.h $H; fi
export CC=clang CXX=clang++
s=$(date +%s)
cmake --build build --target mochi_physics --parallel 4 > logs/build_$n.log 2>&1 || { echo "BUILD FAILED $n"; exit 1; }
mkdir -p lib/$n; cp -p build/bin/libmochi_physics_double.so lib/$n/
echo "$n header $(sha256sum $H | cut -c1-16) library $(sha256sum lib/$n/libmochi_physics_double.so | cut -c1-16) built in $(( $(date +%s) - s )) s" | tee -a logs/variants.txt
for src in "${@:-qi1}"; do
  case $src in
    qi1) settings="integ=be maxiter=200 ndamp=5 implicitn=1" ;;
    q1)  settings="integ=be maxiter=200 ndamp=5" ;;
    *) echo "unknown source $src"; exit 2 ;;
  esac
  O=plays/$n; mkdir -p $O
  ( unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL
    export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003
    SDX_TRACE=$O/${src}_trace.txt LD_DEBUG=libs LD_LIBRARY_PATH=$T/lib/$n \
      $T/record/tools/sdx_player64 ant $T/superdex-src/assets $T/record/actions/05/ant.txt $O/$src $settings \
      < /dev/null > $O/$src.out 2> $O/${src}_loader.txt )
  grep -o 'calling init: [^ ]*libmochi_physics_double[^ ]*' $O/${src}_loader.txt | sort -u > $O/${src}_library.txt
  rm -f $O/${src}_loader.txt
  echo "$n $src $(cat $O/${src}_library.txt) enc $(sha256sum $O/${src}_enc.pcm | cut -c1-16) state $(sha256sum $O/${src}_state.f32 | cut -c1-16) $(grep -o 'converged [0-9]* stopped [0-9]* diverged [0-9]*' $O/$src.out)" | tee -a logs/plays.txt
done
