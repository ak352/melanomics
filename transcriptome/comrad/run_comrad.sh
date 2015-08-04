#!/bin/bash --login

data_dna_dir=$1
data_rna_dir=$2
script_dir=$3
output_dir=$4

# print the message in stdout
echo "Run comrad" 
# print data in stdout
date

temp="${script_dir}/analyze.pl -c ${script_dir}/config.txt -d ${data_dna_dir} -r ${data_rna_dir} -o ${output_dir} -p 12"

# print the command in stdout
echo ${temp}
# ???
eval "time ${temp}"
# print data in stdout
date
# print the message in stdout
echo "Finished comrad."
