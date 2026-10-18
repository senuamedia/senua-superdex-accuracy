#!/usr/bin/env bash
# The twenty-third registration's plays (preregistrations/PREREGISTRATION_23.md): the twenty-first registration's plays
# again, part for part, on fresh numbers drawn from seed 23 and on library build 16. Patches F and G held again to every
# rule of their registrations (the eleventh and twelfth), and the recommended configuration to every backward-Euler
# end-to-end rule of the thirteenth to fifteenth. One play after another, one thread; the parts can be played as
# separate processes. Nothing is played differently from play_21.sh but the numbers, the commands and the library the
# work folder holds; the measuring (measure/runners/sx_study23_run.sh) reads the second suite's momentum with the
# measure pairg.
#   final   the recommended configuration: the shipped step (10 ms), backward Euler, patches A to G with SuperDex's
#           Newton-Euler inertia, contact damping 5, friction falloff 0.03 m/s, the solver's tolerances at 1e-4
#           (absolute) and 1e-8 (relative), each mesh body's grid cell 1/32 of its side on the rigs that take it, and
#           smoothing 1 mm on a body that meets a point cloud
#   nof     the same without patch F (for F1, F5, F6)
#   nog     the same without patch G and Newton-Euler inertia (for G9)
# usage: bash tools/plays/play_23.sh <work folder> <out folder> [part ...]        (from the repository root)
#   as registered: bash tools/plays/play_23.sh <work folder of library build 16> validation/run_055_study23
#   work folder  holds superdex-src, SuperDex at the commit in UPSTREAM_COMMIT; on Linux also superdex-patched-src,
#                build-stock and build-patched, as validation/run_039_linux_replication/build.sh makes them from the
#                patch files in patches/ (library build 16)
#   parts (default: all, in this order): rigs identity suites items arm chain joints limits rotvec cloud deform grip
#                bench order
#   draw         prints the fresh numbers from the seed and plays nothing
# On Linux the part rigs builds every rig used here against the work folder's two libraries; on macOS the rigs in
# tools/ are used as built. Writes <out>/rigs.sha256, played.txt, times.txt, identity.txt (and on Linux
# identity_linux.txt) and the plays under <out>/runs/; the measuring is measure/runners/sx_study23_run.sh.
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"; cd "$R" || exit 2
WD="$(cd "${1:?usage: play_23.sh <work folder> <out folder> [part ...]}" && pwd)"; O="${2:?out folder}"
mkdir -p "$O/runs" && O="$(cd "$O" && pwd)"; shift 2
PARTS="${*:-rigs identity suites items arm chain joints limits rotvec cloud deform grip bench order}"
OS="$(uname -s)"
A="${SUPERDEX_ASSETS:-$WD/superdex-src/assets}"                          # Meta's benchmark scenes
AP="${SUPERDEX_PHYSICS_ASSETS:-$WD/superdex-src/superdex_physics/assets}"  # SuperDex's own assets (the FR3 hand)
sha() { if command -v sha256sum > /dev/null; then sha256sum "$@"; else shasum -a 256 "$@"; fi; }
dt_of() { awk -v k="$1" 'BEGIN { printf "%.12g", 0.01 / k }'; }

# ---- the registered numbers, drawn from seed 23 (the part draw prints them; PREREGISTRATION_23.md gives the ranges) ----
# the first contact suite's cube
S1_CUBE="mass=1.783 radius=0.0394"; S1_H0=0.082; S1_VX=2.89; S1_VXCHAIN=1.17; S1_MU=0.388; S1_VSLIDE=3.05
S1_MUHOLD=0.47; S1_HOLD=4.9274988; S1_SLIP=9.8549976; S1_LIFT=52.4202     # 0.6 and 1.2 of what friction holds; 3 x weight
# the second contact suite: the same cube, and a pair (the carry push half of what friction can carry the light cube
# at, the slip push one and a half times it); the pair's masses are whole grams, not whole multiples of 10 g
S2_MU=0.387; S2_VSTOP=1.26; S2_H0=0.064; S2_PAIR="massa=4.855 ra=0.306 massb=0.465 rb=0.0293"; S2_MUP=0.363
S2_CARRY=9.462684; S2_SLIP=28.388052; S2_VSIDE=1.08; S2_VTOP=0.97
# item 1: two more pairs, each pushed with one and a half times what friction can carry the light cube at
PAIR_A="massa=3.699 ra=0.251 massb=0.736 rb=0.0265 mu=0.446 pusha=29.076747"
PAIR_B="massa=4.195 ra=0.231 massb=0.385 rb=0.0329 mu=0.353 pusha=23.766078"
# the arm on one joint: three release speeds (the twelfth's G1, G2), the sixth's tests (spin, torque, hold at 1.78 x
# gravity's torque, slip), the eighth's limit tests (lower limit, stiffness, two dampings, released 0.038 rad inside the
# limit, lifted with twice gravity's torque) and the swing of 20 s (V9)
ARM="mass=2.056 radius=0.0407 arm=0.371"; W1=1.93; W2=3.37; W3=5.38
JT1=3.62; JT2=1.8; JT4=13.3059; JT5C=1.64; JT5T=2.82
LIM="lo=-0.354 hi=3 limitk=2037"; LD1=18; LD2=122; LANGLE0=-0.392; LLIFT=14.9504096
LONG=20
# the chain: free and swinging
CHAIN="mass1=1.017 mass2=0.636 radius=0.0492 arm1=0.29 len1=0.523 arm2=0.215"
CFREE="angle2=-0.765 omega1=2.66 omega2=-0.91"; CSWING="angle1=0.327 angle2=-0.607"
# the rotations: five axes, eight angles (mantissa,exponent; four above 2e-9 rad and four at or under it)
AXES="-0.45,-0.2,-0.32 0.43,0.3,-0.67 -0.27,-0.42,0.05 0.08,0.98,0.14 -0.73,0.15,0.12"
ANGLES="1.96,-4 7.37,-7 3.77,-9 2.16,-9 1.04,-9 9.85,-10 8.41,-12 6.73,-14"
# the point-cloud floor's cube
CL_CUBE="mass=1.154 radius=0.0303"; CL_H0=0.066; CL_VX=3.32; CL_MU=0.397; CL_VSLIDE=3.99; CL_MUHOLD=0.405
CL_HOLD=2.7481356; CL_SLIP=5.4962712; CL_LIFT=33.9276
# the deformable bodies: a rod, a strip and a bar falling and hanging; three cantilevers; the floor
ROD="lin=0.122 ea=259 ei=4.7 len=0.481"; STRIP="rhoa=1.17 mmu=531 mlambda=0 len=0.311"; BAR="rho=929 young=1540000 nu=0 len=0.461"
CANT1="lin=0.192 ea=196 ei=4.6 len=0.477"; CANT2="lin=0.167 ea=164 ei=4.8 len=0.694"; CANT3="lin=0.146 ea=216 ei=3.7 len=0.667"
FLOOR="mu=0.516"; FV0=0.79; FTILT=0.351; PATCH="size=0.238 rhoa=1.18"; SOFT="size=0.091 rho=1135"
# the gripper's cube, the grip and the weak grip
GRIP_CUBE="mass=0.125 half=0.0118 mu=0.474"; GSTRONG=7; GWEAK=0.86
# Meta's three scenes: commands drawn from seeds 23101 (cart_pole), 23102 (half_cheetah) and 23103 (ant)
ACT="$R/actions/23"
# ---- end of the registered numbers ----

