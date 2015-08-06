#!/bin/bash --login

LUMPY="/work/projects/melanomics/tools/lumpy/lumpy-sv/bin/lumpy"

input_DR=$1
input_SR=$2
histo_file=$3
param=$4
output=$5

echo "Run lumpy on both paired and split reads"
date
CMD="${LUMPY} \
    -mw 4 \
    -tt 0.0 \
    -pe \
    bam_file:${input_DR},histo_file:${histo_file},${param},read_length:104,min_non_overlap:104,discordant_z:4,back_distance:20,weight:1,id:1,min_mapping_threshold:20 \
    -sr \
    bam_file:${input_SR},back_distance:20,weight:1,id:2,min_mapping_threshold:20 \
    > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished lumpy on both paired and split reads."

