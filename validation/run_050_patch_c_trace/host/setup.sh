#!/usr/bin/env bash
# traceC setup: SuperDex v1.0.0 with the fifth registration's contact patch only (the source form of library build 4),
# one build directory, 64-bit, HDF5 on, as validation/run_039_linux_replication/build.sh configures it.
set -euo pipefail
cd ~/work/traceC
COMMIT=1d7150946fa3f3d3fb09c2bff07eaa138cbfdee6
export CC=clang CXX=clang++
[ -d superdex-src ] || git clone -q --branch stable https://github.com/facebookresearch/project_superdex superdex-src
git -C superdex-src checkout -q $COMMIT
git -C superdex-src log --oneline -1
rm -rf src; cp -R superdex-src src
git -C src apply ~/work/traceC/record/patches/superseded/senua_contact_registration5.patch
sha256sum record/patches/superseded/senua_contact_registration5.patch
cmake -S src/superdex_physics -B build -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
  -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
  -DMOCHI_USE_DOUBLE_PRECISION=ON > configure.log 2>&1
date -u +%FT%TZ
cmake --build build --target mochi_physics --parallel 4 > build_b4.log 2>&1
date -u +%FT%TZ
sha256sum build/bin/libmochi_physics_double*
