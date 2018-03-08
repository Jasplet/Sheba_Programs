#! /bin/bash
#Script to tidy to sheba results files
DATA=/Users/ja17375/Shear_Wave_Splitting/Sheba/Results/Sheba_results_$1.temp
OUT=/Users/ja17375/Shear_Wave_Splitting/Sheba/Results/Sheba_$1_$2.sdb
#Header is saved in file /Users/ja17375/Shear_Wave_Splitting/Sheba/final_header
#cat /Users/ja17375/Shear_Wave_Splitting/Sheba/final_header >! $OUT
i=1
for f in /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/*_$1_sheba_results.txt
do
echo $f
tail -n +2 -q $f | awk '{print $0}' >> $DATA
i=$(($i+1))
done
echo 'DATE TIME STAT STLA STLO EVLA EVLO EVDP DIST AZI BAZ FAST DFAST TLAG DTLAG SPOL DSPOL WBEG WEND EIGORIG EIGCORR Q SNR NDF' > hdr
echo $i
cat hdr $DATA > $OUT

rm $DATA
rm hdr
