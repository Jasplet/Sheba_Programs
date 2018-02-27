#! /bin/bash
#Script to tidy to sheba results files
DATA=/Users/ja17375/Shear_Wave_Splitting/Sheba/Results/Sheba_results_$1.temp
OUT=/Users/ja17375/Shear_Wave_Splitting/Sheba/Results/Sheba_$1_results.sdb
#Header is saved in file /Users/ja17375/Shear_Wave_Splitting/Sheba/final_header
#cat /Users/ja17375/Shear_Wave_Splitting/Sheba/final_header >! $OUT

for f in /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/*_$1_sheba_results.txt
do
#echo $f
tail -n +2 -q $f | awk '{print $0}' >> $DATA

done
echo 'DATE TIME STAT STLA STLO EVLA EVLO EVDP DIST AZI BAZ FAST DFAST TLAG DTLAG SPOL DSPOL WBEG WEND EIGORIG EIGCORR Q SNR NDF' > hdr

cat hdr $DATA > $OUT

rm $DATA
rm hdr
