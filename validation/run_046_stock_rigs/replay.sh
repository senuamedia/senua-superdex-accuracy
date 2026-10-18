#!/bin/bash
# replay.sh <stock|b15>: every registered play of the record made with sdx_chain64, sdx_deform64 or sdx_grip64 and no
# SUPERDEX_* switch, played again with the rig built here against the named library (bin/sdx_<rig>64_<stock|b15>).
# Each command and its settings are copied from the registered play scripts (tools/plays/play_12.sh to play_16.sh of
# senua-superdex-accuracy); outputs mirror the registered paths under out/<stock|b15>/. One play after another.
# Every play runs with DYLD_PRINT_LIBRARIES=1; its stderr (the libraries it loaded) is kept in <name>.err.
set -u
S=$HOME/code/superdex-stock-rig-check
WHICH="${1:?usage: replay.sh <stock|b15>}"
O="$S/out/$WHICH"; rm -rf "$O"; mkdir -p "$O"
A=$HOME/code/superdex-src/superdex_physics/assets     # SuperDex's superdex_physics/assets (holds franka_arm/fr3)
unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
      SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT
if env | grep -q '^SUPERDEX_\|^SDX_'; then echo "a SUPERDEX_/SDX_ variable is set; stopping" >&2; exit 2; fi
dt_of() { echo "scale=12; 0.01/$1" | bc; }
# play <rig> <folder, relative to validation/> <name> <trace yes|no> <settings...>
play() {
  local rig="$1" d="$2" name="$3" tr="$4"; shift 4
  local W="$O/$d" bin="$S/bin/${rig}64_$WHICH"; mkdir -p "$W"
  printf '%s\t%s\t%s\t%s\n' "$d/$name" "$rig" "$tr" "$*" >> "$O/manifest.tsv"
  if [ "$tr" = yes ]; then
    SDX_TRACE="$W/$name.tr" DYLD_PRINT_LIBRARIES=1 "$bin" "$W/$name.txt" "$@" 2> "$W/$name.err" | sed "s/^STATS/STATS run $name/" >> "$W/stats.txt"
  else
    DYLD_PRINT_LIBRARIES=1 "$bin" "$W/$name.txt" "$@" 2> "$W/$name.err" | sed "s/^STATS/STATS run $name/" >> "$W/stats.txt"
  fi
  echo "$d/$name rc=${PIPESTATUS[0]}" >> "$O/rc.txt"
}
date -u +%FT%TZ > "$O/started.txt"

# run 028 (play_12.sh chain): configurations off (newtoneuler=0) and ne (newtoneuler=1, SuperDex's own option); no switch
ARMS="mass1=1.2 mass2=0.6 radius=0.04 arm1=0.25 len1=0.5 arm2=0.2"
FREE="gravity=0 angle2=-0.9 omega1=2.5 omega2=1.5 secs=2"
SWING="gravity=1 angle1=0.4 angle2=-0.7 secs=2"
for cfg in off ne; do
  NE=0; [ $cfg = ne ] && NE=1
  for case in free swing; do
    SET="$FREE"; [ $case = swing ] && SET="$SWING"
    for k in 1 4 16; do
      # shellcheck disable=SC2086
      play sdx_chain run_028_joint_motion/chain/$cfg ${case}_$k yes dt="$(dt_of "$k")" $ARMS $SET newtoneuler=$NE
    done
  done
done

