#!/bin/bash --login

export PATH=/work/projects/melanomics/tools/tabix/tabix-0.2.6:$PATH

vcf=/work/projects/melanomics/analysis/genome/variants2/intermediate/all.dna.coverage_annotated.vcf
echo Bgzipping..
bgzip $vcf
echo Tabixing...
tabix -p vcf $vcf.gz
echo Done

