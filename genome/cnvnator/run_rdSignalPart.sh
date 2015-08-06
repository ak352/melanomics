#!/bin/bash --login

module load ROOT
CNVnator="/work/projects/melanomics/tools/cnvnator/CNVnator_v0.3/src/cnvnator"

input=$1
bin_size="1000"

echo "Run cnvnator rdSignalPart on tumor and normal samples"
date
CMD="${CNVnator} \
    -root ${input}  \
    -partition ${bin_size}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished rdSignalPart using cnvnator."
