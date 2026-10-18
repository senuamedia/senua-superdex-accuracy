#!/usr/bin/env bash
# dis.sh <dylib> <outdir>: disassemble the Senua kernels (batch 1..8, Current and Previous) and the range functions
set -u
L="$1"; O="$2"; mkdir -p "$O"
nm "$L" | grep -E 'ComputeBatchCollisionForceDForceSenua|ComputeCollisionResponseRangeSenua' | awk '{print $3}' > "$O/syms.txt"
while read -r s; do
  short="$(echo "$s" | c++filt | grep -oE 'Senua<[0-9], \(mochi::GradTarget\)[01]>|RangeSenua<\(mochi::GradTarget\)[01]>' | head -1 | tr -d ' (),:<>' )"
  objdump --disassemble-symbols="$s" --no-show-raw-insn --no-leading-addr "$L" 2>/dev/null | sed -E 's/0x[0-9a-f]+/ADDR/g; s/<[^>]*>//g' > "$O/$short.s"
done < "$O/syms.txt"
