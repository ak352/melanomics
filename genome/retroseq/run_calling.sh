#!/bin/bash --login
module load SAMtools
module load BEDTools
source paths

retroseq="/work/projects/melanomics/tools/retroseq/RetroSeq/bin/retroseq.pl"

bam=$1
input=$2
ref=$3
output=$4

echo "Run retroseq calling step"
date
CMD="${retroseq} \
    -call \
    -bam ${bam} \
    -input ${input} \
    -ref ${ref} \
    -output ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished calling step using retroseq."
