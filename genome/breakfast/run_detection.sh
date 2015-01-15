#!/bin/bash --login

source path

input=$1
ref=$2
output=$3

echo "Run breakfast detection"
date
#CMD="breakfast detect -a20 -d10 ${input} ${ref} ${output}"
CMD="breakfast detect -d10 ${input} ${ref} ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished breakfast detection"
