#!/bin/bash --login
module load lang/Python/2.7.3-ictce-5.3.0
module load pysam
module load pipel2Cine
input=/work/projects/melanomics/analysis/genome/strelka/somatic_indels_all/all.dna.somatic_indels.vcf.gz
temp=/tmp/temp
output=${input%vcf.gz}testvariants
echo Writing to $temp
zcat $input > $temp
echo Writing to $output
python to_testvariants.py $temp $output
echo Output written to $output



