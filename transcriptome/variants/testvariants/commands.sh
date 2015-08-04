#!/bin/bash --login

module load pipeline
input=/work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.annotated.vcf
temp=/tmp/temp
output=/work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.annotated.testvariants

grep -vP '^##GATK' $input | sed 's/<DEL>/\./g' > $temp
python to_testvariants.py $temp $output

