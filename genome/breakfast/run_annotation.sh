#!/bin/bash --login

source path

input=$1
output=$2
annofile=$3

echo "Run breakfast annotate"
date
CMD="breakfast annotate ${input} ${annofile} > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished breakfast annotate"
