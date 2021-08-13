#! /bin/bash
################### Program: mk_synth.sh  ######################################
# This is a program to create synthetic split waveforms for a range of
# fast directions and lag times
# Recast (9/1/19) to allow for 2layer synthetics. This works by passing in a fixed "upper" layer
# this is then applied along with the grid of phi, dt operators
################################################################################

# Parse arguement
# expected usage mk_synth.sh -spol 30 -n 0.01 -um 45 1.0
POS=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  -s|-spol)
  SPOL=$2
  shift # past arguement (shift makes arg $2 become arg $1 etc (shifts args along 1))
  shift # past value
  ;;
  -n|-noise)
  NOISE_LVL=$2
  shift
  shift
  ;;
  -um)
  UM_FAST=$2 # phi/dt for upper mantle are optional. If added then 2layer synthetics are generated
  UM_PHI=$3
  shift # past -um flag
  shift # past fast direction
  shift # past dt
  ;;
  *)
  POS+=("$1") # Any extra args
  shift
  ;;
esac
done

if [ -z "$UM_FAST" ]
then
    echo "Upper layer not provided, proceeding to generate 1 layer synthetics"
    out=Synthetics_SP${SPOL}_noise${NOISE_LVL}.events
else
    echo "Upper layer provided, gnerating 2 layer synthetics"
    out=Synthetics_SP${SPOL}_noise${NOISE_LVL}_UFAST_${UM_FAST}_UPHI_${UM_PHI}.events
fi

set -- "${POS[@]}" # restore positional parameters

echo "scale=2;$NOISE_LVL/100" | bc

function call_sacsplitwave {
#    Function to basically call sacsplitwav
    echo $1 $2 $3 $4 $5 $6 #var $5 and $6 are for upper layer if provided
    if [ -z "$5" ]
    then
      sacsplitwave -op $1 $2 -spol $3 -dfreq 0.125 -noise $4
    else
      sacsplitwave -op $1 $2 -op $5 $6 -spol $3 -dfreq 0.125 -noise $4
    fi
    #Use 0.1 for "low noise", 0.25 for "high" noise and now also add "0.05" for "very low"
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

    echo "$fname" | cat >> $out
    let fast+=5
    let k+=1
    done
    fast=-90
    let dt+=25
done
echo "End"
