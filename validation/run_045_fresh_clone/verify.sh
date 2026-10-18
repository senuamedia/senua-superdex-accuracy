#!/usr/bin/env bash
# Run 045: the record checked end to end before publication, from a fresh copy of it and a fresh clone of SuperDex, on
# the Linux machine of runs 039 to 044, in the same folders those runs used (their old contents set aside first), so
# that every library and rig the record registers on Linux can be rebuilt and compared by its checksum. Not registered:
# a verification of the record as it will be published.
#   1. the patch files: their checksums; every registered form applies to SuperDex v1.0.0 and only adds lines
#   2. the libraries, built by the record's own build scripts (runs 039, 041, 042) and library build 13, against the
#      checksums those runs recorded
#   3. the rigs, against the checksums runs 040 to 042 recorded
#   4. Studies 19 and 20 played again by their own play scripts, every file against the registered one
#   5. the identity check, every part, against the registered files
#   6. every reading re-made from the record's own files by measure/runners/remake.sh, Studies 1 to 3 included
# usage: verify.sh <work folder (~/work/sdx)> <folder of the Linux-built measuring programs>
#        (from the root of a fresh copy of this repository at ~/work/rec40)
set -u
WD="${1:?usage: verify.sh <work folder> <programs folder>}"; PR="$(cd "${2:?programs folder}" && pwd)"
O=validation/run_045_fresh_clone; mkdir -p $O
R="$(pwd)"
log() { echo "$(date -u +%FT%TZ) $*" | tee -a $O/steps.txt; }
: > $O/steps.txt
log "record $(git log -1 --format=%h) clean=$(git status --porcelain | wc -l)"
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
COMMIT="$(cat UPSTREAM_COMMIT)"

