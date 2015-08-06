#!/bin/bash --login

for k in patient_7_PM #patient_8_PM patient_4_PM
do
    name=$k.fasd
    stdout=$SCRATCH/fasd_genome/$k.fasd.stdout
    stderr=$SCRATCH/fasd_genome/$k.fasd.stderr
    oarsub -n $name -O $stdout -E $stderr -S "./run_snp_fasd.sh $k"
done

