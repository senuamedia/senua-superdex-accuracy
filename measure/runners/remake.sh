#!/usr/bin/env bash
# Every reading of the record re-made from the record's own files, by measuring alone, and compared byte for byte with
# the reading the record keeps. The runners of registrations 3 to 16 read their inputs in folders laid out as they were
# measured; those folders are assembled here from the record's files by measure/runners/inputs.txt (FILE lines copy a
# file; STATS lines take one statistics line from the record's statistics file for that source, which the runners read
# without its wall_s field). Registrations 19 to 23 are re-made from their run folders as they stand.
# Where the record keeps a reading_corrected.txt beside a reading.txt, the reading is compared with it: the reading as
# printed when it was registered, and the same reading made by sx_contact as corrected on 17 October 2026 (the step
# read in nanoseconds, the distance slid added up exactly; measure/README.md).
# The measuring programs are Simplex and need the Senua AI engine to build; give the folder holding the built sx_contact
# and sx_settings3 (the counts and the ledgers use it), and, for registrations 1 to 3, sx_settings and sx_settings2.
# usage: remake.sh <the record's root> <folder holding the built programs> <work folder> [full]
#   full: also registrations 1 to 3 (the gap instrument: about 35 minutes more)
# Prints one line a reading (SAME or DIFFERS, with the record's file) and the count; exit 0 when every reading is SAME.
set -u
R="$(cd "${1:?usage: remake.sh <record root> <programs folder> <work folder> [full]}" && pwd)"
P="$(cd "${2:?programs folder}" && pwd)"; W="${3:?work folder}"; FULL="${4:-}"
mkdir -p "$W" && W="$(cd "$W" && pwd)"
rm -rf "$W/in" "$W/bin" "$W/out" "$W/s20"; mkdir -p "$W/in" "$W/bin" "$W/out"
# the inputs
while read -r kind a b c; do
  case "$kind" in
    FILE) mkdir -p "$(dirname "$W/in/$a")"; cp "$R/$b" "$W/in/$a" ;;
    STATS) mkdir -p "$(dirname "$W/in/$a")"; sc=$(basename "$a" .txt | sed 's/^stats_//')
           grep "^STATS source $b scene $sc " "$R/$c" | head -1 >> "$W/in/$a" ;;
  esac
done < <(grep -E '^(FILE|STATS) ' "$R/measure/runners/inputs.txt")
# the programs beside the runners, as the runners expect them
cp "$R"/measure/runners/*.sh "$R"/measure/instrument/*.sh "$W/bin/"
for p in sx_contact sx_settings sx_settings2 sx_settings3; do [ -x "$P/$p" ] && cp "$P/$p" "$W/bin/"; done
I="$W/in"; B="$W/bin"; O="$W/out"
same=0; n=0
check() {  # check <made> <the record's file>: its corrected form where the record keeps one
  local f="$2"; local c="${2%reading.txt}reading_corrected.txt"
  [ "$c" != "$2" ] && [ -f "$R/$c" ] && f="$c"
  n=$((n + 1))
  if cmp -s "$1" "$R/$f"; then same=$((same + 1)); echo "SAME $f"; else echo "DIFFERS $f"; fi
}
run() {  # run <out name> <runner> <arguments...>: the runner writes its reading to <out>
  local out="$1"; shift
  bash "$B/$1" "${@:2}" "$O/$out" > "$O/$out.log" 2>&1 || echo "RUNNER FAILED $1 (see $O/$out.log)"
}
run count3 sx_count3.sh "$I/sdx_settings3" 6;                          check "$O/count3" validation/run_007_counts/counts.txt
run link sx_link.sh "$I/sdx_settings4";                                 check "$O/link" validation/run_011_counts/counts.txt
run r04 sx_contact_run.sh "$I/sdx_contact" 0 3 0 3;                     check "$O/r04" validation/run_010_contact/reading.txt
run r05 sx_patch_run.sh "$I/sdx_suite5" "$I/sdx_settings5" "$O/c05";    check "$O/r05" patches/validation/ledger.txt
                                                                         check "$O/c05" validation/run_013_counts/counts.txt
run r06 sx_joint_run.sh "$I/sdx_joints" "$I/sdx_joints/stats.txt";      check "$O/r06" validation/run_015_joints/reading.txt
run r07 sx_ledger7_run.sh "$I/sdx_suite7" "$I/sdx_settings7" "$O/c07";  check "$O/r07" validation/run_017_counts/reading.txt
                                                                         check "$O/c07" validation/run_017_counts/counts.txt
run r08 sx_limit_run.sh "$I/sdx_limits" "$I/sdx_settings8" "$O/c08";    check "$O/r08" validation/run_019_limits/reading.txt
                                                                         check "$O/c08" validation/run_019_limits/counts.txt
run r09 sx_study9_run.sh "$I/sdx_study9" "$O/c09";                      check "$O/r09" validation/run_021_rotation/reading.txt
                                                                         check "$O/c09" validation/run_021_rotation/counts.txt
run r10 sx_study10_run.sh "$I/sdx_study10_13";                          check "$O/r10" validation/run_026_ant_stops/reading.txt
run r11 sx_study11_run.sh "$I/sdx_study10_13" "$O/c11";                 check "$O/r11" validation/run_027_friction/reading.txt
                                                                         check "$O/c11" validation/run_027_friction/counts.txt
run r12 sx_study12_run.sh "$I/sdx_study10_13" "$O/c12";                 check "$O/r12" validation/run_028_joint_motion/reading.txt
                                                                         check "$O/c12" validation/run_028_joint_motion/counts.txt
run r13 sx_study13_run.sh "$I/sdx_study10_13";                          check "$O/r13" validation/run_029_end_to_end/reading.txt
run r14 sx_study14_run.sh "$I/sdx_study14_15";                          check "$O/r14" validation/run_032_open_items/reading.txt
run r15 sx_study15_run.sh "$I/sdx_study14_15";                          check "$O/r15" validation/run_034_replication/reading.txt
run r16 sx_study16_run.sh "$I/sdx_study16";                             check "$O/r16" validation/run_036_registration16/reading.txt
run r19 sx_study19_run.sh "$R/validation/run_043_study19";               check "$O/r19" validation/run_043_study19/reading.txt
mkdir -p "$W/s20" && ln -s "$R/validation/run_044_study20/runs/s1" "$W/s20/1" && ln -s "$R/validation/run_044_study20/runs/s2" "$W/s20/2"
run r20 sx_study20_run.sh "$W/s20" "$R/validation/run_044_study20";      check "$O/r20" validation/run_044_study20/reading.txt
run r21 sx_study21_run.sh "$R/validation/run_051_study21";               check "$O/r21" validation/run_051_study21/reading.txt
run r22 sx_study22_run.sh "$R/validation/run_052_study22";               check "$O/r22" validation/run_052_study22/reading.txt
run r23 sx_study23_run.sh "$R/validation/run_055_study23";               check "$O/r23" validation/run_055_study23/reading.txt
if [ "$FULL" = full ]; then
  ( cd "$O" && "$B/sx_settings" run "$I/sdx_settings" > "$O/r01" 2> "$O/r01.log" );  check "$O/r01" validation/run_002_instrument/reading.txt
  run r02 sx_run2.sh "$I/sdx_settings2" 219;                             check "$O/r02" validation/run_005_instrument/reading.txt
  run r03 sx_run3.sh "$I/sdx_settings3" 219 0;                           check "$O/r03" validation/run_008_instrument/reading.txt
fi
echo "readings re-made byte for byte: $same of $n"
[ "$same" -eq "$n" ]
