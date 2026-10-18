#!/usr/bin/env bash
# The twenty-second registration's plays (preregistrations/PREREGISTRATION_22.md): patch G under BDF2, head to head on
# fresh numbers drawn from one seed. Two forms of patch G, each with SuperDex's Newton-Euler inertia:
#   cur    the current form: library build 15, from the four patch files in patches/ (a share of 1/3 under BDF2)
#   der    the derived form: the same with patches/in_design/senua_inertia_transport_bdf2_derived.patch in place of
#          patches/senua_inertia_transport.patch
#   stock  SuperDex v1.0.0 with no patch (safe when off)
# On Linux only. One play after another, one thread; once the parts build and rigs have run, the other parts can be
# played as separate processes.
# usage: bash tools/plays/play_22.sh <work folder> <out folder> [part ...]        (from the repository root)
#   as registered: bash tools/plays/play_22.sh <work folder of run 039 step 1> validation/run_052_study22
#   work folder  holds superdex-src (SuperDex at the commit in UPSTREAM_COMMIT), superdex-patched-src, build-stock,
#                build-patched and patches.sha256, as validation/run_039_linux_replication/build.sh makes them from the
#                patch files in patches/; the part build adds superdex-derived-src, build-derived and derived.sha256,
#                and the part rigs adds rigs22_cur/
#   parts (default: all, in this order): build rigs identity bdf2 be off long bench compare
#     build     the derived library, from superdex-src and the derived set of patch files (PLAY22_JOBS compile jobs,
#               default all the machine's CPUs)
#     rigs      every rig used here: against the derived library in tools/ (sdx_*64, which the identity check plays),
#               against the stock library in tools/ (sdx_*64_stock), against library build 15 in rigs22_cur/
#     identity  tools/play_identity.sh on the derived library, parts rotvec flight suites joints zero fg bench
#               benchrec (E1, E2), with the plays Linux makes differently from the laptop compared as Study 21 does
#     bdf2      the head to head under BDF2: both forms, both tolerances, every scene, steps 1 to 1/64
#     be        the same scenes under backward Euler with patch G's switch set, both libraries (E2, and the floor)
#     off       the same scenes with no switch, under BDF2 and backward Euler: the derived library and stock (E1)
#     long      the pendulum released level for 20 s at 1/16 under BDF2, both forms
#     bench     Meta's three scenes on the fresh commands, both forms: the accurate configuration (BDF2 at 1/16) and
#               the recommended configuration (backward Euler at the shipped step)
#     compare   the byte comparisons of E1 and E2 that the parts above made, written to compare.txt
#   draw        prints the fresh numbers from the seed and plays nothing
# Writes <out>/rigs.sha256, played.txt, times.txt, identity.txt, identity_linux.txt, compare.txt and the plays under
# <out>/runs/; the measuring is measure/runners/sx_study22_run.sh.
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"; cd "$R" || exit 2
WD="$(cd "${1:?usage: play_22.sh <work folder> <out folder> [part ...]}" && pwd)"; O="${2:?out folder}"
mkdir -p "$O/runs" && O="$(cd "$O" && pwd)"; shift 2
PARTS="${*:-build rigs identity bdf2 be off long bench compare}"
[ "$(uname -s)" = Linux ] || { echo "play_22.sh plays on Linux only" >&2; exit 2; }
A="${SUPERDEX_ASSETS:-$WD/superdex-src/assets}"                          # Meta's benchmark scenes
sha() { sha256sum "$@"; }
dt_of() { awk -v k="$1" 'BEGIN { printf "%.12g", 0.01 / k }'; }
DERIVED=patches/in_design/senua_inertia_transport_bdf2_derived.patch
DSET="patches/senua_contact.patch patches/senua_joint_limit.patch patches/senua_rotation_axis.patch $DERIVED"
CUR="$WD/rigs22_cur"

