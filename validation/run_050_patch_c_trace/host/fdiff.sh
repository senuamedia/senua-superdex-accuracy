#!/usr/bin/env bash
# fdiff.sh <a_state.f32> <b_state.f32> [dofs]: the readings whose float32 state differs, with the largest absolute
# difference in that reading; one line a differing reading (reading numbers from 1)
n=${3:-14}
paste <(od -A n -v -t f4 -w4 "$1") <(od -A n -v -t f4 -w4 "$2") | awk -v n=$n "{ r = int((NR-1)/n)+1; if (\$1 != \$2) { d = \$1 - \$2; if (d < 0) d = -d; if (d > m[r]) m[r] = d; c[r]++ ; if (!(r in seen)) { seen[r]=1; order[++k]=r } } } END { for (i=1;i<=k;i++) { r=order[i]; printf \"reading %d dofs_differ %d max_abs %.3g\\n\", r, c[r], m[r] } }"
