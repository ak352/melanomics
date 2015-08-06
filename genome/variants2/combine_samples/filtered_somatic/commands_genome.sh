#!/bin/bash --login
module load Java
#module load pysam
source paths
java=java
sed=sed
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
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
	cmd="java -Xmx2g -jar $GATK/GenomeAnalysisTK.jar \
	    -T CombineVariants"  

	#Get the pats of VCF files
	while read sample_line
	do
	    set $sample_line
	    vcf=$2
	    echo $vcf
            cmd="$cmd --variant:VCF  $vcf"
	done < $sample_files
	cmd="$cmd -o $output -R $ref"

	echo $cmd
	eval $cmd
	echo Output written to $output
    done < $parameters
}



merge $parameters
