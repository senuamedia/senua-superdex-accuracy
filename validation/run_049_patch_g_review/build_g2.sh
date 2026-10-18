#!/usr/bin/env bash
# Builds the probe library: SuperDex v1.0.0 with patches A to F as recorded and the proposed patch G
# (senua_inertia_transport_new.patch), 64-bit, as validation/run_039_linux_replication/build.sh builds library build 15,
# with -j4. Work folder ~/work/probeG only.
set -euo pipefail
P="$HOME/work/probeG"; cd "$P"
export CC=clang CXX=clang++
date -u +%FT%TZ > build-g2.started
cmake -S g2-src/superdex_physics -B build-g2 -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
  -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
  -DMOCHI_USE_DOUBLE_PRECISION=ON > build-g2.configure.log 2>&1
cmake --build build-g2 --target mochi_physics --parallel 4 > build-g2.log 2>&1
sha256sum build-g2/bin/libmochi_physics_double* | tee build-g2.sha256
date -u +%FT%TZ > build-g2.done
