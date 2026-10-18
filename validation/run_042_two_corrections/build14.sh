#!/usr/bin/env bash
# Run 042, step 1: library build 14, the build before the second code review's corrections, built in 64-bit on the
# Linux machine of runs 039 to 041 beside run 039's build 15, from the same SuperDex commit. Build 14's four patch files
# are in this repository: patches/superseded/senua_contact_registration15.patch (78a57a7657388d62...) and
# patches/superseded/senua_joint_limit_registration15.patch (0b8446d24c3fd401...), with the current
# senua_rotation_axis.patch and senua_inertia_transport.patch, which build 15 did not change. Not registered: a design
# probe for the two corrections of build 15 that no rig had played.
# usage: build14.sh <work folder of run 039 step 1> <this repository's patches folder>
set -euo pipefail
WD="$(cd "${1:?usage: build14.sh <work folder> <patches folder>}" && pwd)"; P="$(cd "${2:?patches folder}" && pwd)"
cd "$WD"
export CC=clang CXX=clang++
rm -rf superdex-b14-src; cp -R superdex-src superdex-b14-src
git -C superdex-b14-src apply "$P/superseded/senua_contact_registration15.patch" \
  "$P/superseded/senua_joint_limit_registration15.patch" "$P/senua_rotation_axis.patch" "$P/senua_inertia_transport.patch"
sha256sum "$P/superseded/senua_contact_registration15.patch" "$P/superseded/senua_joint_limit_registration15.patch" \
  "$P/senua_rotation_axis.patch" "$P/senua_inertia_transport.patch" > build-patched14.patches.sha256
cmake -S superdex-b14-src/superdex_physics -B build-patched14 -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
  -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
  -DMOCHI_USE_DOUBLE_PRECISION=ON > build-patched14.configure.log 2>&1
cmake --build build-patched14 --target mochi_physics --parallel "$(nproc)" > build-patched14.log 2>&1
sha256sum build-patched14/bin/libmochi_physics_double* | tee build-patched14.sha256
