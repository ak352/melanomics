#!/bin/bash --login

LUMPY="/work/projects/melanomics/tools/lumpy/lumpy-sv/bin/lumpy"

input=$1
histo_file=$2
output=$3
param=$4

echo "Run lumpy on discordant reads"
date
CMD="${LUMPY} \
    -mw 4 \
    -tt 0.0 \
    -pe \
    bam_file:${input},histo_file:${histo_file},${param},read_length:104,min_non_overlap:104,discordant_z:4,back_distance:20,weight:1,id:1,min_mapping_threshold:20\
    > ${output}" 
  
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished lumpy on discordant reads."


