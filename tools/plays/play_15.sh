#!/usr/bin/env bash
# The fifteenth registration's plays (PREREGISTRATION_15.md): every fix of the fourteenth registration replicated on
# fresh numbers, the deformable slides read where they stop, and the three corrections the code review asked for
# (library build 14) put to tests of their own. One play after another, one thread.
#   final       the shipped step (10 ms), backward Euler: patches A to G with SuperDex's Newton-Euler inertia, contact
#               damping 5, friction falloff 0.03 m/s, the solver's tolerances at 1e-4 (absolute) and 1e-8
#               (relative), each mesh body's grid cell 1/32 of its side, smoothing 1 mm on a body that meets a point
#               cloud
#   accurate    the same with BDF2, at 1/16 of the step, at the final configuration's solver tolerances (amended before
#               any run: at SuperDex's shipped tolerances BDF2 with patch G gains energy as the step shrinks)
# usage: tools/plays/play_15.sh <part> ...        (from the repository root)
#   parts: items deform review long accurate14
#   long        a fresh arm swinging for 20 s, and item 5's chain at 1/64 (the amendment)
#   accurate14  the fourteenth registration's accurate plays again, at the final configuration's tolerances: its play
#               script copied with only the accurate configuration played and its tolerances added (the amendment)
# Needs: library build 14 in the rigs' library folder, library build 13 in <its build>/bin_build13 (review part, for
# the comparison), the patched rigs and tools/sdx_deform64.
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
O="$R/validation/run_034_replication"; mkdir -p "$O/runs"
B13="${SUPERDEX_BUILD13:-}"     # the folder of library build 13, for the review part's comparison
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
items)
  W="$O/runs/items"; mkdir -p "$W"; : > "$W/stats.txt"
  final
  # item 1: two fresh pairs, each cube's cell at 1/32 of its side, the block pushed with 1.5 x what friction can carry
  slip() { local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    "$R/tools/sdx_pair64" "$W/${name}_$k" dt="$(dt_of "$k")" layout=stack pushat=0.5 secs=0.9 $CON $TOL sdfdiv=32 "$@" | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
  for k in 1 16; do
    slip pa $k massa=2.6 ra=0.22 massb=0.35 rb=0.025 mu=0.38 pusha=16.47870
    slip pb $k massa=5 ra=0.32 massb=0.8 rb=0.035 mu=0.5 pusha=42.63
  done
  # item 2: a fresh arm at two speeds and a fresh free chain, steps 1, 1/4, 1/16
  for w in 2 4.5; do for k in 1 4 16; do
    "$R/tools/sdx_joint64" "$W/spin${w}_$k.txt" dt="$(dt_of "$k")" mass=3 radius=0.06 arm=0.5 gravity=0 omega0=$w secs=1 newtoneuler=1 $TOL | sed "s/^STATS/STATS run spin${w}_$k/" >> "$W/stats.txt"
  done; done
  for k in 1 4 16; do
    "$R/tools/sdx_chain64" "$W/chainfree_$k.txt" dt="$(dt_of "$k")" mass1=1.5 mass2=0.9 radius=0.05 arm1=0.3 len1=0.6 arm2=0.25 gravity=0 angle2=-0.7 omega1=2 omega2=-1 secs=2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run chainfree_$k/" >> "$W/stats.txt"
  done
  # item 3: a fresh cube (1 kg, half-size 0.03 m) on the held sheet; stock, final, and accurate at 1/16
  for cfg in stock final accurate; do
    clear_switches; T="$R/tools/sdx_contact64_stock"; X=""; ks="1 4"; one=1
    if [ $cfg != stock ]; then final; T="$R/tools/sdx_contact64"; X="$CON $TOL sdfdiv=32 smooth=0.001"; fi
    if [ $cfg = accurate ]; then X="$CON $TOL sdfdiv=32 smooth=0.001 integ=bdf2"; ks="16"; one=16; fi
    C="$W/cloud_$cfg"; mkdir -p "$C"; : > "$C/stats.txt"
    play() { local name="$1" k="$2"; shift 2
      # shellcheck disable=SC2086
      "$T" "$C/${name}_$k.txt" dt="$(dt_of "$k")" mass=1 radius=0.03 "$@" floor=cloud cloudwid=0.16 $X | sed "s/^STATS/STATS run ${name}_$k/" >> "$C/stats.txt"; }
    for k in $ks; do play oblique $k h0=0.06 secs=0.3 vx0=3 mu=0.42; done
    play slide $one h0=0 secs=0.5 vx0=3.5 mu=0.42
    play rest $one h0=0 secs=2
    play hold $one h0=0 secs=2 mu=0.42 push=2.4696 pushat=0.5
    play slip $one h0=0 secs=2 mu=0.42 push=4.9392 pushat=0.5
    play lift $one h0=0 secs=0.4 lift=29.4 liftat=0.3
  done
  # item 4: the thirteenth registration's rod and two fresh rods as cantilevers held across the clamp, at the final
  # configuration's tolerances (no contact, so no switch acts)
  clear_switches
  for n in 64 128; do
    "$R/tools/sdx_deform64" "$W/cant13_n$n.txt" case=rod_cantilever dt=0.01 lin=0.12 ea=150 len=0.6 ei=3 n=$n clampmid=1 $TOL | sed "s/^STATS/STATS run cant13_n$n/" >> "$W/stats.txt"
    "$R/tools/sdx_deform64" "$W/canta_n$n.txt" case=rod_cantilever dt=0.01 lin=0.2 ea=300 len=0.5 ei=5 n=$n clampmid=1 $TOL | sed "s/^STATS/STATS run canta_n$n/" >> "$W/stats.txt"
    "$R/tools/sdx_deform64" "$W/cantb_n$n.txt" case=rod_cantilever dt=0.01 lin=0.08 ea=120 len=0.7 ei=2.5 n=$n clampmid=1 $TOL | sed "s/^STATS/STATS run cantb_n$n/" >> "$W/stats.txt"
  done
  # item 5: a fresh arm and chain under BDF2 with patch G's share (the final configuration's tolerances, as amended),
  # and under backward Euler
  final
  for k in 1 4 16; do
    "$R/tools/sdx_joint64" "$W/b2_swing_$k.txt" dt="$(dt_of "$k")" mass=2.2 radius=0.045 arm=0.42 secs=3 integ=bdf2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run b2_swing_$k/" >> "$W/stats.txt"
    "$R/tools/sdx_joint64" "$W/b2_spin_$k.txt" dt="$(dt_of "$k")" mass=2.2 radius=0.045 arm=0.42 gravity=0 omega0=3.5 secs=1 integ=bdf2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run b2_spin_$k/" >> "$W/stats.txt"
    "$R/tools/sdx_chain64" "$W/b2_chainswing_$k.txt" dt="$(dt_of "$k")" mass1=1.4 mass2=0.7 radius=0.04 arm1=0.27 len1=0.52 arm2=0.22 gravity=1 angle1=0.6 angle2=-0.5 secs=2 integ=bdf2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run b2_chainswing_$k/" >> "$W/stats.txt"
    "$R/tools/sdx_chain64" "$W/be_chainswing_$k.txt" dt="$(dt_of "$k")" mass1=1.4 mass2=0.7 radius=0.04 arm1=0.27 len1=0.52 arm2=0.22 gravity=1 angle1=0.6 angle2=-0.5 secs=2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run be_chainswing_$k/" >> "$W/stats.txt"
  done
  clear_switches
  ;;
deform)
  # the deformable bodies on a fresh floor: friction 0.5, a slide at 0.9 m/s, a tilt of 0.35 rad
  FLOOR="mu=0.5"
  for cfg in stock final accurate; do
    clear_switches; X=""; dts="0.01 0.001"
    [ $cfg != stock ] && { final; X="ndamp=5 falloff=0.03 $TOL"; }
    [ $cfg = accurate ] && { X="ndamp=5 falloff=0.03 integ=bdf2 $TOL"; dts="0.000625"; }
    W="$O/runs/deform_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" dt="$2"; shift 2
      # shellcheck disable=SC2086
      "$R/tools/sdx_deform64" "$W/${name}_$dt.txt" dt="$dt" "$@" $X | sed "s/^STATS/STATS run ${name}_$dt/" >> "$W/stats.txt"; }
    for dt in $dts; do
      # shellcheck disable=SC2086
      for b in shell soft; do
        play ${b}_rest $dt case=${b}_rest $FLOOR; play ${b}_slide $dt case=${b}_slide $FLOOR v0=0.9; play ${b}_hold $dt case=${b}_hold $FLOOR tilt=0.35
      done
    done
  done
  clear_switches
  ;;
