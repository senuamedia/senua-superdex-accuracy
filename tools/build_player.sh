#!/bin/bash
# Build sdx_player against a SuperDex checkout and a mochi_physics build with HDF5 on (the published benchmark
# scenes keep their meshes in .mochi.h5 files):
#   git clone --branch stable https://github.com/facebookresearch/project_superdex "$SUPERDEX_SRC"
#   git -C "$SUPERDEX_SRC" checkout "$(cat UPSTREAM_COMMIT)"
#   cmake -S "$SUPERDEX_SRC/superdex_physics" -B "$SUPERDEX_BUILD" -DCMAKE_BUILD_TYPE=Release \
#         -DMOCHI_USE_PYBIND=OFF -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON \
#         -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF -DCMAKE_CXX_FLAGS="$EXTRA_FLAGS"
#   cmake --build "$SUPERDEX_BUILD" --target mochi_physics --parallel 4
# macOS on Intel with Command Line Tools only: export
#   EXTRA_FLAGS="-isysroot $(xcrun --show-sdk-path) -isystem $(xcrun --show-sdk-path)/usr/include/c++/v1"
set -e
cd "$(dirname "$0")"
SUPERDEX_SRC="${SUPERDEX_SRC:?set SUPERDEX_SRC to the SuperDex checkout}"
SUPERDEX_BUILD="${SUPERDEX_BUILD:?set SUPERDEX_BUILD to the mochi_physics build directory}"
EXTRA_FLAGS="${EXTRA_FLAGS:-}"

# The player must compile with the library's own defines, flags and include paths, or the parameter structs differ
# in layout across the boundary. CMake records them in flags.make.
FM="$SUPERDEX_BUILD/mochi/mochi_physics/CMakeFiles/mochi_physics.dir/flags.make"
DEFS="$(grep '^CXX_DEFINES' "$FM" | sed 's/^CXX_DEFINES = //; s/-DMOCHI_PHYSICS_EXPORTS=1/-DMOCHI_PHYSICS_EXPORTS=0/; s/-Dmochi_physics_EXPORTS//')"
FLAGS="$(grep '^CXX_FLAGS' "$FM" | sed 's/^CXX_FLAGS = //')"
INCS="$(grep '^CXX_INCLUDES' "$FM" | sed 's/^CXX_INCLUDES = //')"

# shellcheck disable=SC2086
c++ $FLAGS $DEFS $INCS $EXTRA_FLAGS \
    -I "$SUPERDEX_SRC/superdex_physics/include" \
    -o "${OUT:-sdx_player}" "${SRC:-sdx_player.cpp}" \
    -L "${BINDIR:-$SUPERDEX_BUILD/bin}" -l"${LIB:-mochi_physics}" \
    -Wl,-rpath,"${BINDIR:-$SUPERDEX_BUILD/bin}"
echo "built $(pwd)/${OUT:-sdx_player}"
