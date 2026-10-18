#!/bin/bash
# Fourth registration (PREREGISTRATION_04.md), part A: play the smallest contact scene (one cube, the ground) at every
# registered setting and step. Each play takes well under a second.
# usage: tools/contact_all.sh     (from the repository root)
# needs tools/sdx_contact64, built against SuperDex with MOCHI_USE_DOUBLE_PRECISION=ON:
#   SRC=sdx_contact.cpp OUT=sdx_contact64 LIB=mochi_physics_double SUPERDEX_BUILD=<the 64-bit build> tools/build_player.sh
# writes contact/<test>_<setting>_<k>.txt (k = the shipped 10 ms step divided by k) and
# validation/run_010_contact/stats.txt (the solver's own status of every play).
# The registered cube: 2 kg, half-size 0.04 m. Registered constants: drop height 0.08 m; contact damping 5.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
T="$ROOT/tools/sdx_contact64"
OUT="$ROOT/contact"; REC="$ROOT/validation/run_010_contact"
mkdir -p "$OUT" "$REC"
: > "$REC/stats.txt"
CUBE="mass=2 radius=0.04"
dt_of() { echo "scale=12; 0.01/$1" | bc; }
play() {  # play <name> <k> <settings...>
  local name="$1" k="$2"; shift 2
  # shellcheck disable=SC2086
  "$T" "$OUT/${name}_$k.txt" dt="$(dt_of "$k")" $CUBE "$@" | sed "s/^STATS/STATS run ${name}_$k/" >> "$REC/stats.txt"
}
for k in 1 2 4 8 16 32 64; do
  # DROP: released 0.08 m above the ground, no friction. The right answer: it comes back to 0.08 m.
  play drop_shipped $k h0=0.08 secs=0.5
  play drop_dirk33 $k h0=0.08 secs=0.5 integ=dirk33
  play drop_damped $k h0=0.08 secs=0.5 ndamp=5
  # OBLIQUE IMPACT: the same drop with 4 m/s sideways, friction 0.4, rotation held. The right answer: the
  # horizontal speed lost is 0.4 times the vertical speed the ground gives.
  play oblique_shipped $k h0=0.08 secs=0.3 vx0=4 mu=0.4
  play oblique_implicit $k h0=0.08 secs=0.3 vx0=4 mu=0.4 implicitn=1
  # (reported) the same impact with contact damping, with and without the implicit normal force
  play oblique_damped $k h0=0.08 secs=0.3 vx0=4 mu=0.4 ndamp=5
  play oblique_dampedimplicit $k h0=0.08 secs=0.3 vx0=4 mu=0.4 ndamp=5 implicitn=1
  # REFINEMENT CHAIN: the same drop with 1.5 m/s sideways, friction 0.4, played 1 s.
  play chain_shipped $k h0=0.08 secs=1 vx0=1.5 mu=0.4
  play chain_damped $k h0=0.08 secs=1 vx0=1.5 mu=0.4 ndamp=5
  play chain_freefall $k h0=10 secs=1 vx0=1.5 mu=0.4
done
# STEADY SLIDING (control): set on the ground at 5 m/s, friction 0.4. The right answer: friction is 0.4 of the normal force.
play slide_shipped 1 h0=0 secs=0.5 vx0=5 mu=0.4
play slide_shipped 16 h0=0 secs=0.5 vx0=5 mu=0.4
# CREEP: set on the ground, friction 0.5 (it can hold 9.8 N), pushed with 5.88 N. The right answer: it does not move.
play creep_shipped 1 h0=0 secs=1 mu=0.5 push=5.88
play creep_cinf 1 h0=0 secs=1 mu=0.5 push=5.88 fricmodel=cinf
play creep_implicit 1 h0=0 secs=1 mu=0.5 push=5.88 implicitn=1
play creep_expnormals 1 h0=0 secs=1 mu=0.5 push=5.88 expnormals=1
play creep_nofade 1 h0=0 secs=1 mu=0.5 push=5.88 fade=0
play creep_armijo 1 h0=0 secs=1 mu=0.5 push=5.88 armijo=1
play creep_falloff001 1 h0=0 secs=1 mu=0.5 push=5.88 falloff=0.001
play creep_viscous100 1 h0=0 secs=1 mu=0.5 push=5.88 visc=100
(cd "$OUT" && shasum -a 256 ./*.txt > SHA256SUMS)
echo "played $(ls "$OUT"/*.txt | wc -l | tr -d ' ') runs; stopped steps in: $(grep -c -v ' stopped 0 ' "$REC/stats.txt") of them"
