#!/bin/bash --login
module load Java
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
PICARD=/work/projects/melanomics/tools/picard/picard-tools-1.95/


date
echo "recalibration"
input=$1
reference=$2
dbsnp=$3
output=$4
grp=$5

#time java -jar $GATK/GenomeAnalysisTK.jar  -T BaseRecalibrator -I ${input} -R ${reference} -o ${grp} -knownSites ${dbsnp} --filter_reads_with_N_cigar -rf BadCigar
#time java -jar $GATK/GenomeAnalysisTK.jar -T PrintReads -R ${reference} -I ${input} -BQSR ${grp} -o ${output} --filter_reads_with_N_cigar -rf BadCigar
java -jar $PICARD/BuildBamIndex.jar \
    INPUT=$4
