#!/bin/bash --login

samtools="samtools"

input=$1
script=$2
output=$3

echo "Read distribution"
date
CMD="${samtools} view ${input} \
    | tail -n+1000000 \
    | ${script} \
    -r 150 \
    -X 4 \
    -N 10000 \
    -o ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished read distribution."

