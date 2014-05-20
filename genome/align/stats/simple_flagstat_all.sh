#!/bin/bash --login
module load SAMtools/0.1.18-ictce-5.3.0

for m in sreinsbach akrishna
do
    for k in /scratch/users/$m/bwa/*.lane[0-9].bam
    do
	echo oarsub -lnodes=1 "samtools flagstat $k > $SCRATCH/bwa/${k##*/}.flagstat"
	#oarsub -lnodes=1 "samtools flagstat $k > $SCRATCH/bwa/${k##*/}.flagstat"    
    done
done

