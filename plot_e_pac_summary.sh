#! /bin/bash
############# Program: Pair_plot_splits.gmt ############
# This program takes a .pairs file  (implicitly containing SKS SKKS pairs) and their corresponding
# SKS & SKKS pierce points and plots them on a map using GMT5
# This version assumes that pairs have been classified as matching and discrepent and have been
# seperated into two .pairs files accordingly.
# This version is for making a summary figures:
#  A. An example of the classification types (one pair) and the geometery
#  B. A plot where the pairs are collapsed to the midpoint
############# Author: Joseph Asplet ##############
##################################################
############# Required Arguements ################
# Set SNR level
snr=05
file=E_pacific
# Set GMT variables
area=-R120/300/-30/60
proj=-Jk1:1e8
cpt=/Users/ja17375/Shear_Wave_Splitting/Data/S40RTS.cpt
# area=-R-170/-80/10/65
# proj=-Jm1:5.5e7
outfile=/Users/ja17375/Presentations/Figs/Summary_Map_tomo
# outfile=/Users/ja17375/Thesis/Lambda2_Paper/Figs/Summary_Map
outfile2=/Users/ja17375/Presentations/Figs/East_Pacific_results_summary

#Plot the Basemap
psbasemap $proj $area -X4c -Y5c -BWESN -B40 -K  > $outfile.ps # For global map
# psbasemap $proj $area -X5c -Y3.5c  -BWESN -B10 -K > $outfile.ps # For Zoomin
#Plot S40RTS at CMB
# grdimage $proj $area /Users/ja17375/Shear_Wave_Splitting/Data/Walker_models/TX2008.V2.P010.grd -C$cpt -O -K >> $outfile.ps
grdimage $proj $area /Users/ja17375/Shear_Wave_Splitting/Data/S40RTS_2800km.grd -C$cpt -O -K >> $outfile.ps
# add scale
# psscale -Dx10c/-1c+w10c/0.5c+jTC+h+e -C$cpt -O -K -Ba1f0.5g0.25+l"dVs (%)" >> $outfile.ps

#Plot Coastline
#for greyscale use -Ggrey60 -Sgrey75
# pscoast $area $proj -Dl -W0.5p -Golivedrab -Scadetblue1 -N1 -K -O -A1e4 >> $outfile.ps
pscoast $area $proj -Dl -W0.5p -K -O  -A1e4 >> $outfile.ps
 #Plot outline of Falleron slab from model of Lithgow-Bertelloni and Richards (1998)

#Plot a single station (examples) - NOW PLOT ALL STATIONS 'head -1' removed
 tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | awk '{print $7, $6 }' |\
     psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile.ps
 tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | awk '{print $7, $6 }' |\
     psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile.ps
 tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | awk '{print $7, $6 }' |\
     psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile.ps
#Plot events - NOW PLOT ALL EVENTS 'head -1' removed
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs |  awk '{print $5, $4 }' |\
    psxy $area $proj -O -K -Sa0.3 -Gblack -W0.2p >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs |  awk '{print $5, $4 }' |\
    psxy $area $proj -O -K -Sa0.3 -Gblack -W0.2p >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | awk '{print $5, $4 }' |\
    psxy $area $proj -O -K -Sa0.3 -Gblack -W0.2p >> $outfile.ps
############################
# Draw lines adjoining events and station (approx raypath?)
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | head -2 | awk '{print ">\n"$7, $6"\n"$5,$4}' |\
    psxy $area $proj -O -K -W0.5p >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | head -2 | awk '{print ">\n"$7, $6"\n"$5,$4}' |\
    psxy $area $proj -O -K -W0.5p >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | head -2 | awk '{print ">\n"$7, $6"\n"$5,$4}' |\
    psxy $area $proj -O -K -W0.5p>> $outfile.ps

tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.mspp | head -1 |\
    psxy $area $proj -O -K -W2p,green >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.mspp | head -1 |\
    psxy $area $proj -O -K -W2p,green >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.mspp | head -1 |\
    psxy $area $proj -O -K -W2p,black >> $outfile.ps


# Plot SKS, SKKS piercepoints
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | head -1 |  awk '{print $43, $42}' |\
   psxy $area $proj -O -K -Sc0.3 -Ggreen -W0.25p,black >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | head -1 | awk '{print $45,$44}' |\
   psxy $area $proj -O -K -Sd0.3 -Ggreen -W0.25p,black >> $outfile.ps