clear_switches() { unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT; }
final() {  # every switch of patches A to G
  clear_switches
  export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 SUPERDEX_INERTIA_TRANSPORT=1
}
nof() { final; unset SUPERDEX_FRICTION_STEP_NORMAL; }
nog() { final; unset SUPERDEX_INERTIA_TRANSPORT; }
TOL="abstol=1e-4 reltol=1e-8"
CON="ndamp=5 falloff=0.03"
TIGHT="abstol=1e-9 reltol=1e-12"
st() { sed "s/^STATS/STATS run $1/" | grep '^STATS'; }   # a play's statistics line, named
log_part() { echo "$1 $2 $(date -u +%FT%TZ)" >> "$O/times.txt"; }

draw() {  # the fresh numbers from the seed: a stream x(n+1) = (1103515245 x(n) + 12345) mod 2^31 from x(0) = 23, each
          # number mapped onto its range's grid; a value its kind may not take is drawn again (play_21.sh's procedure)
  local x=23 V=0 D=""
  pick() { x=$(( (x * 1103515245 + 12345) % 2147483648 )); V=$(( $1 + x * ($2 - $1 + 1) / 2147483648 )); }
  dec() { local v=$1 p=$2 s="" d=1 i; [ "$v" -lt 0 ] && { s="-"; v=$(( -v )); }
    for ((i = 0; i < p; i++)); do d=$(( d * 10 )); done
    if [ "$p" -eq 0 ]; then echo "$s$v"; else printf "%s%d.%0${p}d\n" "$s" $(( v / d )) $(( v % d )); fi; }
  plain() { echo "$1" | sed -E 's/(\.[0-9]*[1-9])0+$/\1/; s/\.0+$//'; }
  # the values a kind may not take: those the record used for the same kind (every setting of that kind in the
  # record's play, probe, dry-run and runner scripts, those of runs 048, 049 and 053 among them, the rotations'
  # axes and angles, the ratio of joint friction to gravity's torque of the record's holds, and the rigs' defaults
  # where a registration played them), every value the twenty-first and twenty-second registrations drew (their
  # draws are in play_21.sh and play_22.sh), and those this draw has already given to that kind
  SEEN_mass=" 0.1 0.15 0.167 0.35 0.352 0.4 0.436 0.45 0.5 0.55 0.6 0.632 0.649 0.65 0.698 0.7 0.8 0.854 0.893 0.897 "
  SEEN_mass="${SEEN_mass}0.9 1 1.015 1.05 1.063 1.1 1.15 1.152 1.157 1.177 1.2 1.25 1.3 1.325 1.4 1.45 1.5 1.556 1.6 1.7 1.75 2 "
  SEEN_mass="${SEEN_mass}2.2 2.216 2.3 2.4 2.6 2.7 3 3.2 3.5 4 4.177 4.237 4.562 5 5.2 "
  SEEN_len=" 0 0.01 0.0112 0.012 0.02 0.025 0.0255 0.0275 0.028 0.03 0.0316 0.032 0.0328 0.035 0.038 0.0388 0.04 "
  SEEN_len="${SEEN_len}0.0423 0.0439 0.0443 0.0449 0.045 0.0471 0.0497 0.05 0.0514 0.055 0.058 0.06 0.07 0.076 0.08 0.081 0.09 "
  SEEN_len="${SEEN_len}0.095 0.099 0.1 0.11 0.12 0.15 0.16 0.18 0.197 0.2 0.203 0.206 0.22 0.226 0.233 0.244 0.247 0.25 0.254 "
  SEEN_len="${SEEN_len}0.26 0.27 0.273 0.274 0.279 0.28 0.282 0.296 0.3 0.32 0.33 0.35 0.37 0.38 0.4 0.42 0.443 0.444 0.45 "
  SEEN_len="${SEEN_len}0.482 0.5 0.501 0.52 0.529 0.548 0.55 0.561 0.585 0.594 0.598 0.6 0.642 0.673 0.7 10 "
  SEEN_fric=" 0 0.25 0.28 0.3 0.32 0.341 0.35 0.37 0.38 0.391 0.392 0.4 0.406 0.417 0.42 0.44 0.449 0.45 0.46 0.471 "
  SEEN_fric="${SEEN_fric}0.473 0.48 0.492 0.5 0.52 0.544 0.55 0.6 "
  SEEN_speed=" -1.8 -1.16 -1 -0.27 0.015 0.02 0.7 0.75 0.8 0.81 0.84 0.85 0.87 0.9 1 1.04 1.05 1.1 1.16 1.2 1.3 1.35 "
  SEEN_speed="${SEEN_speed}1.36 1.5 1.56 1.8 1.9 2 2.08 2.1 2.18 2.2 2.33 2.5 2.53 2.6 2.7 2.8 2.93 3 3.09 3.1 3.2 3.45 3.5 3.8 "
  SEEN_speed="${SEEN_speed}3.9 3.98 4 4.2 4.5 4.51 4.89 5 5.5 6 8 "
  SEEN_torque=" 1.11 1.5 1.87 2 2.05 2.5 3 3.16 4 10.5381 12 13 13.5104368 15.68 "
  SEEN_force=" 0.67 0.9 1.646 1.764 2.117 2.32848 2.4696 2.76208296 2.94 3.10464 3.234 3.2928 3.528 4.0425 4.2336 "
  SEEN_force="${SEEN_force}4.234 4.84659 4.9392 5.52416592 5.69184 5.88 6.468 6.5856 6.79875 7.203 7.7175 8 8.085 8.4672 9.016 9.1 "
  SEEN_force="${SEEN_force}9.69318 9.9610875 10 14.7 16.4787 20.39625 21.609 23.1525 23.52 24.3873 27.048 28.8004752 29.4 "
  SEEN_force="${SEEN_force}29.8832625 32.34 33.1894836 34.0158 36.75 41.16 42.63 47.04 51.45 "
  SEEN_ang=" -1.1 -0.982 -0.934 -0.922 -0.9 -0.893 -0.8 -0.7 -0.6 -0.512 -0.502 -0.5 -0.373 -0.34 -0.33 -0.3 0 0.033 "
  SEEN_ang="${SEEN_ang}0.2 0.25 0.3 0.31 0.326 0.346 0.35 0.4 0.5 0.6 0.653 0.7 0.787 3 "
  SEEN_lin=" 0.08 0.083 0.09 0.1 0.103 0.106 0.116 0.12 0.13 0.15 0.2 0.21 "
  SEEN_ea=" 100 120 131 150 176 250 281 299 300 "
  SEEN_ei=" 1.2 2 2.2 2.5 3 3.3 4.2 4.5 5 "
  SEEN_mmu=" 400 500 565 "
  SEEN_rhoa=" 0.84 1 1.16 1.2 "
  SEEN_rho=" 884 904 1000 1100 "
  SEEN_young=" 1 1.93 2 "
  SEEN_limk=" 100 2000 2135 "
  SEEN_limd=" 17 20 150 178 "
  SEEN_axis=" -1 -0.97 -0.8 -0.68 -0.59 -0.5 -0.41 -0.4 -0.38 -0.15 -0.11 -0.08 0 0.11 0.27 0.36 0.48 0.55 0.6 0.75 "
  SEEN_axis="${SEEN_axis}0.8 1 2 "
  SEEN_mant=" 1.62 1.66 1.8 2 2.02 2.2 2.68 2.85 3 3.03 3.47 4 5 6 8 8.5 "
  SEEN_ratio=" 1.53 1.56 "
  q() {  # q <kind> <name> <lo> <hi> <places>: one quantity, drawn again while its value is one its kind may not take
    local k="$1" v p seen
    while :; do
      pick "$3" "$4"; v="$(dec "$V" "$5")"; p="$(plain "$v")"
      eval "seen=\"\${SEEN_$k:- }\""
      case "$seen" in *" $p "*) echo "  ($2 drawn again: $v)" ;; *) eval "SEEN_$k=\"\${SEEN_$k:- }$p \""; break ;; esac
    done
    D="$v"; [ "${QUIET:-0}" = 1 ] || echo "$2 $v"
  }
  q mass s1_mass 800 2000 3; q len s1_half 300 450 4; q len s1_h0 70 100 3; q speed s1_vx 200 400 2; q speed s1_vxchain 90 150 2
  q fric s1_mu 300 450 3; q speed s1_vslide 250 500 2; q fric s1_muhold 400 500 3
  q fric s2_mu 300 450 3; q speed s2_vstop 80 130 2; q len s2_h0 50 80 3
  q mass s2_massa 2500 5000 3; q len s2_ra 200 320 3; q mass s2_massb 350 800 3; q len s2_rb 250 350 4; q fric s2_mup 350 500 3
  q speed s2_vside 100 150 2; q speed s2_vtop 70 100 2
  for p in pa pb; do q mass ${p}_massa 2500 5000 3; q len ${p}_ra 200 320 3; q mass ${p}_massb 350 800 3; q len ${p}_rb 250 350 4; q fric ${p}_mu 350 500 3; done
  q mass arm_mass 1500 3000 3; q len arm_half 400 600 4; q len arm_dist 350 500 3
  q speed w1 100 250 2; q speed w2 250 450 2; q speed w3 450 600 2
  q speed jt1_spin 200 400 2; q torque jt2_torque 100 200 2; q ratio jt4_hold_over_gravity 130 180 2; q torque jt5_friction 150 250 2; q torque jt5_excess 80 150 2
  q ang lim_lo -400 -250 3; q limk lim_stiffness 1500 2500 0; q limd lim_damping1 150 300 1; q limd lim_damping2 120 180 0; q ang lim_depth 20 40 3
  q mass ch_mass1 1000 1500 3; q mass ch_mass2 600 900 3; q len ch_radius 400 500 4; q len ch_arm1 250 300 3; q len ch_len1 500 600 3; q len ch_arm2 200 250 3
  q ang ch_free_angle2 -1000 -600 3; q speed ch_free_omega1 200 300 2; q speed ch_free_omega2 -150 150 2; q ang ch_swing_angle1 300 700 3; q ang ch_swing_angle2 -800 -400 3
  local a; for a in 1 2 3 4 5; do q axis axis${a}_x -100 100 2; q axis axis${a}_y -100 100 2; q axis axis${a}_z -100 100 2; done
  q mant angle1_mantissa_e-4 100 999 2; q mant angle2_mantissa_e-7 100 999 2; q mant angle3_mantissa_e-9 300 999 2; q mant angle4_mantissa_e-9 201 299 2
  q mant angle5_mantissa_e-9 100 199 2; q mant angle6_mantissa_e-10 100 999 2; q mant angle7_mantissa_e-12 100 999 2; q mant angle8_mantissa_e-14 100 999 2
  q mass cl_mass 1000 1600 3; q len cl_half 300 400 4; q len cl_h0 60 80 3; q speed cl_vx 300 350 2; q fric cl_mu 350 420 3; q speed cl_vslide 350 400 2; q fric cl_muhold 400 500 3
  q lin rod_lin 100 200 3; q ea rod_ea 120 300 0; q ei rod_ei 12 50 1; q len rod_len 400 700 3
  q rhoa strip_rhoa 80 150 2; q mmu strip_mmu 400 600 0; q len strip_len 300 500 3
  q rho bar_rho 800 1300 0; q young bar_young_MPa 150 300 2; q len bar_len 300 500 3
  # each cantilever drawn again, all four numbers, until its textbook sag lin x 9.8 x len^4 / (8 ei) is from 2 to 10 mm
  local c lin ei len ea ok
  for c in cant1 cant2 cant3; do
    while :; do
      QUIET=1 q lin ${c}_lin 80 200 3; lin=$D; QUIET=1 q ea ${c}_ea 120 300 0; ea=$D; QUIET=1 q ei ${c}_ei 12 50 1; ei=$D; QUIET=1 q len ${c}_len 450 700 3; len=$D
      ok=$(awk -v l="$lin" -v e="$ei" -v n="$len" 'BEGIN { s = l * 9.8 * n ^ 4 / (8 * e); print (s >= 0.002 && s <= 0.010) ? 1 : 0 }')
      [ "$ok" = 1 ] && break
      echo "  ($c drawn again: lin $lin ea $ea ei $ei len $len, sag outside 2 to 10 mm)"
    done
    echo "${c}_lin $lin"; echo "${c}_ea $ea"; echo "${c}_ei $ei"; echo "${c}_len $len"
  done
  # the floor's tilt drawn again until tan(tilt) / friction is from 0.60 to 0.75
  local fmu tilt; q fric floor_mu 400 550 3; fmu=$D
  while :; do
    QUIET=1 q ang floor_tilt 200 360 3; tilt=$D
    ok=$(awk -v t="$tilt" -v m="$fmu" 'BEGIN { r = sin(t) / cos(t) / m; print (r >= 0.60 && r <= 0.75) ? 1 : 0 }')
    [ "$ok" = 1 ] && break
    echo "  (floor_tilt drawn again: $tilt, tan(tilt) / friction outside 0.60 to 0.75)"
  done
  echo "floor_tilt $tilt"
  q speed floor_v0 60 100 2; q len patch_size 160 240 3; q rhoa patch_rhoa 80 120 2; q len soft_cube_size 80 120 3; q rho soft_cube_rho 800 1200 0
  q mass grip_mass 100 200 3; q len grip_half 100 160 4; q fric grip_mu 400 550 3; q force grip_strong 60 100 1; q force grip_weak 50 100 2
}

