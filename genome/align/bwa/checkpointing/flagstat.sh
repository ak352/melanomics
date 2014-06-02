#!/bin/bash --login
module load samtools
MYTMP=$SCRATCH/bwa

for k in $MYTMP/patient_4_PM*recal.bam
do
    oarsub -l/nodes=1/core=2,walltime=72 "echo $k; samtools flagstat $k > ${k%bam}flagstat; "
done; 


k=$MYTMP/patient_4_PM.bam; 
oarsub -l/nodes=1/core=2,walltime=72 "echo $k; samtools flagstat $k  > ${k%bam}flagstat;"
