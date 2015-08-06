#!/bin/bash --login

samtools="samtools"


input=$1
output=$2

echo "Run extraction of untrimmed reads for histogram"
date
CMD="${samtools} view ${input} | awk -F'\t' '\$6==\"104M\"' | tail -n+1000000 > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished extraction of untrimmed reads"
