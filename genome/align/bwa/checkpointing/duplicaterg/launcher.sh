# for k in 2 4 5 6 7 8
# do
#     for m in PM NS
#     do
	
# 	bam=$SCRATCH/bwa/patient_${k}_${m}.bam;
# 	name=patient_${k}_${m}
# 	oarsub -n rg_$name -lcore=2,walltime=24 "./duplicate.sh $bam"
#     done
# done

bam=$SCRATCH/bwa/NHEM.bam
name=NHEM
oarsub -n rg_$name -lcore=2,walltime=24 "./duplicate.sh $bam"
