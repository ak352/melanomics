#!/bin/bash --login
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools
#samtools=/work/projects/melanomics/tools/samtools/trial/samtools

rm -f $5
$samtools merge -f $5 $1 $2 $3 $4
