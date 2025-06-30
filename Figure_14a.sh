#!/bin/bash
#Map_Event_Stations_time-ok.sh
#Leonardo Colavitti - 22 February 2025

# This script generates FIGURE 14A of the DataPaper published in Earth Science System Data:
# A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
# by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa

# SUMMARY:
# This GMT-based script generates a detailed seismic map for the February 2023
# Turkey earthquake sequence. It includes:
#
# - Topographic background using ETOPO 2022
# - Locations of seismic events colored by relative origin time (days)
# - Stations from three different networks (KO, TU, TK)
# - Active faults from field mapping
# - First and second mainshock locations (optional focal mechanisms)
# - Highlighted cross-section lines (A-A’, B-B’, etc.)
# - EQK area bounding box
# - Color scale bar for time (days since first shock)
# - Conversion of the final plot to multiple formats (PDF, PNG, JPG, TIF)
#
# INPUT FILES:
# - ETOPO_2022_v1_60s_N90W180_bed.tif         : Topography
# - KO_stat_coord.txt / TU_stat_coord.txt / TK_stat_coord.txt : Station coordinates
# - coord_events.txt (or coord_out_events_catal_days.txt)     : Event locations and times
# - Malgar_faults_field[1-4].txt              : Fault traces
# - 1st_shock_TK.txt / 2nd_shock_TK.txt       : Mainshock data (optional for psmeca)
#
# OUTPUT:
# - Map_Event_Stations_time_ok_Davide.ps      : PostScript map
# - GIT_event_stations_turkyie_ok.pdf/png/jpg/tif : Converted map images
#
# DEPENDENCIES:
# - GMT 6.x+
# - awk
# - Ghostscript (`ps2pdf`)
#
# NOTES:
# - Time-based event color scale is defined via an inline CPT (`time_palette.cpt`)
# - Cross-sections A-A’, B-B’, etc. are drawn manually and labeled
# - Faults file paths may need updating if moved from their original directory
# ==============================================================================

####################################################
### DEFINE VARIABLES ###
####################################################

#DEFINE OUTPUT NAME
OUT=Map_Event_Stations_time_ok_Davide.ps

#DEFINE MAP TO PLOT
#TOPO=./ETOPO1_Bed_g_gmt4.grd #Probably Replace this version because it is a bit old
TOPO=ETOPO_2022_v1_60s_N90W180_bed.tif

#GET INFO ABOUT THE MAP
gmt grdinfo $TOPO

#DEFINE REGION TO PLOT [West/East/South/North]
REG=32/44/34/42

#DEFINE PROJECTION
PROJ=-JM15

#DEFINE TICK
TICK=-B2/2WSen

####################################################

#CREATE BASEMAP
gmt psbasemap -R$REG $PROJ $TICK -P -Y12 -K > $OUT

#CREATE TOPOGRAPHIC MAP
#To see the possible color palette, go here:  https://docs.generic-mapping-tools.org/6.2/cookbook/cpts.html
gmt makecpt -Cetopo1 -T-4000/4000/200 -Z > topo.cpt

#CREATE IMAGE
gmt grdimage $TOPO -R$REG -JM15 -O -K -Ctopo.cpt >> $OUT

#BOUNDARIES
gmt pscoast -W0.8 -Na/0.8,black -Df -Lf34/34.5/10/200+lkm -R -JM --FONT_ANNOT_PRIMARY=12p,Helvetica,white --FONT_LABEL=12p,Helvetica,white -K -O >> $OUT

#GMT RIVERS
gmt pscoast -W0.8 -Ia/0,5/150/250 -Df -R -JM -K -O >> $OUT

#GMT LAKES
gmt pscoast -W0.8 -C0/150/250 -Df -R -JM -K -O >> $OUT

# Draw a white box for the legend
echo "4.5 -1.5" > depth_legend_box.txt
echo "8.5 0.5" >> depth_legend_box.txt
gmt psxy -R -J -P -O -K -Gwhite -Wthinner depth_legend_box.txt >> $OUT
rm depth_legend_box.txt

# cat << EOF > time_palette.cpt
# -1500   0/0/255    0       255/255/255
# 0       255/255/255  400    255/0/0
# EOF

# cat << EOF > time_palette.cpt
# -1500   255/255/255   0       255/0/0
# 0       255/0/0       0.01      255/255/0
# 0.01      255/255/0     400     0/255/0
# EOF

