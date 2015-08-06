#!/bin/bash --login
module load Java
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/

input=$1
output=$2
dbsnp=$3
ref=$4
cores=$5
bam=$6

cmd1=" \
time java -Xmx2g -jar ${GATK}/GenomeAnalysisTK.jar \
-T VariantAnnotator \
-R $ref \
-o $output \
-V $input \
--dbsnp $dbsnp \
-nt $cores
"

cmd2=" \
time java -Xmx2g -jar ${GATK}/GenomeAnalysisTK.jar \
-T VariantAnnotator \
-R $ref \
-V $input \
--list \
-nt $cores \
"

echo $cmd1
eval $cmd1


 
