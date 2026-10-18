#!/bin/bash
# Sixth registration (PREREGISTRATION_06.md): play the smallest jointed scene (one arm on one revolute joint, nothing
# touching it) on STOCK SuperDex at every registered setting. Each play takes well under a second.
# usage: tools/joint_all.sh     (from the repository root)
# needs tools/sdx_joint64_stock, built against an unpatched SuperDex with MOCHI_USE_DOUBLE_PRECISION=ON:
#   SRC=sdx_joint.cpp OUT=sdx_joint64_stock LIB=mochi_physics_double SUPERDEX_BUILD=<the 64-bit build> tools/build_player.sh
# writes joints/<test>_<setting>_<k>.txt (k = the shipped 10 ms step divided by k) and
# validation/run_015_joints/stats.txt (the solver's own status of every play).
# The registered arm: a cube of 2 kg and half-size 0.04 m whose centre is 0.4 m from the joint.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
T="${RIG:-$ROOT/tools/sdx_joint64_stock}"
OUT="$ROOT/joints"; REC="$ROOT/validation/run_015_joints"
mkdir -p "$OUT" "$REC"
: > "$REC/stats.txt"
ARM="mass=2 radius=0.04 arm=0.4"
dt_of() { echo "scale=12; 0.01/$1" | bc; }
play() {  # play <name> <k> <settings...>
  local name="$1" k="$2"; shift 2
  # shellcheck disable=SC2086
  "$T" "$OUT/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" | sed "s/^STATS/STATS run ${name}_$k/" >> "$REC/stats.txt"
}
for k in 1 4 16 64; do
  play spin_be $k gravity=0 omega0=3 secs=1          # JT1: a free arm keeps its speed
  play torque_be $k gravity=0 torque=1.5 secs=1      # JT2: a driven arm gains torque x time / inertia
  play swing_be $k secs=3                            # JT3: a pendulum released level comes up level
done
for integ in bdf2 dirk33; do                         # reported: the higher-order integrators at the shipped step
  play spin_$integ 1 gravity=0 omega0=3 secs=1 integ=$integ
  play torque_$integ 1 gravity=0 torque=1.5 secs=1 integ=$integ
  play swing_$integ 1 secs=3 integ=$integ
done
for w in 1 2 4 8; do play spinrate$w 1 gravity=0 omega0=$w secs=1; done     # reported: the loss against the speed
for k in 1 16; do
  play hold_shipped $k coulomb=12 secs=2                               # JT4: joint friction holds a level arm
  play hold_tight $k coulomb=12 secs=2 falloff=0.000001
  play slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1             # JT5: above the friction limit it slips on time
  play slip_tight $k gravity=0 coulomb=2 torque=3 secs=1 falloff=0.000001
done
(cd "$OUT" && shasum -a 256 ./*.txt > SHA256SUMS)
echo "played $(ls "$OUT"/*.txt | wc -l | tr -d ' ') runs; stopped steps in: $(grep -c -v ' stopped 0 ' "$REC/stats.txt") of them"
