#!/usr/bin/env bash
# Dry run of the sixteenth registration, throwaway numbers only: the corrections part (a cube of 1 kg, half-size 0.04 m,
# friction 0.5, pushed with 2.94 N from 0.5 s, teleported 3 mm at 1 s; a viscous landing from 0.04 m at 2 m/s with no
# Coulomb friction and viscous coefficient 0.3, with and without patch F, steps 1 and 1/2) on builds 15 and 14; and one
# 32-bit source with a setting no study used (cart_pole, maxiter=3) on the new 32-bit rig and on the stock 32-bit rig.
S="<a scratch folder>"   # as played: a local scratch folder
R="<the repository root>"; B="<sx_contact, built from measure/sx_contact.sx>"   # as played: the local checkout and the measuring program
O=$S/dry16; mkdir -p $O; B14="<library build 14 folder>"   # as played: a local folder
fin() { export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1; }
C="mass=1 radius=0.04 ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8 sdfdiv=32"
for lib in b15 b14; do
  L=""; [ $lib = b14 ] && L="$B14"
  run() { local name="$1"; shift
    if [ -n "$L" ]; then DYLD_LIBRARY_PATH="$L" "$R/tools/sdx_contact64" $O/${lib}_$name.txt $C "$@" > $O/${lib}_$name.stats 2>&1; else "$R/tools/sdx_contact64" $O/${lib}_$name.txt $C "$@" > $O/${lib}_$name.stats 2>&1; fi; }
  fin
  run hold dt=0.01 h0=0 secs=2 mu=0.5 push=2.94 pushat=0.5
  run teleport dt=0.01 h0=0 secs=2 mu=0.5 push=2.94 pushat=0.5 teleport=1 teleportdx=0.003
  for k in 1 2; do
    dt=$(echo "scale=12; 0.01/$k" | bc)
    run visc_f_$k dt=$dt h0=0.04 vx0=2 secs=0.3 mu=0 visc=0.3
    unset SUPERDEX_FRICTION_STEP_NORMAL
    run visc_nof_$k dt=$dt h0=0.04 vx0=2 secs=0.3 mu=0 visc=0.3
    fin
  done
  echo "$lib hold | $("$B" creep $O/${lib}_hold.txt | tail -1 | cut -c1-120)"
  echo "$lib teleport | $("$B" creep $O/${lib}_teleport.txt | tail -1 | cut -c1-120)"
  for k in 1 2; do cmp -s $O/${lib}_visc_f_$k.txt $O/${lib}_visc_nof_$k.txt && echo "$lib visc 1/$k identical" || echo "$lib visc 1/$k differ"; done
  echo "$lib stopped/diverged: $(cat $O/${lib}_*.stats | awk '{for(i=1;i<NF;i++) if($i=="stopped"||$i=="diverged") s[$i]+=$(i+1)} END {print s["stopped"]+0, s["diverged"]+0}')"
done
unset SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT
A="<SuperDex assets>"   # as played: the assets of the SuperDex checkout
"$R/tools/sdx_player32" cart_pole $A $R/actions/01/cart_pole.txt $O/p32 integ=be maxiter=3 < /dev/null > $O/p32.out 2>&1
"$R/tools/sdx_player" cart_pole $A $R/actions/01/cart_pole.txt $O/pstock integ=be maxiter=3 < /dev/null > $O/pstock.out 2>&1
cmp -s $O/p32_enc.pcm $O/pstock_enc.pcm && echo "32-bit rig on build 15 = stock 32-bit rig (cart_pole maxiter 3)" || echo "32-bit: differ"
rm -f $O/p32_state.f32 $O/pstock_state.f32
echo "dry16 done"