for part in $PARTS; do
log_part "$part" started
case "$part" in
draw)
  draw
  ;;
rigs)
  : > "$O/rigs.sha256"
  if [ "$OS" = Linux ]; then
    # the patched library must be built from this commit's patch files: run 039's build.sh records what it applied
    [ -f "$WD/patches.sha256" ] || { echo "no $WD/patches.sha256: build the libraries with validation/run_039_linux_replication/build.sh" >&2; exit 2; }
    if ! cmp -s <(awk '{ print $1 }' "$WD/patches.sha256" | sort) <(sha patches/senua_*.patch | awk '{ print $1 }' | sort); then
      echo "the patched library in $WD was not built from the patch files in patches/" >&2; exit 2
    fi
    # build_player.sh calls c++: Clang, through a link in a folder of this part's own (the work folder is only read)
    CXXD="$(mktemp -d "${TMPDIR:-/tmp}/play23_cxx.XXXXXX")" && ln -s "$(command -v clang++)" "$CXXD/c++"
    rig() { PATH="$CXXD:$PATH" SUPERDEX_SRC=$WD/$3 SUPERDEX_BUILD=$WD/$2 SRC=sdx_$1.cpp OUT=$4 LIB=mochi_physics_double tools/build_player.sh > /dev/null 2>&1 || echo "RIG FAILED $4" | tee -a "$O/played.txt"; }
    for r in contact pair joint chain deform grip rotvec player; do rig $r build-patched superdex-patched-src sdx_${r}64; done
    for r in contact joint player deform grip; do rig $r build-stock superdex-src sdx_${r}64_stock; done
    rm -rf "$CXXD"
    { sha tools/sdx_*.cpp tools/build_player.sh tools/play_identity.sh tools/contact_suite.sh tools/contact_suite2.sh
      sha tools/sdx_*64 tools/sdx_*64_stock
      sha patches/senua_*.patch "$WD"/build-stock/bin/libmochi_physics_double.so "$WD"/build-patched/bin/libmochi_physics_double.so
      # the library each rig loads, without the load address ldd prints (it changes from run to run)
      for r in tools/sdx_*64 tools/sdx_*64_stock; do echo "$r loads: $(ldd $r | grep mochi | sed 's/ (0x[0-9a-f]*)$//')"; done
    } | sed "s#$HOME/#~/#g" >> "$O/rigs.sha256"
  else
    { sha tools/sdx_*.cpp tools/play_identity.sh tools/contact_suite.sh tools/contact_suite2.sh
      sha tools/sdx_*64 tools/sdx_*64_stock
      for r in tools/sdx_*64 tools/sdx_*64_stock; do echo "$r loads from: $(otool -l $r | grep -A2 LC_RPATH | awk '/ path / { print $2 }')"; done
      for l in $(otool -l tools/sdx_contact64 tools/sdx_contact64_stock | grep -A2 LC_RPATH | awk '/ path / { print $2 }' | sort -u); do sha "$l/libmochi_physics_double.dylib"; done
    } | sed "s#$HOME/#~/#g" >> "$O/rigs.sha256"
  fi
  ;;
