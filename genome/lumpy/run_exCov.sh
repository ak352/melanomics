#!/bin/bash --login

source path

input_DR=$1
input_SR=$2
script=$3

echo "Identify regions with high coverage"
date
CMD="${script} ${input_DR} ${input_SR}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished identificcation of high coverage"