# Plot SKS, SKKS piercepoint - Diffs
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | head -1 | awk '{print $43, $42}' |\
   psxy $area $proj -O -K -Sc0.3 -Gblack -W0.25p,black   >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | head -1 | awk '{print $45,$44}' |\
   psxy $area $proj -O -K -Sd0.3 -Gblack -W0.25p,black >> $outfile.ps
# Plot SKS, SKKS piercepoint - Null-Split (Null is SKKS in the example)
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | head -1 | awk '{print $43, $42}' |\
  psxy $area $proj -O -K -Sc0.3 -Ggreen -W0.25p,black   >> $outfile.ps
tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | head -1 | awk '{print $45,$44}' |\
  psxy $area $proj -O -K -Sd0.3 -Gwhite -W0.25p,black >> $outfile.ps

# Make a legend

#Paper Version
###################################
# echo " -160 -25" | psxy $area $proj -O -K -W0.25,black -Sc0.3 -Gwhite >> $outfile.ps
# echo " -151.5 -25 SKS" | pstext $area $proj -O -K -N >> $outfile.ps
# echo "-140 -25" | psxy $area $proj -O -K -W0.25,black -Sd0.3 -Gwhite >> $outfile.ps
# echo "-131 -25 SKKS" | pstext $area $proj -O -K -N >> $outfile.ps
# echo " -160 -20" | psxy $area $proj -O -K -W0.25,black -Sa0.3 -Gblack >> $outfile.ps
# echo " -151.5 -20 Event" | pstext $area $proj -O -K -N >> $outfile.ps
# echo "-140 -20" | psxy $area $proj -O -K -W0.25,black -Si0.3 -Gred >> $outfile.ps
# echo " -131 -20 Station" | pstext $area $proj -O -K -N >> $outfile.ps
###########################################
# Presentations Legend version
echo ">
      -175 -20
      -155 -20
      " | psxy $area $proj -O -K -W2p,green >> $outfile.ps

echo "-175 -20" | psxy $area $proj -O -K -W0.25,black -Sc0.3 -Ggreen >> $outfile.ps
echo "-155 -20" | psxy $area $proj -O -K -W0.25,black -Sd0.3 -Ggreen >> $outfile.ps
echo "-127 -20 Discrepant SKS - SKKS pair" | pstext $area $proj -O -K -N >> $outfile.ps

echo ">
      -175 -25
      -155 -25
      " | psxy $area $proj -O -K -W2p,black>> $outfile.ps

echo "-175 -25" | psxy $area $proj -O -K -W0.25,black -Sc0.3 -Gblack >> $outfile.ps
echo "-155 -25" | psxy $area $proj -O -K -W0.25,black -Sd0.3 -Gblack >> $outfile.ps
echo "-127 -25 Matching SKS - SKKS pair" | pstext $area $proj -O -K -N >> $outfile.ps

echo " -175 -10" | psxy $area $proj -O -K -W0.25,black -Sc0.3 -Ggreen >> $outfile.ps
echo " -165 -10 SKS" | pstext $area $proj -O -K -N >> $outfile.ps
echo "-175 -15" | psxy $area $proj -O -K -W0.25,black -Sd0.3 -Ggreen >> $outfile.ps
echo "-165 -15 SKKS" | pstext $area $proj -O -K -N >> $outfile.ps

echo " -155 -10" | psxy $area $proj -O -K -W0.25,black -Sc0.3 -Gwhite >> $outfile.ps
echo " -137 -10 Null SKS" | pstext $area $proj -O -K -N >> $outfile.ps
echo "-155 -15" | psxy $area $proj -O -K -W0.25,black -Sd0.3 -Gwhite >> $outfile.ps
echo " -137 -15 Null SKKS" | pstext $area $proj -O -K -N >> $outfile.ps

echo " -175 -5" | psxy $area $proj -O -K -W0.25,black -Sa0.3 -Gblack >> $outfile.ps
echo " -165 -5 Event" | pstext $area $proj -O -K -N >> $outfile.ps
echo "-155 -5" | psxy $area $proj -O -K -W0.25,black -Si0.3 -Gred >> $outfile.ps
echo " -137 -5 Station" | pstext $area $proj -O -K -N >> $outfile.ps

#################### Calculate Midpoints


#################### Make second map (summary of results onto midpoints)

area=-R-170/-80/10/65
proj=-Jm1:5.5e7
diff=green
match=black
null=white

