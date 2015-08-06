#!/bin/bash --login

STRELKA="/work/projects/melanomics/tools/strelka/strelka_workflow-1.0.14/release/bin/configureStrelkaWorkflow.pl"
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"
config="/work/projects/melanomics/scripts/genome/strelka/strelka_config_bwa_default.ini"

normal=$1
tumor=$2
output=$3

echo "Run strelka on matched tumor normal samples"
date
CMD="${STRELKA} \
    --normal=${normal} \
    --tumor=${tumor} \
    --ref=${ref} \
    --config=${config} \
    --output=${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished calling of somatic SNVs and indels using strelka."
