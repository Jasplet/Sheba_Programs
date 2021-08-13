#! /bin/bash
############# Program: midpoint_calc.sh ############
# Short script to calculate the midpoints between SKS and SKKS piercepoints (for any .pairs file)
####################################################
path=/Users/ja17375/Shear_Wave_Splitting/Sheba/E_pacific
rm SKS.yx
rm SKKS.yx
#Make SKS file
# awk 'NR>1 {print $42, $43}' E_pacific_05_matches_l2.pairs > SKS.yx
awk 'NR>1 {print $42, $43}' E_pacific_05_diffs_l2.pairs >> SKS.yx
awk 'NR>1 {print $42, $43}' E_pacific_05_diffs_null_split.pairs >> SKS.yx
# #Make SKKS file
# awk 'NR>1 {print $44, $45}' E_pacific_05_matches_l2.pairs > SKKS.yx
awk 'NR>1 {print $44, $45}' E_pacific_05_diffs_l2.pairs >> SKKS.yx
awk 'NR>1 {print $44, $45}' E_pacific_05_diffs_null_split.pairs >> SKKS.yx

SKSfile="SKS.yx"
SKKSfile="SKKS.yx"
cat /dev/null > SKS_SKKS_mid_diff.yx # Makes a balnk file we can append to later
i=0
while read -r line
do
  let i++
  SKSLoc=$line
  SKKSLoc=`head -$i $SKKSfile | tail -1`
  geogeom M $SKSLoc $SKKSLoc q | awk '{print $1,$2}' >> SKS_SKKS_mid_diff.yx

done < $SKSfile # File to read in loop is put in at the end for ,..... reasons

#EOF
