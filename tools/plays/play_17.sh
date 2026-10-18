#!/usr/bin/env bash
# The seventeenth registration's plays (PREREGISTRATION_17.md): the whole registered record of Studies 3 to 13 made
# again on the library of record, each study by its own play scripts, every registered file compared byte for byte.
# The play scripts write where the record keeps their files, so this is run in a fresh clone of the repository, never
# in the record itself: part "clear" deletes the clone's copies of the files to be made again. One play after another,
# one thread.
# usage: bash tools/plays/play_17.sh <the record> <out folder> <part ...>        (from the root of the clone)
#   <the record>  the root of a checkout of this repository whose files are the registered ones; it is only read
#   parts:
#     list     write <out>/inventory.txt: one line for every registered file: "<study> <class> <registered path>
#              <path made>". class: off (played with no patch switch set), on (played under patch switches),
#              changed (played under switches whose code changed after it was registered, as the registration lists)
#     clear    delete, in the clone, every file of the inventory as made, the clone's work/ and suites/ folders, and
#              the statistics files the play scripts append to (so nothing is skipped and nothing is appended twice)
#     s03 .. s13  play one study by its scripts, as docs/reproduce.md gives them; each writes <out>/log_<part>.txt
#              and appends "PART <part> rc <exit code> seconds <time>" to <out>/parts.txt
#     compare  compare every file of the inventory; write <out>/compare.txt: "<SAME|DIFFERS|MISSING> <study> <class>
#              <registered path>" and, for each study and class, "WHOLE <study> <class> <same> of <files>"
# How files are compared: byte for byte, with three exceptions fixed in advance. Files that carry the wall-clock time
# of a play (statistics files and the benchmark rig's output, field "wall_s") are compared without that field. The two
# FR3 gripper statistics files of run 029 are compared without the two error lines of the first, failed invocation
# that run 029's README records. The statistics of the twelfth registration's one-joint tests are compared without the
# lines of the six runs the registration lists as changed.
# Needs: the rigs in tools/ built against the library of record, with the *_stock names given the same library (so
# every stock play is made on the library of record with no switch set); SUPERDEX_ASSETS = the assets directory of
# the SuperDex source tree; bash, bc, cmp, shasum.
set -u
R="$(cd "$(dirname "$0")/../.." && pwd)"
REF="$(cd "${1:?usage: bash tools/plays/play_17.sh <the record> <out folder> <part ...>}" && pwd)"
O="${2:?out folder}"; shift 2; mkdir -p "$O"; O="$(cd "$O" && pwd)"
if [ "$(cd "$R" && pwd -P)" = "$(cd "$REF" && pwd -P)" ]; then echo "run this in a fresh clone, not in the record" >&2; exit 2; fi
INV="$O/inventory.txt"

