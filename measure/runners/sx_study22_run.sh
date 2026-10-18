#!/usr/bin/env bash
# measure/runners/sx_study22_run.sh -- preregistrations/PREREGISTRATION_22.md: patch G under BDF2, its current form
# (library build 15) and its derived form head to head on fresh numbers; re-made by measuring alone. Every registered
# rule is judged by sx_contact rule.
# usage: sx_study22_run.sh <out folder of play_22.sh> <out file>        (sx_contact beside this script)
#   as registered: sx_study22_run.sh validation/run_052_study22 validation/run_052_study22/reading.txt
#   Read under the out folder: identity.txt, identity_linux.txt, compare.txt; runs/ (bdf2_<acc|tight>_<cur|der>,
#   be_<acc|tight>_<cur|der>, off_<bdf2|be>_<der|stock>, long, bench).
# exit 0 = every line was written (what held is in the file's last lines)
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
D="${1:?usage: sx_study22_run.sh <out folder of play_22.sh> <out file>}"; OUT="${2:?out file}"
D="$(cd "$D" && pwd)"; U="$D/runs"
B="$HERE/sx_contact"
P="$(mktemp -d "${TMPDIR:-/tmp}/sx_s22.XXXXXX")"; MISSF="$P/missing"; : > "$MISSF"
trap 'rm -rf "$P"' EXIT
: > "$OUT"
bad=0

# ---- the registered numbers and bounds (PREREGISTRATION_22.md) ----
KS="1 2 4 8 16 32 64"                 # the steps, fractions of the shipped 10 ms
SPIN=3.8; SPIN_9999=3799620           # the free spin's release speed, rad/s; 9,999 in 10,000 of it, urad/s
FLOOR_LEAST=7                         # ppm: the most the rig's and the measure's rounding move a drift on these chains
RULED_TIMES=5                         # a halving is ruled where the finer step's drift is at least this many floors
ORDER_NUM=500; ORDER_DEN=1414         # second order: the finer drift no more than 500/1414 = 1/2^1.5 of the coarser
SPAN=512                              # O0: from 1 to 1/64, six halvings, 2^(1.5 x 6)
N_E1_PARTS=10; N_OFF=48; N_BE=84; N_BENCH_REC=6
# ---- end of the registered numbers ----

m() {  # m <label> <measure> <args...>: one measured line, labelled; echoes the measure's LAST line
  local label="$1"; shift
  local lines; lines="$("$B" "$@")"; [ $? -eq 42 ] || { echo "failed: $*" >&2; bad=1; }   # a Simplex program exits 42 when it ran
  echo "$lines" | awk -v l="$label" '{ print l " | " $0 }' >> "$OUT"; echo "$lines" | tail -1
}
# the number after a name (its n-th occurrence, default the first); a name a measured line does not hold counts as
# missing and stands as 999999999
nv() { local x; x="$(echo "$1" | awk -v k="$2" -v n="${3:-1}" '{ c = 0; for (i = 1; i < NF; i++) if ($i == k) { c++; if (c == n) { print $(i + 1); exit } } }')"; if [ -z "$x" ]; then echo "$2" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }
rule() { "$B" rule "$@" >> "$OUT"; [ $? -eq 42 ] || { echo "rule failed to run: $*" >&2; bad=1; }; }
# a statistic summed over the plays of statistics files; a file that does not exist counts as missing
stat() { local f; for f in "$@"; do [ -f "$f" ] || { echo "$f" >> "$MISSF"; echo 999999999; return; }; done; awk -v k="$K_" '{ for (i = 1; i < NF; i++) if ($i == k) s += $(i + 1) } END { printf "%d", s }' "$@"; }
# the most iterations any step of the plays took (the iteration limit is 200: a step that took 200 stopped at the limit;
# one that stopped with fewer stopped on SuperDex's rule for an update too small to matter)
most() { awk '{ for (i = 1; i < NF; i++) if ($i == "most_iterations" && $(i + 1) > m) m = $(i + 1) } END { printf "%d", m + 0 }' "$@"; }
field() { local x; x="$(grep "^STATS source $2 " "$1" 2>/dev/null | awk -v k="$3" '{for(i=1;i<=NF;i++) if ($i==k) print $(i+1)}')"; if [ -z "$x" ]; then echo "$1 $2 $3" >> "$MISSF"; echo 999999999; else echo "$x"; fi; }