review)
  # the three corrections of library build 14, on a fresh cube (1.1 kg, half-size 0.04 m, friction 0.48) held on the
  # plane by a push of 0.6 of what friction can hold (3.10464 N) for 2 s, final configuration; and the same plays on
  # library build 13 for the comparison
  W="$O/runs/review"; mkdir -p "$W"; : > "$W/stats.txt"
  H="mass=1.1 radius=0.04 h0=0 secs=2 mu=0.48 push=3.10464 $CON $TOL sdfdiv=32"
  for lib in b14 b13; do
    L=""; [ $lib = b13 ] && L="$B13"
    final
    run() { local name="$1"; shift
      # shellcheck disable=SC2086
      if [ -n "$L" ]; then DYLD_LIBRARY_PATH="$L" "$R/tools/sdx_contact64" "$W/${lib}_$name.txt" dt=0.01 $H "$@"; else "$R/tools/sdx_contact64" "$W/${lib}_$name.txt" dt=0.01 $H "$@"; fi | sed "s/^STATS/STATS run ${lib}_$name/" >> "$W/stats.txt"; }
    run hold
    run twin twinscene=1
    # a planner's trial: 10 steps pushed with 1.1 x what friction can hold (5.69184 N), then the state restored
    run rollout rollout=1 rolloutsteps=10 rolloutpush=5.69184
  done
  clear_switches
  ;;
