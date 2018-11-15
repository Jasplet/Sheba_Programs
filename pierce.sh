#! /bin/bash
## First lets make sure that TauP is in our PATH
#export PATH=/Users/ja17375/Ext_programs/TauP/bin:$PATH

## Args
#PHASE=$1 #Phase you want the pierce points for

INFILE=${1} # SDB file that you want the pierce point format
OUTFILE=${1%.*} # Removes infile extension so we can replace it with .pp
DEPTH=2889 # [km] depth we want the pierece point
echo $INFILE
echo $OUTFILE.pp
rm $OUTFILE.pp
#echo $INFILE
rm SKS_tmp
rm SKS_tmp
rm SKS
rm SKKS

function call_taup_pierce {
  #echo $1
  taup_pierce -evt $1 $2 -sta $3 $4 -h $5 -ph $6 -pierce 2889 --nodiscon
}

echo 'dist time depth lat_SKS lon_SKS' > SKS_hdr
echo 'dist time depth lat_SKKS lon_SKKS' > SKKS_hdr

i=1
echo 'STAT EVLA EVLO STLA STLO EVDP' | awk '{print $3,$4,$5,$6,$7,$8}'
while read file; do
    #echo $i
    if [ $i -gt 1 ]
    then
    echo $file | awk '{print $3,$4,$5,$6,$7,$8}'
    call_taup_pierce $(echo $file |  awk  '{print $4, $5, $6, $7, $8}' ) SKS | grep 2889 | tail -1 > SKS_tmp

    call_taup_pierce $(echo $file |  awk  '{print $4, $5, $6, $7, $8}' ) SKKS | grep 2889 | head -3 | tail -1 > SKKS_tmp
    # For a depth of 2800 we get slight less outputs than a depth of 2889 therefore would use head -2 instead of head -3 we use when pierce depth is 2889
    cat SKKS_tmp
    else
    echo 'Skipping Header Line'
    fi
    let i=i+1

    cat SKS_tmp >> SKS
    cat SKKS_tmp >> SKKS

    # awk 'BEGIN{print ">"} {print $5, $4}' SKS_tmp >> $INFILE.mspp
    # awk '{print $5, $4}' SKKS_tmp >> $INFILE.mspp

done < $INFILE




cat SKS_hdr SKS > SKS_pierce.pp
cat SKKS_hdr SKKS > SKKS_pierce.pp

echo $OUTFILE.pp
paste SKS_pierce.pp SKKS_pierce.pp  | awk '{print $5, $4, $10, $9}' > $OUTFILE.pp
#awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$12,$13,$14,$15,$25,$26,$27,$28}' $INFILE > tmp
#paste tmp SKS_SKKS_tmp > SKS_SKKS_pairs.pp

rm SKS_hdr SKKS_hdr
