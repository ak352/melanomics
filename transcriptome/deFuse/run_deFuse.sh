#!/bin/bash --login

data_dir=$1
script_dir=$2
output_dir=$3
file_name=$4

# print the message in stdout
echo "Run deFuse" 
# print data in stdout
date

temp="${script_dir}/defuse.pl -c ${script_dir}/config.txt -1 ${data_dir}/${file_name}_1.fastq -2 ${data_dir}/${file_name}_2.fastq -o ${output_dir} -p 12"

# print the command in stdout
echo ${temp}
# ???
eval "time ${temp}"
# print data in stdout
date
# print the message in stdout
echo "Finished deFuse."