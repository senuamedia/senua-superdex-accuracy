#!/usr/bin/env bash
# The sixteenth registration's plays (PREREGISTRATION_16.md): library build 15 (the second code review's corrections)
# in SuperDex's shipped 32-bit arithmetic against the first two studies; its corrections put to plays of their own,
# with library build 14 beside them; and the deformable bodies on a fresh floor, read as the fifteenth registration's
# failures said they should be. One play after another, one thread.
#   final       the shipped step (10 ms), backward Euler: patches A to G with SuperDex's Newton-Euler inertia, contact
#               damping 5, friction falloff 0.03 m/s, the solver's tolerances at 1e-4 (absolute) and 1e-8 (relative),
#               each mesh body's grid cell 1/32 of its side
#   accurate    the same with BDF2, at 1/16 of the step
# usage: bash tools/plays/play_16.sh <part> ...        (from the repository root)
#   parts: bits32 corrections deform
#   bits32       every stream of the first two studies made again on library build 15, the first study's and the
#                second's 32-bit source in 32-bit (tools/sdx_player32) and the rest in 64-bit, no switch set; six
#                of the first study's with every switch set to 0. Writes runs/identity32.txt: "IDENTITY <part>
#                <identical> of <played>", and a line for every stream that differs
#   corrections  the teleport and the viscous friction of the second review, on library build 15 and build 14
#   deform       the deformable bodies on a fresh floor: friction 0.46, a slide at 0.85 m/s, a tilt of 0.31 rad
# Needs: library build 15 in the rigs' library folder, library build 14 in SUPERDEX_BUILD14 (corrections), the
# patched rigs, tools/sdx_player32 (sdx_player.cpp built against library build 15 in 32-bit), SUPERDEX_ASSETS = the
# assets directory of the SuperDex source tree (bits32).
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
O="$R/validation/run_036_registration16"; mkdir -p "$O/runs"
B14="${SUPERDEX_BUILD14:-}"     # the folder of library build 14, for the corrections' comparison
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
final() {  # every switch of patches A to G
  clear_switches
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1
}
TOL="abstol=1e-4 reltol=1e-8"
CON="ndamp=5 falloff=0.03"
dt_of() { echo "scale=12; 0.01/$1" | bc; }
for part in "$@"; do
case "$part" in
bits32)
  A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"
  W="$R/work/16"; mkdir -p "$W"; OUT="$O/runs/identity32.txt"; : > "$OUT"
  clear_switches
  ZERO="SUPERDEX_FRICTION_FULL_NORMAL=0 SUPERDEX_DAMPING_UNILATERAL=0 SUPERDEX_STICK_DISTANCE=0 SUPERDEX_STICK_DAMPING=0 SUPERDEX_LIMIT_UNILATERAL=0 SUPERDEX_ROTATION_AXIS_EXACT=0 SUPERDEX_FRICTION_STEP_NORMAL=0 SUPERDEX_INERTIA_TRANSPORT=0"
  # the source table of a registered play script: the lines between "<<'SOURCES'" and "SOURCES"
  sources() { awk '/<<.SOURCES.$/ { on = 1; next } /^SOURCES$/ { on = 0 } on && NF' "$1"; }
  same=0; diff=0
  report() { echo "IDENTITY $1 $same of $((same + diff))" | tee -a "$OUT"; same=0; diff=0; }
  # play <rig> <scene> <commands> <label> <registered stream> <settings...>: one play, its stream compared
  play() {
    local rig="$1" scene="$2" act="$3" label="$4" reg="$5"; shift 5
    "$rig" "$scene" "$A" "$act" "$W/$label" "$@" < /dev/null > "$W/$label.out" 2>&1
    if cmp -s "$W/${label}_enc.pcm" "$reg"; then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS $label" >> "$OUT"; fi
    rm -f "$W/${label}_state.f32" "$W/${label}_enc.pcm"
  }
  for scene in cart_pole half_cheetah ant; do
    # the first study: every source in 32-bit
    while read -r src settings; do
      # shellcheck disable=SC2086
      play "$R/tools/sdx_player32" "$scene" "$R/actions/01/$scene.txt" "s01_${scene}_$src" "$R/streams/01/$scene/${src}_enc.pcm" $settings
    done < <(sources "$R/tools/plays/play_01.sh")
  done
  report study1_32bit
  for scene in cart_pole ant half_cheetah; do
    # the second study: its 32-bit source in 32-bit, the rest in 64-bit, as registered
    while read -r src bits settings; do
      rig="$R/tools/sdx_player64"; [ "$bits" = 32 ] && rig="$R/tools/sdx_player32"
      # shellcheck disable=SC2086
      play "$rig" "$scene" "$R/actions/02/$scene.txt" "s02_${scene}_$src" "$R/streams/02/$scene/${src}_enc.pcm" $settings
    done < <(sources "$R/tools/plays/play_02.sh")
  done
  report study2
  # every switch set to 0, which must mean off: the first study's base and s1 sources in 32-bit
  ( for kv in $ZERO; do export "$kv"; done
    for scene in cart_pole half_cheetah ant; do
      while read -r src settings; do
        case "$src" in base|s1) ;; *) continue ;; esac
        # shellcheck disable=SC2086
        play "$R/tools/sdx_player32" "$scene" "$R/actions/01/$scene.txt" "zero_${scene}_$src" "$R/streams/01/$scene/${src}_enc.pcm" $settings
      done < <(sources "$R/tools/plays/play_01.sh")
    done
    report zero_32bit )
  clear_switches
  ;;
