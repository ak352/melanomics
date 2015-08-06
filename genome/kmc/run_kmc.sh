#!/bin/bash --login

module load Boost/1.51.0-goolf-1.4.10
KMC="/work/projects/melanomics/tools/kmc/bin/kmc"

input=$1
output=$2
work_dir=$3

echo "Calculate coverage using kmc"
date
CMD="${KMC} -m44 -k21 ${input} ${output} ${work_dir}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished coverage using kmc"

