#!/usr/bin/env bash
# What the proposed patch G would change in the registered readings of runs 032 and 034 (Studies 14 and 15): run 045's
# step 7 (validation/run_045_fresh_clone/linux_readings.sh) done twice on this machine, once over the plays library
# build 15 made in run 045 (~/work/rec40/work/_identity) and once over the plays the g3 library made in this review's
# identity run (~/work/probeG/idg3/work/_identity); the two re-made readings are then compared rule line by rule line.
# usage: readings_g3.sh            (writes ~/work/probeG/out/readings_g3.txt)
set -u
P="$HOME/work/probeG"; R="$P/idg3"; BIN="$HOME/work/sdx/remake/bin"; O="$P/out/readings_g3.txt"
one() {  # one <label> <identity folder>
  local W="$P/readings/$1" C L
  rm -rf "$W" && mkdir -p "$W"; C="$W/record"; mkdir -p "$C"
  ( cd "$R" && git ls-files -z | xargs -0 -I{} cp --parents {} "$C/" )
  overlay() {
    local from="$1" to="$2" f rel
    while IFS= read -r f; do
      rel="${f#$from/}"
      if [ -f "$to/$rel" ]; then cp "$f" "$to/$rel"
      elif [ -f "$to/$rel.gz" ]; then gzip -n -c "$f" > "$to/$rel.gz"; fi
    done < <(find "$from" -type f | sort)
  }
  L="$2"
  overlay "$L/r032/runs" "$C/validation/run_032_open_items/runs"
  overlay "$L/r034/runs" "$C/validation/run_034_replication/runs"
  overlay "$L/r034/accurate14/runs" "$C/validation/run_034_replication/accurate14/runs"
  bash "$C/measure/runners/remake.sh" "$C" "$BIN" "$W/remake" > "$W/remake.txt" 2>&1
}
one b15 "$HOME/work/rec40/work/_identity"
one g3 "$R/work/_identity"
rules() { grep '^RULE ' "$1" | awk '{ print $2, $NF }'; }
: > "$O"
for r in r14 r15; do
  a="$P/readings/b15/remake/out/$r"; b="$P/readings/g3/remake/out/$r"
  echo "== $r: rule lines, build 15 against g3 (both made on this machine)" >> "$O"
  echo "rule lines: build 15 $(rules "$a" | wc -l), g3 $(rules "$b" | wc -l); verdicts that differ: $(diff <(rules "$a") <(rules "$b") | grep -c '^>')" >> "$O"
  diff <(rules "$a") <(rules "$b") >> "$O"
  echo "-- every measured line that differs:" >> "$O"
  diff "$a" "$b" | grep '^[<>]' >> "$O"
done