# ---- the registered numbers, drawn from seed 22 (the part draw prints them; PREREGISTRATION_22.md gives the ranges) ----
# three free chains (two arms on two joints, no gravity, 2 s): A and B planar, T with its second joint's axis tilted
CHAIN_A="mass1=1.152 mass2=0.632 radius=0.0439 arm1=0.279 len1=0.561 arm2=0.247 angle2=-0.934 omega1=2.33 omega2=-1.16"
CHAIN_B="mass1=1.177 mass2=0.897 radius=0.0423 arm1=0.274 len1=0.585 arm2=0.206 angle2=-0.922 omega1=2.1 omega2=-0.27"
CHAIN_T="mass1=1.063 mass2=0.854 radius=0.0497 arm1=0.254 len1=0.598 arm2=0.203 angle2=-0.893 omega1=2.08 omega2=1.35 tilt2=0.787"
# a swinging chain (gravity, released at rest, 2 s)
CHAIN_S="mass1=1.325 mass2=0.649 radius=0.0471 arm1=0.26 len1=0.529 arm2=0.226 angle1=0.346 angle2=-0.502"
# one arm on one joint: a free spin (no gravity, 1 s) and a pendulum released level (3 s; and 20 s at 1/16)
ARM="mass=2.216 radius=0.0514 arm=0.444"; SPIN=3.8; LONG=20
# Meta's three scenes: commands drawn from seeds 22101 (cart_pole), 22102 (half_cheetah) and 22103 (ant)
ACT="$R/actions/22"
# ---- end of the registered numbers ----

KS="1 2 4 8 16 32 64"                         # the steps, fractions of the shipped 10 ms
clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
final() {  # every switch of patches A to G, as the recommended and the accurate configurations set them
  clear_switches
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1
}
TOL_acc="abstol=1e-4 reltol=1e-8"             # the accurate configuration's tolerances (the final configuration's)
TOL_tight="abstol=1e-9 reltol=1e-12"          # the solve converged
CON="ndamp=5 falloff=0.03"
st() { sed "s/^STATS/STATS run $1/" | grep '^STATS'; }   # a play's statistics line, named
log_part() { echo "$1 $2 $(date -u +%FT%TZ)" >> "$O/times.txt"; }
rig_of() {  # rig_of <lib> <rig>: the rig built against that library
  case $1 in der) echo "$R/tools/sdx_${2}64" ;; stock) echo "$R/tools/sdx_${2}64_stock" ;; cur) echo "$CUR/sdx_${2}64" ;; esac
}
scenes() {  # scenes <lib> <dir> <settings...>: the six scenes at every step in KS (or $KS_HERE), into <dir>
  local lib="$1" W="$2" k; shift 2
  mkdir -p "$W"; : > "$W/stats.txt"
  local C; C="$(rig_of "$lib" chain)"; local J; J="$(rig_of "$lib" joint)"
  for k in ${KS_HERE:-$KS}; do
    # shellcheck disable=SC2086
    { "$C" "$W/chain_a_$k.txt" dt="$(dt_of $k)" $CHAIN_A gravity=0 secs=2 "$@" | st chain_a_$k
      "$C" "$W/chain_b_$k.txt" dt="$(dt_of $k)" $CHAIN_B gravity=0 secs=2 "$@" | st chain_b_$k
      "$C" "$W/chain_t_$k.txt" dt="$(dt_of $k)" $CHAIN_T gravity=0 secs=2 "$@" | st chain_t_$k
      "$C" "$W/chain_s_$k.txt" dt="$(dt_of $k)" $CHAIN_S gravity=1 secs=2 "$@" | st chain_s_$k
      "$J" "$W/spin_$k.txt" dt="$(dt_of $k)" $ARM gravity=0 omega0=$SPIN secs=1 "$@" | st spin_$k
      "$J" "$W/pend_$k.txt" dt="$(dt_of $k)" $ARM secs=3 "$@" | st pend_$k; } >> "$W/stats.txt"
  done
}

