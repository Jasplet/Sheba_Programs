#! /bin/bash
############# Program: plot_SKS_SKKS_raw.gmt ############
# This program plots the raw SKS and SKKS
# SKS & SKKS pierce points and plots them on a map using GMT5
# This version assumes that pairs have been classified as matching and discrepent and have been
# seperated into two .pairs files accordingly. If you just want to plot pairs from a single
# .pairs file, use pait_plot.gmt
############# Author: Joseph Asplet ##############
##################################################
############# Required Arguements ################
# Set SNR level
file=$1
path=/Users/ja17375/DiscrePy/Sheba
sks=${path}/Results/${file}/${file}_SKS_sheba_results.sdb
skks=${path}/Results/${file}/${file}_SKKS_sheba_results.sdb
sksXY=${path}/Results/${file}/${file}_SKS_sheba_results.pp
skksXY=${path}/Results/${file}/${file}_SKKS_sheba_results.pp
# Calc SKS, SKKS piercepoints


# Set GMT variables
area=-R0/360/-70/70
proj=-Jk1:2e8
outfile=${path}/Figures/${file}_SKS_SKKS_raw

cpt=/Users/ja17375/DiscrePy/Data/S40RTS.cpt
#Plot the Basemap
psbasemap $proj $area -X4c -Y5c -Bg -BWESN -B40 -K  > $outfile.ps # For global map
#Plot S40RTS at CMB

# grdimage $proj $area /Users/ja17375/DiscrePy/Data/S40RTS_2800km.grd -C$cpt -O -K >> $outfile.ps
#Plot Coastline
#for greyscale use -Ggrey60 -Sgrey75
pscoast $area $proj -Dl -W0.5p -K -Gwhite -Swhite -O -A1e4 >> $outfile.ps
#plot stations
tail -n +2 $sks | awk '{print $7, $6 }' |\
    psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile.ps
tail -n +2 $skks | awk '{print $7, $6 }' |\
    psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile.ps

#plot pierce points of ALL SKS and SKKS phases measured
#
tail -n +2 $sksXY | awk '{print $1, $2 }' |\
    psxy $area $proj -O -K -Sc0.2 -Gblack -W0.2p >> $outfile.ps
tail -n +2 $skksXY | awk '{print $3, $4 }' |\
    psxy $area $proj -O -K -Sd0.2 -Gblack -W0.2p >> $outfile.ps

ps2pdf $outfile.ps $outfile.pdf
open $outfile.pdf
