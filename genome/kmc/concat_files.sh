#! /bin/bash -l

sample=
DIR="/work/projects/melanomics/analysis/genome/${sample}/fastq"
DEST="${sample}_all"
DEST="${SCRATCH}/kmc_genome/${DEST}.fq"

date

CMD="${DIR}/cat *fastq > ${DEST}"
echo "${CMD}"
eval "time ${CMD}"

date