identity)
  # E0 (the eleventh and twelfth registrations' F0 and G0, the thirteenth's and fourteenth's E0): the identity check's
  # parts against the record's registered files
  clear_switches
  ID_PARTS="${PLAY23_IDENTITY_PARTS:-rotvec flight suites joints zero fg bench benchrec}"
  : > "$O/identity.txt"
  # shellcheck disable=SC2086
  SUPERDEX_ASSETS="$A" bash tools/play_identity.sh "$O/identity.txt" $ID_PARTS > "$O/identity_play.txt" 2>&1
  if [ "$OS" = Linux ]; then
    # the plays runs 040 and 047 found Linux makes differently from the laptop, stock and patched alike: each compared
    # with the Linux file run 040 kept from library build 15, and those with no switch also with the same play made on
    # the stock library on this machine
    K=validation/run_040_linux_identity/runs; W=work/_identity; mkdir -p "$W/stock23"
    same() { if [ -f "$1" ] && cmp -s "$1" "$2"; then echo SAME; else echo DIFFERS; fi; }
    one() {  # one <label in identity.txt> <play> <run 040's file> <stock replay or ->
      local s="-"; [ "$4" != - ] && s="$(same "$2" "$4")"
      echo "LINUX $1 | kept $(same "$2" "$3") | stock $s" >> "$O/identity_linux.txt"
    }
    : > "$O/identity_linux.txt"
    J="mass=2 radius=0.04 arm=0.4"
    tools/sdx_joint64_stock "$W/stock23/swing_be_64.txt" dt="$(dt_of 64)" $J secs=3 > /dev/null 2>&1
    one "joint swing_be_64" "$W/joints/swing_be_64.txt" "$K/joints_swing_be_64.txt" "$W/stock23/swing_be_64.txt"
    one "zero joint swing_be_64" "$W/zero/swing_be_64.txt" "$K/joints_swing_be_64.txt" "$W/stock23/swing_be_64.txt"
    one "fg chain swing_16" "$W/fg/swing_16.txt" "$K/fg_chain_swing_16.txt" -
    one "fg chain tight free_16" "$W/fg/tight_16.txt" "$K/fg_chain_tight_free_16.txt" -
    one "fg joints_fc swing_be_64" "$W/fg/swing_be_64.txt" "$K/fg_joints_fc_swing_be_64.txt" -
    one "fg limits_fc rel20_64" "$W/fg/rel20_64.txt" "$K/fg_limits_fc_rel20_64.txt" -
    for src in s4 c1 c06 c03; do
      case $src in s4) X="integ=be maxiter=4" ;; c1) X="integ=be maxiter=200 smooth=0.00125" ;; c06) X="integ=be maxiter=200 smooth=0.000625" ;; c03) X="integ=be maxiter=200 smooth=0.0003125" ;; esac
      # shellcheck disable=SC2086
      tools/sdx_player64_stock ant "$A" actions/03/ant.txt "$W/stock23/ant_$src" $X < /dev/null > "$W/stock23/ant_$src.out" 2>&1
      one "benchmark ant $src" "$W/bench/ant_${src}_enc.pcm" "$K/bench/ant_${src}_enc.pcm" "$W/stock23/ant_${src}_enc.pcm"
    done
    for k in 1 4; do one "benchmark under its switches half_cheetah y$k" "$W/benchrec/half_cheetah_y${k}_enc.pcm" "$K/bench/half_cheetah_y${k}_enc.pcm" -; done
  fi
  ;;