# ---- the inventory: every registered play file of Studies 3 to 13 in the record ----
# cls <study> <class> <path made> <registered files...>: one inventory line per registered file; <path made> is "=" for
# the same path, or a folder (ending in /) where the file of the same name is made
cls() { local st="$1" c="$2" made="$3" f; shift 3; for f in "$@"; do [ -f "$REF/$f" ] || continue; if [ "$made" = "=" ]; then echo "$st $c $f $f"; else echo "$st $c $f $made$(basename "$f")"; fi; done; }
inside() { (cd "$REF" && find "$@" -type f ! -name 'SHA256SUMS' ! -name 'README.md' ! -name 'reading*.txt' 2>/dev/null | sort); }
inventory() {
  local c f
  # Study 3: the third registration's 84 sources on stock, its statistics and its rule R1's identity files
  cls s03 off = $(inside streams/03) $(cd "$REF" && ls validation/run_007_counts/stats_*.txt validation/run_007_counts/identity_*.txt)
  # Study 4: the one cube on stock, and the benchmark's time-step chain with contact damping
  cls s04 off = $(inside contact) validation/run_010_contact/stats.txt $(inside streams/04) $(cd "$REF" && ls validation/run_011_counts/stats_*.txt)
  # Study 5: the suite under nine configurations, made in suites/1/v5_<configuration>/; the benchmark streams
  for c in stock patched_off implicit damped; do cls s05 off "suites/1/v5_$c/" $(inside patches/validation/runs/$c); echo "s05 off patches/validation/stats_$c.txt suites/1/v5_$c/stats.txt"; done
  for c in damped_a damped_ab stick recommended recommended_implicit; do cls s05 on "suites/1/v5_$c/" $(inside patches/validation/runs/$c); echo "s05 on patches/validation/stats_$c.txt suites/1/v5_$c/stats.txt"; done
  for f in $(inside streams/05); do case "$(basename "$f")" in q*) cls s05 on = "$f" ;; *) cls s05 off = "$f" ;; esac; done
  cls s05 on = $(cd "$REF" && ls validation/run_013_counts/stats_*.txt)
  # Study 6: the 30 one-arm runs on stock
  cls s06 off = $(inside joints) validation/run_015_joints/stats.txt
  # Study 7: both suites, made in suites/<1|2>/v7_<configuration>/; the identity check; the benchmark
  for c in stock off; do cls s07 off "suites/1/v7_$c/" $(inside validation/run_017_counts/runs/s1/$c); cls s07 off "suites/2/v7_$c/" $(inside validation/run_017_counts/runs/s2/$c); done
  for c in rec_old rec_new; do cls s07 on "suites/1/v7_$c/" $(inside validation/run_017_counts/runs/s1/$c); done
  for c in stick stickd rec_old rec_new; do cls s07 on "suites/2/v7_$c/" $(inside validation/run_017_counts/runs/s2/$c); done
  cls s07 off = validation/run_017_counts/identity.txt
  cls s07 on = $(inside streams/07) $(cd "$REF" && ls validation/run_017_counts/stats_*.txt)
  # Study 8: the joint limits under stock, off and patched; the identity checks; the benchmark
  cls s08 off = $(inside limits/stock limits/off) validation/run_019_limits/nolimit_identity.txt validation/run_019_limits/identity.txt
  cls s08 on = $(inside limits/patched streams/08) $(cd "$REF" && ls validation/run_019_limits/stats_*.txt)
  # Study 9: the rotations, two free cubes with the solver's trace, both suites, the joints' identity, the benchmark
  for f in $(inside rotation); do case "$(basename "$f")" in *patched*) cls s09 on = "$f" ;; *) cls s09 off = "$f" ;; esac; done
  cls s09 on = validation/run_021_rotation/stats_flight.txt
  cls s09 off "suites/1/v9_off/" $(inside validation/run_021_rotation/runs/s1/off); cls s09 off "suites/2/v9_off/" $(inside validation/run_021_rotation/runs/s2/off)
  for c in rec stock_e rec_e; do cls s09 on "suites/1/v9_$c/" $(inside validation/run_021_rotation/runs/s1/$c); cls s09 on "suites/2/v9_$c/" $(inside validation/run_021_rotation/runs/s2/$c); done
  cls s09 off = validation/run_021_rotation/joints_identity_off.txt validation/run_021_rotation/identity.txt
  cls s09 on = validation/run_021_rotation/joints_identity_patched.txt $(inside streams/09) $(cd "$REF" && ls validation/run_021_rotation/stats_*.txt | grep -v stats_flight)
  # Study 10: ant's four command sets, each played eleven ways, with the solver's trace
  for f in $(inside validation/run_026_ant_stops); do
    case "$(basename "$f")" in stock[._]*|expn[._]*|implicit[._]*|armijo[._]*|nudge[._]*|ng_stock[._]*) cls s10 off = "$f" ;; *) cls s10 on = "$f" ;; esac
  done
  # Study 11: both suites under the friction correction, the benchmark, its statistics and traces: all under switches
  cls s11 on = $(inside validation/run_027_friction/runs validation/run_027_friction/traces streams/11) $(cd "$REF" && ls validation/run_027_friction/stats_*.txt)
  # Study 12: the arm and the chain under stock, Newton-Euler inertia (SuperDex's own setting), patch G and both; the
  # sixth registration's tests with both; the benchmark. Patch G's share under BDF2 and DIRK3 changed in library
  # build 13, after these were registered: those six runs are "changed"
  cls s12 off = $(inside validation/run_028_joint_motion/arm/stock validation/run_028_joint_motion/arm/ne validation/run_028_joint_motion/chain/off validation/run_028_joint_motion/chain/ne)
  cls s12 on = $(inside validation/run_028_joint_motion/arm/g validation/run_028_joint_motion/arm/neg validation/run_028_joint_motion/chain/g validation/run_028_joint_motion/chain/neg validation/run_028_joint_motion/chain/neg_tight)
  for f in $(inside validation/run_028_joint_motion/joints_neg); do case "$(basename "$f")" in *_bdf2_1.txt|*_dirk33_1.txt) cls s12 changed = "$f" ;; *) cls s12 on = "$f" ;; esac; done
  cls s12 on = $(inside validation/run_028_joint_motion/traces streams/12) $(cd "$REF" && ls validation/run_028_joint_motion/stats_*.txt) validation/run_028_joint_motion/bench_base.txt
  # Study 13: the final configuration end to end, with stock beside it where a rule compares with stock
  for f in $(inside validation/run_029_end_to_end/runs); do
    case "$f" in */cloud_stock/*|*/deform_stock/*|*/grip_stock/*|*/bench/*_stock*) cls s13 off = "$f" ;; *) cls s13 on = "$f" ;; esac
  done
  cls s13 on = validation/run_029_end_to_end/configuration.txt
}

# ---- comparing one file ----
nowall() { sed 's/ wall_s [0-9.]*//' "$1"; }
same_file() {  # same_file <registered> <made>: 0 when they are the same under the rules above
  local reg="$1" made="$2"
  case "$reg" in
    validation/run_029_end_to_end/runs/grip_*/stats.txt)
      cmp -s <(grep -v '^\[Simple Reflection\] Failed to open JSON file for reading: ' "$REF/$reg") "$R/$made" ;;
    validation/run_028_joint_motion/joints_neg/stats.txt)
      cmp -s <(grep -Ev ' (spin|torque|swing)_(bdf2|dirk33)_1 ' "$REF/$reg") <(grep -Ev ' (spin|torque|swing)_(bdf2|dirk33)_1 ' "$R/$made") ;;
    */stats*.txt|*.out) cmp -s <(nowall "$REF/$reg") <(nowall "$R/$made") ;;
    *) cmp -s "$REF/$reg" "$R/$made" ;;
  esac
}

