#!/bin/bash --login

LUMPY="/work/projects/melanomics/tools/lumpy/lumpy-sv/bin/lumpy"
input_t=$1
split_t=$2
input_n=$3
split_n=$4
histo_t=$5
histo_n=$6
param_t=$7
param_n=$8
output=$9

status()
{
    d=`date`
    echo [$d] $1
}

out_status()
{
    d=`date`
    echo [$d] Output written to $1
    wc -l $1
}


status "Running lumpy on matched samples..."
CMD="${LUMPY} \
    -mw 4 \
    -tt 0.0 \
    -pe \
    bam_file:${input_t},histo_file:${histo_t},${param_t},read_length:104,min_non_overlap:104,discordant_z:4,back_distance:20,weight:1,id:1,min_mapping_threshold:1 \
    -sr \
    bam_file:${split_t},back_distance:20,weight:1,id:1,min_mapping_threshold:20 \
    -pe \
    bam_file:${input_n},histo_file:${histo_n},${param_n},read_length:104,min_non_overlap:104,discordant_z:4,back_distance:20,weight:1,id:2,min_mapping_threshold:1\
    -sr \
    bam_file:${split_n},back_distance:20,weight:1,id:2,min_mapping_threshold:20 \
    > ${output}"
status "${CMD}"
eval "time ${CMD}"
status "Finished lumpy on matched samples."
out_status $output


