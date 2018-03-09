#! /bin/bash
#Script to tidy to sheba results files for a given Station and Phase


# $1 = Station to tidy up sheba results
# $2 = Phase the has been measured
# $3 = Path to Sheba directory
STAT=$1
PHASE=$2
SPATH=$3
echo 'DATE  TIME  STAT  EVLA    EVLO    STLA    STLO    EVDP    DIST     AZI     BAZ    FAST   DFAST    TLAG   DTLAG    SPOL   DSPOL    WBEG    WEND   EIGORIG    EIGCORR    Q    SNR    NDF' > hdr
#rm -f $3/Stat_$2_results_list.txt

#touch $3/Stat_$2_results_list.txt


tail -n +2 -q $SPATH/Sheba/SAC/$STAT/$PHASE/*.final_result |cut -c-142 | cat  > temp1

tail -1 -q $SPATH/Sheba/SAC/$STAT/$PHASE/$STAT_$PHASE_*_sheba.stats | cut -c13-50 | cat  > temp2



#cat temp_result

paste temp1 temp2 |\
	awk -v stat="$1" '{print $1,$2,stat,$5,$6,$3,$4,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23}' > temp_result

cat hdr temp_result > $SPATH/Sheba/Results/$1_$2_$4.sdb
#echo $SPATH/Sheba/Results/$1_$2_sheba_results.txt > int
#cat $3/Stat_$2_results_list.txt int  > $3/Stat_$2_results_list.txt

echo $1 $2
## Now to "tidy up" my temp variables
rm temp1 temp2 temp_result
