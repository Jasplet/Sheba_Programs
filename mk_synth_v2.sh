#! /bin/bash
################### Program: mk_synth_v2.sh  ######################################
# This is a program to create synthetic split waveforms for a single fast,dt over a range of noice components
################################################################################

# Parse arguement
SPOL=30
# Make sure we are in the SYNTH directory
#cd ~/Shear_Wave_Splitting/Data/SYNTH/SP${SPOL}
rm /Users/ja17375/Shear_Wave_Splitting/Data/Synthetics_SP30_SNR_range_P3.events
#SNR_range (P1) has fast= -10 dt = 2.0
#SNR_range2 (P2) has fast = 70, dt = 1.5
# For P_match_2 : fast = 70, dt = 1.3
# For P3: fast = 50, dt = 2.5
# For P4: fast = 50, dt = 1.5
# For P5: fast = 60, dt = 1.5
# For P6: fast = 70, st = 2.0

snr=10
k=3001 #Counter so we can give the SWAV files individual names
fstem=`pwd` # File stem
fast=50
lag=2.5
echo 'Fast = ' $fast 'Lag = ' $lag
while [ $snr -lt 1010 ]; do
    echo $snr
    echo "scale=2;$snr/1000" | bc
    sacsplitwave -op $fast $lag -spol 30 -dfreq 0.1 -noise `echo "scale=2;${snr}/1000" | bc `
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
    # sacsethdr nztime 12${snr} SP${SPOL}_${k}001_120000.BH[E,N,Z]

    echo "$fname" | cat >> /Users/ja17375/Shear_Wave_Splitting/Data/Synthetics_SP30_SNR_range_P3.events

    let k+=1
    let snr+=10
done
echo "End"
