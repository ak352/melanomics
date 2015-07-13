#!/bin/bash --login
module load lang/Java
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/

input=$1
output=$2
dbsnp=$3
reference=$4
cores=$5

echo OAR_JOBID = $OAR_JOBID
time java -jar ${GATK}/GenomeAnalysisTK.jar \
    -R ${reference} \
    -T UnifiedGenotyper \
    -I $input \
    -glm INDEL \
    --dbsnp ${dbsnp} \
    -stand_call_conf 30.0 \
    -stand_emit_conf 30.0 \
    -nt $cores \
    -o $output

