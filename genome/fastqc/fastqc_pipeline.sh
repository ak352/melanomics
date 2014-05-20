#!/bin/bash --login

fastqc=/work/projects/melanomics/tools/fastqc/FastQC/fastqc

sample=patient_5
file=/work/projects/melanomics/analysis/genome/${sample}/*/fastq/*.fastq
TMP_DIR=${SCRATCH}/fastq/${sample}
mkdir ${TMP_DIR}/
OUT_DIR=/work/projects/melanomics/analysis/genome/${sample}/*/fastqc
mkdir ${OUT_DIR}

fastqc()
{
    date
    echo "Run FastQC"
    input=${file}
    tmp_output=${TMP_DIR}
    output=${OUT_DIR}
    threads=20
    echo "Run FastQC"

    time ${fastqc} -t=${threads} ${input} ${tmp_output}

    echo "Copying ReadGroup results from ${tmp_output} to ${output}..."
    # Create checksum, i.e. file fingerprint
    md5sum ${tmp_output}
    # Check filesize etc.
    ls -l ${tmp_output}
    cp ${tmp_output} ${output}
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
	echo "done."
    else
	echo "ERROR: Copy UNsuccessful"
    fi
    md5sum ${output}
    ls -l ${output}
    date
}
