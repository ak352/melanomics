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
source paths

merge()
{
    sample=$1
    vcf_files="${sample}.vcf_files.in"
    bam="/work/projects/melanomics/analysis/genome/${sample}_PM/bam/${sample}_PM.bam"
    output="/work/projects/melanomics/analysis/genome/variants2/somatic/${sample}.combined.vcf"

    #Do we need a BAM file here? If not, remove it
    python pipeline.py -vc -g ${GATK} -r ${ref} -d ${dict} --list-of-vcf ${vcf_files} --sample-name ${sample} --bam-file ${bam} -o ${output}
    echo Output written to ${output}
}


choose()
{
    #If variant found in 2 callers, include
    sample=$1
    echo Sample = ${sample}
    input=/work/projects/melanomics/analysis/genome/variants2/somatic/${sample}.combined.vcf
    output=${input%combined.vcf}somatic.vcf
    python merge_callers.py ${input} ${sample} > ${output}
    echo Output written to ${output}

}


for k in 2 4 5 6 7 8
do
    m=patient_$k
    merge ${m}
    choose ${m}
done
