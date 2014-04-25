#!/bin/bash --login
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools

rm -f ${1%.sam}.bam
rm -f ${2%.sam}.bam
rm -f $3
$samtools view -bS $1 > ${1%.sam}.bam
$samtools view -bS $2 > ${2%.sam}.bam
$samtools merge -f $3  ${1%.sam}.bam ${2%.sam}.bam




