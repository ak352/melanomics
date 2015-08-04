#!/bin/bash --login

source path

input=$1
output=$2

echo "Run breakfast blacklist"
date
CMD="breakfast blacklist ${input} > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished breakfast blacklist"
