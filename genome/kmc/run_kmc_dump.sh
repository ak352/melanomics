#!/bin/bash --login

module load Boost/1.51.0-goolf-1.4.10
KMCDUMP="/work/projects/melanomics/tools/kmc/bin/kmc_dump"


input=$1
output=$2

echo "Calculate coverage kmc_dump"
date
CMD="${KMCDUMP} -cx0 ${input} ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished calculating coverage using kmc_dump"