# 1. the patch files
sha256sum patches/*.patch patches/superseded/*.patch patches/in_design/*.patch > $O/patch_checksums.txt
[ -d "$WD/superdex-src" ] || git clone -q --branch stable https://github.com/facebookresearch/project_superdex "$WD/superdex-src"
git -C "$WD/superdex-src" checkout -q "$COMMIT"
check_set() {  # check_set <name> <patch files...>: applies to a clean v1.0.0; lines added and removed
  local name="$1"; shift
  local t="$WD/apply_check"; rm -rf "$t"; git clone -q "$WD/superdex-src" "$t"; git -C "$t" checkout -q "$COMMIT"
  local files=(); for p in "$@"; do files+=("$R/$p"); done
  if git -C "$t" apply --check "${files[@]}" 2> "$O/apply_$name.err"; then
    git -C "$t" apply --numstat "${files[@]}" | awk -v n="$name" '{ a += $1; d += $2; f++ } END { printf "%s applies: %d files, %d lines added, %d removed\n", n, f, a, d }'
  else echo "$name DOES NOT APPLY"; fi
  rm -rf "$t"
}
{
  check_set build15 patches/senua_contact.patch patches/senua_joint_limit.patch patches/senua_rotation_axis.patch patches/senua_inertia_transport.patch
  for p in senua_contact senua_joint_limit senua_rotation_axis senua_inertia_transport; do check_set "$p" patches/$p.patch; done
  check_set build14 patches/superseded/senua_contact_registration15.patch patches/superseded/senua_joint_limit_registration15.patch patches/senua_rotation_axis.patch patches/senua_inertia_transport.patch
  check_set build13 patches/superseded/senua_contact_registration14.patch patches/superseded/senua_joint_limit_registration14.patch patches/superseded/senua_rotation_axis_registration14.patch patches/superseded/senua_inertia_transport_registration14.patch
  check_set build12 patches/superseded/senua_contact_registration14.patch patches/superseded/senua_joint_limit_registration14.patch patches/superseded/senua_rotation_axis_registration14.patch patches/superseded/senua_inertia_transport_registration12.patch
  check_set registration9 patches/superseded/senua_contact_registration9.patch patches/superseded/senua_joint_limit_registration14.patch patches/superseded/senua_rotation_axis_registration14.patch
  check_set registration7 patches/superseded/senua_contact_registration9.patch
  check_set registration5 patches/superseded/senua_contact_registration5.patch
  # the in-design diff that made build 13 for its probes, on top of build 12, applied in order
  t="$WD/apply_check"; rm -rf "$t"; git clone -q "$WD/superdex-src" "$t"; git -C "$t" checkout -q "$COMMIT"
  git -C "$t" apply "$R/patches/superseded/senua_contact_registration14.patch" "$R/patches/superseded/senua_joint_limit_registration14.patch" "$R/patches/superseded/senua_rotation_axis_registration14.patch" "$R/patches/superseded/senua_inertia_transport_registration12.patch" && git -C "$t" apply --check "$R/patches/in_design/build13_on_top_of_the_registered_patches.patch" && echo "in_design build13 applies on top of build 12" || echo "in_design build13 DOES NOT APPLY on top of build 12"
  rm -rf "$t"
} > $O/patches_apply.txt 2>&1
log "patches checked"

# 2. the libraries: the record's own build scripts, then library build 13
{ time bash validation/run_039_linux_replication/build.sh "$WD" patches; } > $O/build_039.txt 2>&1; log "stock and patched 64-bit built"
{ time bash validation/run_041_corrections_32bit/build32.sh "$WD"; } > $O/build_041.txt 2>&1; log "32-bit built"
{ time bash validation/run_042_two_corrections/build14.sh "$WD" patches; } > $O/build_042.txt 2>&1; log "library build 14 built"
(
  cd "$WD" && export CC=clang CXX=clang++
  # library build 13 is the fourteenth registration's four files
  rm -rf superdex-b13-src && cp -R superdex-src superdex-b13-src
  git -C superdex-b13-src apply "$R/patches/superseded/senua_contact_registration14.patch" "$R/patches/superseded/senua_joint_limit_registration14.patch" \
    "$R/patches/superseded/senua_rotation_axis_registration14.patch" "$R/patches/superseded/senua_inertia_transport_registration14.patch"
  cmake -S superdex-b13-src/superdex_physics -B build-patched13 -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
    -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
    -DMOCHI_USE_DOUBLE_PRECISION=ON > build-patched13.configure.log 2>&1
  cmake --build build-patched13 --target mochi_physics --parallel "$(nproc)" > build-patched13.log 2>&1
  sha256sum build-patched13/bin/libmochi_physics_double* > build-patched13.sha256
) > $O/build_13.txt 2>&1; log "library build 13 built"
libcheck() {  # libcheck <label> <fresh sha256 file> <registered sha256 file>
  local f r; f=$(awk 'NR==1{print $1}' "$2"); r=$(awk 'NR==1{print $1}' "$3")
  if [ "$f" = "$r" ]; then echo "SAME $1 ${f:0:16}"; else echo "DIFFERS $1 fresh ${f:0:16} registered ${r:0:16}"; fi
}
{
  libcheck "stock 64-bit" "$WD/build-stock.sha256" validation/run_039_linux_replication/build-stock.sha256
  libcheck "patched 64-bit (build 15)" "$WD/build-patched.sha256" validation/run_039_linux_replication/build-patched.sha256
  libcheck "stock 32-bit" "$WD/build-stock32.sha256" validation/run_041_corrections_32bit/build-stock32.sha256
  libcheck "patched 32-bit" "$WD/build-patched32.sha256" validation/run_041_corrections_32bit/build-patched32.sha256
  libcheck "library build 14" "$WD/build-patched14.sha256" validation/run_042_two_corrections/build-patched14.sha256
  echo "library build 13 (no Linux build registered) $(awk 'NR==1{print substr($1,1,16)}' "$WD/build-patched13.sha256")"
} > $O/libraries.txt

# 3. the rigs
rig() { SUPERDEX_SRC=$WD/$4 SUPERDEX_BUILD=$WD/$3 SRC=$1 OUT=$2 LIB=$5 tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $2" >> $O/rigs_failed.txt; }
: > $O/rigs_failed.txt
for r in contact pair joint rotvec chain player deform grip; do
  rig sdx_$r.cpp sdx_${r}64 build-patched superdex-patched-src mochi_physics_double
  rig sdx_$r.cpp sdx_${r}64_stock build-stock superdex-src mochi_physics_double
done
rig sdx_contact.cpp sdx_contact64_b14 build-patched14 superdex-b14-src mochi_physics_double
for r in contact pair; do
  rig sdx_$r.cpp sdx_${r}32 build-patched32 superdex-patched-src mochi_physics
  rig sdx_$r.cpp sdx_${r}32_stock build-stock32 superdex-src mochi_physics
done
FM="$WD/build-patched/mochi/mochi_physics/CMakeFiles/mochi_physics.dir/flags.make"
DEFS="$(grep '^CXX_DEFINES' "$FM" | sed 's/^CXX_DEFINES = //; s/-DMOCHI_PHYSICS_EXPORTS=1/-DMOCHI_PHYSICS_EXPORTS=0/; s/-Dmochi_physics_EXPORTS//')"
FLAGS="$(grep '^CXX_FLAGS' "$FM" | sed 's/^CXX_FLAGS = //')"; INCS="$(grep '^CXX_INCLUDES' "$FM" | sed 's/^CXX_INCLUDES = //')"
# shellcheck disable=SC2086
c++ $FLAGS $DEFS $INCS -I "$WD/superdex-patched-src/superdex_physics/include" -o tools/sdx_exit tools/sdx_exit.cpp -ldl || echo "RIG FAILED sdx_exit" >> $O/rigs_failed.txt
sha256sum tools/sdx_*64 tools/sdx_*64_stock tools/sdx_*64_b14 tools/sdx_*32 tools/sdx_*32_stock tools/sdx_exit > $O/rigs.sha256 2>/dev/null
rigcheck() {  # rigcheck <registered rigs file>: each rig it lists, against the fresh one
  awk '{print $1, $2}' "$1" | grep -E 'tools/sdx_' | while read -r h f; do
    n=$(awk -v f="$f" '$2 == f {print $1}' $O/rigs.sha256)
    if [ -z "$n" ]; then echo "NOT BUILT $f ($1)"; elif [ "$n" = "$h" ]; then echo "SAME $f ($1)"; else echo "DIFFERS $f ($1)"; fi
  done
}
{ rigcheck validation/run_040_linux_identity/rigs.sha256; rigcheck validation/run_042_two_corrections/rigs4.sha256; rigcheck validation/run_041_corrections_32bit/rigs.sha256; } > $O/rigs_check.txt
readelf -d tools/sdx_contact64 | grep -E 'RPATH|RUNPATH' > $O/rig_runpath.txt
log "rigs built"

# 4. Studies 19 and 20 again, by their own play scripts
samedir() {  # samedir <label> <fresh folder> <registered folder> [excluded name pattern]: file by file
  local s=0 d=0 n=0 x rel
  while IFS= read -r x; do
    rel="${x#$3/}"
    case "$rel" in ${4:-__none__}) continue ;; esac
    n=$((n + 1)); if [ -f "$2/$rel" ] && cmp -s "$x" "$2/$rel"; then s=$((s + 1)); else d=$((d + 1)); echo "  DIFFERS $1 $rel"; fi
  done < <(find "$3" -type f | sort)
  echo "$1: $s of $n the same"
}
bash tools/plays/play_19.sh "$WD" $O/s19 > $O/play_19.txt 2>&1; log "Study 19 played again"
bash tools/plays/play_20.sh "$WD" $O/s20 > $O/play_20.txt 2>&1; log "Study 20 played again"
mkdir -p $O/s20/plays && for s in 1 2; do mkdir -p $O/s20/plays/s$s && cp -r suites/$s/s20_* $O/s20/plays/s$s/; done
{
  for f in identity.txt exit.txt soft.txt; do if cmp -s $O/s19/$f validation/run_043_study19/$f; then echo "SAME study19 $f"; else echo "DIFFERS study19 $f"; fi; done
  samedir "study19 plays" $O/s19/runs validation/run_043_study19/runs 'valgrind_*'
  for f in identity.txt; do if cmp -s $O/s20/$f validation/run_044_study20/$f; then echo "SAME study20 $f"; else echo "DIFFERS study20 $f"; fi; done
  samedir "study20 plays" $O/s20/plays validation/run_044_study20/runs 'none'
} > $O/studies_19_20.txt
log "Studies 19 and 20 compared"

# 5. the identity check, every part; the review parts give a rig an earlier library with DYLD_LIBRARY_PATH, which
#    Linux does not read, so the contact rig is wrapped to pass it on as LD_LIBRARY_PATH (the rigs carry a RUNPATH)
mv tools/sdx_contact64 tools/sdx_contact64.real
printf '#!/usr/bin/env bash\n[ -n "${DYLD_LIBRARY_PATH:-}" ] && export LD_LIBRARY_PATH="$DYLD_LIBRARY_PATH"\nexec "$(dirname "$0")/sdx_contact64.real" "$@"\n' > tools/sdx_contact64
chmod +x tools/sdx_contact64
SUPERDEX_ASSETS="$WD/superdex-src/assets" SUPERDEX_BUILD13="$WD/build-patched13/bin" \
  tools/play_identity.sh $O/identity.txt rotvec flight suites joints zero fg bench benchrec r032 r034 > $O/play_identity.txt 2>&1
mv tools/sdx_contact64.real tools/sdx_contact64
log "identity check played"

# 6. every reading re-made from the record's own files
bash measure/runners/remake.sh "$R" "$PR" "$WD/remake" full > $O/remake.txt 2>&1; log "readings re-made: $(tail -1 $O/remake.txt)"
log "done"
