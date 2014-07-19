#!/bin/bash --login
module load Java
#GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
GATK=/work/projects/melanomics/tools/gatk/gatk3/
PICARD=/work/projects/melanomics/tools/picard/picard-tools-1.95/

input=$1
output=$2
dbsnp=$3
reference=$4
cores=$5

echo "Run GATK UnifiedGenotyper"
date
time java -Xmx64g -jar ${GATK}/GenomeAnalysisTK.jar \
    -R ${reference} \
    -T UnifiedGenotyper \
    -I ${input} \
    -glm INDEL \
    --dbsnp ${dbsnp} \
    -stand_call_conf 30.0 \
    -stand_emit_conf 30.0 \
    -nt ${cores} \
    -o ${output}
echo "Finished GATK UnifiedGenotyper"
