#!/bin/bash --login

source path

input=$1
output=$2

echo "Run breakfast blacklist"
date
time breakfast blacklist ${input} > ${output}
date
echo "Finished breakfast blacklist"

