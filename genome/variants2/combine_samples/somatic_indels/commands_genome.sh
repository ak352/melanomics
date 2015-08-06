#!/bin/bash --login
module load lang/Java
#module load pysam
source paths
java=java
sed=sed
GATK=/work/projects/melanomics/tools/gatk/gatk3/
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
BEDTOOLS=/work/projects/melanomics/tools/bedtools/bedtools2/bin/
dict=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.dict
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf
parameters=parameters.in
bcftools=/work/projects/melanomics/tools/samtools/bcftools-1.2/bcftools

#Params file is of the format "<sample-files> <output-file>"
#Each <sample-file> contains lines of the format "<sample-name> <vcf-file> <bam-file>"

rename()
{
    while read line
    do
	set $line
	sample=$1
	infile=$2
	output=${infile%%vcf}renamed.vcf
	tv=${infile%%vcf}testvariants
	grep -P '^#CHROM' $infile | head -n1
	#python add_gt.py $infile $sample $output
	sed "s/TUMOR/$sample/1" $infile > $output
	#grep -P '^#CHROM' $output | head -n1
	
    done < dna_samples.in
}



normalise()
{
    parameters=$1
    while read line
    do
	set $line
	samples_file=$1
	while read line 
	do
	    set $line
	    input=$2
	    output=${input%vcf}norm.vcf.gz

	    cmd="$bcftools norm -f $ref $input -c w -O z > $output"
	    echo $cmd; eval $cmd
	    cmd="$bcftools index -f $output"
	    echo $cmd; eval $cmd
	done < $samples_file
    done < $parameters

}

       
merge_old()
{
    parameters=$1
    while read k
    do
	set $k
	sample_files=$1
	vcf_files=$sample_files.vcf_files.in
	awk '{print $2}' $sample_files > $vcf_files
	output=$2
	cmd="java -Xmx2g -jar $GATK/GenomeAnalysisTK.jar \
	    -T CombineVariants"  

	#Get the pats of VCF files
	while read sample_line
	do
	    set $sample_line
	    vcf=$2
	    #vcf=${vcf%%.vcf}.norm.vcf
	    echo $vcf
            cmd="$cmd --variant:VCF  $vcf"
	done < $sample_files
	cmd="$cmd -o $output -R $ref"

	echo $cmd; eval $cmd
	echo Output written to $output
    done < $parameters
}

merge()
{
    parameters=$1
    while read k
    do
    	set $k
    	sample_files=$1
    	output=$2
	cmd="time $bcftools merge -O z"

    	while read sample_line
    	do
    	    set $sample_line
    	    vcf=$2
    	    vcf=${vcf%.vcf}.norm.vcf.gz
    	    echo $vcf
            cmd="$cmd $vcf"
	    
    	done < $sample_files
	cmd="$cmd > $output"

    	echo $cmd; eval $cmd
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
	    echo sample line = $sample_line
	    output_normal=$2.normal.coverage
	    output_tumor=$2.tumor.coverage
	    sample=$1
	    bam_normal=$3
	    bam_tumor=$4
	    echo Intervals = $intervals 
	    echo Output = $output_normal, $output_tumor
	    echo bam = $bam_normal, $bam_tumor
	    #$BEDTOOLS/coverageBed -split -abam $bam -b $intervals > $output
	    #CMD="oarsub -t bigmem -lcpu=2,walltime=24 -n ${sample}.get_cov \"${BEDTOOLS}/coverageBed -split -abam ${bam_normal} -b ${intervals} > ${output_normal}\""
	    CMD="oarsub  -t besteffort -t bigsmp -p \"for_sgi='YES' AND os='rhel6'\" \
                -lcpu=2,walltime=24 -n ${sample}.get_cov \"${BEDTOOLS}/coverageBed -split -abam ${bam_normal} -b ${intervals} > ${output_normal}\""

	    echo "${CMD}"
	    eval "${CMD}"
	    #CMD="oarsub -t bigmem -lcpu=2,walltime=24 -n ${sample}.get_cov \"${BEDTOOLS}/coverageBed -split -abam ${bam_tumor} -b ${intervals} > ${output_tumor}\""
	    CMD="oarsub  -t besteffort -t bigsmp -p \"for_sgi='YES' AND os='rhel6'\" -lcpu=2,walltime=24 -n ${sample}.get_cov \"${BEDTOOLS}/coverageBed -split -abam ${bam_tumor} -b ${intervals} > ${output_tumor}\""
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
	    for k in normal tumor
	    do
		input=$vcf.$k.coverage
		output=$input.sorted
		echo vcf = $vcf
		echo input = $input
		sed 's/^\([0-9]\t\)/0\1/g' $input \
		    |sort -k1,1 -k2,3n| sed 's/^0//g' \
		    > $output
	    done
	    paste -d "," $vcf.normal.coverage.sorted $vcf.tumor.coverage.sorted > $vcf.coverage.sorted
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


#rename 
#normalise $parameters
#merge $parameters
#get_coverages $parameters
#sort_coverages $parameters
#paste_coverages $parameters
#set_dp $parameters