corrections)
  # a fresh cube (0.9 kg, half-size 0.045 m, friction 0.44) on the plane, final configuration, on build 15 and
  # build 14
  W="$O/runs/corrections"; mkdir -p "$W"; : > "$W/stats.txt"
  T="$R/tools/sdx_contact64"; C="mass=0.9 radius=0.045 $CON $TOL sdfdiv=32"
  for lib in b15 b14; do
    L=""; [ $lib = b14 ] && L="$B14"
    run() { local name="$1"; shift
      # shellcheck disable=SC2086
      if [ -n "$L" ]; then DYLD_LIBRARY_PATH="$L" "$T" "$W/${lib}_$name.txt" $C "$@"; else "$T" "$W/${lib}_$name.txt" $C "$@"; fi | sed "s/^STATS/STATS run ${lib}_$name/" >> "$W/stats.txt"; }
    final
    # the teleport: held by a push of 0.6 of what friction can hold (2.32848 N) from 0.5 s, moved 2 mm along x by
    # SuperDex's SetRootTransform before the step at 1 s, and played to 2 s
    run hold dt=0.01 h0=0 secs=2 mu=0.44 push=2.32848 pushat=0.5
    run teleport dt=0.01 h0=0 secs=2 mu=0.44 push=2.32848 pushat=0.5 teleport=1 teleportdx=0.002
    # viscous friction with patch F: an oblique landing (from 0.05 m at 2.5 m/s) on a floor with no Coulomb
    # friction and a viscous friction coefficient of 0.2, with patch F and without it, at the shipped step and 1/4
    for k in 1 4; do
      run visc_f_$k dt="$(dt_of $k)" h0=0.05 vx0=2.5 secs=0.3 mu=0 visc=0.2
      unset SUPERDEX_FRICTION_STEP_NORMAL
      run visc_nof_$k dt="$(dt_of $k)" h0=0.05 vx0=2.5 secs=0.3 mu=0 visc=0.2
      final
    done
  done
  clear_switches
  ;;
deform)
  # the deformable bodies on a fresh floor: friction 0.46, a slide at 0.85 m/s, a tilt of 0.31 rad
  FLOOR="mu=0.46"
  for cfg in stock final accurate; do
    clear_switches; X=""; dts="0.01 0.001"
    [ $cfg != stock ] && { final; X="ndamp=5 falloff=0.03 $TOL"; }
    [ $cfg = accurate ] && { X="ndamp=5 falloff=0.03 integ=bdf2 $TOL"; dts="0.000625"; }
    W="$O/runs/deform_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" dt="$2"; shift 2
      # shellcheck disable=SC2086
      "$R/tools/sdx_deform64" "$W/${name}_$dt.txt" dt="$dt" "$@" $X | sed "s/^STATS/STATS run ${name}_$dt/" >> "$W/stats.txt"; }
    for dt in $dts; do
      for b in shell soft; do
        play ${b}_rest $dt case=${b}_rest $FLOOR; play ${b}_slide $dt case=${b}_slide $FLOOR v0=0.85; play ${b}_hold $dt case=${b}_hold $FLOOR tilt=0.31
      done
    done
  done
  clear_switches
  ;;
*) echo "unknown part $part" >&2; exit 2 ;;
esac
done
