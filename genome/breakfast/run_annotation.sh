#!/bin/bahs --login

source path

input=$1
output=$2
annofile=$3

echo "Run breakfast annotate"
date
time breakfast annotate -b ${annofile} ${input} > ${output}
date
echo "Finished breakfast annotate"