ROD="lin=0.12 ea=150 len=0.6"; STRIP="rhoa=1.2 mmu=500 mlambda=0 len=0.4"; BAR="rho=1100 young=2e6 nu=0 len=0.4"
# deform_stock <folder> <floor mu> <slide v0> <hold tilt> <falls and hangs yes|no> <cantilever clampmid setting or "" or none>
deform_stock() {
  local d="$1" floor="mu=$2" v0="$3" tilt="$4" fh="$5" cant="$6"
  for dt in 0.01 0.001; do
    if [ "$fh" = yes ]; then
      # shellcheck disable=SC2086
      { play sdx_deform $d rod_fall_$dt no dt="$dt" case=rod_fall $ROD ei=3; play sdx_deform $d shell_fall_$dt no dt="$dt" case=shell_fall $STRIP
        play sdx_deform $d soft_fall_$dt no dt="$dt" case=soft_fall $BAR
        play sdx_deform $d rod_hang_$dt no dt="$dt" case=rod_hang $ROD ei=3; play sdx_deform $d shell_hang_$dt no dt="$dt" case=shell_hang $STRIP
        play sdx_deform $d soft_hang_$dt no dt="$dt" case=soft_hang $BAR; }
    fi
    for b in shell soft; do
      play sdx_deform $d ${b}_rest_$dt no dt="$dt" case=${b}_rest $floor
      play sdx_deform $d ${b}_slide_$dt no dt="$dt" case=${b}_slide $floor v0=$v0
      play sdx_deform $d ${b}_hold_$dt no dt="$dt" case=${b}_hold $floor tilt=$tilt
    done
  done
  if [ "$cant" != none ]; then
    # shellcheck disable=SC2086
    for n in 32 64 128; do play sdx_deform $d cantilever_n${n}_0.01 no dt=0.01 case=rod_cantilever $ROD ei=3 n=$n $cant; done
  fi
}
# grip_stock <folder> <dt setting or "">
grip_stock() {
  local d="$1" dts="$2"
  for g in built fr3; do for grip in 8 0.9; do
    # shellcheck disable=SC2086
    play sdx_grip $d ${g}_$grip yes gripper=$g assets="$A" mass=0.15 half=0.012 mu=0.45 grip=$grip $dts
  done; done
}

# run 029 (play_13.sh deform, grip; configuration stock)
deform_stock run_029_end_to_end/runs/deform_stock 0.4 0.8 0.25 yes ""
grip_stock run_029_end_to_end/runs/grip_stock ""

# run 032 (play_14.sh items item 4, deform, grip; configuration stock)
for n in 32 64 128; do
  for cm in 0 1; do
    play sdx_deform run_032_open_items/runs/items cant13_c${cm}_n$n no case=rod_cantilever dt=0.01 lin=0.12 ea=150 len=0.6 ei=3 n=$n clampmid=$cm
    play sdx_deform run_032_open_items/runs/items cantf_c${cm}_n$n no case=rod_cantilever dt=0.01 lin=0.15 ea=250 len=0.45 ei=1.2 n=$n clampmid=$cm
  done
done
deform_stock run_032_open_items/runs/deform_stock 0.45 0.7 0.3 yes clampmid=1
grip_stock run_032_open_items/runs/grip_stock "dt=$(dt_of 1)"

# run 034 (play_15.sh items item 4, no switch, the final configuration's tolerances; deform, configuration stock)
TOL="abstol=1e-4 reltol=1e-8"
for n in 64 128; do
  # shellcheck disable=SC2086
  { play sdx_deform run_034_replication/runs/items cant13_n$n no case=rod_cantilever dt=0.01 lin=0.12 ea=150 len=0.6 ei=3 n=$n clampmid=1 $TOL
    play sdx_deform run_034_replication/runs/items canta_n$n no case=rod_cantilever dt=0.01 lin=0.2 ea=300 len=0.5 ei=5 n=$n clampmid=1 $TOL
    play sdx_deform run_034_replication/runs/items cantb_n$n no case=rod_cantilever dt=0.01 lin=0.08 ea=120 len=0.7 ei=2.5 n=$n clampmid=1 $TOL; }
done
deform_stock run_034_replication/runs/deform_stock 0.5 0.9 0.35 no none

# run 036 (play_16.sh deform; configuration stock)
deform_stock run_036_registration16/runs/deform_stock 0.46 0.85 0.31 no none

date -u +%FT%TZ > "$O/finished.txt"
echo "done $WHICH: $(wc -l < "$O/manifest.tsv") plays"
