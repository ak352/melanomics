#!/bin/bash --login

module load Java/1.7.0_10

validate_sam="/work/projects/melanomics/tools/picard/picard-tools-1.95/ValidateSamFile.jar"

input=$1
output=$2
ignore=$3

date
echo "Validate bam files"
CMD="${validate_sam} I=${input} O=${output} IGNORE=${ignore}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished validateSam."
