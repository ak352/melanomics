#!/bin/bash --login
#input=$SCRATCH/dna_variants/all.dna.coverage_annotated.testvariants
input=/work/projects/melanomics/analysis/genome/variants2/annotation/all.dna.coverage_annotated.testvariants
tested=$input.annotation
#tested=$SCRATCH/dna_variants/all.testvariants
#sed 's/^\([0-9]\+\t\)\(.\+\)/\1chr\2/g'  $input | sed 's/chrMT/chrM/g' > $tested
#/work/projects/isbsequencing/scripts/pipeline
./runAnnovarTestvariantFile.sh $tested