suites)
  # both contact suites on the fresh cube under the recommended configuration (F2 to F6, K1 to K3) and without patch F
  # (F1, F6); each suite's files copied into the run
  export SUITE_CUBE="$S1_CUBE" SUITE_H0=$S1_H0 SUITE_VX=$S1_VX SUITE_VXCHAIN=$S1_VXCHAIN SUITE_MU=$S1_MU SUITE_VSLIDE=$S1_VSLIDE SUITE_MUHOLD=$S1_MUHOLD SUITE_HOLD=$S1_HOLD SUITE_SLIP=$S1_SLIP SUITE_LIFT=$S1_LIFT
  export S2_CUBE="$S1_CUBE" S2_MU S2_VSTOP S2_H0 S2_PAIR S2_MUP S2_CARRY S2_SLIP S2_VSIDE S2_VTOP
  for cfg in final nof; do
    ( $cfg
      # shellcheck disable=SC2086
      RIG="$R/tools/sdx_contact64" tools/contact_suite.sh s23_$cfg $CON $TOL sdfdiv=32 integ=be &&
      # shellcheck disable=SC2086
      RIG="$R/tools/sdx_contact64" RIGPAIR="$R/tools/sdx_pair64" tools/contact_suite2.sh s23_$cfg $CON $TOL sdfdiv=32 integ=be
    ) > "$O/log_suites_$cfg.txt" 2>&1
    echo "PLAYED suites $cfg rc $?" >> "$O/played.txt"
    mkdir -p "$O/runs/s1" "$O/runs/s2"; rm -rf "$O/runs/s1/$cfg" "$O/runs/s2/$cfg"
    cp -R "suites/1/s23_$cfg" "$O/runs/s1/$cfg"; cp -R "suites/2/s23_$cfg" "$O/runs/s2/$cfg"
  done
  unset SUITE_CUBE SUITE_H0 SUITE_VX SUITE_VXCHAIN SUITE_MU SUITE_VSLIDE SUITE_MUHOLD SUITE_HOLD SUITE_SLIP SUITE_LIFT S2_CUBE
  clear_switches
  ;;
