#!/bin/bash --login


YAHA="/work/projects/melanomics/tools/yaha/yaha"
samtools="/work/projects/melanomics/tools/samtools/samtools"

cores=$1
input=$2
ref_index=$3
output=$4

echo "Run split read alignment"
date
CMD="${YAHA} \
    -t ${cores}
    -x ${ref_index} \
    -q ${input} \
    -osh stdout \
    -M 15 \
    -H 2000 \
    -L 11 \
    | ${samtools} view -Sb - \
    > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished split read alignment"
