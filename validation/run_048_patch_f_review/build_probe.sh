#!/usr/bin/env bash
# build_probe.sh <name> <patch...> : PROBE ONLY. A copy of the pristine SuperDex tree (~/work/sdx/superdex-src, read
# only) with the given patches applied, built 64-bit as validation/run_039_linux_replication/build.sh builds (Clang,
# Release, HDF5 on, double precision), with -j4, into ~/work/probeF/build-<name>. Writes nothing outside ~/work/probeF.
set -euo pipefail
NAME="${1:?name}"; shift
W=~/work/probeF
export CC=clang CXX=clang++
cd "$W"
rm -rf "src-$NAME" "build-$NAME"
cp -R ~/work/sdx/superdex-src "src-$NAME"
git -C "src-$NAME" checkout -q 1d7150946fa3f3d3fb09c2bff07eaa138cbfdee6
for p in "$@"; do git -C "src-$NAME" apply "$p"; done
sha256sum "$@" > "build-$NAME.patches.sha256"
cmake -S "src-$NAME/superdex_physics" -B "build-$NAME" -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
  -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
  -DMOCHI_USE_DOUBLE_PRECISION=ON > "build-$NAME.configure.log" 2>&1
cmake --build "build-$NAME" --target mochi_physics --parallel 4 > "build-$NAME.log" 2>&1
sha256sum "build-$NAME"/bin/libmochi_physics_double* | tee "build-$NAME.sha256"
