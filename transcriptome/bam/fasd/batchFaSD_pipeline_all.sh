#! /bin/bash -l

if [ ! $# -eq 2 ]; then
    echo "USAGE: ${0} <myPath> <sampleID>"
    exit 1
fi

MYPATH=${1}
SAMPLE=${2}

CMD="oarsub -n \"FaSD_Transcriptome_${SAMPLE}\" -lnodes=1,walltime=48:00:00 \"./FaSD_pipeline_all.sh ${MYPATH} ${SAMPLE}\""
echo ${CMD}
eval ${CMD}
