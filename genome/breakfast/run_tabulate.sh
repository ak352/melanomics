#!/bin/bash --login

source path

input=$1
output=$2

echo "Run breakfast tabulate"
date
CMD="breakfast tabulate fusions ${input} > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished breakfast tabulate"
