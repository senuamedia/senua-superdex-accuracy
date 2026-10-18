#!/usr/bin/env bash
# Run 040, step 4: the benchmark streams play_identity.sh found different on Linux (step 3), examined. For each: the
# reading it first differs at (a stream holds two bytes a reading, 200 readings an episode), how many readings differ
# of how many, and the solver's own counts of the Linux play beside the registered ones (steps converged, stopped and
# diverged, the most iterations, the encoder's least and largest value), from the rig's STATS line and the statistics
# file registered with the same streams: streams/03 with run 007's, streams/04 with run 011's, streams/09 with run
# 021's. (Corrected before its output was used: a first form took the first statistics file in the record holding the
# same source and scene, which for streams/03 can be the second study's, and misread the lines of the switches part.)
# usage: differences_bench.sh   (from the root of the copy of the repository step 3 played in)
set -u
O=validation/run_040_linux_identity; W=work/_identity
counts() { grep -o 'converged [0-9]* stopped [0-9]* diverged [0-9]* unset [0-9]* most_iterations [0-9]* enc_min [-0-9]* enc_max [-0-9]*'; }
{
  grep '^DIFFERS benchmark' $O/identity_bench.txt | while read -r _ _ a b c d e; do
    if [ "$a" = "under" ]; then part=benchrec; sc=$d; src=$e; sd=streams/09; st=validation/run_021_rotation
    else part=bench; sc=$a; src=$b
      case $src in d1|d2) sd=streams/04; st=validation/run_011_counts ;; *) sd=streams/03; st=validation/run_007_counts ;; esac
    fi
    reg=$sd/$sc/${src}_enc.pcm; lx=$W/$part/${sc}_${src}_enc.pcm
    total=$(( $(stat -c %s "$reg") / 2 ))
    first=$(cmp "$lx" "$reg" | sed 's/.*differ: byte \([0-9]*\).*/\1/; s/.*differ: char \([0-9]*\).*/\1/')
    rd=$(( (first - 1) / 2 + 1 ))
    ndiff=$(cmp -l "$lx" "$reg" | awk '{ print int(($1 - 1) / 2) }' | sort -u | wc -l)
    echo "== $part $sc $src: first differs at reading $rd of $total (episode $(( (rd - 1) / 200 + 1 )), reading $(( (rd - 1) % 200 + 1 )) of it); readings differing $ndiff"
    echo "Linux      | $(grep '^STATS' $W/$part/${sc}_$src.out | counts)"
    echo "registered | $(grep "^STATS source $src scene $sc " $st/stats_$sc.txt | counts)"
  done
} > $O/differences_bench.txt
cat $O/differences_bench.txt
