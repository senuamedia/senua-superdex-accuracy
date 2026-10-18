#!/usr/bin/env bash
# Run 045, step 7 (added after step 5 found 25 files of run 032 and 18 of run 034 made differently on Linux): the
# readings of runs 032 and 034 re-made from the files the identity check made on Linux, and every rule line compared
# with the registered reading. A copy of the record is made with run 032's and run 034's play files replaced by the
# Linux ones (a solver trace registered compressed is compressed the same way), and measure/runners/remake.sh is run
# on it; the registered readings come from the record itself.
# usage: linux_readings.sh <the record, as played (~/work/rec40)> <folder of the Linux-built measuring programs>
#        <work folder>   (writes linux_readings.txt beside this script)
set -u
R="$(cd "${1:?usage: linux_readings.sh <record> <programs> <work folder>}" && pwd)"
P="$(cd "${2:?programs}" && pwd)"; W="${3:?work folder}"
O="$R/validation/run_045_fresh_clone/linux_readings.txt"
rm -rf "$W" && mkdir -p "$W" && W="$(cd "$W" && pwd)"
C="$W/record"; mkdir -p "$C"
( cd "$R" && git ls-files -z | xargs -0 -I{} cp --parents {} "$C/" )
overlay() {  # overlay <Linux tree> <registered tree in the copy>
  local from="$1" to="$2" f rel n=0
  while IFS= read -r f; do
    rel="${f#$from/}"
    if [ -f "$to/$rel" ]; then cp "$f" "$to/$rel"; n=$((n + 1))
    elif [ -f "$to/$rel.gz" ]; then gzip -n -c "$f" > "$to/$rel.gz"; n=$((n + 1)); fi
  done < <(find "$from" -type f | sort)
  echo "$n files of $to replaced by the Linux plays" >> "$O"
}
: > "$O"
L="$R/work/_identity"
overlay "$L/r032/runs" "$C/validation/run_032_open_items/runs"
overlay "$L/r034/runs" "$C/validation/run_034_replication/runs"
overlay "$L/r034/accurate14/runs" "$C/validation/run_034_replication/accurate14/runs"
bash "$C/measure/runners/remake.sh" "$C" "$P" "$W/remake" > "$W/remake.txt" 2>&1
grep -E '^(SAME|DIFFERS)' "$W/remake.txt" | grep -E 'run_032|run_034' >> "$O"
rules() { grep '^RULE ' "$1" | awk '{ print $2, $NF }'; }
for pair in "r14 validation/run_032_open_items/reading.txt" "r15 validation/run_034_replication/reading.txt"; do
  set -- $pair
  made="$W/remake/out/$1"; reg="$R/$2"
  echo "== $2: rule lines on Linux against the registered" >> "$O"
  echo "rule lines registered $(rules "$reg" | wc -l), made on Linux $(rules "$made" | wc -l)" >> "$O"
  echo "verdict differs: $(diff <(rules "$reg") <(rules "$made") | grep -c '^>')" >> "$O"
  diff <(rules "$reg") <(rules "$made") >> "$O"
  echo "measured values differ (whole lines):" >> "$O"
  diff "$reg" "$made" | grep '^[<>]' >> "$O"
done
cat "$O"
