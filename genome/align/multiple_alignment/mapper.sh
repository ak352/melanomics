#!/bin/bash --login
MYSCRATCH=/work/projects/melanomics/analysis/genome/
mkdir -v $MYSCRATCH
MYTMP=$MYSCRATCH/mapping_ctdsp2_mutation/
mkdir -v $MYTMP
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf



bwa()
{
    module load bio/BWA
    module load bio/SAMtools

    read_group=$1
    ref=$2
    read1=$3
    read2=$4
    output=$5
    cores=$6
    
    echo "Command: bwa mem -t $cores -M -R $read_group -p $ref $read1 $read2 > $output"
    date
    echo OAR_JOBID = $OAR_JOBID
    time bwa mem -t $cores -M -R $read_group $ref $read1 $read2 | samtools view -bS - > $output
    date
}

blast()
{
   echo This is Blast.

}


read1=/work/projects/melanomics/analysis/igv/ctdsp2_mutation/raw_fastq/patient_2_NS.1_1.fastq
read2=/work/projects/melanomics/analysis/igv/ctdsp2_mutation/raw_fastq/patient_2_NS.2_2.fastq
read_group=p2_all_lanes
cores=4
BWA_OUTDIR=$MYTMP/bwa
mkdir -v $BWA_OUTDIR
output=$BWA_OUTDIR/patient_2_NS.bam
bwa $read_group $ref $read1 $read2 $output $cores



