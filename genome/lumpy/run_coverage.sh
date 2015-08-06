#!/bin/bash --login


LUMPY="/work/projects/melanomics/tools/lum"

input_pe=$1
input_se=$2
output=$3


echo "Detecting coverage"
date
CMD="${LUMPY} ${input} ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished coverage detection."
