#!/usr/bin/env bash
# kp_steps.sh <probe stderr log> : one line per step and contact pair, from the LAST pass of the step that assembled
# the residual (the solver's final residual evaluation), summed over that pass's task ranges. PROBE ONLY.
# Output columns:
#  step t e0 e1 nActive W Tx Ty Px Py Frx Fry Dx Dy frMag fnNow fnSS fnF nAct fnRawG nTilt tiltPx tiltPy tiltFrx
#  tiltFnNow tiltFnSS ymean xmin xmax
set -u
awk '
function flush(step, t,   k) {
  for (k in sum_n) {
    if (pass_of[k] != lastpass) continue
    split(k, ee, SUBSEP)
    printf "%d %.9g %s %s %d", step, t, ee[1], ee[2], sum_act[k]
    printf " %.9g %.9g %.9g %.9g %.9g %.9g %.9g %.9g %.9g", sW[k], sTx[k], sTy[k], sPx[k], sPy[k], sFx[k], sFy[k], sDx[k], sDy[k]
    printf " %.9g %.9g %.9g %.9g %.9g %.9g", sFm[k], sNow[k], sSS[k], sFF[k], sNa[k], sRg[k]
    printf " %d %.9g %.9g %.9g %.9g %.9g", sNt[k], sTpx[k], sTpy[k], sTfx[k], sTnow[k], sTss[k]
    printf " %.9g %.9g %.9g\n", ymean[k], xmn[k], xmx[k]
  }
  delete sum_n; delete pass_of; delete sum_act; delete sW; delete sTx; delete sTy; delete sPx; delete sPy
  delete sFx; delete sFy; delete sDx; delete sDy; delete sFm; delete sNow; delete sSS; delete sFF; delete sNa
  delete sRg; delete sNt; delete sTpx; delete sTpy; delete sTfx; delete sTnow; delete sTss; delete ymean
  delete xmn; delete xmx; lastpass = -1
}
BEGIN { lastpass = -1 }
$1 == "KP" {
  pass = $2 + 0; e0 = $3; e1 = $4; res = $8 + 0
  if (res != 1) next
  if (pass > lastpass) lastpass = pass
  k = e0 SUBSEP e1
  if (pass_of[k] != pass) {   # a new pass for this pair: restart its sums
    pass_of[k] = pass; sum_n[k] = 0; sum_act[k] = 0; sW[k] = 0; sTx[k] = 0; sTy[k] = 0; sPx[k] = 0; sPy[k] = 0
    sFx[k] = 0; sFy[k] = 0; sDx[k] = 0; sDy[k] = 0; sFm[k] = 0; sNow[k] = 0; sSS[k] = 0; sFF[k] = 0; sNa[k] = 0
    sRg[k] = 0; sNt[k] = 0; sTpx[k] = 0; sTpy[k] = 0; sTfx[k] = 0; sTnow[k] = 0; sTss[k] = 0; ymean[k] = 0
    xmn[k] = 1e9; xmx[k] = -1e9; ysum[k] = 0
  }
  sum_n[k] += $10; sum_act[k] += $11; sW[k] += $12; sTx[k] += $13; sTy[k] += $14; sPx[k] += $16; sPy[k] += $17
  sFx[k] += $19; sFy[k] += $20; sDx[k] += $22; sDy[k] += $23; sFm[k] += $25; sNow[k] += $26; sSS[k] += $27
  sFF[k] += $28; sNa[k] += $29; sRg[k] += $30; sNt[k] += $31; sTpx[k] += $32; sTpy[k] += $33; sTfx[k] += $34
  sTnow[k] += $35; sTss[k] += $36
  if ($11 > 0) { ysum[k] += $37 * $11; ymean[k] = ysum[k] / sum_act[k]; if ($38 < xmn[k]) xmn[k] = $38; if ($39 > xmx[k]) xmx[k] = $39 }
  next
}
$1 == "STEP" { flush($2, $3); next }
' "$1"
