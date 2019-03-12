#!/bin/bash
R=g103.6/104/33/33.4
J=X4i
PS=pic.ps
eqfile=JZ.txt
gmt set PLOT_DEGREE_FORMAT DF
#gmt set FORMAT_GEO_MAP 
gmt set MAP_FRAME_TYPE=plain
gmt set FONT_ANNOT_PRIMARY 10p,0,black
gmt set FONT_LABEL 10p,0,black

#gmt grdgradient Jz.nc -Ne0.8 -A100 -Gtopo.grad
# 制作灰色色标文件g.cpt
###定义要生成的CPT文件的Z值范围及Z值间隔
#gmt makecpt -Cst11.cpt -T-8000/8000/500 -Z > g.cpt


gmt psbasemap -R$R -J$J -Bf0.1a0.1 -BWesN  -K  > $PS
gmt grdimage -R$R -J$J Jz.nc  -Itopo.grad -Cmy.cpt -O -K >> $PS
#gmt psscale -DjCB+w18c/0.3c+o0/-1.5c+h -R$R -J$J -Y1i -Cworld -BWSEN -Bxa2000f400+l"Elevation/m" -G-1000/7000 -O -K >> $PS

awk '{print $3,$2}' $eqfile | gmt psxy -R$R -J$J -St0.1i -W0.5p,black -Gred -O -K >> $PS
awk '{print $3, $2,"9 0 1 BL", $1 }' $eqfile | gmt pstext -R$R -J$J  -O -K -P >> $PS


gmt psxy Tibet_Faults.txt -R$R -J$J -W1p,blue -K -O >> $PS

echo 2017-08-08 21:19:28.0 33.20 103.82 20 7.0  | awk '{print $4,$3,$5,$6*0.08}' | gmt psxy -R -J -O -K -Sa10p -Gred  >> $PS
echo 103.6 33.1 Minjiang_Ft | awk 'NR==1 {print $1+0.1,$2+0.1,$3}' | gmt pstext -R -J -F+f10p,3,black+a90  -O -K >> $PS
echo 103.9 33.27 Tazang_Ft | awk 'NR==1 {print $1,$2,$3}' | gmt pstext -R -J -F+f10p,3,black+a315  -O -K >> $PS
echo 103.98 33.07 Huya_Ft | awk 'NR==1 {print $1,$2,$3}' | gmt pstext -R -J -F+f10p,3,black+a300  -O -K >> $PS

gmt psmeca -J -R -CP1p -Sa0.5c  -K -O >> $PS << EOF
# 经度 纬度 深度(km) strike dip rake 震级 newX newY ID
103.82 33.20 20 246 57 -173  7 103.8  33.2     JZG.Eq
EOF

gmt psbasemap -R0/30/0/30 -JX3i -Bwesn+n  -K -O -X4.2i -Y0.5i >> $PS
echo 2 25  | awk '{print $1,$2}' | gmt psxy -R -J -O -K -St10p -W0.5p,black -Gred  >> $PS
echo 7 25 Sub-Array | awk 'NR==1 {print $1,$2,$3}' | gmt pstext -R -J -F+f10p,0,black  -O -K >> $PS

echo 2 15  | awk '{print $1,$2}' | gmt psxy -R -J -O -K -Sa10p -Gred  >> $PS
echo 7 15 Mainshcok | awk 'NR==1 {print $1,$2,$3}' | gmt pstext -R -J -F+f10p,0,black  -O -K >> $PS

echo 0 5 > fault1.dat
echo 5 5 >> fault1.dat
gmt psxy fault1.dat -R -J -O -K  -W1p,blue >> $PS
echo 8 5 Faults | awk 'NR==1 {print $1,$2,$3}' | gmt pstext -R -J -F+f10p,0,black  -O -K >> $PS

gmt psxy -R -J -T -O >> $PS
gmt psconvert $PS -A -P -Tg
rm gmt*
