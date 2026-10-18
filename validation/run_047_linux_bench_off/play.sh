#!/usr/bin/env bash
# Run 047: safe when off for the benchmark streams on Linux. Run 040 played the identity check's 38 benchmark streams
# (the third and fourth studies' sources, no switch) on Linux with the patched library and found 4 that differ from
# the registered macOS streams. Here the same 38 are played on the same Linux machine twice, once with the player
# built against the stock library and once with the player built against the patched library with no switch set,
# and each pair is compared byte for byte; each play is also compared with the registered stream, and the solver's own
# statistics of each pair (without the wall-clock field) with each other. Not registered: a check for publication.
# usage: play.sh <work folder holding superdex-src, build-stock, superdex-patched-src and build-patched>
#   (from the root of a clone of this repository; SUPERDEX_ASSETS defaults to <work folder>/superdex-src/assets)
set -u
WD="$(cd "${1:?usage: play.sh <work folder>}" && pwd)"
O=validation/run_047_linux_bench_off; W=work/_bench_off
mkdir -p "$O" && rm -rf "$W" && mkdir -p "$W/stock" "$W/off"
A="${SUPERDEX_ASSETS:-$WD/superdex-src/assets}"
unset SDX_TRACE SUPERDEX_STICK_DISTANCE SUPERDEX_STICK_DAMPING SUPERDEX_FRICTION_FULL_NORMAL SUPERDEX_DAMPING_UNILATERAL \
      SUPERDEX_LIMIT_UNILATERAL SUPERDEX_ROTATION_AXIS_EXACT SUPERDEX_FRICTION_STEP_NORMAL SUPERDEX_INERTIA_TRANSPORT
if env | grep -E '^(SUPERDEX_[A-Z_]+|SDX_[A-Z_]+)=' | grep -v '^SUPERDEX_ASSETS=' | grep -q .; then echo "a switch is set; stopping" >&2; exit 2; fi
# the two players, built with the same Clang as the libraries
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
SUPERDEX_SRC=$WD/superdex-src SUPERDEX_BUILD=$WD/build-stock SRC=sdx_player.cpp OUT=sdx_player64_stock \
  LIB=mochi_physics_double tools/build_player.sh > $O/build_stock.txt 2>&1
SUPERDEX_SRC=$WD/superdex-patched-src SUPERDEX_BUILD=$WD/build-patched SRC=sdx_player.cpp OUT=sdx_player64 \
  LIB=mochi_physics_double tools/build_player.sh > $O/build_patched.txt 2>&1
{
  sha256sum tools/sdx_player64_stock tools/sdx_player64
  for b in build-stock build-patched; do sha256sum "$(find "$WD/$b" -name 'libmochi_physics_double.so' | head -1)"; done
  for r in tools/sdx_player64_stock tools/sdx_player64; do echo "$r loads: $(ldd $r | grep mochi)"; done
} | sed "s#$HOME/#~/#g" > $O/rigs.txt
date -u +%FT%TZ > $O/started.txt
B="integ=be maxiter=200"
st() { grep '^STATS' "$1" | sed 's/ wall_s [0-9.]*//'; }
same_so=0; same_sr=0; same_or=0; same_st=0; n=0
play2() {  # play2 <scene> <source> <registered streams dir> <settings...>
  local sc="$1" src="$2" dir="$3"; shift 3
  tools/sdx_player64_stock "$sc" "$A" actions/03/$sc.txt "$W/stock/${sc}_$src" "$@" < /dev/null > "$W/stock/${sc}_$src.out" 2>&1
  tools/sdx_player64 "$sc" "$A" actions/03/$sc.txt "$W/off/${sc}_$src" "$@" < /dev/null > "$W/off/${sc}_$src.out" 2>&1
  local s="$W/stock/${sc}_${src}_enc.pcm" f="$W/off/${sc}_${src}_enc.pcm" r="$dir/$sc/${src}_enc.pcm" a b c d
  n=$((n + 1))
  if cmp -s "$s" "$f"; then a=SAME; same_so=$((same_so + 1)); else a=DIFFERS; fi
  if cmp -s "$s" "$r"; then b=SAME; same_sr=$((same_sr + 1)); else b=DIFFERS; fi
  if cmp -s "$f" "$r"; then c=SAME; same_or=$((same_or + 1)); else c=DIFFERS; fi
  if [ -n "$(st "$W/stock/${sc}_$src.out")" ] && cmp -s <(st "$W/stock/${sc}_$src.out") <(st "$W/off/${sc}_$src.out"); then
    d=SAME; same_st=$((same_st + 1)); else d=DIFFERS; fi
  echo "$sc $src | stock vs off $a | stock vs registered $b | off vs registered $c | statistics stock vs off $d" >> $O/compare.txt
}
: > $O/compare.txt
for sc in cart_pole ant half_cheetah; do
  case $sc in
    cart_pole) L="sref srefb z n9 n6 n3 n0 t2 t4 t8 t16 t32 t64 s1 s2 s4 s8 s16" ;;
    ant) L="sref t2 s4 s16 c10 c2 c1 c06 c03 g1 m1 d1 d2" ;;
    half_cheetah) L="sref t2 s1 s16 c03 m1 d1" ;;
  esac
  for src in $L; do
    case $src in
      sref|srefb) play2 $sc $src streams/03 $B ;;
      z) play2 $sc $src streams/03 $B nudge=0 ;;
      n9) play2 $sc $src streams/03 $B nudge=1e-9 ;; n6) play2 $sc $src streams/03 $B nudge=1e-6 ;;
      n3) play2 $sc $src streams/03 $B nudge=1e-3 ;; n0) play2 $sc $src streams/03 $B nudge=1 ;;
      t2|t4|t8|t16|t32|t64) play2 $sc $src streams/03 $B sub=${src#t} ;;
      s1|s2|s4|s8|s16) play2 $sc $src streams/03 integ=be maxiter=${src#s} ;;
      c10) play2 $sc $src streams/03 $B smooth=0.010 ;; c2) play2 $sc $src streams/03 $B smooth=0.0025 ;;
      c1) play2 $sc $src streams/03 $B smooth=0.00125 ;; c06) play2 $sc $src streams/03 $B smooth=0.000625 ;;
      c03) play2 $sc $src streams/03 $B smooth=0.0003125 ;;
      g1) play2 $sc $src streams/03 $B ground=0 ;; m1) play2 $sc $src streams/03 $B mu=0 ;;
      d1) play2 $sc $src streams/04 $B ndamp=5 ;; d2) play2 $sc $src streams/04 $B ndamp=5 sub=2 ;;
    esac
  done
done
date -u +%FT%TZ > $O/finished.txt
{
  echo "streams played: $n"
  echo "stock against patched with no switch, byte for byte: $same_so of $n"
  echo "statistics, stock against patched with no switch (without wall_s): $same_st of $n"
  echo "stock against the registered macOS stream: $same_sr of $n"
  echo "patched with no switch against the registered macOS stream: $same_or of $n"
} | tee $O/totals.txt
# the players' statistics lines, for the record
for w in stock off; do for f in "$W/$w"/*.out; do echo "$(basename "$f" .out) $(st "$f")"; done > $O/stats_$w.txt; done
