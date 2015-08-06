#!/bin/bash --login

samtools="samtools"


input=$1
script=$2
output=$3

echo "Run extraction of split reads"
date
CMD="${samtools} view -h ${input} \
  | ${script} -i stdin \
  | samtools view -Sb - \
  > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished extraction of split reads"