items)
  # item 1 (V1, I1d): the two pairs, each cube's cell at 1/32 of its side, pushed from 0.5 s, 0.9 s, steps 1 and 1/16
  W="$O/runs/items"; mkdir -p "$W"; : > "$W/stats.txt"
  final
  for k in 1 16; do
    # shellcheck disable=SC2086
    tools/sdx_pair64 "$W/pa_$k" dt="$(dt_of $k)" layout=stack pushat=0.5 secs=0.9 $CON $TOL sdfdiv=32 $PAIR_A | st pa_$k >> "$W/stats.txt"
    # shellcheck disable=SC2086
    tools/sdx_pair64 "$W/pb_$k" dt="$(dt_of $k)" layout=stack pushat=0.5 secs=0.9 $CON $TOL sdfdiv=32 $PAIR_B | st pb_$k >> "$W/stats.txt"
  done
  # the three cantilevers held across the clamp, 32, 64 and 128 elements, 0.01 s, under the configuration's switches
  # and tolerances (V4, the fourteenth's I4a and I4c)
  for n in 32 64 128; do
    for c in 1 2 3; do
      eval "CR=\$CANT$c"
      # shellcheck disable=SC2086
      tools/sdx_deform64 "$W/cant${c}_n$n.txt" case=rod_cantilever dt=0.01 $CR n=$n clampmid=1 $TOL | st cant${c}_n$n >> "$W/stats.txt"
    done
  done
  clear_switches
  echo "PLAYED items" >> "$O/played.txt"
  ;;
arm)
  # one arm on one joint, no gravity, released at the three speeds, 1 s, steps 1, 1/4 and 1/16: stock (G1, the law),
  # and the recommended configuration (G2, G7, V2)
  for cfg in stock final; do
    W="$O/runs/arm_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    clear_switches; T=tools/sdx_joint64_stock; X=""
    [ $cfg = final ] && { final; T=tools/sdx_joint64; X="newtoneuler=1 $TOL"; }
    for w in $W1 $W2 $W3; do for k in 1 4 16; do
      # shellcheck disable=SC2086
      $T "$W/spin${w}_$k.txt" dt="$(dt_of $k)" $ARM gravity=0 omega0=$w secs=1 $X | st spin${w}_$k >> "$W/stats.txt"
    done; done
  done
  clear_switches
  echo "PLAYED arm" >> "$O/played.txt"
  ;;
chain)
  # two arms on two joints, free and swinging, 2 s, steps 1, 1/4 and 1/16: no switch at SuperDex's shipped tolerances
  # (G3, G6), the recommended configuration (G5, G6, G7, V2), and the recommended configuration with the solver
  # converged, absolute 1e-9 and relative 1e-12 (G4, free only)
  for cfg in off final tight; do
    W="$O/runs/chain_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    clear_switches; X="newtoneuler=0"
    [ $cfg = final ] && { final; X="newtoneuler=1 $TOL"; }
    [ $cfg = tight ] && { final; X="newtoneuler=1 $TIGHT"; }
    for case in free swing; do
      [ $cfg = tight ] && [ $case = swing ] && continue
      SET="gravity=0 $CFREE secs=2"; [ $case = swing ] && SET="gravity=1 $CSWING secs=2"
      for k in 1 4 16; do
        # shellcheck disable=SC2086
        tools/sdx_chain64 "$W/${case}_$k.txt" dt="$(dt_of $k)" $CHAIN $SET $X | st ${case}_$k >> "$W/stats.txt"
      done
    done
  done
  clear_switches
  echo "PLAYED chain" >> "$O/played.txt"
  ;;
