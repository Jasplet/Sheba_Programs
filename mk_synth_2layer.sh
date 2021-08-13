#! /bin/bash
################### Program: mk_synth_2layer.sh  ######################################
# This is a program to create synthetic split waveforms for a range of
# fast directions and lag times
################################################################################

# Parse arguement
SPOL=$1
NOISE_LVL=$2
# Make sure we are in the SYNTH directory. Directorys need to me created in advance
cd ~/Shear_Wave_Splitting/Data/SYNTH/SP${SPOL}/Noise${NOISE_LVL}
rm /Users/ja17375/Shear_Wave_Splitting/Data/SP${SPOL}/Noise${NOISE_LVL}/Synthetics_SP${SPOL}.events
function call_sacsplitwave {
#    Function to basically call sacsplitwav
    echo $1 $2 $3 $4
    sacsplitwave -op $1 $2 -spol $3 -dfreq 0.1 -noise $4 #Use 0.1 for "low noise", 0.25 for "high" noise and now also add "0.05" for "very low"

}

fast=-90
dt=0
k=3001 #Counter so we can give the SWAV files individual names
fstem=`pwd` # File stem
# echo $fast
while [ $dt -lt 401 ]; do

    # echo "$dt/10" | bc -l

    while [ $fast -lt 91 ]; do

    call_sacsplitwave  $fast `echo "scale=2;$dt/100" | bc ` $SPOL `echo "scale=2;$NOISE_LVL/100" | bc `
    # Modify Filenamesd
    mv SWAV.BHE SP${SPOL}_${k}001_120000.BHE
    mv SWAV.BHN SP${SPOL}_${k}001_120000.BHN
    mv SWAV.BHZ SP${SPOL}_${k}001_120000.BHZ
    fname=$fstem/SP${SPOL}_${k}001_120000
    echo $fname
    # Alter station name, Date
    # echo 'stat'
    sacsethdr kstnm SP${SPOL} SP${SPOL}_${k}001_120000.BH[E,N,Z]
    # echo 'year'
    sacsethdr nzyear $k SP${SPOL}_${k}001_120000.BH[E,N,Z]
    sacsethdr user7 `echo "scale=2;$dt/100" | bc -l` SP${SPOL}_${k}001_120000.BH[E,N,Z]
    sacsethdr user8 $fast  SP${SPOL}_${k}001_120000.BH[E,N,Z]


#     if [ $fast -lt 0 ]
#     then
#       # echo "${fast} lt 0 "
#       mv SWAV.BHE SWAV_${dt}_N${fast#-}.BHE
# q      mv SWAV.BHN SWAV_${dt}_N${fast#-}.BHN
#       mv SWAV.BHZ SWAV_${dt}_N${fast#-}.BHZ
#       fname=$fstem/SWAV_${dt}_N${fast#-}
#     else
#       # echo "$fast gt 0"
#       mv SWAV.BHE SWAV_${dt}_${fast}.BHE
#       mv SWAV.BHN SWAV_${dt}_${fast}.BHN
#       mv SWAV.BHZ SWAV_${dt}_${fast}.BHZ
#       fname=$fstem/SWAV_${dt}_${fast}
#     fi
    # Create a file file

    echo "$fname" | cat >> /Users/ja17375/Shear_Wave_Splitting/Data/SYNTH/SP${SPOL}/Noise${NOISE_LVL}/Synthetics_SP${SPOL}_noise${NOISE_LVL}.events
    let fast+=5
    let k+=1
    done
    fast=-90
    let dt+=25
done
echo "End"
