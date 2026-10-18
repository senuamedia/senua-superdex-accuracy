#!/usr/bin/env bash
# The fifth registration's plays (PREREGISTRATION_05.md). The fifth registration was played from the command line;
# this script was written afterwards, for the seventeenth registration, from what its record says was played: the
# cube of the registration, the settings and switches in each configuration's CONFIG file, and the sources, their
# order and their settings in run 013's statistics. One play after another, one thread.
# usage: bash tools/plays/play_05.sh suites | bench        (from the repository root)
#   suites  the contact suite on the fifth registration's cube under each of its nine configurations: stock on the
#           stock library, the rest on the patched library. Writes suites/1/v5_<configuration>/, whose files are the
#           registered patches/validation/runs/<configuration>/ (its stats.txt is also
#           patches/validation/stats_<configuration>.txt)
#   bench   half_cheetah and ant on the fifth registration's commands (actions/05/): stock at steps 1 to 1/16 (sources
#           sref, t2 .. t16), the recommended configuration (patches A, B and C with contact damping 5) at steps 1 to
#           1/16 (q1 .. q16), and the same with SuperDex's implicitNormalForceForDissipation at the shipped step
#           (qi1). Writes streams/05/<scene>/<source>_enc.pcm and validation/run_013_counts/stats_<scene>.txt. A source
#           already played (its stream and its STATS line exist) is skipped.
# Needs: tools/sdx_contact64 and tools/sdx_contact64_stock (suites), tools/sdx_player64 and tools/sdx_player64_stock
# (bench); SUPERDEX_ASSETS = the assets directory of the SuperDex source tree (bench).
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
clear_switches() { unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL; }
ABC="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003"
case "${1:-}" in
suites)
  # the registered cube: 0.5 kg, half-size 0.03 m; dropped 0.12 m; the oblique impact at 3 m/s with friction 0.3; the
  # chain at 1 m/s; the steady slide at 4 m/s; hold and slip with friction 0.6, pushed with 1.764 N and 3.528 N;
  # lifted with 14.7 N
  export SUITE_CUBE="mass=0.5 radius=0.03" SUITE_H0=0.12 SUITE_VX=3 SUITE_VXCHAIN=1 SUITE_MU=0.3 SUITE_VSLIDE=4 SUITE_MUHOLD=0.6 SUITE_HOLD=1.764 SUITE_SLIP=3.528 SUITE_LIFT=14.7
  conf() {  # conf <configuration> <rig suffix: _stock or empty> <switches or -> <rig settings...>
    local label="$1" suf="$2" envs="$3"; shift 3
    ( clear_switches
      if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
      cd "$R" || exit 2
      RIG="$R/tools/sdx_contact64$suf" tools/contact_suite.sh "v5_$label" "$@" || exit 1
    ) > /dev/null 2>&1 || echo "PLAY FAILED $label"
    echo "played $label"
  }
  conf stock _stock -
  conf patched_off "" -
  conf implicit "" - implicitn=1
  conf damped "" - ndamp=5
  conf damped_a "" "SUPERDEX_FRICTION_FULL_NORMAL=1" ndamp=5
  conf damped_ab "" "SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1" ndamp=5
  conf stick "" "SUPERDEX_STICK_DISTANCE=0.0003"
  conf recommended "" "$ABC" ndamp=5
  conf recommended_implicit "" "$ABC" ndamp=5 implicitn=1
  ;;
bench)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  O="$R/validation/run_013_counts"; mkdir -p "$O"
  for sc in half_cheetah ant; do
    mkdir -p "$R/streams/05/$sc" "$R/work/05/$sc"; stats="$O/stats_$sc.txt"; touch "$stats"
    while read -r src lib settings; do
      [ -z "$src" ] && continue
      suf=""; envs="-"; case $lib in stock) suf=_stock ;; abc) envs="$ABC" ;; esac
      if [ -f "$R/streams/05/$sc/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then continue; fi
      ( clear_switches
        if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
        # shellcheck disable=SC2086
        "$R/tools/sdx_player64$suf" "$sc" "$A" "$R/actions/05/$sc.txt" "$R/work/05/$sc/$src" $settings < /dev/null > "$R/work/05/$sc/$src.out" 2>&1 )
      sed "s/^STATS/STATS source $src/" "$R/work/05/$sc/$src.out" | grep '^STATS' >> "$stats"
      mv "$R/work/05/$sc/${src}_enc.pcm" "$R/streams/05/$sc/${src}_enc.pcm"
      tail -1 "$stats" | cut -c1-160
    done <<'SOURCES'
sref  stock  integ=be maxiter=200
t2    stock  integ=be maxiter=200 sub=2
t4    stock  integ=be maxiter=200 sub=4
t8    stock  integ=be maxiter=200 sub=8
t16   stock  integ=be maxiter=200 sub=16
q1    abc    integ=be maxiter=200 ndamp=5
q2    abc    integ=be maxiter=200 ndamp=5 sub=2
q4    abc    integ=be maxiter=200 ndamp=5 sub=4
q8    abc    integ=be maxiter=200 ndamp=5 sub=8
q16   abc    integ=be maxiter=200 ndamp=5 sub=16
qi1   abc    integ=be maxiter=200 ndamp=5 implicitn=1
SOURCES
  done
  (cd "$R/streams/05" && shasum -a 256 */*.pcm > SHA256SUMS)
  ;;
*) echo "usage: bash tools/plays/play_05.sh suites | bench" >&2; exit 2 ;;
esac
