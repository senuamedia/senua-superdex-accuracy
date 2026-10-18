#!/bin/bash
# list the headers each rig includes (c++ -MM equivalent with system headers), using build_player.sh's flags
set -e
SUPERDEX_SRC=$HOME/code/superdex-src
SUPERDEX_BUILD=$HOME/code/superdex-build-f64
FM="$SUPERDEX_BUILD/mochi/mochi_physics/CMakeFiles/mochi_physics.dir/flags.make"
DEFS="$(grep '^CXX_DEFINES' "$FM" | sed 's/^CXX_DEFINES = //; s/-DMOCHI_PHYSICS_EXPORTS=1/-DMOCHI_PHYSICS_EXPORTS=0/; s/-Dmochi_physics_EXPORTS//')"
FLAGS="$(grep '^CXX_FLAGS' "$FM" | sed 's/^CXX_FLAGS = //')"
INCS="$(grep '^CXX_INCLUDES' "$FM" | sed 's/^CXX_INCLUDES = //')"
cd "$(dirname "$0")/tools"
for r in sdx_deform sdx_grip sdx_chain; do
  # shellcheck disable=SC2086
  c++ $FLAGS $DEFS $INCS -I "$SUPERDEX_SRC/superdex_physics/include" -M "$r.cpp" | tr ' \\' '\n\n' | grep -v '^$' | grep superdex-src > "../logs/deps_$r.txt"
  echo "$r: $(wc -l < ../logs/deps_$r.txt) superdex-src headers; modified ones:"
  grep -E 'contact_utils.h|quaternion_inl.h|mochi_contact.h' "../logs/deps_$r.txt" || echo "  (none)"
done