# ---- the chains, the free spin and the pendulum, under BDF2 and under backward Euler ----
for integ in bdf2 be; do for lib in cur der; do for tol in acc tight; do
  W="$U/${integ}_${tol}_$lib"
  for k in $KS; do
    for c in a b t; do
      l="$(m "$integ $tol $lib, chain $c, 1/$k" chain "$W/chain_${c}_$k.txt")"
      eval "ML_${integ}_${lib}_${tol}_${c}_$k=\"$(nv "$l" momentum_largest_drift_ppm)\"; EL_${integ}_${lib}_${tol}_${c}_$k=\"$(nv "$l" energy_largest_drift_ppm)\"; KE_${integ}_${lib}_${tol}_${c}_$k=\"$(nv "$l" kinetic_end_per_million_of_start)\""
    done
    l="$(m "$integ $tol $lib, chain s (swinging), 1/$k" chain "$W/chain_s_$k.txt")"
    eval "ED_${integ}_${lib}_${tol}_s_$k=\"$(nv "$l" energy_drift_ppm_of_most_kinetic)\"; EL_${integ}_${lib}_${tol}_s_$k=\"$(nv "$l" energy_largest_drift_ppm)\""
    eval "SP_${integ}_${lib}_${tol}_$k=\"$(nv "$(m "$integ $tol $lib, free spin, 1/$k" final "$W/spin_$k.txt")" speed_urads)\""
    l="$(m "$integ $tol $lib, pendulum, 1/$k" swing "$W/pend_$k.txt")"
    eval "SW_${integ}_${lib}_${tol}_${k}_1=\"$(nv "$l" swing_per_10000 1)\"; SW_${integ}_${lib}_${tol}_${k}_2=\"$(nv "$l" swing_per_10000 2)\"; SW_${integ}_${lib}_${tol}_${k}_3=\"$(nv "$l" swing_per_10000 3)\""
    l="$(m "$integ $tol $lib, pendulum, 1/$k, turns placed between the steps" swingq "$W/pend_$k.txt")"
    eval "SQ_${integ}_${lib}_${tol}_${k}_1=\"$(nv "$l" swing_per_10000 1)\"; SQ_${integ}_${lib}_${tol}_${k}_2=\"$(nv "$l" swing_per_10000 2)\"; SQ_${integ}_${lib}_${tol}_${k}_3=\"$(nv "$l" swing_per_10000 3)\""
  done
  K_=stopped; s="$(stat "$W/stats.txt")"; K_=diverged; d="$(stat "$W/stats.txt")"
  echo "solver | $integ $tol $lib: steps stopped $s, diverged $d, most iterations of any step $([ -f "$W/stats.txt" ] && most "$W/stats.txt" || echo 999999999)" >> "$OUT"
done; done; done

# the floor of each chain at each tolerance and step: the largest momentum drift read under backward Euler with patch
# G (which keeps a free chain's angular momentum exactly), or FLOOR_LEAST, whichever is larger
for tol in acc tight; do for c in a b t; do for k in $KS; do
  eval "f=\$ML_be_der_${tol}_${c}_$k"; [ "$f" -lt $FLOOR_LEAST ] && f=$FLOOR_LEAST
  eval "FL_${tol}_${c}_$k=$f"
done; echo "floor | $tol, chain $c, steps $KS: $(for k in $KS; do eval "printf '%s ' \$FL_${tol}_${c}_$k"; done)ppm" >> "$OUT"; done; done

# every drift of both forms under BDF2, step by step, for the order rules (reported)
for lib in cur der; do for tol in acc tight; do
  for c in a b t; do echo "drifts | $lib $tol chain $c, momentum, ppm at steps $KS: $(for k in $KS; do eval "printf '%s ' \$ML_bdf2_${lib}_${tol}_${c}_$k"; done)" >> "$OUT"; done
  for c in a b; do echo "drifts | $lib $tol chain $c, energy, ppm at steps $KS: $(for k in $KS; do eval "printf '%s ' \$EL_bdf2_${lib}_${tol}_${c}_$k"; done)" >> "$OUT"; done
  echo "drifts | $lib $tol chain s (swinging, reported), energy, ppm at steps $KS: $(for k in $KS; do eval "printf '%s ' \$EL_bdf2_${lib}_${tol}_s_$k"; done)" >> "$OUT"