long)
  # a fresh arm (1.7 kg, half-size 0.045 m, 0.38 m) released level and swinging for 20 s: accurate at 1/16 and 1/64,
  # final at the shipped step and at 1/16, and BDF2 with patch G at SuperDex's shipped tolerances at 1/16 (the cause
  # the amendment names); item 5's chain under the accurate configuration at 1/64
  W="$O/runs/long"; mkdir -p "$W"; : > "$W/stats.txt"
  final
  arm() { local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    "$R/tools/sdx_joint64" "$W/${name}_$k.txt" dt="$(dt_of "$k")" mass=1.7 radius=0.045 arm=0.38 secs=20 newtoneuler=1 "$@" | sed "s/^STATS/STATS run ${name}_$k/" >> "$W/stats.txt"; }
  # shellcheck disable=SC2086
  for k in 16 64; do arm accurate $k integ=bdf2 $TOL; done
  # shellcheck disable=SC2086
  for k in 1 16; do arm final $k $TOL; done
  arm shipped_tolerances 16 integ=bdf2
  # shellcheck disable=SC2086
  "$R/tools/sdx_chain64" "$W/b2_chainswing_64.txt" dt="$(dt_of 64)" mass1=1.4 mass2=0.7 radius=0.04 arm1=0.27 len1=0.52 arm2=0.22 gravity=1 angle1=0.6 angle2=-0.5 secs=2 integ=bdf2 newtoneuler=1 $TOL | sed "s/^STATS/STATS run b2_chainswing_64/" >> "$W/stats.txt"
  clear_switches
  ;;
accurate14)
  # the fourteenth registration's play script, copied: written to this run's folder, only the accurate configuration
  # played, and the final configuration's tolerances added to it; nothing else in it changes
  A14="$O/accurate14"
  [ -e "$A14" ] && { echo "$A14 exists already; the part writes a fresh folder" >&2; exit 2; }
  mkdir -p "$A14"
  sed -e "s|^R=\"\$(cd \"\$(dirname \"\$0\")/../..\" \&\& pwd)\"|R=\"$R\"|" \
      -e "s|O=\"\$R/validation/run_032_open_items\"|O=\"$A14\"|" \
      -e 's/for cfg in stock final accurate; do/for cfg in accurate; do/' \
      -e 's/for cfg in final accurate; do/for cfg in accurate; do/' \
      -e 's/{ integ=bdf2; FT=""; }/{ integ=bdf2; FT="$TOL"; }/' \
      -e 's/X="newtoneuler=1 integ=bdf2"/X="newtoneuler=1 integ=bdf2 $TOL"/' \
      -e 's/newtoneuler=1 integ=bdf2 | sed/newtoneuler=1 integ=bdf2 $TOL | sed/' \
      -e 's/X="$CON sdfdiv=32 smooth=0.001 integ=bdf2"/X="$CON $TOL sdfdiv=32 smooth=0.001 integ=bdf2"/' \
      -e 's/X="ndamp=5 falloff=0.03 integ=bdf2"/X="ndamp=5 falloff=0.03 integ=bdf2 $TOL"/' \
      -e 's/X="ndamp=5 falloff=0.03 newtoneuler=1 integ=bdf2"/X="ndamp=5 falloff=0.03 newtoneuler=1 integ=bdf2 $TOL"/' \
      -e 's/X="integ=bdf2 sub=16 ndamp=5 falloff=0.03 newtoneuler=1"/X="integ=bdf2 sub=16 ndamp=5 falloff=0.03 newtoneuler=1 $TOL"/' \
      "$R/tools/plays/play_14.sh" > "$A14/play_14_accurate.sh"
  diff "$R/tools/plays/play_14.sh" "$A14/play_14_accurate.sh" > "$A14/play_14_accurate.diff"
  ( cd "$R" || exit 2; bash "$A14/play_14_accurate.sh" suites joints limits cloud deform grip bench ) > "$A14/play.log" 2>&1 || echo "PLAY FAILED accurate14"
  ;;
*) echo "unknown part $part" >&2; exit 2 ;;
esac
done
