#!/usr/bin/env bash
# play_f64.sh <lib> <source>: the same play with the private player that writes the double state (rig/sdx_player_f64)
T=~/work/traceC; n=$1; src=$2
case $src in qi1) settings="integ=be maxiter=200 ndamp=5 implicitn=1" ;; q1) settings="integ=be maxiter=200 ndamp=5" ;; esac
O=$T/plays64/$n; mkdir -p $O
( unset SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003
  LD_LIBRARY_PATH=$T/lib/$n $T/rig/sdx_player_f64 ant $T/superdex-src/assets $T/record/actions/05/ant.txt $O/$src $settings < /dev/null > $O/$src.out 2>&1 )
echo "$n $src enc $(sha256sum $O/${src}_enc.pcm | cut -c1-16) $(grep -o "converged [0-9]* stopped [0-9]* diverged [0-9]*" $O/$src.out)"
