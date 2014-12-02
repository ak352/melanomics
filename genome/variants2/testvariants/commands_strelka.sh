#!/bin/bash --login
module load pipeline
for k in 2 4 5 6 7 8
do
    input=/work/projects/melanomics/analysis/genome/strelka/patient_${k}/results/passed.somatic.indels.gt.vcf
    temp=/tmp/temp
    output=${input%gt.vcf}testvariants
    echo Writing to $temp
    grep -vP '^##GATK' $input | sed 's/<DEL>/\./g' > $temp
    echo Writing to $output
    python to_testvariants.py $temp $output
    echo Output written to $output
done

