#!/bin/bash --login

source path

input=$1
ref=$2
output=$3

echo "Run breakfast detection"
date
time breakfast detect -a25 -d1000 ${input} ${ref} ${output}
date
echo "Finished breakfast detection"


