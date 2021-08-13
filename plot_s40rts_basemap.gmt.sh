#! /bin/bash

# Set GMT variables
area=-R-155/-100/30/70
proj=-Jk1:1e8
cpt=/Users/ja17375/Shear_Wave_Splitting/Data/S40RTS.cpt
outfile=/Users/ja17375/Conferences/S40RTS_E_Pac_basemap

psbasemap $proj $area -X4c -Y5c -BWESN -B40 -K  > $outfile.ps 
grdimage $proj $area /Users/ja17375/Shear_Wave_Splitting/Data/S40RTS_2800km.grd -C$cpt -O -K >> $outfile.ps
pscoast $area $proj -Dl -W0.5p -K -O  -A1e4 >> $outfile.ps

ps2pdf $outfile.ps $outfile.pdf
