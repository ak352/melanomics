#!/bin/bash --login

samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools

sample=$1


make_directories()
{
    date
    echo "STATUS: Create directories ..."
    files="/scratch/users/akrishna/bwa"
    OUT_DIR=/scratch/users/sreinsbach/stats/${sample}
    CMD="mkdir -pv ${OUT_DIR}"
    echo ${CMD}
    eval ${CMD}
    echo "STATUS: Directories created."
    date
}


run_flagstat()
{
    date
    echo "STATUS: Run flagstat"
    files="/scratch/users/akrishna/bwa"
    for k in ${files}/${sample}*.lane*.pe.bam
    do
    input=${k}
    #output=${OUT_DIR}/${k}_flagstat.txt
    CMD="${samtools} flagstat ${input}"
    echo ${CMD}
    eval ${CMD}
    done
    echo "STATUS: done."
    date
}

make_directories
run_flagstat
