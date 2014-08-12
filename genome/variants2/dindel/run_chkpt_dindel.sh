#!/bin/bash --login

# for k in NHEM
# do
#     OUTDIR=$SCRATCH/dindel_genome
#     stderr=$OUTDIR/$k.stderr
#     stdout=$OUTDIR/$k.stdout
#     context=$OUTDIR/$k.context
#     oarsub -O $stdout -E $stderr -n dindel_$k -S "./chkpt_dindel.sh $k 1 $context"
# done


while read k
do
    OUTDIR=$SCRATCH/dindel_genome
    stderr=$OUTDIR/$k.stderr
    stdout=$OUTDIR/$k.stdout
    context=$OUTDIR/$k.context
    oarsub -O $stdout -E $stderr -n ${k#patient_} -S "./chkpt_dindel.sh $k 1 $context"
done < patients2


