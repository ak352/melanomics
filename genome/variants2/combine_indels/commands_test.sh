#!/bin/bash --login
module load Java
#module load pipeline
#module load pysam

#Merge VCF files
java=java
sed=sed
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/GenomeAnalysisTK.jar
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dict=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.dict


correct_dindel()
{
    sample=$1
    dindel="/work/projects/melanomics/analysis/genome/${sample}/variants/dindel/${sample}.dindel.vcf"
    dindel_corrected=${dindel##*/}
    dindel_corrected="/work/projects/melanomics/analysis/genome/variants/${dindel_corrected%vcf}corrected.vcf"
    python correct_dindel.py ${dindel} > ${dindel_corrected}
    echo Output written to ${dindel_corrected}
}

merge()
{
    sample=$1
    vcf_files="${sample}.vcf_files.in"
    bam="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output="/work/projects/melanomics/analysis/genome/variants/${sample}.combined.vcf"

    #Do we need a BAM file here? If not, remove it
    python pipeline.py -vc -g ${GATK} -r ${ref} -d ${dict} --list-of-vcf ${vcf_files} --sample-name ${sample} --bam-file ${bam} -o ${output}
    echo Output written to ${output}
}


choose()
{
    #If variant found in 2 callers, include
    sample=$1
    echo Sample = ${sample}
    input=/work/projects/melanomics/analysis/genome/variants/${sample}.combined.vcf
    output=${input%combined.vcf}indels.vcf
    python merge_callers.py ${input} ${sample} > ${output}
    echo Output written to ${output}

}


for m in patient_5_NS #patient_5_NS patient_6_NS patient_7_NS patient_8_NS patient_2_PM patient_4_PM patient_5_PM patient_6_PM patient_7_PM patient_8_PM NHEM patient_2_NS 
do
    #correct_dindel ${m}
    merge ${m}
    choose ${m}
done
