#!/usr/bin/env bash
# Run 040, step 2: the plays play_identity.sh found different on Linux, examined. For each: how many lines differ,
# from which step, the largest difference in each column (whole numbers as the rigs write them: micro-radians and
# micrometres), and the record's own reading of the play on Linux and of the registered file, side by side.
# usage: differences.sh <sx_contact binary>   (from the root of the copy of the repository run 040 played in)
set -u
B="${1:?usage: differences.sh <sx_contact binary>}"; W=work/_identity; O=validation/run_040_linux_identity
one() {  # <label> <measure> <Linux play> <registered file>
  echo "== $1"
  awk 'NR == FNR { a[FNR] = $0; next }
       { if (a[FNR] != $0) { n++; if (!first) first = FNR; split(a[FNR], x, " "); for (i = 2; i <= NF; i++) { d = $i - x[i]; if (d < 0) d = -d; if (d > m[i]) m[i] = d } } }
       END { printf "lines differing: %d of %d, from line %d; largest difference by column:", n, FNR, first; for (i = 2; i <= 15; i++) if (i in m) printf " c%d %d", i, m[i]; print "" }' "$4" "$3"
  echo "Linux      | $("$B" $2 "$3" | tail -1)"
  echo "registered | $("$B" $2 "$4" | tail -1)"
}
{
  one "joint swing_be_64 (also the zero part's)" swing $W/joints/swing_be_64.txt joints/swing_be_64.txt
  one "patch G chain swing_16" chain $W/fg/swing_16.txt validation/run_028_joint_motion/chain/neg/swing_16.txt
  one "patch G chain, tight tolerances, free_16" chain $W/fg/tight_16.txt validation/run_028_joint_motion/chain/neg_tight/free_16.txt
  one "patches A to G, joint swing_be_64" swing $W/fg/swing_be_64.txt validation/run_029_end_to_end/runs/joints_fc/swing_be_64.txt
  one "patches A to G, limit rel20_64" final $W/fg/rel20_64.txt validation/run_029_end_to_end/runs/limits_fc/rel20_64.txt
} > $O/differences.txt
