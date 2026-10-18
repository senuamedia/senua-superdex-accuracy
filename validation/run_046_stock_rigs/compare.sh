#!/bin/bash
# compare.sh: for every play in out/stock/manifest.tsv, compare the stock-built rig's output files and the build-15
# rig's output files byte for byte with the registered files of senua-superdex-accuracy/validation, and with each other.
# Writes out/compare.tsv (one row a file) and out/compare_summary.txt; for a file that differs, out/diffs/<path>.txt
# gives the first differing line and the largest difference between the two files' numbers.
set -u
S=$HOME/code/superdex-stock-rig-check
V=$HOME/code/senua-superdex-accuracy/validation
T="$S/out/compare.tsv"; SUM="$S/out/compare_summary.txt"; D="$S/out/diffs"; rm -rf "$D"; mkdir -p "$D"
printf 'file\trig\tcommand\tstock_vs_registered\tb15_vs_registered\tstock_vs_b15\tstock_library_loaded\tb15_library_loaded\n' > "$T"
# reg_bytes <registered path without .gz>: the registered bytes on stdout (a .tr may be kept as .tr.gz)
reg_bytes() { if [ -f "$1" ]; then cat "$1"; elif [ -f "$1.gz" ]; then gzip -dc "$1.gz"; else return 1; fi; }
# where <a> <b> <label>: first differing line, and the largest absolute difference between same-position numbers
where() {
  awk -v lab="$3" 'NR == FNR { a[FNR] = $0; na = FNR; next }
    { b[FNR] = $0; nb = FNR }
    END {
      first = 0; maxd = 0; maxl = 0; ndl = 0
      n = (na > nb) ? na : nb
      for (i = 1; i <= n; i++) {
        if (a[i] == b[i]) continue
        ndl++; if (!first) first = i
        k = split(a[i], x, /[ \t]+/); m = split(b[i], y, /[ \t]+/)
        for (j = 1; j <= ((k < m) ? k : m); j++) {
          if (x[j] ~ /^-?[0-9.]+([eE][-+]?[0-9]+)?$/ && y[j] ~ /^-?[0-9.]+([eE][-+]?[0-9]+)?$/) {
            dd = x[j] - y[j]; if (dd < 0) dd = -dd
            if (dd > maxd) { maxd = dd; maxl = i; maxc = j; mx = x[j]; my = y[j] }
          }
        }
      }
      printf "%s: lines %d and %d; %d lines differ; first at line %d", lab, na, nb, ndl, first
      if (maxl) printf "; largest difference %s at line %d column %d (%s against %s)", maxd, maxl, maxc, mx, my
      printf "\n"
      if (first) { printf "  line %d first file : %s\n  line %d second file: %s\n", first, substr(a[first], 1, 240), first, substr(b[first], 1, 240) }
    }' "$1" "$2"
}
lib_of() { grep -o "$HOME/code/superdex-build-f64/[a-z_0-9]*/libmochi_physics_double.dylib" "$1" | sort -u | sed "s|$HOME/code/superdex-build-f64/||; s|/libmochi_physics_double.dylib||" | tr '\n' ' ' | sed 's/ $//'; }
same=(0 0 0); diff=(0 0 0); missing=0
while IFS=$'\t' read -r path rig tr settings; do
  exts="txt"; [ "$tr" = yes ] && exts="txt tr"
  for e in $exts; do
    f="$path.$e"; st="$S/out/stock/$f"; bf="$S/out/b15/$f"; rg="$S/out/_reg.tmp"
    if ! reg_bytes "$V/$f" > "$rg"; then missing=$((missing + 1)); r1=NOREG; r2=NOREG
    else
      if cmp -s "$st" "$rg"; then r1=SAME; same[0]=$((same[0] + 1)); else r1=DIFFERS; diff[0]=$((diff[0] + 1)); mkdir -p "$(dirname "$D/$f")"; where "$st" "$rg" "stock-built rig vs registered" >> "$D/$f.txt"; fi
      if cmp -s "$bf" "$rg"; then r2=SAME; same[1]=$((same[1] + 1)); else r2=DIFFERS; diff[1]=$((diff[1] + 1)); mkdir -p "$(dirname "$D/$f")"; where "$bf" "$rg" "build-15 rig vs registered" >> "$D/$f.txt"; fi
    fi
    if cmp -s "$st" "$bf"; then r3=SAME; same[2]=$((same[2] + 1)); else r3=DIFFERS; diff[2]=$((diff[2] + 1)); mkdir -p "$(dirname "$D/$f")"; where "$st" "$bf" "stock-built rig vs build-15 rig" >> "$D/$f.txt"; fi
    printf '%s\t%s64\t%s\t%s\t%s\t%s\t%s\t%s\n' "$f" "$rig" "$settings" "$r1" "$r2" "$r3" "$(lib_of "$S/out/stock/$path.err")" "$(lib_of "$S/out/b15/$path.err")" >> "$T"
  done
done < "$S/out/stock/manifest.tsv"
rm -f "$S/out/_reg.tmp"
# the STATS lines (stdout): each play's line against the registered stats.txt line of the same name
sst=0; sdf=0; bst=0; bdf=0
: > "$S/out/stats_compare.txt"
while IFS=$'\t' read -r path rig tr settings; do
  d="$(dirname "$path")"; n="$(basename "$path")"
  reg="$(grep "^STATS run $n " "$V/$d/stats.txt" | tail -1)"
  s="$(grep "^STATS run $n " "$S/out/stock/$d/stats.txt" | tail -1)"; b="$(grep "^STATS run $n " "$S/out/b15/$d/stats.txt" | tail -1)"
  if [ "$s" = "$reg" ]; then sst=$((sst + 1)); else sdf=$((sdf + 1)); printf 'STOCK DIFFERS %s\n  stock: %s\n  reg:   %s\n' "$path" "$s" "$reg" >> "$S/out/stats_compare.txt"; fi
  if [ "$b" = "$reg" ]; then bst=$((bst + 1)); else bdf=$((bdf + 1)); printf 'B15 DIFFERS %s\n  b15: %s\n  reg: %s\n' "$path" "$b" "$reg" >> "$S/out/stats_compare.txt"; fi
done < "$S/out/stock/manifest.tsv"
{
  echo "plays $(wc -l < "$S/out/stock/manifest.tsv"), files compared $((same[0] + diff[0])) (registered file missing: $missing)"
  echo "stock-built rig vs registered: SAME ${same[0]}, DIFFERS ${diff[0]}"
  echo "build-15 rig vs registered:    SAME ${same[1]}, DIFFERS ${diff[1]}"
  echo "stock-built rig vs build-15:   SAME ${same[2]}, DIFFERS ${diff[2]}"
  echo "STATS lines: stock vs registered SAME $sst DIFFERS $sdf; build-15 vs registered SAME $bst DIFFERS $bdf"
  echo "libraries loaded (stock rigs): $(cut -f7 "$T" | tail -n +2 | sort | uniq -c | tr '\n' ';')"
  echo "libraries loaded (b15 rigs):   $(cut -f8 "$T" | tail -n +2 | sort | uniq -c | tr '\n' ';')"
  echo "nonzero exit codes: stock $(grep -vc 'rc=0$' "$S/out/stock/rc.txt"), b15 $(grep -vc 'rc=0$' "$S/out/b15/rc.txt")"
} | tee "$SUM"
