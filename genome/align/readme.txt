# Short read alignment
This folder contains scripts for short read alignment of Illumina FASTQ reads to the human genome

## bwa
* Alignment and pre-processing of BAM files following the GATK Best Practices pipeline
* Checkpointed pipeline to run on the HPC cluster
* Currently, must remove comments from different parts of the pipeline in gatk_best_practices.sh

Usage:
1. At the bottom of checkpointed/gatk_best_practices.sh, remove comments from the part of the pipeline to run
2. cd checkpointed
3. ./gatk_best_practices.sh  

## stats
Post-alignment statistics (number of reads aligned etc.) using samtools flagstat 

