#!/bin/bash 
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/somatic/stats

while read line
do
    set $line
    col=$1
    sample=$2
    echo "Calculating for $sample..."
    python stats.py /work/projects/melanomics/analysis/genome/variants2/somatic/all.dna.soma.mutect.strelka.coverage_annotated.vcf $col > $OUTDIR/$sample.depth.hist
    echo "$sample done"
done < input

