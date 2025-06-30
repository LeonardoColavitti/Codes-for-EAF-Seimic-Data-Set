#!/bin/zsh
# section_BB-time.zsh
# Leonardo Colavitti - 01 March 2025

# This script generates FIGURE 14C of the DataPaper published in Earth Science System Data:
# A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
# by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa

# SUMMARY:
#   This script generates a vertical seismic cross-section (1:1 aspect ratio)
#   along a user-defined profile between two geographic coordinates:
#     - Point A:   35.1 38.2
#     - Point A':  36.5 35.9
#
#   Earthquake events are projected onto the section within ±$spes km and
#   plotted with color-coded symbols representing event times (in days),
#   using GMT (Generic Mapping Tools).
#
# Features :
#   - Fixed vertical height in cm (defined by variable `valt`)
#   - Maximum depth (`vprof`) customizable
#   - Events colored according to a custom time color palette
#   - Scaled to preserve a 1:1 ratio between depth and horizontal distance
#   - Automatically adds section labels A and A' at the ends
#
# Requirements :
#   - GMT installed (version ≥ 6 recommended)
#   - Input file: coord_out_events_catal_days.txt
#     (columns: lon lat depth time magnitude)
#   - Optional topography file defined but not used: ETOPO1_Bed_g_int.xyz
#
# Output :
#   - PostScript file: section_AA-time.ps
#
# Usage :
#   $ ./section_BB-time.zsh
#
# Notes :
#   - Customize the color palette in `time_palette.cpt` as needed
#   - Final output is opened automatically using `okular`
#
################################################################################

zmodload zsh/mathfunc

gmt set PAGE_ORIENTATION = landscape
gmt set FONT_LABEL 50p,Helvetica-Bold  # Ingrandisce e rende in grassetto le etichette degli assi
gmt set FONT_ANNOT_PRIMARY 50p         # Dimensione dei numeri sui tick degli assi
gmt set FONT_TICK 50p                  # Dimensione dei numeri delle tacche
gmt set MAP_FRAME_WIDTH 0.5p
gmt set MAP_TICK_LENGTH 5p
gmt set MAP_LABEL_OFFSET 1.2c
gmt set MAP_ANNOT_OFFSET_PRIMARY 1.2c

spes=10    # Offset Cross-Section (+/-)
valt=14.8 # Height of the cross-section in the paper - Height=20 if vprof=50 and if if [[ $dist -le 50.0 ]]

#DEFINE OUTPUT NAME
OUT=section_BB-time.ps

rm $OUT

############################################à

#DEFINE MAP TO PLOT
TOPO=ETOPO1_Bed_g_int.xyz

#EARTH RADIUS
R=6371

pi=3.14159

EQK="coord_out_events_catal_days.txt"

############################################à

echo '-------------------------------------------------------------------------------'
echo 'Script per plottare eventi in sezione di qualsiasi lunghezza e profondita (1:1)'
echo 'con ALTEZZA della sezione fissata !'
echo 'Settato per proiettare gli eventi in sezione a +/-  '$spes'km'
echo '-------------------------------------------------------------------------------'

# Choose your cross-section [Lon-Lat Lon-Lat]
echo "35.1 38.2" |read VL1 VL2
echo "36.5 35.9" |read VL3 VL4

#echo 'Inserisci profondita' sezione (es: 50.0): '
#read vprof
vprof="40.0"
echo $VL1 $VL2 $VL3 $VL4 $vprof $valt

(( MINLON1=$VL1*(2*pi)/360 ))
(( MINLAT1=$VL2*(2*pi)/360 ))
(( MAXLON1=$VL3*(2*pi)/360 ))
(( MAXLAT1=$VL4*(2*pi)/360 ))
(( dist=acos(sin($MINLAT1)*sin($MAXLAT1)+cos($MINLAT1)*cos($MAXLAT1)*cos($MAXLON1-$MINLON1))*$R ))
echo 'Lunghezza sezione (km): ' $dist

# settaggio label del plot in base alla lunghezza della sezione
if [[ $dist -le 40.0 ]];then
  vb=20
  vb1=a10f5
else
  vb=20
  vb1=a10f5
fi
# fine calcolo lunghezza

# calcolo del rapporto 1:1 per -JX in sezione in base alla lunghezza e alla profondita'
(( vx=0.5*($valt*$dist)/$vprof ))
echo 'Altezza sezione settata su '$valt'cm; lunghezza in cm calcolata (1:1) per sezione: ' $vx
echo '---------------------------------------------------------------------------------------------------'
# fine calcolo rapporto

#cat << EOF > time_palette.cpt
#-1500   0/0/255    0       255/255/255
#0       255/255/255  400    255/0/0
#EOF

# cat << EOF > time_palette.cpt
# -1500   255/255/255   0       255/0/0
# 0       255/0/0       30      255/255/0
# 30      255/255/0     400     0/255/0
# EOF

#See map_time.cpt [2nd version]
cat << EOF > time_palette.cpt
-1500   205/255/162   0     13/129/248
0       13/129/248  0.5     255/90/90
0.5     255/90/90   400   255/189/87
EOF

awk '{print $1, $2, -$3, $5, $4*0.2}' $EQK | gmt project -C$VL1/$VL2 -E$VL3/$VL4 -Fpz -W-$spes/$spes -V -Lw -Q > selected_AA-time.txt

#awk '{print $1, $2, -$3, $5, $4*0.2}' $EQK | sort -k4,4n | gmt project -C$VL1/$VL2 -E$VL3/$VL4 -Fpz -W-$spes/$spes -V -Lw -Q | gmt psxy -R0/$dist/-$vprof/0 -JX$vx/$valt -Bxa40g20+l"Distance along section (km)" -Bya10g5+l"Depth (km)" -BWSne -W0.5p,black -Sc -Ctime_palette.cpt -X8 -Y15 -K > $OUT

# Plot degli eventi
awk '{print $1, $2, -$3, $5, $4*0.2}' $EQK | sort -k4,4n | gmt project -C$VL1/$VL2 -E$VL3/$VL4 -Fpz -W-$spes/$spes -V -Lw -Q | gmt psxy -R0/$dist/-$vprof/0 -JX$vx/$valt -Bxa40g20+l"Distance along section (km)" -Bya10g5+l"Depth (km)" -BWSne -W0.5p,black -Sc -Ctime_palette.cpt -X8 -Y15 -K > $OUT

# Aggiunta delle etichette A e A' con un piccolo spostamento
echo "0 -1 B" | gmt pstext -R0/$dist/-$vprof/5 -JX$vx/$valt -F+f50p,Helvetica-Bold,black+jLT -Dj-1c/-4c -O -K -N >> $OUT
echo "$dist -1 B'" | gmt pstext -R0/$dist/-$vprof/5 -JX$vx/$valt -F+f50p,Helvetica-Bold,black+jRT -Dj-1c/-4c -O -N >> $OUT

# gmt psscale -Ctime_palette.cpt -Dx8c/-6c+w22c/1.5c+h -Bxaf -By+l"Time (days)" -O >> $OUT

#Open $OUT file
okular $OUT
