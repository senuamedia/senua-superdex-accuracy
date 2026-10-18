#!/usr/bin/env bash
# Two probes, probe numbers only:
#  tilt: the two-link chain with its second joint axis tilted 0.6 rad from z towards x (a 3D chain), BDF2 and backward
#        Euler, tight tolerances, steps 1, 1/4, 1/16, 1/64: angular momentum about z and kinetic energy, read from
#        SuperDex's link states (cubes: isotropic inertia), on stock, build 15 and g3.
#  32:   the planar chain and the free arm in SuperDex's shipped 32-bit precision, configuration tolerances, on build 15
#        (32-bit), g3 (32-bit) and stock (32-bit, arm only).
set -u
cd "$(dirname "$0")/../rigs"
CH="links=2 mass1=0.9 mass2=0.7 radius=0.035 arm1=0.22 len1=0.45 arm2=0.18 angle2=-1.1 omega1=2.2 omega2=1.9 secs=2 gravity=0 newtoneuler=1"
ARM="links=1 mass1=1.3 radius=0.055 arm1=0.33 omega1=4.2 secs=1 gravity=0 newtoneuler=1"
for integ in bdf2 be; do for l in stock cur g3; do for k in 1 4 16 64; do
  [ $integ = be ] && [ $l = g3 ] && continue
  dt=$(echo "scale=12; 0.01/$k" | bc); sw="SUPERDEX_INERTIA_TRANSPORT=1"; [ $l = stock ] && sw=""
  # shellcheck disable=SC2086
  echo "tilt $integ $l 1/$k $(env $sw nice -n 5 ./$l/sdx_probe3d64 $CH abstol=1e-9 reltol=1e-12 tilt=0.6 integ=$integ dt=$dt)"
done; done; done
for sc in CH ARM; do eval "set=\$$sc"; for integ in bdf2 be; do for l in cur32 g332 stock32; do for k in 1 4 16 64; do
  [ $l = stock32 ] && [ $sc = CH ] && continue
  dt=$(echo "scale=12; 0.01/$k" | bc); sw="SUPERDEX_INERTIA_TRANSPORT=1"; [ $l = stock32 ] && sw=""
  # shellcheck disable=SC2086
  echo "32bit $sc $integ $l 1/$k $(env $sw nice -n 5 ./$l/sdx_probe32 $set abstol=1e-4 reltol=1e-8 integ=$integ dt=$dt)"
done; done; done; done
