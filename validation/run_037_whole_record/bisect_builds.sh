#!/usr/bin/env bash
# Run 037, a probe after the registered decision (not registered): which kept library build changed the play that
# differs. replay_differs.sh found that Study 5's ant benchmark under the recommended configuration with SuperDex's
# implicitNormalForceForDissipation (source qi1) is made byte for byte on library build 4, kept from the fifth
# registration's time, and differs on library build 15 from its first difference at byte 3411. Here the same rig and
# the same settings play it on every kept build between them, in order, and each stream is compared with the registered
# one and with run 037's. A build is "registered" when it makes the registered stream, "build 15" when it makes run
# 037's, and "other" when it makes neither. The library each play loaded is recorded from the loader.
# usage: bisect_builds.sh <clone run 037 played in> <the record> <SuperDex assets> <folder of the kept builds> [build ...]
#   builds default: 5 6 8 9 10 11 12 13 14
set -u
C="$(cd "${1:?usage: bisect_builds.sh <clone> <record> <assets> <builds folder> [build ...]}" && pwd)"
REF="$(cd "${2:?}" && pwd)"; A="${3:?}"; L="${4:?}"; shift 4
BUILDS="${*:-5 6 8 9 10 11 12 13 14}"
O="$(cd "$(dirname "$0")" && pwd)/bisect"; mkdir -p "$O"; : > "$O/verdict.txt"
for b in $BUILDS; do
  W="$O/build$b"; rm -rf "$W"; mkdir -p "$W"
  ( unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL
    export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003
    DYLD_PRINT_LIBRARIES=1 DYLD_LIBRARY_PATH="$L/bin_build$b" "$C/tools/sdx_player64" ant "$A" "$C/actions/05/ant.txt" \
      "$W/qi1" integ=be maxiter=200 ndamp=5 implicitn=1 < /dev/null > "$W/qi1.out" 2> "$W/loader.txt" )
  lib="$(grep -o '[^ ]*libmochi_physics_double[^ ]*' "$W/loader.txt" | sort -u)"
  sha="$(shasum -a 256 "$lib" | cut -c1-16)"
  if cmp -s "$W/qi1_enc.pcm" "$REF/streams/05/ant/qi1_enc.pcm"; then v=registered
  elif cmp -s "$W/qi1_enc.pcm" "$C/streams/05/ant/qi1_enc.pcm"; then v="build 15"
  else v="other, first differs from the registered at $(cmp "$W/qi1_enc.pcm" "$REF/streams/05/ant/qi1_enc.pcm" | sed 's/.*differ: char \([0-9]*\).*/byte \1/')"; fi
  st="$(grep '^STATS' "$W/qi1.out" | grep -o 'converged [0-9]* stopped [0-9]* diverged [0-9]*')"
  echo "build$b $sha $(basename "$(dirname "$lib")") : $v ; $st" | tee -a "$O/verdict.txt"
  rm -f "$W/loader.txt" "$W/qi1_state.f32"
done
