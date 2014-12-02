#!/bin/bash --login
module load pipeline
#input=/scratch/users/akrishna/all.dna.coverage_annotated.vcf
input=/work/projects/melanomics/analysis/genome/variants2/somatic/all.dna.soma.mutect.strelka.coverage_annotated.vcf
temp=/tmp/temp
#output=/scratch/users/akrishna/all.dna.coverage_annotated.testvariants
output=/work/projects/melanomics/analysis/genome/variants2/somatic/all.dna.soma.mutect.strelka.coverage_annotated.testvariants
echo Writing to $temp
grep -vP '^##GATK' $input | sed 's/<DEL>/\./g' > $temp
echo Writing to $output
python to_testvariants.py $temp $output
echo Output written to $output