#See map_time.cpt
# cat << EOF > time_palette.cpt
# -1500   205/255/162   0     25/175/255
# 0       25/175/255  0.5     255/124/124
# 0.5     255/124/124   400   255/189/87
# EOF

#See map_time.cpt [2nd version]
cat << EOF > time_palette.cpt
-1500   205/255/162   0     13/129/248
0       13/129/248  0.5     255/90/90
0.5     255/90/90   400   255/189/87
EOF

# COLOR LEGEND
# white  # red
# red    # yellow
# yellow # green


#PLOT EVENTS
awk '{print $1,$2,$5,$4/15}' coord_out_events_catal_days.txt | gmt psxy -R -JM15 -Sc -Ctime_palette.cpt -W0.5p,black -P -O -K >> $OUT

#PLOT FAULTS
gmt psxy -R -JM15 -P -O -K -W1.5,yellow /home/leonardo/Desktop/TURKIYE/GMT_Turkiye/Turkyie_Images_OLD/Malgar_faults_field1.txt >> $OUT
gmt psxy -R -JM15 -P -O -K -W1.5,yellow /home/leonardo/Desktop/TURKIYE/GMT_Turkiye/Turkyie_Images_OLD/Malgar_faults_field2.txt >> $OUT
gmt psxy -R -JM15 -P -O -K -W1.5,yellow /home/leonardo/Desktop/TURKIYE/GMT_Turkiye/Turkyie_Images_OLD/Malgar_faults_field3.txt >> $OUT
gmt psxy -R -JM15 -P -O -K -W1.5,yellow /home/leonardo/Desktop/TURKIYE/GMT_Turkiye/Turkyie_Images_OLD/Malgar_faults_field4.txt >> $OUT

#PLOT MECFOC OF THE 2 MAINSHOCKS
#1st SHOCK - 1st_shock_TK.dat
#gmt psmeca 1st_shock_TK.txt -R$REG -JM -Sc0.539c -P -O -K >> $OUT
#2nd SHOCK - 2nd_shock_TK.dat
#gmt psmeca 2nd_shock_TK.txt -R$REG -JM -Sc0.532c -P -O -K >> $OUT

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

#SECTION A-A' [Lon Lat] [Lon Lat]
echo "35.7 36.9" > section_A-A.txt
echo "41.5 39.55" >> section_A-A.txt
gmt psxy section_A-A.txt -R -JM15 -W2p,black -O -K >> $OUT
#LABELS A-A'
echo "35.4 36.76 A" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT
echo "41.5 39.4 A'" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT

#SECTION B-B'
echo "35.1 38.2" > section_B-B.txt
echo "36.5 35.9" >> section_B-B.txt
gmt psxy section_B-B.txt -R -JM15 -W2p,black -O -K >> $OUT
#LABELS B-B'
echo "35.1 38.3 B" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT
echo "36.5 35.6 B'" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT

#SECTION C-C'
echo "37.3 39" > section_C-C.txt
echo "38.3 36.8" >>  section_C-C.txt
gmt psxy section_C-C.txt -R -JM15 -W2p.black -O -K >> $OUT
#LABELS C-C'
echo "37.2 39.1 C" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT
echo "38.2 36.5 C'" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT

#SECTION D-D'
echo "39.1 40.15" > section_D-D.txt
echo "41.8 37.9" >>  section_D-D.txt
gmt psxy section_D-D.txt -R -JM15 -W2p.black -O -K >> $OUT
#LABELS D-D'
echo "39 40.2 D" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT
echo "41.9 37.85 D'" | gmt pstext -R -JM15 -F+f14p,Helvetica-Bold,black+jLB -O -K >> $OUT

gmt psscale -Ctime_palette.cpt -Dx0.4c/-2c+w12c/0.5c+h -Bxaf -By+l"Time (days)" -O >> $OUT

#gmt psscale -Ctime_palette.cpt -Dx1c/-3c+w12c/0.5c+h -Bxa500f500+l"Time (days)"+l400 -By -O >> $OUT

# Convert to PNG, JPG, TIF
gmt psconvert $OUT -Tp -FGIT_event_stations_turkyie_ok
gmt psconvert $OUT -Tj -FGIT_event_stations_turkyie_ok
gmt psconvert $OUT -Tt -FGIT_event_stations_turkyie_ok

#CONVERT PS2PDF
ps2pdf $OUT

#CREATION OF PDF FILE
open  $OUT
