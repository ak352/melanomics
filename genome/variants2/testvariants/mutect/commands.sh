#!/bin/bash --login
module load pipeline
input=/work/projects/melanomics/analysis/genome/mutect/all/all.mutect.coverage_annotated.vcf
temp=/tmp/temp
output=/work/projects/melanomics/analysis/genome/mutect/all/all.mutect.coverage_annotated.testvariants
echo Writing to $temp
grep -vP '^##GATK' $input | sed 's/<DEL>/\./g' > $temp
echo Writing to $output
python to_testvariants.py $temp $output
echo Output written to $output