draw() {  # the fresh numbers from the seed: a stream x(n+1) = (1103515245 x(n) + 12345) mod 2^31 from x(0) = 22, each
          # number mapped onto its range's grid; a value its kind may not take is drawn again
  local x=22 V=0 D=""
  pick() { x=$(( (x * 1103515245 + 12345) % 2147483648 )); V=$(( $1 + x * ($2 - $1 + 1) / 2147483648 )); }
  dec() { local v=$1 p=$2 s="" d=1 i; [ "$v" -lt 0 ] && { s="-"; v=$(( -v )); }
    for ((i = 0; i < p; i++)); do d=$(( d * 10 )); done
    if [ "$p" -eq 0 ]; then echo "$s$v"; else printf "%s%d.%0${p}d\n" "$s" $(( v / d )) $(( v % d )); fi; }
  plain() { echo "$1" | sed -E 's/(\.[0-9]*[1-9])0+$/\1/; s/\.0+$//'; }
  # the values a kind may not take: those the record used for the same kind (play_21.sh's lists), those the
  # twenty-first registration's draw gives (PREREGISTRATION_21.md), those of run 049's probes, and those this draw
  # has already given to that kind
  SEEN_mass=" 0.1 0.15 0.35 0.4 0.45 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 2 2.2 2.4 2.6 3 3.5 4 5 1.75 4.177 0.698 4.562 0.436 4.237 0.352 1.556 1.015 0.893 1.157 0.167 "
  SEEN_len=" 0.01 0.012 0.025 0.028 0.03 0.035 0.04 0.045 0.05 0.055 0.06 0.07 0.08 0.09 0.1 0.12 0.15 0.16 0.18 0.2 0.22 0.25 0.27 0.28 0.3 0.32 0.33 0.35 0.37 0.38 0.4 0.42 0.45 0.5 0.52 0.55 0.6 0.7 0.0388 0.081 0.058 0.244 0.0328 0.273 0.0255 0.282 0.0275 0.0449 0.443 0.0443 0.296 0.501 0.233 0.0316 0.076 0.673 0.482 0.642 0.594 0.548 0.197 0.099 0.0112 "
  SEEN_speed=" -1 -1.8 0.015 0.02 0.7 0.8 0.81 0.84 0.85 0.87 0.9 1 1.04 1.1 1.16 1.2 1.36 1.5 1.56 1.8 1.9 2 2.18 2.2 2.5 2.53 2.7 2.93 3 3.09 3.1 3.45 3.5 3.9 3.98 4 4.2 4.5 4.51 4.89 5 5.5 6 8 "
  SEEN_ang=" -1.1 -0.982 -0.9 -0.8 -0.7 -0.6 -0.512 -0.5 -0.373 -0.34 -0.33 -0.3 0 0.033 0.2 0.25 0.3 0.31 0.326 0.35 0.4 0.5 0.6 0.653 0.7 "
  q() {  # q <kind> <name> <lo> <hi> <places>: one quantity, drawn again while its value is one its kind may not take
    local k="$1" v p seen
    while :; do
      pick "$3" "$4"; v="$(dec "$V" "$5")"; p="$(plain "$v")"
      eval "seen=\"\${SEEN_$k:- }\""
      case "$seen" in *" $p "*) echo "  ($2 drawn again: $v)" ;; *) eval "SEEN_$k=\"\${SEEN_$k:- }$p \""; break ;; esac
    done
    D="$v"; echo "$2 $v"
  }
  local c
  for c in a b t; do
    q mass chain_${c}_mass1 1000 1500 3; q mass chain_${c}_mass2 600 900 3; q len chain_${c}_half 400 500 4
    q len chain_${c}_arm1 250 300 3; q len chain_${c}_len1 500 600 3; q len chain_${c}_arm2 200 250 3
    q ang chain_${c}_angle2 -1000 -600 3; q speed chain_${c}_omega1 200 300 2; q speed chain_${c}_omega2 -150 150 2
    [ $c = t ] && q ang chain_t_tilt2 300 900 3
  done
  q mass chain_s_mass1 1000 1500 3; q mass chain_s_mass2 600 900 3; q len chain_s_half 400 500 4
  q len chain_s_arm1 250 300 3; q len chain_s_len1 500 600 3; q len chain_s_arm2 200 250 3
  q ang chain_s_angle1 300 700 3; q ang chain_s_angle2 -800 -400 3
  q mass arm_mass 1500 3000 3; q len arm_half 400 600 4; q len arm_dist 350 500 3; q speed arm_spin 300 400 2
}

for part in $PARTS; do
log_part "$part" started
case "$part" in
draw)
  draw
  ;;
