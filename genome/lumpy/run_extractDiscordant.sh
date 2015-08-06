#!/bin/bash --login


samtools="samtools"


input=$1
output=$2

echo "Run extraction of discordant paired-end reads"
date
CMD="${samtools} view -u -F 0x0002 ${input} \
    |  samtools view -u -F 0x0100 - \
    | samtools view -u -F 0x0004 - \
    | samtools view -u -F 0x0008 - \
    | samtools view -b -F 0x0400 - \
    > ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished extraction"
