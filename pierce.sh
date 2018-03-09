#! /bin/bash
## First lets make sure that TauP is in our PATH
export PATH=/Users/ja17375/Ext_programs/TauP/bin:$PATH

## Args
#PHASE=$1 #Phase you want the pierce points for

INFILE=$1 # SDB file that you want the pierce point format
DEPTH=2691 # [km] depth we want the pierece point (~ 200km above CMB at 2891km)
rm SKS
rm SKKS
rm SKS_SKKS_pairs.mspp
rm SKS_tmp
rm SKKS_tmp

function call_taup_pierce {
  #echo $3
  taup_pierce -sta $1 $2 -evt $3 $4 -h $5 -ph $6 -pierce 2689 --nodiscon
}

echo 'dist time depth  lat_SKS lon_SKS' > SKS_hdr
echo 'dist time depth lat_SKKS lon_SKKS' > SKKS_hdr

i=1
while read file; do
    #echo $i
    if [ $i -gt 1 ]
    then

    call_taup_pierce $(echo $file |  awk  '{print $4, $5, $6, $7, $8}' ) SKS | grep 2689 | head -1 > SKS_tmp
    #echo SKKS
    call_taup_pierce $(echo $file |  awk  '{print $4, $5, $6, $7, $8}' ) SKKS | grep 2689 | head -1 | tail -2 > SKKS_tmp
    else
    echo 'Skipping Header Line'
    fi
    let i=i+1

    cat SKS_tmp >> SKS
    cat SKKS_tmp >> SKKS

    awk 'BEGIN{print ">"} {print $5, $4}' SKS_tmp >> SKS_SKKS_pairs.mspp
    awk '{print $5, $4}' SKKS_tmp >> SKS_SKKS_pairs.mspp

done < $INFILE



cat SKS_hdr SKS > SKS_pierce.pp
cat SKKS_hdr SKKS > SKKS_pierce.pp


paste SKS_pierce.pp SKKS_pierce.pp  | awk '{print $10, $9, $5, $4}' > SKS_SKKS_tmp
awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$12,$13,$14,$15,$25,$26,$27,$28}' $INFILE > tmp
paste tmp SKS_SKKS_tmp > SKS_SKKS_pairs.pp

rm tmp SKS_SKKS_tmp
