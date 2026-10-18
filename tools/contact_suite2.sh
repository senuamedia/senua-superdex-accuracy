#!/bin/bash
# The second contact suite: known-answer runs about a slide that ends and about two moving bodies, played under ONE
# configuration of SuperDex. It adds to tools/contact_suite.sh what that suite did not ask: does a cube that slides
# to a stop stay stopped, and is contact right between two cubes that both move.
# usage: tools/contact_suite2.sh <label> [rig setting ...]        (from the repository root)
#   the rig settings are applied to every run (for example: ndamp=5)
#   the library's patch switches are environment variables and are inherited:
#     SUPERDEX_STICK_DISTANCE=<m>  SUPERDEX_STICK_DAMPING=1  SUPERDEX_FRICTION_FULL_NORMAL=1  SUPERDEX_DAMPING_UNILATERAL=1
#   RIG=<binary> and RIGPAIR=<binary> select the rigs (default tools/sdx_contact64 and tools/sdx_pair64)
# writes suites/2/<label>/<run>_<k>.txt (one cube) and <run>_<k>_a.txt, <run>_<k>_b.txt (two cubes), k = the 10 ms step
# divided by k, with suites/2/<label>/stats.txt and suites/2/<label>/CONFIG.
# Each play takes a few seconds at most.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LABEL="${1:?usage: tools/contact_suite2.sh <label> [rig setting ...]}"
shift
EXTRA="$*"
T="${RIG:-$ROOT/tools/sdx_contact64}"
TP="${RIGPAIR:-$ROOT/tools/sdx_pair64}"
OUT="$ROOT/suites/2/$LABEL"
mkdir -p "$OUT"
: > "$OUT/stats.txt"
{
  echo "rig settings: ${EXTRA:-none}"
  echo "SUPERDEX_STICK_DISTANCE=${SUPERDEX_STICK_DISTANCE:-unset}"
  echo "SUPERDEX_STICK_DAMPING=${SUPERDEX_STICK_DAMPING:-unset}"
  echo "SUPERDEX_FRICTION_FULL_NORMAL=${SUPERDEX_FRICTION_FULL_NORMAL:-unset}"
  echo "SUPERDEX_DAMPING_UNILATERAL=${SUPERDEX_DAMPING_UNILATERAL:-unset}"
} > "$OUT/CONFIG"
# The scenes. The defaults are the design probe's; a registration sets its own.
CUBE="${S2_CUBE:-mass=1 radius=0.05}"
MU="${S2_MU:-0.4}"                 # friction of the one cube and the ground
VSTOP="${S2_VSTOP:-1.2}"           # speed the one cube is set sliding at, m/s
H0="${S2_H0:-0.1}"                 # height the one cube is dropped from in the landing run, m
PAIR="${S2_PAIR:-massa=3 ra=0.4 massb=0.4 rb=0.025}"
MUP="${S2_MUP:-0.5}"               # friction between the two cubes (the ground under A has none)
CARRY="${S2_CARRY:-8.33}"          # the push on A that B should ride, N: half of what friction can carry B at
SLIP="${S2_SLIP:-24.99}"           # the push on A that B cannot ride, N: one and a half times it
VSIDE="${S2_VSIDE:-1.5}"           # B's speed into A's side, m/s
VTOP="${S2_VTOP:-1}"               # B's speed when it is released sliding on top of A, m/s
dt_of() { echo "scale=12; 0.01/$1" | bc; }
play() {  # play <name> <k> <settings...>: one cube
  local name="$1" k="$2"; shift 2
  # shellcheck disable=SC2086
  "$T" "$OUT/${name}_$k.txt" dt="$(dt_of "$k")" $CUBE "$@" $EXTRA | sed "s/^STATS/STATS run ${name}_$k/" >> "$OUT/stats.txt"
}
pair() {  # pair <name> <k> <settings...>: two cubes
  local name="$1" k="$2"; shift 2
  # shellcheck disable=SC2086
  "$TP" "$OUT/${name}_$k" dt="$(dt_of "$k")" $PAIR "$@" $EXTRA | sed "s/^STATS/STATS run ${name}_$k/" >> "$OUT/stats.txt"
}
for k in 1 4 16 64; do
  play stop $k h0=0 secs=1.5 vx0=$VSTOP mu=$MU      # set sliding on the ground: it stops, and stays stopped
  play land $k h0=$H0 secs=1.5 vx0=$VSTOP mu=$MU    # dropped while moving sideways: it lands, stops, and stays stopped
done
for k in 1 16; do
  pair rest $k layout=stack mu=$MUP secs=1                                # B on A on the ground: each contact carries its weight
  pair carry $k layout=stack mu=$MUP pusha=$CARRY pushat=0.5 secs=2       # A pushed gently: B rides with it
  pair slip $k layout=stack mu=$MUP pusha=$SLIP pushat=0.5 secs=0.9       # A pushed hard: B slips at the friction limit
  pair side $k layout=side vxb=$VSIDE secs=0.5                            # B runs into A's side: momentum is kept
  pair top $k layout=stack mu=$MUP vxb=$VTOP secs=1.5                     # B slides on top of A: momentum is kept, they end together
done
echo "played $(ls "$OUT"/*_[0-9]*.txt | wc -l | tr -d ' ') files under: ${EXTRA:-shipped settings}"
