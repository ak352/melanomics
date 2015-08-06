#1/bin/bash --login


samtools="samtools"

input=$1
output=$2

echo "Run sorting"
date
CMD="${samtools} sort ${input} ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Sorting finished."
