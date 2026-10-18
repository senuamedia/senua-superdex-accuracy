#!/usr/bin/env bash
# Run 041, step 3: the measuring, with Senua AI's measure (sx_contact) and the record's suite runner beside it.
# First suite: the ten T-numbered tests of each configuration (runners/sx_contact_suite.sh with the seventh study's
# friction and slip push, as sx_ledger7_run.sh gives them). Second suite: the stop, the two-body plays and the
# acceleration while slipping, each line as measured (as the seventh study measured them), and the lift of the slide
# (hover). Then each 32-bit file against its 64-bit twin, and each 64-bit file of stock, off, abcd and abcde against
# the registered one (seventh study's run 017 for stock and abcd, ninth study's run 021 for abcde).
# usage: measure.sh <folder holding sx_contact and sx_contact_suite.sh>   (from the repository root)
set -u
M="${1:?usage: measure.sh <folder holding sx_contact and sx_contact_suite.sh>}"; B="$M/sx_contact"
O=validation/run_041_corrections_32bit
export SUITE_MU10K=3500 SUITE_SLIPMN=4234
for bits in 32 64; do for l in stock off abcd abcde final; do
  t=r41_${bits}_$l
  bash "$M/sx_contact_suite.sh" suites/1/$t $O/suite1_${bits}_$l.txt || echo "suite 1 $t: measuring incomplete"
  d=suites/2/$t
  {
    for run in stop land; do for k in 1 4 16 64; do echo "$run 1/$k | $($B stop $d/${run}_$k.txt | tail -1)"; done; done
    for run in stop land; do for k in 1 4 16 64; do echo "$run 1/$k | $($B hover $d/${run}_$k.txt | tail -1)"; done; done
    for k in 1 16; do
      echo "rest 1/$k | $($B pair $d/rest_${k}_a.txt $d/rest_${k}_b.txt | tail -1)"
      echo "carry 1/$k | $($B pair $d/carry_${k}_a.txt $d/carry_${k}_b.txt | tail -1)"
      echo "slip A 1/$k | $($B accel $d/slip_${k}_a.txt 700 900 | tail -1)"
      echo "slip B 1/$k | $($B accel $d/slip_${k}_b.txt 700 900 | tail -1)"
      echo "side 1/$k | $($B pair $d/side_${k}_a.txt $d/side_${k}_b.txt | tail -1)"
      echo "top 1/$k | $($B pair $d/top_${k}_a.txt $d/top_${k}_b.txt | tail -1)"
    done
  } > $O/suite2_${bits}_$l.txt
done; done
same() {  # same <label> <dir a> <dir b>: files of a that are byte-identical in b
  local s=0 n=0 x; for x in "$2"/*_[0-9]*.txt; do n=$((n + 1)); cmp -s "$x" "$3/$(basename "$x")" && s=$((s + 1)); done
  echo "$1 $s of $n"
}
S7=validation/run_017_counts/runs; S9=validation/run_021_rotation/runs
{
  for l in stock off abcd abcde final; do for s in 1 2; do same "32 against 64, suite $s, $l:" suites/$s/r41_32_$l suites/$s/r41_64_$l; done; done
  for s in 1 2; do same "32-bit off against 32-bit stock, suite $s:" suites/$s/r41_32_stock suites/$s/r41_32_off; done
  for s in 1 2; do
    same "64-bit stock against registered, suite $s:" $S7/s$s/stock suites/$s/r41_64_stock
    same "64-bit off against registered stock, suite $s:" $S7/s$s/stock suites/$s/r41_64_off
    same "64-bit abcd against registered, suite $s:" $S7/s$s/rec_new suites/$s/r41_64_abcd
    same "64-bit abcde against registered, suite $s:" $S9/s$s/rec_e suites/$s/r41_64_abcde
  done
} > $O/identity.txt
grep -h '^T[01][0-9]' $O/suite1_*.txt > /dev/null && for f in $O/suite1_*.txt; do echo "$(basename $f .txt): $(grep '^T[01][0-9]' $f | sed -E 's/.* : (PASS|FAIL)$/\1/' | tr '\n' ' ')"; done > $O/verdicts.txt
cat $O/identity.txt $O/verdicts.txt
