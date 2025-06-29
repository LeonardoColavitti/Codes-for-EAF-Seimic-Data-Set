#!/bin/bash
#GIT_Dataset_ok.sh
#LC - 03 June 2024

####################################################
### DEFINE INPUT TXT FILE ###
####################################################
# ETOPO_2022_v1_60s_N90W180_bed.tif 	 [TOPOGRAPHY MAP]
# KO_stat_ok.txt			             [KO STATIONS]
# TU_stat_ok.txt			             [TU STATIONS]
# TK_stat_ok.txt			             [TK STATIONS]
# coord_out_events_catal_qc_ok.txt		 [EVENTS AFTER QC]
# Malgar_faults_field1.txt 		         [FAULTS 1]
# Malgar_faults_field2.txt		         [FAULTS 2]
# Malgar_faults_field3.txt		         [FAULTS 3]
# Malgar_faults_field4.txt		         [FAULTS 4]
# 1st_shock_TK.txt			             [1st SHOCK]
# 2nd shock_TK.txt			             [2nd SHOCK]

####################################################
### DEFINE VARIABLES ###
####################################################

#DEFINE OUTPUT NAME
OUT=GIT_Dataset_ok.ps

#DEFINE MAP TO PLOT
TOPO=/home/leonardo/Desktop/TURKIYE/GMT_Turkiye/Turkyie_Images/ETOPO_2022_v1_60s_N90W180_bed.tif

#GET INFO ABOUT THE MAP
gmt grdinfo $TOPO

#DEFINE REGION TO PLOT [West/East/South/North]
REG=32/44/34/44

#DEFINE PROJECTION
PROJ=-JM15

#DEFINE TICK
TICK=-B2/2WSen

####################################################

#CREATE BASEMAP
gmt psbasemap -R$REG $PROJ $TICK -P -X1.5 -Y12 -K > $OUT

#CREATE TOPOGRAPHIC MAP
gmt makecpt -Cetopo1 -T-4000/4000/200 -Z > topo.cpt

#CREATE IMAGE
gmt grdimage $TOPO -R$REG -JM15 -O -K -Ctopo.cpt >> $OUT

#BOUNDARIES
gmt pscoast -W0.8 -Na/0.8,black -Df -Lf34/34.5/10/200+lkm -R -JM15 -K -O >> $OUT

#GMT RIVERS
gmt pscoast -W0.8 -Ia/0,5/150/250 -Df -R -JM15 -K -O >> $OUT

#GMT LAKES
gmt pscoast -W0.8 -C0/150/250 -Df -R -JM15 -K -O >> $OUT

#PLOT KO STATIONS
awk '{print $2,$1}' KO_stat_ok.txt | gmt psxy -V -R -JM15 -St0.4 -Gred -Wthinner -P -O -K >> $OUT
#PLOT TK STATIONS
awk '{print $2,$1}' TK_stat_ok.txt | gmt psxy -V -R -JM15 -St0.4 -Gblue -Wthinner -P -O -K >> $OUT
#PLOT TU STATIONS
awk '{print $2,$1}' TU_stat_ok.txt | gmt psxy -V -R -JM15 -St0.4 -Ggreen -Wthinner -P -O -K >> $OUT

#CREATE A COLOR SCALE BASED ON DEPTH
gmt makecpt -Cmagma -T0/40/5 -I -Z > depth_palette.cpt

# DRAW WHITE RECTANGLE IN THE TOP-RIGHT CORNER OF MAIN MAP
# Adjust these coordinates based on your map region
echo "42 41.38" > rect_top_right.dat
echo "43.8   41.38" >> rect_top_right.dat
echo "43.8   43.96" >> rect_top_right.dat
echo "42 43.96" >> rect_top_right.dat
echo "42 41.38" >> rect_top_right.dat
gmt psxy -R -J -P -O -K -Gwhite -Wthinner rect_top_right.dat >> $OUT
rm rect_top_right.dat

# PLOT LEGEND ON DEPTH
gmt psscale -Cdepth_palette.cpt -Dx5i/11.82c+w4c/0.15i+v -Bxa10f+l"Depth" -F8p,Helvetica-Bold -O -K >> $OUT

# Draw a white box for the legend
echo "4.5 -1.5" > depth_legend_box.txt
echo "8.5 0.5" >> depth_legend_box.txt
gmt psxy -R -J -P -O -K -Gwhite -Wthinner depth_legend_box.txt >> $OUT
rm depth_legend_box.txt

#PLOT EVENTS
awk '{print $2,$1,$3,$4/15}' coord_out_events_catal_qc_ok.txt | gmt psxy -V -R -JM15 -Sc -Cdepth_palette.cpt -W0.5p,black -P -O -K >> $OUT