done; done

# the free spin and the pendulum at every step, both forms: the coarse-step cost, reported (the one-time loss at the
# start of BDF2 the derived form is known to give a single joint, (omega h)^2 of the speed, printed beside them)
for k in $KS; do
  echo "single joint | 1/$k: (omega h)^2 per 10,000 $(awk -v w=$SPIN -v k=$k 'BEGIN { printf "%.3f", (w * 0.01 / k) ^ 2 * 10000 }') ; free spin, urad/s, of $(awk -v w=$SPIN 'BEGIN { printf "%d", w * 1000000 }'): $(for lib in cur der; do for tol in acc tight; do eval "printf '%s %s %s ' $lib $tol \$SP_bdf2_${lib}_${tol}_$k"; done; done); pendulum, first three swings: $(for lib in cur der; do eval "printf '%s %s %s %s ' $lib \$SW_bdf2_${lib}_acc_${k}_1 \$SW_bdf2_${lib}_acc_${k}_2 \$SW_bdf2_${lib}_acc_${k}_3"; done)" >> "$OUT"
done

# ---- the 20 s pendulum at 1/16 ----
for lib in cur der; do
  l="$(m "long, $lib, pendulum 20 s at 1/16, turns placed between the steps" swingq "$U/long/pend20_$lib.txt")"
  eval "LQ_least_$lib=\"$(nv "$l" least_per_10000)\"; LQ_most_$lib=\"$(nv "$l" most_per_10000)\""
done

# ---- Meta's three scenes ----
BS="$U/bench/stats.txt"
for sc in half_cheetah ant cart_pole; do for cfg in acc rec; do for lib in cur der; do
  echo "benchmark | $sc $cfg $lib steps $(field "$BS" ${sc}_${cfg}_$lib solver_steps) stopped $(field "$BS" ${sc}_${cfg}_$lib stopped) diverged $(field "$BS" ${sc}_${cfg}_$lib diverged) most_iterations $(field "$BS" ${sc}_${cfg}_$lib most_iterations) wall_s $(field "$BS" ${sc}_${cfg}_$lib wall_s)" >> "$OUT"
done; done; done

# ---- safe when off and backward Euler unchanged: the identity check and the comparisons ----
ID="$D/identity.txt"; IL="$D/identity_linux.txt"; CP="$D/compare.txt"
[ -f "$ID" ] || { echo "$ID" >> "$MISSF"; : > "$P/id_empty"; ID="$P/id_empty"; }
[ -f "$CP" ] || { echo "$CP" >> "$MISSF"; : > "$P/cp_empty"; CP="$P/cp_empty"; }
while read -r _ part same_ _ played; do echo "identity | $part $same_ of $played" >> "$OUT"; done < <(grep '^IDENTITY ' "$ID")
[ -f "$IL" ] && sed 's/^/identity, the plays Linux makes differently from the laptop | /' "$IL" >> "$OUT"
n_e1="$(grep '^IDENTITY ' "$ID" | grep -vc '^IDENTITY fg ')"; n_fg="$(grep -c '^IDENTITY fg ' "$ID")"
# a play that differs from its registered file counts against its rule unless it is one of the plays named for Linux
# and is the same as the file run 040 kept from Linux and, with no switch, as the same play on Linux's stock library
un_e1=0; un_e2=0
while IFS= read -r line; do
  case "$line" in
    "PLAY FAILED"*) un_e1=$((un_e1 + 1)); echo "identity | $line" >> "$OUT" ;;
    DIFFERS*) lab="${line#DIFFERS }"
      if [ -f "$IL" ] && grep -qxF "LINUX $lab | kept SAME | stock SAME" "$IL"; then :
      elif [ -f "$IL" ] && grep -qxF "LINUX $lab | kept SAME | stock -" "$IL"; then :
      else
        case "$lab" in "fg "*) un_e2=$((un_e2 + 1)) ;; *) un_e1=$((un_e1 + 1)) ;; esac
        echo "identity | differs and is not explained: $lab" >> "$OUT"
      fi ;;
  esac