part() {  # part <name> <command...>: one study's plays, timed, from the root of the clone
  local name="$1" t0 rc; shift; t0=$(date +%s)
  ( cd "$R" || exit 2; "$@" ) >> "$O/log_$name.txt" 2>&1; rc=$?
  echo "PART $name rc $rc seconds $(( $(date +%s) - t0 ))" | tee -a "$O/parts.txt"
}
need_assets() { A="${SUPERDEX_ASSETS:?set SUPERDEX_ASSETS to the assets directory of the SuperDex source tree}"; export SUPERDEX_ASSETS="$A"; }

for p in "$@"; do
case "$p" in
list) inventory > "$INV"; echo "inventory: $(wc -l < "$INV" | tr -d ' ') files" ;;
clear)
  [ -s "$INV" ] || inventory > "$INV"
  while read -r _ _ _ made; do rm -f "$R/$made"; done < "$INV"
  rm -rf "$R/work" "$R/suites"
  ;;
s03) need_assets; part s03 bash tools/plays/play_03.sh "$A" ;;
s04) need_assets; part s04 bash -c 'bash tools/contact_all.sh && bash tools/plays/play_04.sh "$SUPERDEX_ASSETS"' ;;
s05) need_assets; part s05 bash -c 'bash tools/plays/play_05.sh suites && bash tools/plays/play_05.sh bench' ;;
s06) part s06 bash tools/joint_all.sh ;;
s07) need_assets; part s07 bash -c 'bash tools/plays/play_07.sh suites && bash tools/plays/play_07.sh identity && bash tools/plays/play_07.sh bench' ;;
s08) need_assets; part s08 bash -c 'bash tools/limit_all.sh && bash tools/plays/play_08.sh identity && bash tools/plays/play_08.sh bench' ;;
s09) need_assets; part s09 bash -c 'for q in rotvec flight suites joints identity bench; do bash tools/plays/play_09.sh $q || exit 1; done' ;;
s10) need_assets; part s10 bash tools/plays/play_10.sh 0 1 2 3 ;;
s11) need_assets; part s11 bash -c 'bash tools/plays/play_11.sh suites && bash tools/plays/play_11.sh bench' ;;
s12) need_assets; part s12 bash -c 'for q in arm chain joints; do bash tools/plays/play_12.sh $q || exit 1; done; bash tools/plays/play_12.sh bench with_f' ;;
s13) need_assets; part s13 bash tools/plays/play_13.sh yes yes suites joints limits rotvec cloud deform grip bench ;;
compare)
  [ -s "$INV" ] || inventory > "$INV"
  : > "$O/compare.txt"
  while read -r st c reg made; do
    if [ ! -f "$R/$made" ]; then echo "MISSING $st $c $reg"
    elif same_file "$reg" "$made"; then echo "SAME $st $c $reg"
    else echo "DIFFERS $st $c $reg"; fi
  done < "$INV" >> "$O/compare.txt"
  awk '{ k = $2 " " $3; n[k]++; if ($1 == "SAME") s[k]++ } END { for (k in n) printf "WHOLE %s %d of %d\n", k, s[k] + 0, n[k] }' "$O/compare.txt" | sort >> "$O/compare.txt"
  grep '^WHOLE' "$O/compare.txt"
  ;;
*) echo "unknown part $p" >&2; exit 2 ;;
esac
done
