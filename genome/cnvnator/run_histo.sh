#!/bin/bash --login

module load ROOT
CNVnator="/work/projects/melanomics/tools/cnvnator/CNVnator_v0.3/src/cnvnator"

input=$1
bin_size="1000"
ref=$2

echo "Run cnvnator histo on tumor and normal samples"
date
CMD="${CNVnator} \
    -root ${input}  \
    -his ${bin_size} \
    -d ${ref}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished histo generation using cnvnator."
