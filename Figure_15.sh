# !/bin/bash
# GIT_Ray_Coverage_1.sh
#Leonardo Colavitti - 18 September 2024

# This script generates FIGURE 15 of the DataPaper published in Earth Science System Data:
# A high-quality data set for seismological studies in the East Anatolian Fault Zone, Türkiye
# by L. Colavitti, D. Bindi, G. Tarchini, D. Scafidi, M. Picozzi and D. Spallarossa

# SUMMARY:
# This script generates a map of seismic ray coverage at 1 Hz for a selected
# region in Turkey. It uses GMT (Generic Mapping Tools) to produce a visual
# representation including:
#
# - Topography background (from ETOPO2022)
# - Ray paths between stations and events
# - Event and station locations
# - Geographical features (coastlines, rivers, lakes)
# - An optional bounding box indicating the earthquake study area
#
# INPUT FILES:
# - cov_events_GMT_1.txt   : coordinates of seismic events
# - cov_stations_GMT_1.txt : coordinates of stations
# - cov_rays_GMT_1.txt     : ray paths (source and receiver coordinates)
# - ETOPO_2022_v1_60s_N90W180_bed.tif : topographic map
#
# OUTPUT:
# - GIT_ray_coverage_1_ok.ps : PostScript map image
# - GIT_ray_coverage_1_ok.pdf : PDF version (converted via ps2pdf)
#
# DEPENDENCIES:
# - GMT (v6+)
# - awk
# - ps2pdf (Ghostscript)
#
# NOTES:
# - The topography file should be updated if a higher-resolution or more
#   recent dataset becomes available.
# - The EQK box is manually defined and can be adjusted as needed.
# ==============================================================================

#FILE TO BE LOADED AND DEFINE INPUT FILES
IN_FILE1="cov_events_GMT_1.txt"
IN_FILE2="cov_stations_GMT_1.txt"
IN_FILE3='cov_rays_GMT_1.txt'

OUT='GIT_ray_coverage_1_ok.ps'

#DEFINE MAP TO PLOT
#TOPO=./ETOPO1_Bed_g_gmt4.grd #Probably Replace this version because it is a bit old
TOPO=ETOPO_2022_v1_60s_N90W180_bed.tif

#DEFINE REGION TO PLOT [West/East/South/North]
REG=33/44/35/42

#DEFINE PROJECTION
PROJ=-JM15

#DEFINE TICK
TICK=-B2/2WSen

####################################################

#CREATE BASEMAP
gmt psbasemap -R$REG $PROJ $TICK -Y4c -K > $OUT

#CREATE IMAGE
gmt grdimage $TOPO -R$REG -JM15 -O -K -Ctopo.cpt >> $OUT

#BOUNDARIES
gmt pscoast -W0.8 -Na/0.8,black -Df -Lf38.5/41.6/10/200+lkm -R -JM --FONT_ANNOT_PRIMARY=12p,Helvetica,white --FONT_LABEL=12p,Helvetica,white -K -O >> $OUT

#RIVERS
gmt pscoast -W0.8 -Ia/0,5/150/250 -Df -R -JM -K -O >> $OUT

#LAKES
gmt pscoast -W0.8 -C0/150/250 -Df -R -JM -K -O >> $OUT

# PLOT RAYS
awk '{print $1, $2}' $IN_FILE3 | gmt psxy -R -J -W0.3p,blue,-. -K -O >> $OUT

# PLOT EVENTS
gmt psxy $IN_FILE1 -R -J -Sc0.125c -Gwhite -Wblack -K -O >> $OUT

# PLOT STATIONS
gmt psxy $IN_FILE2 -R -J -St0.25c -Gred -Wblack -K -O >> $OUT

#PLOT EQK BOX
echo 34.89 35.50 >  box_eqk.dat
echo 42.00 35.50 >> box_eqk.dat
echo 42.00 40.00 >> box_eqk.dat
echo 34.89 40.00 >> box_eqk.dat
echo 34.89 35.50 >> box_eqk.dat
gmt psxy -R -JM15 -P -O -W2.0,red box_eqk.dat >> $OUT
rm box_eqk.dat

#CONVERT PS2PDF
ps2pdf $OUT

#OPEN OUTPUT FILE
#open $OUT
