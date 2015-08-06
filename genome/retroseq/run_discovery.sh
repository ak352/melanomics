#!/bin/bash --login

module load SAMtools
module load BEDTools
source paths

retroseq="/work/projects/melanomics/tools/retroseq/RetroSeq/bin/retroseq.pl"

bam=$1
output=$2
eref=$3
refTEs=$4

echo "Run retroseq discovery phase"
date
CMD="${retroseq} \
	-discover \
	-bam ${bam} \
	-eref ${eref} \
	-refTEs ${refTEs} \
	-align \
	-output ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished discovery phase using retroseq."
