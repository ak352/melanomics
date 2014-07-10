#!/bin/bash --login

source path

input=$1
output=$2

echo "Run breakfast tabulate"
date
time breakfast tabulate fusions ${input} > ${output}
date
echo "Finished breakfast tabulate"
