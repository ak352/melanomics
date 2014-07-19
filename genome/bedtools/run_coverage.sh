#!/bin/bash --login 

module load BEDTools

input=$1
genome=$2
output=$3

echo "Calculating coverage"
date
CMD="bedtools genomecov -ibam ${input} -g ${genome} > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished calculating coverage"
