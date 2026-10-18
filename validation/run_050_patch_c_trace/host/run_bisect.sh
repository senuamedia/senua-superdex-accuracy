#!/usr/bin/env bash
# the bisect after b4 and b5: each variant built and played in turn; b4 rebuilt last to check the incremental build
cd ~/work/traceC
for v in v_noEigT v_onlyEigT v_visc v_fold; do ./variant.sh $v qi1 q1; done
mkdir -p variants && cp variants/b4.h variants/b4_again.h && ./variant.sh b4_again qi1
echo done
