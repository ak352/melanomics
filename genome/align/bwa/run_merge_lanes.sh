#!/bin/bash --login
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools
#samtools=/work/projects/melanomics/tools/samtools/trial/samtools

#Usage: ./run_merge_lanes <lane1.bam>... <merged.bam>

rm -f $2
$samtools merge -f $2 $1
