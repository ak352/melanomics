#!/bin/bash -l

OUT_DIR=//work/projects/melanomics/analysis/transcriptome/patient_2/fasd
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools

sample=patient_2

echo Indexing...
$samtools index $sample.trim.sorted.merged.bam

echo Filtering unmapped...
$samtools view -h -F 4 -b $sample.trim.sorted.merged.bam > $sample.trim.sorted.merged.OnlyMapped.bam