done < <(grep -E '^(DIFFERS|PLAY FAILED)' "$ID")
grep -E '^(COMPARE|DIFFERS)' "$CP" | sed 's/^/compare | /' >> "$OUT"
cmp_n() { local x; x="$(grep "^COMPARE $1 " "$CP" | awk '{ print $(NF - 2) " " $NF }')"; [ -n "$x" ] || { echo "compare $1" >> "$MISSF"; x="0 999999999"; }; echo "$x"; }
read -r off_same off_n < <(cmp_n off_bdf2); read -r off2_same off2_n < <(cmp_n off_be)
read -r bea_same bea_n < <(cmp_n be_acc); read -r bet_same bet_n < <(cmp_n be_tight)
read -r ben_same ben_n < <(cmp_n bench_rec)
if [ $bad -ne 0 ]; then echo "measuring incomplete" >&2; fi

# ---- the registered rules ----
echo "rules | every rule below is judged by sx_contact rule from the numbers above and the registered bounds" >> "$OUT"
# O0, required: the current form's momentum is not second order (from 1 to 1/64 it falls by less than 2^(1.5 x 6))
for c in a b t; do
  eval "e1=\$ML_bdf2_cur_tight_${c}_1; e64=\$ML_bdf2_cur_tight_${c}_64; f64=\$FL_tight_${c}_64"
  rule "O0_current_form_chain_${c}_momentum_falls_less_than_second_order" share "$e1" "$e64" $SPAN 1
  rule "O0_current_form_chain_${c}_momentum_above_the_floor_at_1/64" ge "$e64" $(( RULED_TIMES * f64 ))
done
# O1 and O2: the derived form's momentum (three chains) and energy (the planar two) fall at least 2^1.5 a halving
# wherever the finer step's drift is at least RULED_TIMES floors; with the solve converged at least one halving each
order() {  # order <rule name> <tol> <chain> <ML or EL> <at least one halving ruled: 1 or 0>
  local name="$1" tol="$2" c="$3" q="$4" need="$5" k k2 ec ef f1 f2 thr n=0
  for k in 1 2 4 8 16 32; do k2=$((k * 2))
    eval "ec=\$${q}_bdf2_der_${tol}_${c}_$k; ef=\$${q}_bdf2_der_${tol}_${c}_$k2; f1=\$FL_${tol}_${c}_$k; f2=\$FL_${tol}_${c}_$k2"
    thr=$(( RULED_TIMES * (f1 > f2 ? f1 : f2) ))
    if [ "$ef" -ge "$thr" ]; then n=$((n + 1)); rule "${name}_1/${k}_to_1/${k2}" share "$ef" "$ec" $ORDER_NUM $ORDER_DEN
    else echo "order | $name, 1/$k to 1/$k2: the drift at the finer step, $ef ppm, is under $RULED_TIMES floors ($thr): not ruled" >> "$OUT"; fi
  done
  echo "order | $name: halvings ruled $n" >> "$OUT"
  if [ "$need" = 1 ]; then rule "${name}_halvings_ruled" ge "$n" 1; fi
}
for tol in tight acc; do
  need=0; [ $tol = tight ] && need=1
  for c in a b t; do order "O1_chain_${c}_${tol}_momentum" $tol $c ML $need; done
  for c in a b; do order "O2_chain_${c}_${tol}_energy" $tol $c EL $need; done
