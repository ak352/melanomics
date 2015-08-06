#!/bin/bash --login

module load ROOT
CNVnator="/work/projects/melanomics/tools/cnvnator/CNVnator_v0.3/src/cnvnator"

output=$1
bam=$2

echo "Run cnvnator readMapping on tumor and normal samples"
date
CMD="${CNVnator} \
    -root ${output} \
    -tree ${bam}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished readMApping using cnvnator."
