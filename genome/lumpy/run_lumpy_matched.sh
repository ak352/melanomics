#!/bin/bash --login

LUMPY="/work/projects/melanomics/tools/lumpy/lumpy-sv/bin/lumpy"


input_t=$1
input_n=$2
histo_t=$3
histo_n=$4
param_t=$5
param_n=$6
output=$7

echo "Run lumpy on matched samples"
date
CMD="${LUMPY} \
    -mw 4 \
    -tt 0.0 \
    -pe \
    bam_file:${input_t},histo_file:${histo_t},${param_t},read_length:104,min_non_overlap:104,discordant_z:4,back_distance:20,weight:1,id:1,min_mapping_threshold:1 \
    -pe \
    bam_file:${input_n},histo_file:${histo_n},${param_n},read_length:104,min_non_overlap:104,discordant_z:4,back_distance:20,weight:1,id:2,min_mapping_threshold:1\
    > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished lumpy on matched samples."

