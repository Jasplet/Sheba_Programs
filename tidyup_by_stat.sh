#! /bin/bash
#Script to tidy to sheba results files for a given Station and Phase


# $1 = Station to tidy up sheba results
# $2 = Phase the has been measured
# $3 = Path to Sheba directory
SPATH=$3
echo 'DATE  TIME    EVLA    EVLO    STLA    STLO    EVDP    DIST     AZI     BAZ    FAST   DFAST    TLAG   DTLAG    SPOL   DSPOL    WBEG    WEND  STAT' > head1
echo 'EIGORIG EIGCORR      Q    SNR    NDF' > head2
#rm -f $3/Stat_$2_results_list.txt

#touch $3/Stat_$2_results_list.txt

if [ ${#1} -eq 3 ]
then
	tail -n +2  -q $SPATH/Sheba/SAC/$1/$2/*.final_result | cut -c-142,144-147 | cat head1 -  > temp1
elif [ ${#1} -eq 4 ]
then
	tail -n +2 -q $SPATH/Sheba/SAC/$1/$2/*.final_result |cut -c-142,144-148 | cat head1 - > temp1
fi

tail -1 -q $SPATH/Sheba/SAC/$1/$2/$1_$2_*_sheba.stats | cut -c13-50 | cat head2 - > temp2


paste temp1 temp2 > temp_result
#cat temp_result
#cat temp_result > $1_$2_sheba_results.txt


awk '{print $1,$2,$19,$5,$6,$3,$4,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$20,$21,$22,$23,$24}' temp_result  > $SPATH/Sheba/Results/$1_$2_sheba_results.txt

#echo $SPATH/Sheba/Results/$1_$2_sheba_results.txt > int
#cat $3/Stat_$2_results_list.txt int  > $3/Stat_$2_results_list.txt

echo $1 $2
## Now to "tidy up" my temp variables
rm temp1 temp2 temp_result head1 head2
