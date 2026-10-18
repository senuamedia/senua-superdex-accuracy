#!/usr/bin/env bash
# the T16 diagnostic's reading: momentum change per million, side and top, steps 1 and 1/16, each variant
cd ~/work/rec51 || exit 2
{ echo "variant | side 1/1 | side 1/16 | top 1/1 | top 1/16 (per million; T16's bound 500)"
for d in registered default_grid shipped_tol no_damping off_patched old_pair; do
  row="$d"
  for t in side top; do for k in 1 16; do
    l=$(~/sxbuild/sx_contact pair suites/2/diag_$d/${t}_${k}_a.txt suites/2/diag_$d/${t}_${k}_b.txt 2>/dev/null | tail -1)
    row="$row | $(echo "$l" | tr ' ' '\n' | awk 'p{print;exit} $0=="per_million"{p=1}')"
  done; done
  echo "$row"
done
echo
echo "registered side 1/1, the full line: $(~/sxbuild/sx_contact pair suites/2/diag_registered/side_1_a.txt suites/2/diag_registered/side_1_b.txt | tail -1)"
echo "headers: $(head -1 suites/2/diag_registered/side_1_a.txt) / $(head -1 suites/2/diag_registered/side_1_b.txt)"; } > ~/work/t16diag/table.txt
cat ~/work/t16diag/table.txt
