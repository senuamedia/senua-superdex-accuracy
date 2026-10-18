#!/usr/bin/env bash
# The probe's reading, made the way runs 027 and 028 read the order (measure/runners/sx_study11_run.sh and
# sx_study12_run.sh): for each configuration and scene, sx_settings3 time over the chain 1, 1/2, 1/4, 1/8, 1/16 and
# sx_settings3 plain chain <LABEL> over the same sources (plain subtraction of the gaps between successive halvings,
# by fold; a fold is in order when each gap is smaller than the one before). Then the solver's counts from each
# play's STATS line, the stopped and diverged steps from its trace by iteration count, and the control (shp) compared
# byte for byte with the record's streams/12 (Study 12's g chain, made on the laptop).
# usage: read_probe.sh        (on the host, after every play has ended; sx_settings3 is the Linux build in ~/sxbuild)
set -u
P="${PROBE_DIR:-$HOME/work/orderprobe}"
B="${SX_SETTINGS3:-$HOME/sxbuild/sx_settings3}"
D="$P/streams"; O="$P/out"; mkdir -p "$O"
desc() { case "$1" in
  rec) echo "the recommended configuration (patches A to G, Newton-Euler inertia, absTol 1e-4, relTol 1e-8)" ;;
  nof) echo "the recommended configuration without patch F" ;;
  nog) echo "the recommended configuration without patch G and Newton-Euler inertia" ;;
  shp) echo "control: the recommended configuration at SuperDex's shipped tolerances (1e-3, 1e-6), Study 12's g chain" ;;
esac; }
bad=0
for cfg in rec nof nog shp; do
  C="$O/counts_$cfg.txt"; : > "$C"; L="$(echo "$cfg" | tr a-z A-Z)"
  for sc in half_cheetah ant; do
    echo "=== $sc, the fifth registration's commands: $(desc $cfg) (${cfg}1 .. ${cfg}16)" >> "$C"
    "$B" time "$D" $sc 108 200 ${cfg}1 ${cfg}2 ${cfg}4 ${cfg}8 ${cfg}16 >> "$C"; [ $? -eq 42 ] || { echo "time failed $cfg $sc" >&2; bad=1; }
    "$B" plain "$D" $sc 108 200 chain $L ${cfg}1 ${cfg}2 ${cfg}4 ${cfg}8 ${cfg}16 >> "$C"; [ $? -eq 42 ] || { echo "plain failed $cfg $sc" >&2; bad=1; }
  done
done
S="$O/summary.txt"; : > "$S"
echo "ORDER: folds in order of 3 (sx_settings3 plain), and each fold's plain_in_order" >> "$S"
for cfg in rec nof nog shp; do
  for sc in half_cheetah ant; do
    L="$(echo "$cfg" | tr a-z A-Z)"
    f="$(grep "^PLAIN $sc $L folds_in_order" "$O/counts_$cfg.txt" | awk '{print $5}')"
    per="$(awk -v s="$sc" -v l="$L" '$1 == "CELL" && $2 == s && $3 == l { fold = $5 } $1 == "plain_in_order" && fold != "" { printf " fold%s=%s", fold, $2; fold = "" }' "$O/counts_$cfg.txt")"
    echo "order $cfg $sc folds_in_order ${f:-missing} of 3 ;$per" >> "$S"
  done
done
echo "SOLVER: each play's STATS line (stopped, diverged, most iterations, wall seconds)" >> "$S"
for cfg in rec nof nog shp; do for sc in half_cheetah ant; do for k in 1 2 4 8 16; do
  line="$(grep "^STATS source $cfg$k " "$P/stats/$sc.txt")"
  if [ -z "$line" ]; then echo "solver $cfg $sc 1/$k missing" >> "$S"; bad=1; continue; fi
  get() { echo "$line" | awk -v k="$1" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}'; }
  st="$P/stops/${sc}_$cfg$k.txt"
  atlim="$(awk '$2 == 2 && $3 >= 200' "$st" | wc -l | tr -d ' ')"; below="$(awk '$2 == 2 && $3 < 200' "$st" | wc -l | tr -d ' ')"
  echo "solver $cfg $sc 1/$k steps $(get solver_steps) converged $(get converged) stopped $(get stopped) diverged $(get diverged) unset $(get unset) most_iterations $(get most_iterations) stopped_at_limit $atlim stopped_below_limit $below wall_s $(get wall_s)" >> "$S"
done; done; done
echo "CONTROL: shp against the record's streams/12 g chain (laptop, library build 12), byte for byte" >> "$S"
for sc in half_cheetah ant; do for k in 1 2 4 8 16; do
  if cmp -s "$D/$sc/shp${k}_enc.pcm" "$P/record/streams/12/$sc/g${k}_enc.pcm"; then r=same; else r=differs; fi
  echo "control $sc shp$k against streams/12 g$k: $r" >> "$S"
done; done
(cd "$D" && sha256sum */*.pcm) > "$O/streams.sha256"
[ $bad -eq 0 ] || { echo "reading incomplete" >&2; exit 1; }
exit 0
