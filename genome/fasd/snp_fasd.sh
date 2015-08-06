#!/bin/bash --login

OUT_DIR="${SCRATCH}/fasd_genome"
mkdir ${OUT_DIR}
reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"

pileup()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output="${OUT_DIR}/${sample}.pileup"
    ./run_samtools_mpileup.sh ${reference} ${input} ${output}
}


SNP_detection()
{
    sample=$1
    input="${SCRATCH}/fasd_genome/${sample}.pileup"
    cores=6
    output="${OUT_DIR}/${sample}.fasd.vcf"
    ./run_fasd.sh ${input} ${cores} ${output}
}

# pileup $1
SNP_detection $1

#for k in NHEM
#   do
#       pileup $k
#    done

# for k in patient_7_PM #patient_5_PM patient_8_PM patient_8_NS NHEM patient_7_PM patient_4_NS NHEM
#     do
# 	SNP_detection $k
#     done


# finished pileup for patient_5_PM patient_2_NS patient_8_NS patient_4_NS patient_5_NS patient_6_NS patient_7_NS patient_2_PM patient_4_PM patient_6_PM patient_7_PM patient_8_PM
#finished SNP detection for patient_2_NS patient_4_NS patient_2_PM patient_5_NS patient_4_PM patient_6_NS patient_6_PM patient_7_NS 
