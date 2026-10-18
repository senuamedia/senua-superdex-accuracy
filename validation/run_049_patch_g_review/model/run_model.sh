#!/usr/bin/env bash
# The model's probes: a free two-link chain and a single arm, under BE and BDF2, three variants, steps 1 to 1/64 of
# 10 ms. Probe numbers (none of them registered by any study).
set -u
cd "$(dirname "$0")"
M=./model_chain
CH="links=2 m1=0.9 m2=0.7 h=0.035 a1=0.22 l1=0.45 a2=0.18 q2=-1.1 w1=2.2 w2=1.9 secs=2"
ARM="links=1 m1=1.3 h=0.055 a1=0.33 w1=4.2 secs=1"
PEN="links=1 m1=1.3 h=0.055 a1=0.33 q1=0 secs=2 gravity=1"
SW="links=2 m1=0.9 m2=0.7 h=0.035 a1=0.22 l1=0.45 a2=0.18 q1=0.5 q2=-0.8 secs=2 gravity=1"
for scene in CH ARM PEN SW; do
  eval "set=\$$scene"
  for integ in be bdf2; do for v in 0 1 2; do
    [ "$integ" = be ] && [ "$v" = 2 ] && continue
    for k in 1 4 16 64; do
      dt=$(echo "scale=12; 0.01/$k" | bc)
      # shellcheck disable=SC2086
      echo "$scene $(nice -n 19 $M $set integ=$integ variant=$v dt=$dt)"
    done
  done; done
done
