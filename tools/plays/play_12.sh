#!/usr/bin/env bash
# The twelfth registration's plays (PREREGISTRATION_12.md): the loss on joint motion, and the two corrections that
# remove it (patch G, and SuperDex's own Newton-Euler inertia). One play after another, one thread.
# usage: tools/plays/play_12.sh arm | chain | joints | bench <with_f|without_f>        (from the repository root)
#   arm      one arm on one joint, no gravity, released at 1.5, 3.5 and 6 rad/s, 1 s, steps 1, 1/4 and 1/16, under:
#            stock (the stock library), Newton-Euler inertia alone (ne), patch G alone (g), both (neg)
#   chain    two arms on two joints, free and swinging, 2 s, steps 1, 1/4 and 1/16, under: no switch (off), each
#            correction alone (ne, g), both at the shipped tolerances (neg), and for the free chain both at tight
#            tolerances (neg_tight)
#   joints   the sixth registration's 38 one-joint runs with both corrections
#   bench    the three scenes at the shipped step with both corrections added to the configuration as it stands
#            (source g1), then half_cheetah and ant at steps 1 to 1/16 (g1, g2, g4, g8, g16). with_f: the
#            configuration is patches A to F; without_f: patches A to E. Commands: the fifth registration's
#            (half_cheetah, ant) and the third's (cart_pole)
# Needs: the patched rigs, tools/sdx_joint64_stock and tools/sdx_chain64; SUPERDEX_ASSETS (bench only).
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
O="$R/validation/run_028_joint_motion"; mkdir -p "$O"
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
dt_of() { echo "scale=12; 0.01/$1" | bc; }
G="SUPERDEX_INERTIA_TRANSPORT=1"
setup() {  # setup <configuration>: the rig suffix in SUF, the Newton-Euler setting in NE, patch G in the environment
  clear_switches; SUF=""; NE=0
  case "$1" in
    stock) SUF="_stock" ;;
    off) ;;
    ne) NE=1 ;;
    g) export $G ;;
    neg|neg_tight) NE=1; export $G ;;
  esac
}
case "${1:-}" in
arm)
  ARM="mass=2.4 radius=0.05 arm=0.45"
  for cfg in stock ne g neg; do
    setup $cfg; W="$O/arm/$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    for w in 1.5 3.5 6; do for k in 1 4 16; do
      ne=""; [ "$cfg" != stock ] && ne="newtoneuler=$NE"
      # shellcheck disable=SC2086
      SDX_TRACE="$W/spin${w}_$k.tr" "$R/tools/sdx_joint64$SUF" "$W/spin${w}_$k.txt" dt="$(dt_of "$k")" $ARM gravity=0 omega0=$w secs=1 $ne \
        | sed "s/^STATS/STATS run spin${w}_$k/" >> "$W/stats.txt"
    done; done
  done
  clear_switches
  ;;
chain)
  ARMS="mass1=1.2 mass2=0.6 radius=0.04 arm1=0.25 len1=0.5 arm2=0.2"
  FREE="gravity=0 angle2=-0.9 omega1=2.5 omega2=1.5 secs=2"
  SWING="gravity=1 angle1=0.4 angle2=-0.7 secs=2"
  for cfg in off ne g neg neg_tight; do
    setup $cfg; W="$O/chain/$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    TOL=""; [ "$cfg" = neg_tight ] && TOL="abstol=1e-9 reltol=1e-12"
    for case in free swing; do
      [ "$cfg" = neg_tight ] && [ "$case" = swing ] && continue
      SET="$FREE"; [ "$case" = swing ] && SET="$SWING"
      for k in 1 4 16; do
        # shellcheck disable=SC2086
        SDX_TRACE="$W/${case}_$k.tr" "$R/tools/sdx_chain64" "$W/${case}_$k.txt" dt="$(dt_of "$k")" $ARMS $SET newtoneuler=$NE $TOL \
          | sed "s/^STATS/STATS run ${case}_$k/" >> "$W/stats.txt"
      done
    done
  done
  clear_switches
  ;;
