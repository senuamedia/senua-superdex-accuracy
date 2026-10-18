#!/usr/bin/env bash
# Run 039, step 1: SuperDex v1.0.0 built on another machine and another operating system (AWS EC2,
# Ubuntu 24.04, Clang 18: SuperDex refuses any compiler but Clang 17 or newer on Linux), stock and patched, 64-bit, as
# docs/reproduce.md says, to replicate the record away from the laptop. Not registered: a replication probe; it decides
# nothing until a study registers its rules.
# usage: build.sh <work folder> <this repository's patches folder>
set -euo pipefail
WD="${1:?usage: build.sh <work folder> <patches folder>}"; P="$(cd "${2:?patches folder}" && pwd)"
COMMIT=1d7150946fa3f3d3fb09c2bff07eaa138cbfdee6   # UPSTREAM_COMMIT
command -v clang++ > /dev/null || sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q clang > /dev/null
export CC=clang CXX=clang++
mkdir -p "$WD"; cd "$WD"
[ -d superdex-src ] || git clone -q --branch stable https://github.com/facebookresearch/project_superdex superdex-src
git -C superdex-src checkout -q $COMMIT
rm -rf superdex-patched-src; cp -R superdex-src superdex-patched-src
git -C superdex-patched-src apply "$P/senua_contact.patch" "$P/senua_joint_limit.patch" "$P/senua_rotation_axis.patch" \
  "$P/senua_inertia_transport.patch"
sha256sum "$P"/senua_*.patch > patches.sha256
for t in stock patched; do
  src=superdex-src; [ $t = patched ] && src=superdex-patched-src
  cmake -S $src/superdex_physics -B build-$t -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
    -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
    -DMOCHI_USE_DOUBLE_PRECISION=ON > build-$t.configure.log 2>&1
  cmake --build build-$t --target mochi_physics --parallel "$(nproc)" > build-$t.log 2>&1
  sha256sum build-$t/bin/libmochi_physics_double* | tee build-$t.sha256
done
{ clang++ --version | head -1; cmake --version | head -1; grep PRETTY /etc/os-release; lscpu | grep "Model name"; } > machine.txt
