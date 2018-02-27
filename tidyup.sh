#! /bin/bash
#Script to tidy to sheba results files
DATA=/Users/ja17375/Shear_Wave_Splitting/Sheba/Results/Sheba_results_$1.temp
#Header is saved in file /Users/ja17375/Shear_Wave_Splitting/Sheba/final_header
#cat /Users/ja17375/Shear_Wave_Splitting/Sheba/final_header >! $OUT 

for f in /Users/ja17375/Shear_Wave_Splitting/Sheba/Results/*_$1_sheba_results.txt
do
tail -n +2  -q $f` > $DATA

done