done
# T1 to T4: the accurate configuration's step, 1/16, at its tolerances, the derived form
for c in a b t; do eval "v=\$ML_bdf2_der_acc_${c}_16"; rule "T1_chain_${c}_momentum_within_1000_ppm" le "$v" 1000; done
for c in a b; do eval "v=\$KE_bdf2_der_acc_${c}_16"; rule "T1_chain_${c}_energy_within_1_in_200" within "$v" 1000000 200; done
rule "T2_swinging_chain_energy_within_1_in_200" in "$ED_bdf2_der_acc_s_16" -5000 5000
rule "T3_free_spin_keeps_9999_in_10000" ge "$SP_bdf2_der_acc_16" $SPIN_9999
rule "T4_pendulum_first_three_swings" all_in 9995 10005 "$SW_bdf2_der_acc_16_1" "$SW_bdf2_der_acc_16_2" "$SW_bdf2_der_acc_16_3"
rule "T4_pendulum_first_three_swings_turns_between_steps" all_in 9995 10005 "$SQ_bdf2_der_acc_16_1" "$SQ_bdf2_der_acc_16_2" "$SQ_bdf2_der_acc_16_3"
rule "T4_pendulum_20_s_every_swing" all_in 9990 10005 "$LQ_least_der" "$LQ_most_der"
# U1 and U2: the solver
grep '^STATS run pend20_der ' "$U/long/stats.txt" > "$P/long_der.txt" 2>/dev/null || true
U1F="$U/bdf2_acc_der/stats.txt $U/bdf2_tight_der/stats.txt $P/long_der.txt"
# shellcheck disable=SC2086
{ K_=diverged; u1d="$(stat $U1F)"; K_=stopped; u1s="$(stat $U1F)"; u1m="$(most $U1F 2>/dev/null || echo 999999999)"; }
[ -s "$P/long_der.txt" ] || { echo "long pend20_der" >> "$MISSF"; u1m=999999999; }
echo "solver | the derived form's plays under BDF2: steps stopped (reported) $u1s, diverged $u1d, most iterations of any step $u1m" >> "$OUT"
rule "U1_no_step_diverges" eq "$u1d" 0
rule "U1_no_step_stops_at_the_iteration_limit" le "$u1m" 199
for sc in half_cheetah ant cart_pole; do
  rule "U2_${sc}_no_step_diverges" eq "$(field "$BS" ${sc}_acc_der diverged)" 0
  rule "U2_${sc}_none_at_the_iteration_limit" le "$(field "$BS" ${sc}_acc_der most_iterations)" 199
  rule "U2_${sc}_stops_no_more_than_1_in_1000" share "$(field "$BS" ${sc}_acc_der stopped)" "$(field "$BS" ${sc}_acc_der solver_steps)" 1 1000
done
# E1: safe when off; E2: backward Euler unchanged
rule "E1_identity_every_play_identical_or_the_linux_play_named" eq "$un_e1" 0
rule "E1_identity_parts_played" eq "$n_e1" $N_E1_PARTS
rule "E1_own_scenes_no_switch_as_stock" all_eq 0 "$(( off_n - off_same ))" "$(( off2_n - off2_same ))"
rule "E1_own_scenes_compared" eq "$(( off_n + off2_n ))" $N_OFF
rule "E2_identity_fg_identical_or_the_linux_play_named" eq "$un_e2" 0
rule "E2_identity_fg_played" eq "$n_fg" 1
rule "E2_own_scenes_backward_euler_as_build_15" all_eq 0 "$(( bea_n - bea_same ))" "$(( bet_n - bet_same ))"
rule "E2_own_scenes_compared" eq "$(( bea_n + bet_n ))" $N_BE
rule "E2_benchmark_recommended_configuration_as_build_15" eq "$(( ben_n - ben_same ))" 0
rule "E2_benchmark_compared" eq "$ben_n" $N_BENCH_REC
# reported beside the rules: the current form at the accurate configuration's step
echo "reported, not a rule | the current form at 1/16, accurate tolerances: chains' momentum $ML_bdf2_cur_acc_a_16 $ML_bdf2_cur_acc_b_16 $ML_bdf2_cur_acc_t_16 ppm, energy at the end $KE_bdf2_cur_acc_a_16 $KE_bdf2_cur_acc_b_16, swinging chain $ED_bdf2_cur_acc_s_16, free spin $SP_bdf2_cur_acc_16, pendulum $SW_bdf2_cur_acc_16_1 $SW_bdf2_cur_acc_16_2 $SW_bdf2_cur_acc_16_3, 20 s swings $LQ_least_cur to $LQ_most_cur" >> "$OUT"
held="$(grep -c '^RULE [A-Z][A-Za-z0-9]*_.* : HELD$' "$OUT")"; failed="$(grep -c '^RULE [A-Z][A-Za-z0-9]*_.* : FAILED$' "$OUT")"
echo "STUDY22 rule lines held $held failed $failed ; values missing $(wc -l < "$MISSF" | tr -d ' ') ; measuring complete $(( 1 - bad ))" >> "$OUT"
[ -s "$MISSF" ] && sed 's/^/missing | /' "$MISSF" >> "$OUT"
[ $bad -eq 0 ] || exit 1
exit 0
