#!/bin/bash --login


sample="patient_4_NS"
file="/scratch/users/akrishna/gatk/${sample}.sorted.markdup.realn.recal.bam"
OUT_DIR="/work/projects/melanomics/analysis/transcriptome/variants"
TMP_DIR="$SCRATCH/variants"
reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"
samtools="samtools"
FASD="/work/projects/melanomics/tools/fasd/fasd_linux/FaSD-single"



pileup()
{
    date
    echo "STATUS: Pileup"
    input="${file}"
    output="${OUT_DIR}/${sample}.pileup"
    reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/Bowtie2Index/genome.fa"

    tmp_output="${TMP_DIR}/${sample}.pileup"

    
    time ${samtools} mpileup -f ${reference} ${input} > ${tmp_output}

    echo "Saving results to ${output} ..."
    cp ${tmp_output} ${output}
    echo "done."
    date
}


SNP_detection()
{
    date
    input="${OUT_DIR}/${sample}.pileup"
    output="${OUT_DIR}/${sample}.fasd.vcf"

    tmp_output="${TMP_DIR}/${sample}.fasd.vcf"

    time ${FASD} ${input} -d 4 -o ${tmp_output}

    echo "Saving results to ${output} ..."
    cp ${tmp_output} ${output}
    echo "done."
    date
}

SNP_detection
