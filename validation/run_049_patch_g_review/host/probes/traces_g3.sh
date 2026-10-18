#!/usr/bin/env bash
# The solver's own status of every step in the benchmark plays the identity replay made with g3 (runs 032 and 034, the
# accurate configuration: BDF2, 16 sub-steps, patch G set), against the same plays made by library build 15 in run 045:
# steps stopped (status 2), diverged (3), and the most iterations. Trace lines: "<step> <status> <iterations> <residual>".
set -u
P="$HOME/work/probeG"
count() { if [ "${1%.gz}" != "$1" ]; then zcat "$1"; else cat "$1"; fi | awk '{ n++; if ($2 == 2) s++; if ($2 == 3) d++; if ($3 > m) m = $3 } END { printf "steps %d stopped %d diverged %d most_iterations %d", n, s, d, m }'; }
for f in $(cd "$P/idg3/work/_identity" && find r032 r034 -path '*bench*' \( -name '*.tr' -o -name '*.tr.gz' \) | sort); do
  echo "$f | g3: $(count "$P/idg3/work/_identity/$f") | build 15: $(count "$P/idg3/work/_ref_b15/$f")"
done