joints)
  # the sixth registration's tests on the fresh arm (G8; J1 to J5): the recommended configuration at the steps the
  # fourteenth played them; stock's spin, hold and slip beside it; and the swing of 20 s at steps 1 and 1/16 (V9)
  for cfg in final stock; do
    W="$O/runs/joints_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    clear_switches; T=tools/sdx_joint64_stock; X=""; ks="1"
    [ $cfg = final ] && { final; T=tools/sdx_joint64; X="newtoneuler=1 $TOL"; ks="1 4 16 64"; }
    play() { local name="$1" k="$2"; shift 2
      # shellcheck disable=SC2086
      $T "$W/${name}_$k.txt" dt="$(dt_of $k)" $ARM "$@" $X | st ${name}_$k >> "$W/stats.txt"; }
    for k in $ks; do play spin $k gravity=0 omega0=$JT1 secs=1; [ $cfg = final ] && { play torque $k gravity=0 torque=$JT2 secs=1; play swing $k secs=3; }; done
    for k in 1 16; do play hold $k coulomb=$JT4 secs=2; play slip $k gravity=0 coulomb=$JT5C torque=$JT5T secs=1; done
    [ $cfg = final ] && for k in 1 16; do play long $k secs=$LONG; done
  done
  clear_switches
  echo "PLAYED joints" >> "$O/played.txt"
  ;;
limits)
  # the eighth registration's limit tests on the fresh arm and limit, recommended configuration (L1 to L4)
  W="$O/runs/limits_final"; mkdir -p "$W"; : > "$W/stats.txt"
  final
  play() { local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    tools/sdx_joint64 "$W/${name}_$k.txt" dt="$(dt_of $k)" $ARM $LIM "$@" newtoneuler=1 $TOL | st ${name}_$k >> "$W/stats.txt"; }
  for k in 1 16; do play rest $k secs=3 limitd=$LD2; play lift $k secs=1.6 limitd=$LD2 torque=$LLIFT torqueat=1.5; done
  for k in 1 16 64; do play rel1 $k secs=0.5 gravity=0 angle0=$LANGLE0 limitd=$LD1; play rel2 $k secs=0.5 gravity=0 angle0=$LANGLE0 limitd=$LD2; done
  clear_switches
  echo "PLAYED limits" >> "$O/played.txt"
  ;;
rotvec)
  # the forty fresh rotations through SuperDex's quaternion, recommended configuration (R1)
  final
  CASES=""; for ax in $AXES; do for an in $ANGLES; do CASES="$CASES $ax,$an"; done; done
  # shellcheck disable=SC2086
  tools/sdx_rotvec64 "$O/runs/rotvec_final.txt" $CASES > /dev/null
  echo "PLAYED rotvec rc $?" >> "$O/played.txt"
  clear_switches
  ;;
cloud)
  # the fresh cube on the held sheet (a node every 10 mm): stock (P1) and the recommended configuration (P2)
  for cfg in stock final; do
    clear_switches; T=tools/sdx_contact64_stock; X=""
    [ $cfg = final ] && { final; T=tools/sdx_contact64; X="$CON $TOL sdfdiv=32 smooth=0.001"; }
    W="$O/runs/cloud_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" k="$2"; shift 2
      # shellcheck disable=SC2086
      $T "$W/${name}_$k.txt" dt="$(dt_of $k)" $CL_CUBE "$@" floor=cloud cloudwid=0.16 $X | st ${name}_$k >> "$W/stats.txt"; }
    for k in 1 4; do play oblique $k h0=$CL_H0 secs=0.3 vx0=$CL_VX mu=$CL_MU; done
    play slide 1 h0=0 secs=0.5 vx0=$CL_VSLIDE mu=$CL_MU
    play rest 1 h0=0 secs=2
    play hold 1 h0=0 secs=2 mu=$CL_MUHOLD push=$CL_HOLD pushat=0.5
    play slip 1 h0=0 secs=2 mu=$CL_MUHOLD push=$CL_SLIP pushat=0.5
    play lift 1 h0=0 secs=0.4 lift=$CL_LIFT liftat=0.3
  done
  clear_switches
  echo "PLAYED cloud" >> "$O/played.txt"
  ;;
deform)
  # the deformable bodies at 0.01 s and 0.001 s: stock falls and hangs (D1, D2); the cloth patch and the soft cube on
  # the fresh floor, at rest, sliding and on the tilt, stock and recommended configuration (D4 to D8)
  for cfg in stock final; do
    clear_switches; X=""; T=tools/sdx_deform64
    [ $cfg = final ] && { final; X="$CON $TOL"; }
    # stock is played on the stock library; where no stock rig was built (the laptop), on the patched library with no
    # switch, as Studies 13 to 16 played it (run 046 found the two the same)
    [ $cfg = stock ] && [ -x tools/sdx_deform64_stock ] && T=tools/sdx_deform64_stock
    [ $cfg = stock ] && echo "deform stock played on $T" >> "$O/played.txt"
    W="$O/runs/deform_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    play() { local name="$1" dt="$2"; shift 2
      # shellcheck disable=SC2086
      $T "$W/${name}_$dt.txt" dt="$dt" "$@" $X | st ${name}_$dt >> "$W/stats.txt"; }
    for dt in 0.01 0.001; do
      if [ $cfg = stock ]; then
        # shellcheck disable=SC2086
        { play rod_fall $dt case=rod_fall $ROD; play shell_fall $dt case=shell_fall $STRIP; play soft_fall $dt case=soft_fall $BAR
          play rod_hang $dt case=rod_hang $ROD; play shell_hang $dt case=shell_hang $STRIP; play soft_hang $dt case=soft_hang $BAR; }
      fi
      # shellcheck disable=SC2086
      { play shell_rest $dt case=shell_rest $FLOOR $PATCH; play shell_slide $dt case=shell_slide $FLOOR $PATCH v0=$FV0; play shell_hold $dt case=shell_hold $FLOOR $PATCH tilt=$FTILT
        play soft_rest $dt case=soft_rest $FLOOR $SOFT; play soft_slide $dt case=soft_slide $FLOOR $SOFT v0=$FV0; play soft_hold $dt case=soft_hold $FLOOR $SOFT tilt=$FTILT; }
    done
  done
  clear_switches
  echo "PLAYED deform" >> "$O/played.txt"
  ;;
