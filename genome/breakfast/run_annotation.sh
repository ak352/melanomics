#!/bin/bash --login

source path

input=$1
output=$2
#annofile=$3

echo "Run breakfast annotate"
date
time breakfast annotate ${input} --bed ${annofile}
date
echo "Finished breakfast annotate"
