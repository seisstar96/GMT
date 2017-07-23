#!/bin/bash
#made by Lu Weifan
# PS=test2.ps
PS=sanxia.ps
eqfile=sanxia.txt
# R=108/135/15/55
R=g110/111/30.3/31.5
J=X15c/15c

#gmt gmtset FORMAT_GEO_MAP=ddd:mm:ssF

gmt grdcut earth_relief_15s.grd -R$R -GcutTopo.grd
gmt grdgradient cutTopo.grd -Ne0.7 -A50 -GcutTopo_i.grd
gmt grd2cpt cutTopo.grd -Cglobe -S-10000/10000/200 -Z -D > colorTopo.cpt

# 绘制底图
gmt psbasemap -R$R -J$J -Ba0.2f0.2 -Xc -Yc -K  -P > $PS
gmt grdimage cutTopo.grd -R$R -J$J -IcutTopo_i.grd -CcolorTopo.cpt -Q -O -K >>$PS

# 绘制colorbar
gmt psscale -CcolorTopo.cpt -D7.5c/-1c/15c/0.5ch -B2000:Elevation:/:m: -O -K >>$PS

# 绘制台站位置 经度在前
awk '{print $2,$3}' $eqfile | psxy -R$R -J$J -St0.2i -Gred -O -K >>$PS
awk '{print $2-0.01, $3+0.02,"9 0 1 BL", $1 }' $eqfile | pstext -JX -B -R -O -K -P >>$PS
# 绘制国界、省界数据
#gmt psxy CN-border-La.dat -J$J -R$R -W0.7p -K -O >>$PS

gmt psxy -R$R -J$J -T -O >>$PS
ps2raster $PS -Tg -P -A    #g表示png格式 -A表示裁去白边
#gmt psconvert $PS -A -Tg -P
#rm gmt.* cutTopo*.grd colorTopo.cpt