#PLOT FAULTS
gmt psxy -R -JM15 -P -O -K -W1.5,yellow Malgar_faults_field1.txt >> $OUT
gmt psxy -R -JM15 -P -O -K -W1.5,yellow Malgar_faults_field2.txt >> $OUT
gmt psxy -R -JM15 -P -O -K -W1.5,yellow Malgar_faults_field3.txt >> $OUT
gmt psxy -R -JM15 -P -O -K -W1.5,yellow Malgar_faults_field4.txt >> $OUT

#PLOT MECFOC OF THE 2 MAINSHOCKS
#1st SHOCK - 1st_shock_TK.dat
gmt psmeca 1st_shock_TK.txt -R$REG -JM15 -Sc0.539c -P -O -K >> $OUT
#2nd SHOCK - 2nd_shock_TK.dat
gmt psmeca 2nd_shock_TK.txt -R$REG -JM15 -Sc0.532c -P -O -K >> $OUT

#Pazarcık (Kahramanmaraş) - Mw 7.7
#06-02-2023 01:17:32
#Latitude  37.288 Longitude 37.043 Depth      8.6 Focal Mechanism Strike 1: 233 Dip    1: 74 Rake   1: 18 Strike 2: 140 Dip    2: 77 Rake   2: 168

#Elbistan (Kahramanmaraş) - Mw 7.6
#06-02-2023 10:24:47
#Latitude  38.089 Longitude 37.239 Depth     7 Focal Mechanism Strike 1: 358 Dip    1: 73 Rake   1: 174 Strike 2: 90 Dip    2: 86 Rake   2: 13

#PLOT EQK BOX
echo 34.89 35.50 >  box_eqk.dat
echo 42.00 35.50 >> box_eqk.dat
echo 42.00 40.00 >> box_eqk.dat
echo 34.89 40.00 >> box_eqk.dat
echo 34.89 35.50 >> box_eqk.dat
gmt psxy -R -JM15 -P -O -K -W1.0,red box_eqk.dat >> $OUT
rm box_eqk.dat

#PLOT INSET MAP
gmt pscoast -R$26/50/32/46 -JM15 -B0ewns -N1/0.4p,black -X0.5 -Y13.2 -Dh -W0.2 -Ggrey -S135/206/250 -O -K >> $OUT

#PLOT SQUARE BOX AS AREA SIGN
echo 32 34 >   box1.dat
echo 44 34 >>  box1.dat
echo 44 44 >>  box1.dat
echo 32 44 >>  box1.dat
echo 32 34 >>  box1.dat
gmt psxy -R -J -P -O -K -W0.8,black box1.dat >> $OUT
rm box1.dat

# Creare il file di dati per la legenda
echo "H 10 1 Magnitude (proportional to circle size)" > mag_legend.txt
echo "G" >> mag_legend.txt # Spazio aggiuntivo
echo "S 10 0.38 c 0.167c grey 0.5p 0.3i M 2.5" >> mag_legend.txt
echo "S 10 0.38 c 0.23c grey 0.5p 0.3i M 3.5" >> mag_legend.txt
echo "S 10 0.38 c 0.30c grey 0.5p 0.3i M 4.5" >> mag_legend.txt
echo "S 10 0.38 c 0.37c grey 0.5p 0.3i M 5.5" >> mag_legend.txt

# Aggiungere legenda della magnitudo con il box e testo centrato
gmt pslegend -R -J -Dx12.5c/3.5c+w2.8c/2.6c+o-5c/-5c -F+gwhite+p0.5p,black -P -O -K << EOF >> $OUT

H 10 1 Magnitude
G
S 0.38 c 0.167c grey 0.5p 0.3i M 2.5
S 0.38 c 0.23c grey 0.5p 0.3i M 3.5
S 0.38 c 0.30c grey 0.5p 0.3i M 4.5
S 0.38 c 0.37c grey 0.5p 0.3i M 5.5
EOF

gmt pstext -R-1/1/-5/0 -JX5c/3c -O -F+f10p,Helvetica-Bold,black map_legend.txt >> $OUT

# Rimuovi il file temporaneo
rm mag_legend.txt

# Convert to PNG, JPG, TIF
#gmt psconvert $OUT -Tp -FGIT_event_stations_turkyie_ok
#gmt psconvert $OUT -Tj -FGIT_event_stations_turkyie_ok
#gmt psconvert $OUT -Tt -FGIT_event_stations_turkyie_ok

#CONVERT PS2PDF
#ps2pdf $OUT

#CREATION OF PDF FILE
open  $OUT
