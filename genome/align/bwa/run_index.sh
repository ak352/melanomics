#!/bin/bash --login
module load BWA
PICARD=/work/projects/melanomics/tools/picard/picard-tools-1.95/
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools

ref=$1

bwa index -a bwtsw $ref

#Should have it already!!!
#$samtools faidx $ref
#java -jar $PICARD/CreateSequenceDictionary.jar \
#    REFERENCE=$ref \ 
#    OUTPUT=${ref%.fa}.dict 
