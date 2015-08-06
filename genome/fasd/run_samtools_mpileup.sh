#!/bin/bash --login

samtools="samtools"

reference=$1
input=$2
output=$3

date
echo "Running samtools mpileup"
time ${samtools} mpileup -f ${reference} ${input} > ${output}
echo "Finished samtools mpileup"
date

