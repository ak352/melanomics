#!/bin/bash --login

fastqc=/work/projects/melanomics/tools/fastqc/FastQC/fastqc

#sample=patient_2
sample=$1

run_fastqc()
{
    date
    echo "STATUS: Run FastQC ..."
    input=${files}
    tmp_output=${TMP_DIR}
    output=${OUT_DIR}
    threads=10

    CMD="time ${fastqc} -t ${threads} -o ${tmp_output} ${input}"
    echo $CMD
    eval $CMD
    echo "done (FastQC)."
    echo

    echo "STATUS: Copying FastQC results from ${tmp_output} to ${output} ..."
    # Create checksum, i.e. file fingerprint
    md5sum ${tmp_output}/*
    # Check filesize etc.
    ls -l ${tmp_output}
    cp -av ${tmp_output}/* ${output}
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
	echo "done."
    else
	echo "ERROR: Copy UNsuccessful"
    fi
    md5sum ${output}/*
    ls -l ${output}
    date
}

make_directories()
{
  files=/work/projects/melanomics/analysis/genome/${sample}/${condition}/fastq/*.fastq
  TMP_DIR=${SCRATCH}/fastqc/${sample}_${condition}
  CMD="mkdir -pv ${TMP_DIR}"
  echo $CMD
  eval $CMD
  OUT_DIR=/work/projects/melanomics/analysis/genome/${sample}/${condition}/fastqc
  CMD="mkdir -pv ${OUT_DIR}"
  echo $CMD
  eval $CMD
}


make_directory()
{
    files=/work/projects/melanomics/analysis/genome/${sample}/fastq/*.fastq
    TMP_DIR=${SCRATCH}/fastqc/${sample}
    CMD="mkdir -pv ${TMP_DIR}"
    echo $CMD
    eval $CMD
    OUT_DIR=/work/projects/melanomics/analysis/genome/${sample}/fastqc
    CMD="mkdir -pv ${OUT_DIR}"
    echo $CMD
    eval $CMD
}


#make_directory
#run_fastqc

# Normal skin
condition="NS"

make_directories
run_fastqc

# Primary melanoma
condition="PM"

make_directories
run_fastqc

echo "DONE."

