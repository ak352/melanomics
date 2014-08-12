#!/bin/bash --login
module load Java
module load pipeline
module load pysam
java=java
sed=sed
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
BEDTOOLS=/work/projects/melanomics/tools/bedtools/bedtools2/bin/
dict=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.dict
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf
parameters=parameters.in

#Params file is of the format "<sample-files> <output-file>"
#Each <sample-file> contains lines of the format "<sample-name> <vcf-file> <bam-file>"

merge()
{
    parameters=$1
    while read k
    do
	set $k
	sample_files=$1
	vcf_files=$sample_files.vcf_files.in
	awk '{print $2}' $sample_files > $vcf_files
	output=$2
	python pipeline.py -vc --ignore-source -g $GATK/GenomeAnalysisTK.jar -r $ref -d $dict --list-of-vcf ${vcf_files} -o $output
	echo Output written to $output
    done < $parameters
}

get_coverages()
{
    parameters=$1
    while read param_line
    do
	set $param_line
	sample_file=$1
	input=$2
	intervals=$input.intervals
	echo Getting intervals...
	grep -v ^"#" $input | cut -f1-4 | awk -F"\t" 'BEGIN{OFS="\t"}{print $1,$2-1,$2+length($4)-1;}' > $intervals
	echo done.
	#Get coverages
	while read sample_line
	do
	    set $sample_line
	    output=$2.coverage
	    bam=$3
	    echo Intervals = $intervals 
	    echo Output = $output
	    echo bam = $bam
	    echo "$BEDTOOLS/coverageBed -split -abam $bam -b $intervals > $output" 
	    $BEDTOOLS/coverageBed -split -abam $bam -b $intervals > $output
	    #oarsub -lcore=2,walltime=8 "$BEDTOOLS/coverageBed -split -abam $bam -b $intervals > $output"
	done < $sample_file
    done < $parameters
}

sort_coverages()
{
    parameters=$1
    while read param_line
    do
	set $param_line
	sample_files=$2
	while read sample_line
	do
	    set $sample_line
	    input=$2.coverage
	    output=$input.sorted
	    sed 's/^\([0-9]\t\)/0\1/g' $input \
	    |sort -k1,1 -k2,3n| sed 's/^0//g' \
	    > $output
	done < $sample_files
    done < $parameters
}

paste_coverages()
{
    parameters=$1
    while read k
    do
	set $k
	input=$2
	output=$2.coverages
	temp=/tmp/
	sample_file=$1
	while read sample_line
	do
	    set $sample_line
	    cut -f4 $2.coverage.sorted > $temp$k
            cmd="$cmd $temp$k"
	done < $sample_file
	(grep ^"#" $input; paste <( grep -v ^"#" $input | sed 's/^\([0-9]\t\)/0\1/g'| sort -k1,1 -k2,3n| sed 's/^0//g'  )  $cmd;) > $output
    done < $parameters
}

set_dp()
{
    parameters=$1
    while read k
    do
	set $k
	merged_vcf=$2.coverages
	input=$merged_vcf
	output=${merged_vcf%vcf}annotated.vcf
	python set_dp.py $input > $output
    done < $parameters
}



#merge $parameters
get_coverages $parameters
#sort_coverages $parameters
#paste_coverages $parameters
#set_dp $parameters