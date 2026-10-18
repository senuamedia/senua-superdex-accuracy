#!/bin/bash
# The contact suite: known-answer runs on the smallest contact scene (one cube, the ground), played under ONE
# configuration of SuperDex. Used to show, patch by patch, that stock SuperDex fails a test with a known right
# answer, that the patch makes it pass, and that nothing else gets worse.
# usage: tools/contact_suite.sh <label> [rig setting ...]        (from the repository root)
#   the rig settings are applied to every run (for example: ndamp=5 implicitn=1)
#   the library's patch switches are environment variables and are inherited:
#     SUPERDEX_STICK_DISTANCE=<m>  SUPERDEX_FRICTION_FULL_NORMAL=1  SUPERDEX_DAMPING_UNILATERAL=1
#   RIG=<binary> selects the rig (default tools/sdx_contact64)
# writes suites/1/<label>/<run>_<k>.txt (k = the 10 ms step divided by k), suites/1/<label>/stats.txt and
# suites/1/<label>/CONFIG (the settings and switches this label was played with).
# Each play takes well under a second.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LABEL="${1:?usage: tools/contact_suite.sh <label> [rig setting ...]}"
shift
EXTRA="$*"
T="${RIG:-$ROOT/tools/sdx_contact64}"
OUT="$ROOT/suites/1/$LABEL"
mkdir -p "$OUT"
: > "$OUT/stats.txt"
{
  echo "rig settings: ${EXTRA:-none}"
  echo "SUPERDEX_STICK_DISTANCE=${SUPERDEX_STICK_DISTANCE:-unset}"
  if [ -n "${SUPERDEX_STICK_DAMPING:-}" ]; then echo "SUPERDEX_STICK_DAMPING=${SUPERDEX_STICK_DAMPING}"; fi
  echo "SUPERDEX_FRICTION_FULL_NORMAL=${SUPERDEX_FRICTION_FULL_NORMAL:-unset}"
  echo "SUPERDEX_DAMPING_UNILATERAL=${SUPERDEX_DAMPING_UNILATERAL:-unset}"
} > "$OUT/CONFIG"
# The scene of the suite. The defaults are the fourth registration's cube; a registration can set its own.
CUBE="${SUITE_CUBE:-mass=2 radius=0.04}"
H0="${SUITE_H0:-0.08}"            # drop height, m
VX="${SUITE_VX:-4}"               # sideways speed of the oblique impact, m/s
VXCHAIN="${SUITE_VXCHAIN:-1.5}"   # sideways speed of the refinement chain, m/s
MU="${SUITE_MU:-0.4}"             # friction of the oblique impact, the chain and the steady slide
VSLIDE="${SUITE_VSLIDE:-5}"       # speed of the steady slide, m/s
MUHOLD="${SUITE_MUHOLD:-0.5}"     # friction of the hold and slip tests
HOLD="${SUITE_HOLD:-5.88}"        # the hold push, N: 0.6 of what friction can hold
SLIP="${SUITE_SLIP:-11.76}"       # the slip push, N: 1.2 of what friction can hold
LIFT="${SUITE_LIFT:-58.8}"        # the lift, N: three times the weight
dt_of() { echo "scale=12; 0.01/$1" | bc; }
play() {  # play <name> <k> <settings...>
  local name="$1" k="$2"; shift 2
  # shellcheck disable=SC2086
  "$T" "$OUT/${name}_$k.txt" dt="$(dt_of "$k")" $CUBE "$@" $EXTRA | sed "s/^STATS/STATS run ${name}_$k/" >> "$OUT/stats.txt"
}
for k in 1 2 4 8 16 32 64; do
  play free $k h0=10 secs=1 vx0=$VXCHAIN mu=$MU           # never reaches the ground: the chain halves
  play drop $k h0=$H0 secs=0.5                             # the bounce must not depend on the step
  play oblique $k h0=$H0 secs=0.3 vx0=$VX mu=$MU          # Coulomb at impact: lost = friction x given
  play chain $k h0=$H0 secs=1 vx0=$VXCHAIN mu=$MU        # the refinement chain is in order
done
for k in 1 16; do
  play slide $k h0=0 secs=0.5 vx0=$VSLIDE mu=$MU          # steady sliding: friction = coefficient x normal
  play rest $k h0=0 secs=2                                 # at rest: the ground carries the weight
  play hold $k h0=0 secs=2 mu=$MUHOLD push=$HOLD pushat=0.5  # set down, then pushed with 0.6 of what friction holds: it does not move
  play slip $k h0=0 secs=2 mu=$MUHOLD push=$SLIP pushat=0.5  # set down, then pushed with 1.2 of it: it accelerates at (push - friction) / mass
  play lift $k h0=0 secs=0.4 lift=$LIFT liftat=0.3         # lifted with three times its weight: the ground never pulls
done
play rebound 16 h0=0.3 secs=0.5 integ=bdf2           # a fast rebound: the ground never pulls
echo "played $(ls "$OUT"/*_[0-9]*.txt | wc -l | tr -d ' ') runs under: ${EXTRA:-shipped settings}"