build)
  # the derived library: SuperDex at the commit in UPSTREAM_COMMIT with the contact, joint-limit and rotation files of
  # library build 15 and the derived file in place of patch G's, 64-bit, built as run 039's build.sh builds build 15
  cd "$WD" || exit 2
  if [ -f build-derived/bin/libmochi_physics_double.so ] && [ -f derived.sha256 ] &&
     cmp -s <(head -4 derived.sha256 | awk '{ print $1 }') <(cd "$R" && sha $DSET | awk '{ print $1 }'); then
    echo "build: the derived library is already built from these files" >> "$O/played.txt"
  else
    export CC=clang CXX=clang++
    rm -rf superdex-derived-src build-derived; mkdir superdex-derived-src; cp -R superdex-src/. superdex-derived-src/
    # shellcheck disable=SC2086
    ( cd "$R" && git -C "$WD/superdex-derived-src" apply $(for f in $DSET; do echo "$R/$f"; done) ) || { echo "the derived set does not apply" >&2; exit 2; }
    cmake -S superdex-derived-src/superdex_physics -B build-derived -DCMAKE_BUILD_TYPE=Release -DMOCHI_USE_PYBIND=OFF \
      -DMOCHI_BUILD_DEBUGGER=OFF -DMOCHI_USE_HDF5=ON -DMOCHI_BUILD_TESTS=OFF -DMOCHI_BUILD_BENCHMARKS=OFF \
      -DMOCHI_USE_DOUBLE_PRECISION=ON > build-derived.configure.log 2>&1
    cmake --build build-derived --target mochi_physics --parallel "${PLAY22_JOBS:-$(nproc)}" > build-derived.log 2>&1 || { echo "the derived library did not build" >&2; exit 2; }
    { (cd "$R" && sha $DSET); sha build-derived/bin/libmochi_physics_double.so; } > derived.sha256
    echo "build: the derived library built" >> "$O/played.txt"
  fi
  cd "$R" || exit 2
  ;;
rigs)
  # library build 15 must be built from this commit's patch files, and the derived library from the derived set
  [ -f "$WD/patches.sha256" ] || { echo "no $WD/patches.sha256: build the libraries with validation/run_039_linux_replication/build.sh" >&2; exit 2; }
  if ! cmp -s <(awk '{ print $1 }' "$WD/patches.sha256" | sort) <(sha patches/senua_*.patch | awk '{ print $1 }' | sort); then
    echo "library build 15 in $WD was not built from the patch files in patches/" >&2; exit 2
  fi
  # shellcheck disable=SC2086
  if ! cmp -s <(head -4 "$WD/derived.sha256" 2>/dev/null | awk '{ print $1 }') <(sha $DSET | awk '{ print $1 }'); then
    echo "the derived library in $WD was not built from the derived set: play the part build" >&2; exit 2
  fi
  mkdir -p "$WD/cxx" "$CUR" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
  rig() { SUPERDEX_SRC=$WD/$3 SUPERDEX_BUILD=$WD/$2 SRC=sdx_$1.cpp OUT=$4 LIB=mochi_physics_double tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $4" | tee -a "$O/played.txt"; }
  for r in contact pair joint chain rotvec player; do rig $r build-derived superdex-derived-src sdx_${r}64; done
  for r in contact joint chain player; do rig $r build-stock superdex-src sdx_${r}64_stock; done
  for r in joint chain player; do rig $r build-patched superdex-patched-src "$CUR/sdx_${r}64"; done
  : > "$O/rigs.sha256"
  { sha tools/sdx_*.cpp tools/build_player.sh tools/play_identity.sh tools/contact_suite.sh tools/contact_suite2.sh
    for r in contact pair joint chain rotvec player; do sha tools/sdx_${r}64; done
    for r in contact joint chain player; do sha tools/sdx_${r}64_stock; done
    sha "$CUR"/sdx_*64
    sha patches/senua_*.patch "$DERIVED" "$WD"/build-stock/bin/libmochi_physics_double.so "$WD"/build-patched/bin/libmochi_physics_double.so "$WD"/build-derived/bin/libmochi_physics_double.so
    for r in tools/sdx_contact64 tools/sdx_pair64 tools/sdx_joint64 tools/sdx_chain64 tools/sdx_rotvec64 tools/sdx_player64 tools/sdx_*64_stock "$CUR"/sdx_*64; do echo "$r loads: $(ldd "$r" | grep mochi)"; done
  } | sed "s#$HOME/#~/#g" >> "$O/rigs.sha256"
  ;;
identity)
  # E1 and E2: the identity check's parts on the derived library against the record's registered files
  clear_switches
  ID_PARTS="${PLAY22_IDENTITY_PARTS:-rotvec flight suites joints zero fg bench benchrec}"
  : > "$O/identity.txt"
  # shellcheck disable=SC2086
  SUPERDEX_ASSETS="$A" bash tools/play_identity.sh "$O/identity.txt" $ID_PARTS > "$O/identity_play.txt" 2>&1
  # the plays runs 040 and 047 found Linux makes differently from the laptop, stock and library build 15 alike: each
  # compared with the Linux file run 040 kept from library build 15, and those with no switch also with the same play
  # made on the stock library on this machine
  K=validation/run_040_linux_identity/runs; W=work/_identity; mkdir -p "$W/stock22"
  same() { if [ -f "$1" ] && cmp -s "$1" "$2"; then echo SAME; else echo DIFFERS; fi; }
  one() {  # one <label in identity.txt> <play> <run 040's file> <stock replay or ->
    local s="-"; [ "$4" != - ] && s="$(same "$2" "$4")"
    echo "LINUX $1 | kept $(same "$2" "$3") | stock $s" >> "$O/identity_linux.txt"
  }
  : > "$O/identity_linux.txt"
  case " $ID_PARTS " in *" joints "*|*" zero "*)
    tools/sdx_joint64_stock "$W/stock22/swing_be_64.txt" dt="$(dt_of 64)" mass=2 radius=0.04 arm=0.4 secs=3 > /dev/null 2>&1 ;; esac
  case " $ID_PARTS " in *" joints "*) one "joint swing_be_64" "$W/joints/swing_be_64.txt" "$K/joints_swing_be_64.txt" "$W/stock22/swing_be_64.txt" ;; esac
  case " $ID_PARTS " in *" zero "*) one "zero joint swing_be_64" "$W/zero/swing_be_64.txt" "$K/joints_swing_be_64.txt" "$W/stock22/swing_be_64.txt" ;; esac
  case " $ID_PARTS " in *" fg "*)
    one "fg chain swing_16" "$W/fg/swing_16.txt" "$K/fg_chain_swing_16.txt" -
    one "fg chain tight free_16" "$W/fg/tight_16.txt" "$K/fg_chain_tight_free_16.txt" -
    one "fg joints_fc swing_be_64" "$W/fg/swing_be_64.txt" "$K/fg_joints_fc_swing_be_64.txt" -
    one "fg limits_fc rel20_64" "$W/fg/rel20_64.txt" "$K/fg_limits_fc_rel20_64.txt" - ;; esac
  case " $ID_PARTS " in *" bench "*)
    for src in s4 c1 c06 c03; do
      case $src in s4) X="integ=be maxiter=4" ;; c1) X="integ=be maxiter=200 smooth=0.00125" ;; c06) X="integ=be maxiter=200 smooth=0.000625" ;; c03) X="integ=be maxiter=200 smooth=0.0003125" ;; esac
      # shellcheck disable=SC2086
      tools/sdx_player64_stock ant "$A" actions/03/ant.txt "$W/stock22/ant_$src" $X < /dev/null > "$W/stock22/ant_$src.out" 2>&1
      one "benchmark ant $src" "$W/bench/ant_${src}_enc.pcm" "$K/bench/ant_${src}_enc.pcm" "$W/stock22/ant_${src}_enc.pcm"
    done ;; esac
  case " $ID_PARTS " in *" benchrec "*)
    for k in 1 4; do one "benchmark under its switches half_cheetah y$k" "$W/benchrec/half_cheetah_y${k}_enc.pcm" "$K/bench/half_cheetah_y${k}_enc.pcm" -; done ;; esac
  ;;
