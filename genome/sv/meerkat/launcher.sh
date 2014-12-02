#!/bin/bash --login


# name=mkt_test
# stderr=$SCRATCH/meerkat/test.stderr
# stdout=$SCRATCH/meerkat/test.stdout
# oarsub -E $stderr -O $stdout -n $name -S "./run_meerkat.sh $SCRATCH/meerkat/test.bam"


for k in 4 #5 #2 5 #4 5 6 7 8 #2
do
    for m in NS #PM #NS PM
    do
	name=mkt_patient_${k}${m}
	# stderr=$SCRATCH/meerkat/patient_${k}_${m}.stderr
	# stdout=$SCRATCH/meerkat/patient_${k}_${m}.stdout
	# input=$SCRATCH/meerkat/patient_${k}_${m}.bam
	OUTDIR=/work/projects/melanomics/analysis/genome/patient_${k}_${m}/sv/meerkat
	mkdir -pv $OUTDIR
	ln -fs $OUTDIR/../../bam/*.bam $OUTDIR/.
	ln -fs $OUTDIR/../../bam/*.bai $OUTDIR/.
	stderr=$OUTDIR/patient_${k}_${m}.stderr
        stdout=$OUTDIR/patient_${k}_${m}.stdout
	input=$OUTDIR/patient_${k}_${m}.bam
	oarsub -E $stderr -O $stdout -n $name -S "./run_meerkat.sh $input"
    done
done




# name=mkt_rna_p2
# stderr=$SCRATCH/rna_melanomics/patient_2.stderr
# stdout=$SCRATCH/rna_melanomics/patient_2.stdout
# oarsub -E $stderr -O $stdout -n $name -S "./run_meerkat.sh $SCRATCH/rna_melanomics/patient_2.bam"

# name=mkt_example
# stderr=$SCRATCH/meerkat/Meerkat.example/bam/example.stderr
# stdout=$SCRATCH/meerkat/Meerkat.example/bam/example.stdout
# oarsub -E $stderr -O $stdout -n $name -S "./run_meerkat.sh $SCRATCH/meerkat/Meerkat.example/bam/example.sorted.bam"

