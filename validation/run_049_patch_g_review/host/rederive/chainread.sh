#!/usr/bin/env bash
# Reads a sdx_chain file (validation format) two ways, in double precision:
#   link: as measure/sx_contact.sx's chain reading does, from SuperDex's own link velocities and spins;
#   joint: from the joint speeds the file records, each arm's velocity being the one its joints' motion implies
#          (e_z x r about each joint it rides on), with the same positions and spins = sums of joint speeds.
# Prints, for each: kinetic energy at the end per million of the start, the angular momentum's drift at the end and
# its largest drift, in parts per million.
# usage: chainread.sh <chain file>
awk 'NR==1 { m1=$5/1000; m2=$7/1000; h=$9/1e6; a1=$11/1e6; l1=$13/1e6; g=$17; next }
     { w1=$3/1e6; w2=$5/1e6
       x1=$6/1e6; y1=$7/1e6; x2=$11/1e6; y2=$12/1e6
       I1=2/3*m1*h*h; I2=2/3*m2*h*h
       # link reading
       kL=0.5*m1*(($8/1e6)^2+($9/1e6)^2)+0.5*I1*($10/1e6)^2+0.5*m2*(($13/1e6)^2+($14/1e6)^2)+0.5*I2*($15/1e6)^2
       LL=m1*(x1*$9/1e6-y1*$8/1e6)+I1*$10/1e6+m2*(x2*$14/1e6-y2*$13/1e6)+I2*$15/1e6
       # joint reading: elbow at l1/a1 of the first centre
       px=x1*l1/a1; py=y1*l1/a1
       v1x=-w1*y1; v1y=w1*x1
       v2x=-w1*y2-w2*(y2-py); v2y=w1*x2+w2*(x2-px)
       kJ=0.5*m1*(v1x^2+v1y^2)+0.5*I1*w1^2+0.5*m2*(v2x^2+v2y^2)+0.5*I2*(w1+w2)^2
       LJ=m1*(x1*v1y-y1*v1x)+I1*w1+m2*(x2*v2y-y2*v2x)+I2*(w1+w2)
       if (NR==2) { kL0=kL; LL0=LL; kJ0=kJ; LJ0=LJ; mL=0; mJ=0 }
       d=(LL-LL0)/LL0*1e6; if (d<0) d=-d; if (d>mL) mL=d
       d=(LJ-LJ0)/LJ0*1e6; if (d<0) d=-d; if (d>mJ) mJ=d
       kLe=kL; LLe=LL; kJe=kJ; LJe=LJ }
     END { printf "link: kinetic_end_per_million %.1f momentum_drift_ppm %.1f largest %.1f | joint: kinetic_end_per_million %.1f momentum_drift_ppm %.1f largest %.1f | start link L %.9f joint L %.9f\n",
           kLe/kL0*1e6, (LLe-LL0)/LL0*1e6, mL, kJe/kJ0*1e6, (LJe-LJ0)/LJ0*1e6, mJ, LL0, LJ0 }' "$1"
