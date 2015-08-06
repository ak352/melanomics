#!/bin/bash --login
module load Java
#module load pysam
source paths
java=java
sed=sed
GATK=/work/projects/melanomics/tools/gatk/gatk3/
#GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
BEDTOOLS=/work/projects/melanomics/tools/bedtools/bedtools2/bin/
dict=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.dict
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf
parameters=params.in

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
	cmd="java -Xmx16g -jar $GATK/GenomeAnalysisTK.jar \
	    -T CombineVariants"  

	#Get the pats of VCF files
	while read sample_line
	do
	    set $sample_line
	    vcf=$2
	    echo $vcf
            cmd="$cmd --variant  $vcf"
	done < $sample_files
	cmd="$cmd -o $output -R $ref \
             --filteredrecordsmergetype KEEP_IF_ANY_UNFILTERED \
             -nt 12"

	echo $cmd

	#stdout=$output.stdout
	#stderr=$output.stderr
	eval $cmd
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
	grep -v ^"#" $input | cut -f1-4 | awk -F"\t" 'BEGIN{OFS="\t"}{print $1,$2-1,$2+length($4)-1;}' > ${intervals}
	echo done.
	#Get coverages
	while read sample_line
	do
	    set $sample_line
	    output=$2.coverage
	    sample=$1
	    bam=$3
	    echo Intervals = $intervals 
	    echo Output = $output
	    echo bam = $bam
	    #$BEDTOOLS/coverageBed -split -abam $bam -b $intervals > $output
	    CMD="oarsub -t bigmem -lcpu=2,walltime=24 -n ${sample}.get_cov \"${BEDTOOLS}/coverageBed -split -abam ${bam} -b ${intervals} > ${output}\""
	    echo "${CMD}"
	    eval "${CMD}"
	done < $sample_file
    done < $parameters
}

sort_coverages()
{
    parameters=$1
    while read param_line
    do
	set $param_line
	sample_file=$1
	echo sample file = $sample_file
	while read sample_line
	do
	    set $sample_line
	    vcf=$2
	    input=$vcf.coverage
	    output=$input.sorted
	    echo vcf = $vcf
	    echo input = $input
	    sed 's/^\([0-9]\t\)/0\1/g' $input \
	    |sort -k1,1 -k2,3n| sed 's/^0//g' \
	    > $output
	done < $sample_file
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
	    sample=$1
	    vcf=$2
	    cut -f4 $vcf.coverage.sorted > $temp$sample
            cmd="$cmd $temp$sample"
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
	input=$2
	output=${input%vcf}coverage_annotated.vcf
	python set_dp.py $merged_vcf > $output 2>$output.stderr
	echo Output written to $output
	echo Standard error output written to $output.stderr
    done < $parameters

}



merge $parameters
#get_coverages $parameters
#sort_coverages $parameters
#paste_coverages $parameters
#set_dp $parameters