bdf2)
  # the head to head (O0 to O2, T1 to T4, U1): BDF2, every switch of patches A to G, Newton-Euler inertia, both forms,
  # at the accurate configuration's tolerances and with the solve converged, every scene at steps 1 to 1/64
  for lib in cur der; do for tol in acc tight; do
    final; eval "TOL=\$TOL_$tol"
    # shellcheck disable=SC2086
    scenes $lib "$O/runs/bdf2_${tol}_$lib" integ=bdf2 newtoneuler=1 $TOL
  done; done
  clear_switches
  echo "PLAYED bdf2" >> "$O/played.txt"
  ;;
be)
  # backward Euler with patch G's switch set, both libraries, the same scenes, tolerances and steps (E2; the floor of
  # the order rules: backward Euler with patch G keeps a free chain's angular momentum exactly)
  for lib in cur der; do for tol in acc tight; do
    final; eval "TOL=\$TOL_$tol"
    # shellcheck disable=SC2086
    scenes $lib "$O/runs/be_${tol}_$lib" integ=be newtoneuler=1 $TOL
  done; done
  clear_switches
  echo "PLAYED be" >> "$O/played.txt"
  ;;
off)
  # no switch, the same scenes under BDF2 and backward Euler at the accurate configuration's tolerances, steps 1, 1/4,
  # 1/16 and 1/64: the derived library and the stock library (E1)
  for lib in der stock; do for integ in bdf2 be; do
    clear_switches
    # shellcheck disable=SC2086
    KS_HERE="1 4 16 64" scenes $lib "$O/runs/off_${integ}_$lib" integ=$integ newtoneuler=1 $TOL_acc
  done; done
  echo "PLAYED off" >> "$O/played.txt"
  ;;
