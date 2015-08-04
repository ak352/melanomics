#!/bin/bash --login
module load SAMtools

sample=$1
INPUT_DIR=/work/projects/melanomics/analysis/transcriptome/unmapped/
input=${INPUT_DIR}/$sample/$sample.unmapped.paired.sorted.bam
output=$input.only_pairs.bam

date
echo Getting only unmapped pairs...
time (samtools view -H  $input; samtools view $input| python get_pairs.py;) \
| samtools view -bS - \
> $output 
date
echo Done.
