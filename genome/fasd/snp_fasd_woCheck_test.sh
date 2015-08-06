#!/bin/bash --login

OUT_DIR="/work/projects/melanomics/analysis/genome/patient_5_PM/fasd_genome"
mkdir ${OUT_DIR}
reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"

pileup()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output="${OUT_DIR}/${sample}.pileup"
    oarsub -lwalltime=120 -n ${sample}_pileup "./run_samtools_mpileup.sh ${reference} ${input} ${output}"
}


SNP_detection()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/patient_5_PM/fasd_genome/${sample}.pileup"
    cores=12
    output="${OUT_DIR}/${sample}.fasd.vcf"
    oarsub -l /nodes=1/core=${cores},walltime=120 -n ${sample}_fasd "./run_fasd.sh ${input} ${cores} ${output}"
    #oarsub -t bigmem -l/nodes=1/core=${cores},walltime=120 -n ${sample}_fasd "./run_fasd.sh ${input} ${cores} ${output}"
}

#SNP_detection $1

#for k in NHEM
#   do
#       pileup $k
#    done

 for k in patient_5_PM #test_120mn_deleted_patient_8_PM #patient_8_PM #patient_7_PM #patient_5_PM patient_8_PM patient_8_NS NHEM patient_7_PM patient_4_NS NHEM
     do
 	SNP_detection $k
     done


# finished pileup for patient_5_PM patient_2_NS patient_8_NS patient_4_NS patient_5_NS patient_6_NS patient_7_NS patient_2_PM patient_4_PM patient_6_PM patient_7_PM patient_8_PM
#finished SNP detection for patient_2_NS patient_4_NS patient_2_PM patient_5_NS patient_4_PM patient_6_NS patient_6_PM patient_7_NS 
