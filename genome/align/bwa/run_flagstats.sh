#!/bin/bash --login

INDIR=$SCRATCH/bwa/
OUTDIR=$SCRATCH/flagstats/
mkdir $OUTDIR

for k in 2 4 5 8
do
    out=$OUTDIR/patient_$k
    rm -rf $out
    oarsub -n patient_$k "./flagstats.sh $INDIR/patient_${k}_NS.bam >> $out "
    oarsub -n patient_${k}_temp "./flagstats.sh $INDIR/patient_${k}_NS.bam.temp >> $out "
done


INDIR=/scratch/users/sreinsbach/bwa/
out=$OUTDIR/NHEM
rm -rf $out
oarsub -n NHEM "./flagstats.sh $INDIR/NHEM.bam >> $out"
oarsub -n NHEM_temp "./flagstats.sh $INDIR/NHEM.bam.temp >> $out"
