#!/usr/bin/env bash
# PROBE ONLY: T05 and T10 (friction over an impact, and over the impact and the 0.1 s after it) on three more probe
# cubes, under the recommended configuration with and without patch F, at the seven registered steps.
W=~/work/probeF; O=$W/rules/impact; B=$W/bin/sx_contact; RG=$W/rigs
REC="ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8 sdfdiv=32"
for cube in "c2 mass=0.9 radius=0.038 h0=0.11 vx0=2.6 mu=0.28" "c3 mass=1.7 radius=0.05 h0=0.06 vx0=1.9 mu=0.38" "c4 mass=0.65 radius=0.032 h0=0.095 vx0=3.2 mu=0.25"; do
  set -- $cube; name=$1; shift
  for cfg in nof f; do
    unset SUPERDEX_FRICTION_STEP_NORMAL
    export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_INERTIA_TRANSPORT=1
    [ $cfg = f ] && export SUPERDEX_FRICTION_STEP_NORMAL=1
    line="$name $* $cfg | T05"; line10=" | T10"; stops=0
    for k in 1 2 4 8 16 32 64; do dt=$(echo "scale=12; 0.01/$k" | bc)
      $RG/sdx_contact64_b15 $O/${name}_${cfg}_$k.txt dt=$dt "$@" secs=0.3 $REC > $O/${name}_${cfg}_$k.stats 2>&1
      $RG/sdx_contact64_b15 $O/${name}_${cfg}_${k}_long.txt dt=$dt "$@" secs=0.3 $REC > /dev/null 2>&1
      l="$($B impact $O/${name}_${cfg}_$k.txt)"
      line="$line $(echo "$l" | awk "{print \$11}")"; line10="$line10 $(echo "$l" | awk "{for(i=1;i<=NF;i++) if (\$i==\"friction_over_impact_and_after_per_10000\") print \$(i+1)}")"
      stops=$((stops + $(grep -o "stopped [0-9]*" $O/${name}_${cfg}_$k.stats | awk "{print \$2}")))
    done
    echo "$line$line10 | suite stops $stops"
  done
done