psbasemap $proj $area -X4c -Y3c -BWESN -B10 -K  > $outfile2.ps
grdimage $proj $area /Users/ja17375/Shear_Wave_Splitting/Data/S40RTS_2800km.grd -C$cpt -O -K >> $outfile2.ps
pscoast $area $proj -Dl -W0.5p -K -O -A1e4 >> $outfile2.ps
#Plot stations
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | awk '{print $7, $6 }' |\
#     psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile2.ps
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | awk '{print $7, $6 }' |\
#     psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile2.ps
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | awk '{print $7, $6 }' |\
#     psxy $area $proj -O -K -Si0.3 -Gred -W0.2p >> $outfile2.ps
# #Plot events
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | awk '{print $5, $4 }' |\
#    psxy $area $proj -O -K -Sa0.3 -Gblack -W0.2p >> $outfile2.ps
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | awk '{print $5, $4 }' |\
#    psxy $area $proj -O -K -Sa0.3 -Gblack -W0.2p >> $outfile2.ps
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | awk '{print $5, $4 }' |\
#    psxy $area $proj -O -K -Sa0.3 -Gblack -W0.2p >> $outfile2.ps
############################
# # Draw lines adjoining events and station (approx raypath?)
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | head -1 | awk '{print ">\n"$7, $6"\n"$5,$4}' |\
#    psxy $area $proj -O -K -W0.5p >> $outfile2.ps
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | head -1 | awk '{print ">\n"$7, $6"\n"$5,$4}' |\
#    psxy $area $proj -O -K -W0.5p >> $outfile2.ps
# tail -n +2 /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | head -1 | awk '{print ">\n"$7, $6"\n"$5,$4}' |\
#    psxy $area $proj -O -K -W0.5p >> $outfile2.ps

# awk '{print $2, $1 }' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/SKS_SKKS_mid_match.yx

# awk '{print $2, $1 }' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/SKS_SKKS_mid_match.yx  |\
#    psxy $area $proj -O -K -Sc0.3 -Gblack -W0.5p,black >> $outfile2.ps
# awk '{print $2, $1 }' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/SKS_SKKS_mid_diff.yx  |\
#    psxy $area $proj -O -K -Sc0.3 -Ggreen -W0.5p,black >> $outfile2.ps
#Connect SKS-SKKS pairs
psxy $area $proj -O -K -W0.5p,${match} < /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.mspp >> $outfile2.ps
psxy $area $proj -O -K -W0.75p,${diff} < /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.mspp >> $outfile2.ps
psxy $area $proj -O -K -W0.75p,${diff} < /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.mspp >> $outfile2.ps

awk '{if ($22 > 0.5) print $43, $42}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | psxy $area $proj -O -K -Sc0.25 -G${diff} -W0.25p,black   >> $outfile2.ps
awk '{if ($22 < -0.7) print $43, $42}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | psxy $area $proj -O -K -Sc0.25 -G${null} -W0.25p,black   >> $outfile2.ps
awk '{if ($37 > 0.5) print $45,$44}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | psxy $area $proj -O -K -Sd0.25 -G${diff} -W0.25p,black >> $outfile2.ps
awk '{if ($37 < -0.7) print $45,$44}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_null_split.pairs | psxy $area $proj -O -K -Sd0.25 -G${null} -W0.25p,black >> $outfile2.ps

# Plot Circles centered on SKS, SKKS pierce points (Standard for this sort of plot) - Matches
awk '{print $43, $42}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | psxy $area $proj -O -K -Sc0.25 -G${match} -W0.25p,black >> $outfile2.ps
awk '{print $45,$44}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_matches_l2.pairs | psxy $area $proj -O -K -Sd0.25 -G${match} -W0.25p,black >> $outfile2.ps
# Plot Circles centered on SKS, SKKS pierce points (Standard for this sort of plot) - Diffs
awk '{print $43, $42}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | psxy $area $proj -O -K -Sc0.25 -G${diff} -W0.25p,black   >> $outfile2.ps
awk '{print $45,$44}' /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/${file}/${file}_${snr}_diffs_l2.pairs | psxy $area $proj -O -K -Sd0.25 -G${diff} -W0.25p,black >> $outfile2.ps



ps2pdf $outfile.ps $outfile.pdf
ps2pdf $outfile2.ps $outfile2.pdf
# open $outfile.pdf
open $outfile2.pdf
