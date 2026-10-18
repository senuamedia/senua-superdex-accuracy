#!/usr/bin/env bash
# Run 041, step 1: SuperDex v1.0.0 built in its shipped 32-bit precision (MOCHI_USE_DOUBLE_PRECISION=OFF) on the
# Linux machine of runs 039 and 040, stock and patched, from the source trees run 039 prepared (the same commit and
# the same four patch files). Not registered: a design probe for the open item "the corrections switched on in 32-bit".
# usage: build32.sh <work folder of run 039 step 1>
set -euo pipefail
WD="$(cd "${1:?usage: build32.sh <work folder>}" && pwd)"; cd "$WD"
export CC=clang CXX=clang++
for t in stock patched; do
  src=superdex-src; [ $t = patched ] && src=superdex-patched-src
  cmake -S $src/superdex_physics -B build-${t}32 -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
    -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
    -DMOCHI_USE_DOUBLE_PRECISION=OFF > build-${t}32.configure.log 2>&1
  cmake --build build-${t}32 --target mochi_physics --parallel "$(nproc)" > build-${t}32.log 2>&1
  sha256sum build-${t}32/bin/libmochi_physics* | tee build-${t}32.sha256
done
