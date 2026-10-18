#!/usr/bin/env bash
# Probe: BDF2 on articulated bodies, three libraries (stock; cur = library build 15, patch G as recorded; g2 = patch G
# as proposed), steps 1 to 1/64 of 10 ms. Probe numbers only (none registered by any study).
#   chainA, chainB  free two-link chains, no gravity, 2 s
#   swing           a swinging chain under gravity, released at rest, 2 s
#   arm             a free arm spinning at 4.2 rad/s, no gravity, 1 s
#   pend            a pendulum released level, gravity, 3 s
# Newton-Euler inertia on, patch G's switch set for cur and g2 (and no switch for stock). Tolerances: tight
# (absolute 1e-9, relative 1e-12) unless TOL is given.
# usage: probe_bdf2.sh <integ> [tolerance settings]
set -u
cd "$(dirname "$0")/../rigs"
INTEG="${1:-bdf2}"; TOL="${2:-abstol=1e-9 reltol=1e-12}"
CHA="links=2 mass1=0.9 mass2=0.7 radius=0.035 arm1=0.22 len1=0.45 arm2=0.18 angle2=-1.1 omega1=2.2 omega2=1.9 secs=2 gravity=0"
CHB="links=2 mass1=1.6 mass2=0.45 radius=0.03 arm1=0.3 len1=0.6 arm2=0.15 angle1=0.3 angle2=0.7 omega1=-1.8 omega2=3.1 secs=2 gravity=0"
SW="links=2 mass1=0.9 mass2=0.7 radius=0.035 arm1=0.22 len1=0.45 arm2=0.18 angle1=0.5 angle2=-0.8 secs=2 gravity=1"
ARM="links=1 mass1=1.3 radius=0.055 arm1=0.33 omega1=4.2 secs=1 gravity=0"
PEN="links=1 mass1=1.3 radius=0.055 arm1=0.33 angle1=0 secs=3 gravity=1"
for scene in chainA chainB swing arm pend; do
  case $scene in chainA) SET=$CHA ;; chainB) SET=$CHB ;; swing) SET=$SW ;; arm) SET=$ARM ;; pend) SET=$PEN ;; esac
  for lib in stock cur g2 g3; do
    for k in 1 2 4 8 16 32 64; do
      dt=$(echo "scale=12; 0.01/$k" | bc)
      if [ $lib = stock ]; then sw=""; else sw="SUPERDEX_INERTIA_TRANSPORT=1"; fi
      # shellcheck disable=SC2086
      echo "$scene $lib 1/$k $(env $sw nice -n 5 ./$lib/sdx_probe64 $SET integ=$INTEG newtoneuler=1 $TOL dt=$dt)"
    done
  done
done
