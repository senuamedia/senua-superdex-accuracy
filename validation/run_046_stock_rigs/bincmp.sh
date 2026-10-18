#!/bin/bash
# byte-compare rig binaries: how many bytes differ and where (the LC_UUID is random per link)
S=$HOME/code/superdex-stock-rig-check; R=$HOME/code/senua-superdex-accuracy/tools; cd "$S/bin" || exit 2
cmpone() {
  local n rng; n=$(cmp -l "$1" "$2" | wc -l | tr -d ' '); rng=$(cmp -l "$1" "$2" | awk 'NR==1{a=$1} {b=$1} END{print a"-"b}')
  echo "$3: $n bytes differ (offsets $rng); sizes $(stat -f %z "$1") $(stat -f %z "$2")"
}
for r in deform grip chain; do
  cmpone sdx_${r}64_stock sdx_${r}64_stocklib_srchdr "$r stock(pristine headers) vs stock(superdex-src headers)"
  cmpone sdx_${r}64_b15 "$R/sdx_${r}64" "$r b15 rebuild vs record's tools/sdx_${r}64"
  cmpone sdx_${r}64_stock sdx_${r}64_b15 "$r stock vs b15 (rpath differs)"
done
