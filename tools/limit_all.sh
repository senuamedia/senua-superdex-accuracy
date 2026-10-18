#!/bin/bash
# The eighth registration's one-joint plays (PREREGISTRATION_08.md): joint limits on the registered arm, under stock,
# the patched library with no switch, and the joint limit patch (SUPERDEX_LIMIT_UNILATERAL=1); then the sixth
# registration's 30 runs (no limit in them) with the switch on, each compared with its registered file.
# usage: tools/limit_all.sh        (from the repository root; each play takes a second or two)
set -u
R="$(cd "$(dirname "$0")/.." && pwd)"
O="$R/validation/run_019_limits"; mkdir -p "$O"
ARM="mass=2 radius=0.04 arm=0.4"
LIM="lo=-0.3 hi=3 limitk=2000"
dt_of() { echo "scale=12; 0.01/$1" | bc; }
for cfg in stock off patched; do
  case $cfg in
    stock) T="$R/tools/sdx_joint64_stock"; unset SUPERDEX_LIMIT_UNILATERAL ;;
    off) T="$R/tools/sdx_joint64"; unset SUPERDEX_LIMIT_UNILATERAL ;;
    patched) T="$R/tools/sdx_joint64"; export SUPERDEX_LIMIT_UNILATERAL=1 ;;
  esac
  D="$R/limits/$cfg"; mkdir -p "$D"; : > "$D/stats.txt"
  play() {  # play <name> <k> <settings...>
    local name="$1" k="$2"; shift 2
    # shellcheck disable=SC2086
    "$T" "$D/${name}_$k.txt" dt="$(dt_of "$k")" $ARM $LIM "$@" | sed "s/^STATS/STATS run ${name}_$k/" >> "$D/stats.txt"
  }
  for k in 1 16; do
    play rest $k secs=3 limitd=150                                   # LT1: falls onto the limit and rests on it
    play lift $k secs=1.6 limitd=150 torque=15.68 torqueat=1.5       # LT3: rests, then lifted with twice gravity's torque
  done
  for k in 1 16 64; do
    play rel20 $k secs=0.5 gravity=0 angle0=-0.33 limitd=20          # LT2: released at rest 0.03 rad inside the limit
    play rel150 $k secs=0.5 gravity=0 angle0=-0.33 limitd=150
  done
done
# the sixth registration's runs with the switch on
export SUPERDEX_LIMIT_UNILATERAL=1
T="$R/tools/sdx_joint64"; W="$R/work/_v8_nolimit"; mkdir -p "$W"; same=0; diff=0
chk() { local name="$1" k="$2"; shift 2; "$T" "$W/${name}_$k.txt" dt="$(dt_of "$k")" $ARM "$@" > /dev/null 2>&1; if cmp -s "$W/${name}_$k.txt" "$R/joints/${name}_$k.txt"; then same=$((same+1)); else diff=$((diff+1)); echo "DIFFERS ${name}_$k"; fi; }
for k in 1 4 16 64; do chk spin_be $k gravity=0 omega0=3 secs=1; chk torque_be $k gravity=0 torque=1.5 secs=1; chk swing_be $k secs=3; done
for integ in bdf2 dirk33; do chk spin_$integ 1 gravity=0 omega0=3 secs=1 integ=$integ; chk torque_$integ 1 gravity=0 torque=1.5 secs=1 integ=$integ; chk swing_$integ 1 secs=3 integ=$integ; done
for w in 1 2 4 8; do chk spinrate$w 1 gravity=0 omega0=$w secs=1; done
for k in 1 16; do chk hold_shipped $k coulomb=12 secs=2; chk hold_tight $k coulomb=12 secs=2 falloff=0.000001; chk slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; chk slip_tight $k gravity=0 coulomb=2 torque=3 secs=1 falloff=0.000001; done
echo "NOLIMIT identical $same of $((same+diff))" | tee "$O/nolimit_identity.txt"
unset SUPERDEX_LIMIT_UNILATERAL
# the same 30 runs on the patched library with no switch
same=0; diff=0
for k in 1 4 16 64; do chk spin_be $k gravity=0 omega0=3 secs=1; chk torque_be $k gravity=0 torque=1.5 secs=1; chk swing_be $k secs=3; done
for integ in bdf2 dirk33; do chk spin_$integ 1 gravity=0 omega0=3 secs=1 integ=$integ; chk torque_$integ 1 gravity=0 torque=1.5 secs=1 integ=$integ; chk swing_$integ 1 secs=3 integ=$integ; done
for w in 1 2 4 8; do chk spinrate$w 1 gravity=0 omega0=$w secs=1; done
for k in 1 16; do chk hold_shipped $k coulomb=12 secs=2; chk hold_tight $k coulomb=12 secs=2 falloff=0.000001; chk slip_shipped $k gravity=0 coulomb=2 torque=3 secs=1; chk slip_tight $k gravity=0 coulomb=2 torque=3 secs=1 falloff=0.000001; done
echo "OFF identical $same of $((same+diff))" | tee -a "$O/nolimit_identity.txt"
(cd "$R/limits" && shasum -a 256 */*.txt > SHA256SUMS)
echo "played $(ls "$R"/limits/*/*_[0-9]*.txt | wc -l | tr -d ' ') limit runs"
