#!/usr/bin/env bash
# The eleventh registration's plays (PREREGISTRATION_11.md): friction at an impact, and the correction that gives
# Coulomb friction the normal force of the step being solved. One play after another, one thread.
# usage: tools/plays/play_11.sh suites | bench        (from the repository root)
#   suites    both contact suites on the registered cubes, under: the recommended configuration (patches A to E;
#             label rec), the same with the friction correction (rec_f), and the friction correction alone on
#             stock contact (f_only, reported)
#   bench     the three scenes at the shipped step under the recommended configuration (source r1) and with the
#             friction correction added (f1); then half_cheetah and ant at steps 1 to 1/16 with it added (sources
#             f1, f2, f4, f8, f16); commands: the fifth registration's (half_cheetah, ant) and the third's
#             (cart_pole); the solver's trace of every step is kept beside each play
# Needs: the patched rigs; SUPERDEX_ASSETS = the assets directory of the SuperDex source tree (bench only).
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
O="$R/validation/run_027_friction"; mkdir -p "$O"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
AB="SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1"
CD="SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1"
E="SUPERDEX_ROTATION_AXIS_EXACT=1"
D="SUPERDEX_LIMIT_UNILATERAL=1"
F="SUPERDEX_FRICTION_STEP_NORMAL=1"
case "${1:-}" in
suites)
  # the registered cubes
  export SUITE_CUBE="mass=1.4 radius=0.03" SUITE_H0=0.09 SUITE_VX=3 SUITE_VXCHAIN=1.1 SUITE_MU=0.3 SUITE_VSLIDE=2.5 SUITE_MUHOLD=0.4 SUITE_HOLD=3.2928 SUITE_SLIP=6.5856 SUITE_LIFT=41.16
  export S2_CUBE="mass=1.4 radius=0.03" S2_MU=0.3 S2_VSTOP=1.1 S2_H0=0.05 S2_PAIR="massa=3 ra=0.25 massb=0.5 rb=0.03" S2_MUP=0.45 S2_CARRY=7.7175 S2_SLIP=23.1525 S2_VSIDE=1 S2_VTOP=0.7
  conf() {  # conf <label> <switches or -> <rig settings...>
    local label="$1" envs="$2"; shift 2
    ( clear_switches
      if [ "$envs" != "-" ]; then for kv in $envs; do export "$kv"; done; fi
      cd "$R" || exit 2
      RIG="$R/tools/sdx_contact64" tools/contact_suite.sh "v11_$label" "$@" || exit 1
      RIG="$R/tools/sdx_contact64" RIGPAIR="$R/tools/sdx_pair64" tools/contact_suite2.sh "v11_$label" "$@" || exit 1
    ) > /dev/null 2>&1 || echo "PLAY FAILED $label"
    mkdir -p "$O/runs/s1/$label" "$O/runs/s2/$label"
    cp "$R/suites/1/v11_$label"/* "$O/runs/s1/$label/"; cp "$R/suites/2/v11_$label"/* "$O/runs/s2/$label/"
    echo "played $label"
  }
  conf rec "$AB $CD $E" ndamp=5 falloff=0.03
  conf rec_f "$AB $CD $E $F" ndamp=5 falloff=0.03
  conf f_only "$F"
  ;;
bench)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  one() {  # one <scene> <source> <commands file> <settings...>
    local sc="$1" src="$2" act="$3"; shift 3
    mkdir -p "$R/streams/11/$sc" "$R/work/11/$sc"; local stats="$O/stats_$sc.txt"; touch "$stats"
    if [ -f "$R/streams/11/$sc/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then return; fi
    SDX_TRACE="$R/work/11/$sc/$src.tr" "$R/tools/sdx_player64" "$sc" "$A" "$act" "$R/work/11/$sc/$src" integ=be maxiter=200 "$@" < /dev/null > "$R/work/11/$sc/$src.out" 2>&1
    sed "s/^STATS/STATS source $src/" "$R/work/11/$sc/$src.out" | grep '^STATS' >> "$stats"
    mv "$R/work/11/$sc/${src}_enc.pcm" "$R/streams/11/$sc/${src}_enc.pcm"
    mkdir -p "$O/traces/$sc"; cp "$R/work/11/$sc/$src.tr" "$O/traces/$sc/$src.tr"
    tail -1 "$stats" | cut -c1-170
  }
  act() { if [ "$1" = cart_pole ]; then echo "$R/actions/03/$1.txt"; else echo "$R/actions/05/$1.txt"; fi; }
  clear_switches; export $AB $CD $E $D
  for sc in half_cheetah ant cart_pole; do one $sc r1 "$(act $sc)" ndamp=5 falloff=0.03; done
  export $F
  for sc in half_cheetah ant cart_pole; do one $sc f1 "$(act $sc)" ndamp=5 falloff=0.03; done
  for sc in half_cheetah ant; do for k in 2 4 8 16; do one $sc f$k "$R/actions/05/$sc.txt" ndamp=5 falloff=0.03 sub=$k; done; done
  (cd "$R/streams/11" && shasum -a 256 */*.pcm > SHA256SUMS)
  clear_switches
  ;;
*) echo "usage: tools/plays/play_11.sh suites | bench"; exit 2 ;;
esac
