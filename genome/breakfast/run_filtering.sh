#!/bin/bash --login

#source path
source testpath

input=$1
output=$2
blacklist=$3

echo "Run breakfast filtering"
date
time breakfast filter -r 1-3-0 -r 0-10-0 --blacklist=${blacklist} ${input} > ${output}
date
echo "Finished breakfast filtering"
