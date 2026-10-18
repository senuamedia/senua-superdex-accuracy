#!/usr/bin/env bash
# Run 039, step 2: the record's two contact suites played on the Linux builds of step 1, and compared with the
# laptop's. Not registered: a replication probe.
#   linux_stock  stock SuperDex, no setting and no switch. Compared byte for byte with the record's id_off plays (the
#                patched library with every switch unset, which Study 16 found byte-identical to stock on the laptop)
#   linux_final  the patched library with every switch of the recommended configuration set and the rig settings of the
#                record's dry14_final plays (contact damping 5, falloff 0.03, tolerances 1e-4 and 1e-8, the grid cell at
#                1/32 of a side, backward Euler). Compared by its readings with the recommended configuration's published
#                result (10 of 10 and 7 of 7), and byte for byte with dry14_final, which may have been played on an
#                earlier library build
# Both suites read by the record's own runner, measure/runners/sx_contact_suite.sh, with Senua AI's sx_contact built
# for Linux beside it.
# usage: play.sh <work folder of step 1> <sx_contact for Linux>   (from the root of a copy of this repository)
set -u
WD="$(cd "${1:?usage: play.sh <work folder> <sx_contact>}" && pwd)"; SX="$(cd "$(dirname "${2:?sx_contact}")" && pwd)/$(basename "$2")"
O=validation/run_039_linux_replication; mkdir -p $O
# the rigs, built by the record's build_player.sh with the library's own compiler (SuperDex's flags are Clang's)
mkdir -p "$WD/cxx" && ln -sf "$(command -v clang++)" "$WD/cxx/c++" && export PATH="$WD/cxx:$PATH"
for t in stock patched; do
  src=$WD/superdex-src; [ $t = patched ] && src=$WD/superdex-patched-src
  suf=""; [ $t = stock ] && suf=_stock
  for r in contact pair; do
    SUPERDEX_SRC=$src SUPERDEX_BUILD=$WD/build-$t SRC=sdx_$r.cpp OUT=sdx_${r}64$suf LIB=mochi_physics_double \
      tools/build_player.sh > /dev/null
  done
done
sha256sum tools/sdx_contact64* tools/sdx_pair64* > $O/rigs.sha256
cp "$SX" measure/runners/sx_contact
# stock
RIG=$PWD/tools/sdx_contact64_stock tools/contact_suite.sh linux_stock > /dev/null
RIG=$PWD/tools/sdx_contact64_stock RIGPAIR=$PWD/tools/sdx_pair64_stock tools/contact_suite2.sh linux_stock > /dev/null
# the recommended configuration's switches, and dry14_final's rig settings
( export SUPERDEX_FRICTION_FULL_NORMAL=1 SUPERDEX_DAMPING_UNILATERAL=1 SUPERDEX_STICK_DISTANCE=0.0003 \
    SUPERDEX_STICK_DAMPING=1 SUPERDEX_LIMIT_UNILATERAL=1 SUPERDEX_ROTATION_AXIS_EXACT=1 SUPERDEX_FRICTION_STEP_NORMAL=1 \
    SUPERDEX_INERTIA_TRANSPORT=1
  SET="ndamp=5 falloff=0.03 abstol=1e-4 reltol=1e-8 sdfdiv=32 integ=be"
  # shellcheck disable=SC2086
  RIG=$PWD/tools/sdx_contact64 tools/contact_suite.sh linux_final $SET > /dev/null
  # shellcheck disable=SC2086
  RIG=$PWD/tools/sdx_contact64 RIGPAIR=$PWD/tools/sdx_pair64 tools/contact_suite2.sh linux_final $SET > /dev/null )
for l in linux_stock linux_final id_off dry14_final; do
  bash measure/runners/sx_contact_suite.sh suites/1/$l $O/suite1_$l.txt > /dev/null 2>&1 || echo "suite 1 $l: measuring incomplete" >> $O/notes.txt
done
compare() {  # <new label> <record's label>: the play files of both suites, byte for byte
  local n=0 s=0 f
  for f in suites/1/$2/*_[0-9]*.txt suites/2/$2/*_[0-9]*.txt; do
    n=$((n + 1)); cmp -s $f ${f/\/$2\//\/$1\/} && s=$((s + 1))
  done
  echo "$1 against the record's $2: $s of $n play files byte-identical"
}
{ compare linux_stock id_off; compare linux_final dry14_final
  for l in linux_stock id_off linux_final dry14_final; do
    echo "== suite 1, $l"; grep '^T[01][0-9]\|^SUITE' $O/suite1_$l.txt
  done; } > $O/reading.txt
