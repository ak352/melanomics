#!/bin/bash --login

for k in 2 4 5 6 7 8
do
    for m in PM NS
    do
	name=mkt_patient_${k}${m}
	stderr=$SCRATCH/meerkat/patient_${k}_${m}.stderr
	stdout=$SCRATCH/meerkat/patient_${k}_${m}.stdout
	oarsub -E $stderr -O $stdout -n $name -S "./run_meerkat.sh $SCRATCH/meerkat/patient_${k}_${m}.bam"
    done
done
