#!/bin/bash --login

source path

script=$1
cov=$2
ex_file=$3
input_DR=$4
input_SR=$5


echo "Getting high coverage"
date
CMD="${script} ${cov} ${ex_file} ${input_DR} ${input_SR}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished getting high coverage"
