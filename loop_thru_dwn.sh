#! /bin/bash
# loop_thru_dwn.sh
#####################
# Loops over downloaded stream files and concatenates them all together
# Author: J.P.R asplet
#####################
path2files=/Users/ja17375/DiscrePy/Data/
outf=ScS_data_downloaded_streams.txt
echo $path2files/$outf
for f in $path2files/ScS_Data/*/*_downloaded_streams_Jacks_ScS.txt
do
# echo $f
cat $f >> $path2files/$outf
done
echo "Ta Dah!"