joints)
  # the sixth registration's arm and its runs, with both corrections
  setup neg; W="$O/joints_neg"; mkdir -p "$W"; : > "$W/stats.txt"
  ARM="mass=2 radius=0.04 arm=0.4"
  play() {  # play <name> <k> <settings...>
    local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    "$R/tools/sdx_joint64" "$W/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" newtoneuler=1 | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"
  }
  for k in 1 4 16 64; do play spin_be $k gravity=0 omega0=3 secs=1; play torque_be $k gravity=0 torque=1.5 secs=1; play swing_be $k secs=3; done
  for integ in bdf2 dirk33; do play spin_$integ 1 gravity=0 omega0=3 secs=1 integ=$integ; play torque_$integ 1 gravity=0 torque=1.5 secs=1 integ=$integ; play swing_$integ 1 secs=3 integ=$integ; done
  for w in 1 2 4 8; do play spinrate$w 1 gravity=0 omega0=$w secs=1; done
  for k in 1 16; do
    play hold_shipped $k coulomb=12 secs=2; play hold_tight $k coulomb=12 secs=2 falloff=0.000001
    play slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; play slip_tight $k gravity=0 coulomb=2 torque=3 secs=1 falloff=0.000001
  done
  clear_switches
  ;;
bench)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  BASE="${2:?usage: tools/plays/play_12.sh bench <with_f|without_f>}"
  one() {  # one <scene> <source> <commands file> <settings...>
    local sc="$1" src="$2" act="$3"; shift 3
    mkdir -p "$R/streams/12/$sc" "$R/work/12/$sc"; local stats="$O/stats_$sc.txt"; touch "$stats"
    if [ -f "$R/streams/12/$sc/${src}_enc.pcm" ] && grep -q "^STATS source $src " "$stats"; then return; fi
    SDX_TRACE="$R/work/12/$sc/$src.tr" "$R/tools/sdx_player64" "$sc" "$A" "$act" "$R/work/12/$sc/$src" integ=be maxiter=200 "$@" < /dev/null > "$R/work/12/$sc/$src.out" 2>&1
    sed "s/^STATS/STATS source $src/" "$R/work/12/$sc/$src.out" | grep '^STATS' >> "$stats"
    mv "$R/work/12/$sc/${src}_enc.pcm" "$R/streams/12/$sc/${src}_enc.pcm"
    mkdir -p "$O/traces/$sc"; cp "$R/work/12/$sc/$src.tr" "$O/traces/$sc/$src.tr"
    tail -1 "$stats" | cut -c1-170
  }
  act() { if [ "$1" = cart_pole ]; then echo "$R/actions/03/$1.txt"; else echo "$R/actions/05/$1.txt"; fi; }
  clear_switches
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_LIMIT_UNILATERAL=1
  [ "$BASE" = with_f ] && export SUPERDEX_FRICTION_STEP_NORMAL=1
  echo "$BASE" > "$O/bench_base.txt"
  # the configuration as it stands, without the two corrections (source b1), for the solver's count to compare with
  for sc in half_cheetah ant cart_pole; do one $sc b1 "$(act $sc)" ndamp=5 falloff=0.03; done
  export $G
  for sc in half_cheetah ant cart_pole; do one $sc g1 "$(act $sc)" ndamp=5 falloff=0.03 newtoneuler=1; done
  for sc in half_cheetah ant; do for k in 2 4 8 16; do one $sc g$k "$R/actions/05/$sc.txt" ndamp=5 falloff=0.03 newtoneuler=1 sub=$k; done; done
  (cd "$R/streams/12" && shasum -a 256 */*.pcm > SHA256SUMS)
  clear_switches
  ;;
*) echo "usage: tools/plays/play_12.sh arm | chain | joints | bench <with_f|without_f>"; exit 2 ;;
esac
