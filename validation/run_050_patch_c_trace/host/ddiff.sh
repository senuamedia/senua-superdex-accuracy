#!/usr/bin/env bash
# ddiff.sh <a_state.f64> <b_state.f64>: readings (from 1) whose double state differs, the first ones with the largest
# absolute difference, and the count of differing readings and values
paste <(od -A n -v -t f8 -w8 "$1") <(od -A n -v -t f8 -w8 "$2") | awk "{ r = int((NR-1)/14)+1; if (\$1 != \$2) { d = \$1 - \$2; if (d < 0) d = -d; a = \$1; if (a < 0) a = -a; if (d > m[r]) { m[r] = d; rel[r] = (a > 0 ? d/a : 0) } c[r]++; nv++; if (!(r in s)) { s[r]=1; o[++k]=r } } } END { for (i=1;i<=k && i<=8;i++) { r=o[i]; printf \"reading %d values_differ %d max_abs %.3g rel %.3g\\n\", r, c[r], m[r], rel[r] } ; printf \"differing readings %d of %d, differing values %d\\n\", k, int(NR/14), nv }"
