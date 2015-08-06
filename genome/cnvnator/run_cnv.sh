#!/bin/bash --login

module load ROOT
CNVnator="/work/projects/melanomics/tools/cnvnator/CNVnator_v0.3/src/cnvnator"

input=$1
bin_size="100"

echo "Run cnvnator cnv calling on tumor and normal samples"
date
CMD="${CNVnator} \
    -root ${input}  \
    -call ${bin_size}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished cnv calling using cnvnator."
