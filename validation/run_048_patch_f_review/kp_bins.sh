#!/usr/bin/env bash
# kp_bins.sh <kp_steps output> <rig _b file> <mu> <mass of B kg> <bin s> <ytop of A, m> : PROBE ONLY.
# For the pair "B on A" (colliding samples at y near ytop in A's frame), averages over bins of <bin s> of every
# step whose end falls in the bin:
#   aB      B's acceleration along x from the rig's speeds (mm/s2)
#   Tx/m    the contact force on B along x over B's mass (mm/s2): the same thing seen from the contact
#   Px Frx Dx   its three parts (mN): penalty (normal force's horizontal part), friction, normal damping
#   Fy      the contact force up on B (mN)
#   Rfric   friction magnitude over mu x the normal force actually applied (per 10,000)
#   RF  RSS  patch F's friction normal and stock's (stage-start, fade included) over the applied normal (per 10,000)
#   RNOW     the step's penalty normal with SuperDex's fade (no damping) over the applied normal (per 10,000)
#   nTilt nAct  samples on a tilted or non-unit gradient, samples in contact; tiltLoad: their share of Py (per 10,000)
#   xmin    the rearmost active sample along x in A's frame (mm)
set -u
KP="$1"; BF="$2"; MU="$3"; MB="$4"; BIN="$5"; YTOP="$6"
awk -v mu="$MU" -v mb="$MB" -v bin="$BIN" -v ytop="$YTOP" '
FNR == 1 && FILENAME == ARGV[1] { file = 1 }
FILENAME == ARGV[2] && FNR == 1 { file = 2; next }
file == 2 { vx[$1] = $3; next }
file == 1 {
  if (($27 - ytop) > 0.02 || ($27 - ytop) < -0.02) next   # not the B-on-A pair
  s = $1; t = $2; T[s] = t
  Tx[s] = $7; Ty[s] = $8; Px[s] = $9; Py[s] = $10; Fx[s] = $11; Dx[s] = $13; Fm[s] = $15; Now[s] = $16; SS[s] = $17
  FF[s] = $18; Na[s] = $19; Nt[s] = $21; Tpy[s] = $23; Na_n[s] = $5; xm[s] = $28; have[s] = 1
}
END {
  # dt from the first two steps
  for (s in have) { if (min == "" || s + 0 < min) min = s + 0 }
  dt = T[min + 1] - T[min]
  printf "%7s %6s %7s %7s %8s %8s %8s %8s %6s %6s %6s %6s %5s %5s %6s %8s\n", "bin_end", "steps", "aB", "Tx/m", "Px_mN", "Frx_mN", "Dx_mN", "Fy_mN", "Rfric", "RF", "RSS", "RNOW", "nTilt", "nAct", "tiltLd", "xmin_mm"
  for (s in have) {
    b = int((T[s] - 1e-9) / bin); key[b] = 1
    if (bmin == "" || b < bmin) bmin = b; if (bmax == "" || b > bmax) bmax = b
    if ((s - 1) in vx) { cnt[b]++; aB[b] += (vx[s] - vx[s - 1]) / (dt * 1000) }
    n[b]++; tx[b] += Tx[s]; px[b] += Px[s]; fx[b] += Fx[s]; dx[b] += Dx[s]; fy[b] += Ty[s]
    rf[b] += (Na[s] > 0 ? Fm[s] / (mu * Na[s]) : 0); rF[b] += (Na[s] > 0 ? FF[s] / Na[s] : 0); rS[b] += (Na[s] > 0 ? SS[s] / Na[s] : 0)
    rN[b] += (Na[s] > 0 ? Now[s] / Na[s] : 0); nt[b] += Nt[s]; na[b] += Na_n[s]; tl[b] += (Py[s] != 0 ? Tpy[s] / Py[s] : 0)
    if (!(b in xmn) || xm[s] < xmn[b]) xmn[b] = xm[s]
  }
  for (b = bmin; b <= bmax; b++) {
    if (!(b in key)) continue
    printf "%7.3f %6d %7.0f %7.0f %8.1f %8.1f %8.1f %8.1f %6.0f %6.0f %6.0f %6.0f %5.1f %5.1f %6.0f %8.2f\n", (b + 1) * bin, n[b], (cnt[b] > 0 ? aB[b] / cnt[b] : 0), tx[b] / n[b] / mb * 1000, px[b] / n[b] * 1000, fx[b] / n[b] * 1000, dx[b] / n[b] * 1000, fy[b] / n[b] * 1000, rf[b] / n[b] * 10000, rF[b] / n[b] * 10000, rS[b] / n[b] * 10000, rN[b] / n[b] * 10000, nt[b] / n[b], na[b] / n[b], tl[b] / n[b] * 10000, xmn[b] * 1000
  }
}' "$KP" "$BF"
