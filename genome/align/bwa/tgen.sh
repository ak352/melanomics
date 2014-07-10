#!/bin/bash --login
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf


realign()
{
    sample=$1
    typename=$2
    if [ $typename ]
	then
	INDIR=/work/projects/melanomics/data/rawdata/Susanne/$sample/alignments_bams/$typename/
	OUTDIR=/work/projects/melanomics/analysis/genome/tgen/${sample}_${typename}/
	else
	INDIR=/work/projects/melanomics/data/rawdata/Susanne/$sample/alignments_bams/
	OUTDIR=/work/projects/melanomics/analysis/genome/tgen/${sample}/
    fi
    echo $INDIR
    echo $OUTDIR
    mkdir -pv $OUTDIR
    for k in $INDIR/*.prmdup.bam
    do
        input=$k
	output=${k%bam}
        output=$OUTDIR/${output##*/}realn.bam
        intervals=${output%bam}intervals
	stderr=${output%bam}stderr
	stdout=${output%bam}stdout
	# ./run_realignment.sh $input $ref $output $intervals
        oarsub -lcore=2,walltime=24 -tbigsmp -n ${sample}_${typename} -O $stdout -E $stderr "./run_realignment.sh $input $ref $output $intervals"
    done
}

recalibrate()
{
    sample=$1
    typename=$2
    INDIR=/work/projects/melanomics/analysis/tgen/${sample}_$typename/
    OUTDIR=/work/projects/melanomics/analysis/genome/tgen/${sample}_$typename/
    mkdir -pv $OUTDIR
    for k in $INDIR/*.realn.bam
    do
        input=$k
        output=${k%bam}recal.bam
        grp=${output%.bam}.grp
	stderr=${output%bam}stderr
	stdout=${output%bam}stdout
        oarsub -lcore=2,walltime=24 -n ${sample}_$typename -O $stdout -E $stderr "./run_recalibrate.sh $input $ref $dbsnp $output $grp"
    done

}

# for x in 6 #2 3 4 5 6 7
# do
#     for m in PM NS
#     do
# 	realign sample_$x $m
#     done
# done

realign sample_NHEM





