#!/bin/bash --login
module load pipeline
input=test.vcf
temp=/tmp/temp
output=test.testvariants
echo Writing to $temp
grep -vP '^##GATK' $input | sed 's/<DEL>/\./g' > $temp
echo Writing to $output
python to_testvariants.py $temp $output
echo Output written to $output

