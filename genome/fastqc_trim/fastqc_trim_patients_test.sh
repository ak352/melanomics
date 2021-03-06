#!/bin/bash --login

fastqc=/work/projects/melanomics/tools/fastqc/FastQC/fastqc

#sample=patient_2
#sample=$1

run_fastqc()
{
    date
    echo "STATUS: Run FastQC ..."
    input=${files}
    tmp_output=${TMP_DIR}
    #output=${OUT_DIR}
    threads=12

    CMD="time ${fastqc} -t ${threads} -o ${tmp_output} ${input}"
    echo $CMD
    eval $CMD
    echo "FastQC done."
    echo

    #echo "STATUS: Copying FastQC results from ${tmp_output} to ${output} ..."
    # Create checksum, i.e. file fingerprint
    #md5sum ${tmp_output}/*
    # Check filesize etc.
    #ls -l ${tmp_output}
    #cp -av ${tmp_output}/* ${output}
    #RETSTAT=$?
    #if [ ${RETSTAT} -eq 0 ]; then
#	echo "done."
 #   else
#	echo "ERROR: Copy UNsuccessful"
 #   fi
  #  md5sum ${output}/*
   # ls -l ${output}
    #echo "STATUS: Copying done."    
    #date
}

make_directories()
{
  date
  echo "STATUS: Create directories ..."
  #files=/work/projects/melanomics/analysis/genome/${sample}/${condition}/trim/*_trimmed_*
  files=/scratch/users/akrishna/trim/*_5_${condition}_*_trimmed_*
  #files=/scratch/users/akrishna/trim/*_6_${condition}_*_trimmed_*
  #files=/scratch/users/akrishna/trim/*_7_${condition}_*_trimmed_*
  TMP_DIR=${SCRATCH}/fastqc_trim/${sample}_${condition}_test
  CMD="mkdir -pv ${TMP_DIR}"
  echo $CMD
  eval $CMD
  #OUT_DIR=/work/projects/melanomics/analysis/genome/${sample}/${condition}/fastqc_trim
  #CMD="mkdir -pv ${OUT_DIR}"
  #echo $CMD
  #eval $CMD
  #echo "STATUS: Directories created."
  date
}

# Normal skin
condition="NS"

#make_directories
#run_fastqc

# Primary melanoma
condition="PM"

make_directories
run_fastqc

echo "DONE."

