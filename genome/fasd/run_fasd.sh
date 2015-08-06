#!/bin/bash --login

FASD="/work/projects/melanomics/tools/fasd/fasd_linux/FaSD-single"

input=$1
cores=$2
output=$3


date
echo "Running SNP detection - FaSD"
time ${FASD} ${input} -n ${cores} -d 4 -o ${output}
echo "Finished SNP detection - FaSD."
date
