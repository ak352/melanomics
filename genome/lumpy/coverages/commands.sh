#!/bin/bash --login

status()
{
    d=`date`
    echo [$d] $1
}

out_status()
{
    d=`date`
    echo [$d] Output written to $1
    wc -l $1
}

SCRIPTDIR=/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/
    

# 2. Get mean and standard deviation of coverages
stats()
{
    echo -e ">sample\tmean_coverage\tstdev_coverage\tthreshold"
    while read line
    do
	cov=$line
	sample=${line##*/}
	sample=${sample%.cov}
	stat=`grep genome $cov | awk -F"\t" 'BEGIN{OFS="\t"}{mean+=$2*$5;s=$2*$2*$5;t+=$5;}END{stdev=sqrt(s); print mean, stdev, 2*mean+3*stdev;}'`
	echo -e "$sample\t$stat"
    done  < params_coverage
}

# 3. Create paired-end bam file
pe_bam()
{
    module load SAMtools
    OUTDIR=/work/projects/melanomics/analysis/genome/lumpy_genome/trim/
    while read bam
    do
	out1=${bam##*/}
	out=$OUTDIR/${out1%.bam}.pe.bam
	stdout=$OUTDIR/${out1%.bam}.stdout
	stderr=$OUTDIR/${out1%.bam}.stderr
	oarsub -lcore=2,walltime=24 -n $bam -O $stdout -E $stderr "./run_samtools.sh $bam $out"
    done < params_bam
}
# 4. Create exclude BED file
create_bed()
{
    OUTDIR=/work/projects/melanomics/analysis/genome/lumpy_genome/trim/whole_genome
    while read line
    do
	set $line
	sample=$1
	pe=$OUTDIR/$sample.pe.bam
	se=$OUTDIR/$sample.sr.sort.bam
	exclude=$OUTDIR/$sample.exclude.bed
	threshold=`printf "%.0f" $4`
	stdout=$OUTDIR/$sample.exclude.stdout
	stderr=$OUTDIR/$sample.exclude.stderr
	echo "python $SCRIPTDIR/get_exclude_regions.py $threshold $exclude $pe $se"
	./run_exclude_bed.sh $threshold $exclude $pe $se
	#oarsub -lcore=2,walltime=24 -n $sample -O $stdout -E $stderr "./run_exclude_bed.sh $threshold $exclude $pe $se"
    done < <(sed '1d' coverage_thresholds)
}

# 1. Get the coverages
get_coverages()
{
    INDIR=/work/projects/melanomics/analysis/genome/lumpy_genome/trim/whole_genome
    while read line
    do
	set $line
	pe=$1
	sr=$2
	out=$3
	stdout=$out.stdout
	stderr=$out.stderr
	name=${out##*/}
	name=${name%%.*}
	oarsub -lcore=2,walltime=24 -n $name -O $stdout -E $stderr "./run_get_coverages.sh $pe $sr $out"

    done < params #params2 #params
}


#stats
#pe_bam
#create_bed
#get_coverages
create_bed
