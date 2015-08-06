#!/bin/bash --login

LUMPY="/work/projects/melanomics/tools/lumpy/lumpy-sv/bin/lumpy"

input=$1
output=$2


echo "Run lumpy on split reads"
date
samtools="samtools"
CMD="${LUMPY} \
    -mw 4 \
    -tt 0.0\
    -sr \
    bam_file:${input},back_distance:20,weight:1,id:2,min_mapping_threshold:20 \
    > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished lumpy on split reads."