long)
  # the pendulum released level for 20 s at 1/16 under the accurate configuration, both forms (T4)
  W="$O/runs/long"; mkdir -p "$W"; : > "$W/stats.txt"
  final
  for lib in cur der; do
    # shellcheck disable=SC2086
    "$(rig_of $lib joint)" "$W/pend20_$lib.txt" dt="$(dt_of 16)" $ARM secs=$LONG integ=bdf2 newtoneuler=1 $TOL_acc | st pend20_$lib >> "$W/stats.txt"
  done
  clear_switches
  echo "PLAYED long" >> "$O/played.txt"
  ;;
bench)
  # Meta's three scenes on the fresh commands, both forms: the accurate configuration, BDF2 at 1/16 of the step (U2),
  # and the recommended configuration, backward Euler at the shipped step (E2)
  W="$O/runs/bench"; mkdir -p "$W"; touch "$W/stats.txt"
  for sc in cart_pole half_cheetah ant; do
    for cfg in acc rec; do for lib in cur der; do
      if grep -q "^STATS source ${sc}_${cfg}_$lib " "$W/stats.txt"; then continue; fi
      final; X="integ=be"; [ $cfg = acc ] && X="integ=bdf2 sub=16"
      # shellcheck disable=SC2086
      "$(rig_of $lib player)" "$sc" "$A" "$ACT/$sc.txt" "$W/${sc}_${cfg}_$lib" maxiter=200 $X $CON newtoneuler=1 $TOL_acc < /dev/null > "$W/${sc}_${cfg}_$lib.out" 2>&1
      sed "s/^STATS/STATS source ${sc}_${cfg}_$lib/" "$W/${sc}_${cfg}_$lib.out" | grep '^STATS' >> "$W/stats.txt"
      rm -f "$W/${sc}_${cfg}_${lib}_state.f32"
    done; done
  done
  clear_switches
  echo "PLAYED bench" >> "$O/played.txt"
  ;;
compare)
  # E1: the derived library with no switch against stock; E2: the derived library under backward Euler with patch G's
  # switch set against library build 15, the scenes and Meta's scenes (the statistics without the wall-clock time)
  : > "$O/compare.txt"
  cmpdir() {  # cmpdir <label> <dir made> <dir against>: every play file of the second folder, byte for byte
    local same=0 diff=0 f b
    for f in "$3"/*.txt; do
      b="$(basename "$f")"; [ "$b" = stats.txt ] && continue
      if [ -f "$2/$b" ] && cmp -s "$2/$b" "$f"; then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS $1 $b" >> "$O/compare.txt"; fi
    done
    echo "COMPARE $1 $same of $((same + diff))" >> "$O/compare.txt"
  }
  U="$O/runs"
  cmpdir off_bdf2 "$U/off_bdf2_der" "$U/off_bdf2_stock"
  cmpdir off_be "$U/off_be_der" "$U/off_be_stock"
  cmpdir be_acc "$U/be_acc_der" "$U/be_acc_cur"
  cmpdir be_tight "$U/be_tight_der" "$U/be_tight_cur"
  same=0; diff=0
  for sc in cart_pole half_cheetah ant; do
    if [ -f "$U/bench/${sc}_rec_der_enc.pcm" ] && cmp -s "$U/bench/${sc}_rec_der_enc.pcm" "$U/bench/${sc}_rec_cur_enc.pcm"; then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS bench_rec ${sc}_enc.pcm" >> "$O/compare.txt"; fi
    if [ -f "$U/bench/${sc}_rec_der.out" ] && cmp -s <(grep '^STATS' "$U/bench/${sc}_rec_der.out" | sed 's/ wall_s [0-9.]*//') <(grep '^STATS' "$U/bench/${sc}_rec_cur.out" | sed 's/ wall_s [0-9.]*//'); then same=$((same + 1)); else diff=$((diff + 1)); echo "DIFFERS bench_rec ${sc} statistics" >> "$O/compare.txt"; fi
  done
  echo "COMPARE bench_rec $same of $((same + diff))" >> "$O/compare.txt"
  ;;
*) echo "unknown part $part" >&2; exit 2 ;;
esac
log_part "$part" finished
done