grip)
  # the gripper holding the fresh cube: both grippers, the grip and the weak grip, stock and the recommended
  # configuration (GR1 to GR5, the thirteenth's and fourteenth's G1 to G5)
  for cfg in stock final; do
    clear_switches; X=""; T=tools/sdx_grip64
    [ $cfg = final ] && { final; X="$CON newtoneuler=1 $TOL"; }
    [ $cfg = stock ] && [ -x tools/sdx_grip64_stock ] && T=tools/sdx_grip64_stock   # as for the deformable bodies
    [ $cfg = stock ] && echo "grip stock played on $T" >> "$O/played.txt"
    W="$O/runs/grip_$cfg"; mkdir -p "$W"; : > "$W/stats.txt"
    for g in built fr3; do for grip in $GSTRONG $GWEAK; do
      # shellcheck disable=SC2086
      $T "$W/${g}_$grip.txt" gripper=$g assets="$AP" $GRIP_CUBE grip=$grip dt=0.01 $X | st ${g}_$grip >> "$W/stats.txt"
    done; done
  done
  clear_switches
  echo "PLAYED grip" >> "$O/played.txt"
  ;;
bench)
  # Meta's three scenes at the shipped step on the fresh commands: stock (reported), the recommended configuration
  # (B1, B2), and the same without patch F (F5) and without patch G and Newton-Euler inertia (G9)
  W="$O/runs/bench"; mkdir -p "$W"; touch "$W/stats.txt"
  for sc in cart_pole half_cheetah ant; do
    for cfg in stock final nof nog; do
      if grep -q "^STATS source ${sc}_$cfg " "$W/stats.txt"; then continue; fi
      clear_switches; T=tools/sdx_player64_stock; X="integ=be"
      case $cfg in
        final) final; T=tools/sdx_player64; X="integ=be $CON newtoneuler=1 $TOL" ;;
        nof) nof; T=tools/sdx_player64; X="integ=be $CON newtoneuler=1 $TOL" ;;
        nog) nog; T=tools/sdx_player64; X="integ=be $CON $TOL" ;;
      esac
      # shellcheck disable=SC2086
      $T "$sc" "$A" "$ACT/$sc.txt" "$W/${sc}_$cfg" maxiter=200 $X < /dev/null > "$W/${sc}_$cfg.out" 2>&1
      sed "s/^STATS/STATS source ${sc}_$cfg/" "$W/${sc}_$cfg.out" | grep '^STATS' >> "$W/stats.txt"
      rm -f "$W/${sc}_${cfg}_state.f32"
    done
  done
  clear_switches
  echo "PLAYED bench" >> "$O/played.txt"
  ;;
order)
  # the order test of the eleventh and twelfth registrations' decisions, carried as B3: half_cheetah and ant on the
  # fresh commands under the recommended configuration at steps 1, 1/2, 1/4, 1/8 and 1/16 (sources o1 to o16), each
  # stream written as <out>/runs/order/<scene>/o<k>_enc.pcm for the instrument (sx_settings3), with the settings of
  # the part bench's plays under the configuration; every stopped or diverged solver step is taken from the play's
  # trace (step, status 2 stopped or 3 diverged, iterations, residual) into runs/order/stops/, and the trace removed
  W="$O/runs/order"; mkdir -p "$W/stops"
  final
  for sc in half_cheetah ant; do
    mkdir -p "$W/$sc"; touch "$W/stats_$sc.txt"
    for k in 1 2 4 8 16; do
      if grep -q "^STATS source o$k " "$W/stats_$sc.txt"; then continue; fi
      SUB=""; [ "$k" -gt 1 ] && SUB="sub=$k"
      # shellcheck disable=SC2086
      SDX_TRACE="$W/$sc/o$k.tr" tools/sdx_player64 "$sc" "$A" "$ACT/$sc.txt" "$W/$sc/o$k" maxiter=200 integ=be $CON newtoneuler=1 $TOL $SUB < /dev/null > "$W/$sc/o$k.out" 2>&1
      sed "s/^STATS/STATS source o$k/" "$W/$sc/o$k.out" | grep '^STATS' >> "$W/stats_$sc.txt"
      if [ -f "$W/$sc/o$k.tr" ]; then awk '$2 == 2 || $2 == 3' "$W/$sc/o$k.tr" > "$W/stops/${sc}_o$k.txt"; fi
      rm -f "$W/$sc/o$k.tr" "$W/$sc/o${k}_state.f32"
    done
  done
  clear_switches
  echo "PLAYED order" >> "$O/played.txt"
  ;;
*) echo "unknown part $part" >&2; exit 2 ;;
esac
log_part "$part" finished
done
