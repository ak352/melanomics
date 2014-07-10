#!/bin/bash --login
echo "Run breakfast create the blacklist"
date
output=$1
rm -rf $output
for k in 2 4 5 6 7 8
do
    sample=patient_${k}_NS
    input=${OUTDIR}/${sample}.bf.blacklist.txt
    cat $input >> $output
done
input=${OUTDIR}/NHEM.bf.blacklist.txt
cat $input >> $output
date
echo "Finished breakfast create blacklist"
