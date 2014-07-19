#!/bin/bash --login
module load Java
#GATK=/work/projects/melanomics/tools/gatk/gatk3/
GATK=/work/projects/melanomics/tools/gatk/gatk3

input=$1
output=$2
dbsnp=$3
reference=$4
nct=$6

echo "Run GATK HaplotypeCaller"
date
time java -Xmx64g -jar ${GATK}/GenomeAnalysisTK.jar \
    -R ${reference} \
    -T HaplotypeCaller \
    -I ${input} \
    --dbsnp ${dbsnp} \
    -stand_call_conf 30.0 \
    -stand_emit_conf 30.0 \
    -nct ${nct} \
    -o ${output}
echo "Finished GATK HaplotypeCaller"
