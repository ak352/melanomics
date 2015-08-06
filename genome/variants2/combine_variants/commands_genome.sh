#!/bin/bash --login
module load Java
#module load pysam
source paths
echo $PYTHONPATH
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa

fasd2vcf()
{
    sample=$1
    input="/scratch/users/sreinsbach/fasd_genome_2/${sample}.fasd.vcf"
    output="/work/projects/melanomics/analysis/genome/variants2/${sample}.fasd.corr.vcf"
    
    echo ${input}
    python fasd2vcf.py ${input} ${sample} ${ref} > ${output}


}

remove_M()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/variants2/${sample}.fasd.corr.vcf"
    output="/work/projects/melanomics/analysis/genome/variants2/${sample}.fasd.corr.noM.vcf"
    
    echo ${input}
    awk -F"\t" '$4!="M" && $4!="R"' $input > $output
}


merge_snv_indel()
{
    sample=$1
    mkdir /work/projects/melanomics/analysis/genome/variants2/
    snv="/work/projects/melanomics/analysis/genome/variants2/${sample}.fasd.corr.noM.vcf"
    indels="/work/projects/melanomics/analysis/genome/variants2/${sample}.indels.vcf"
    output="/work/projects/melanomics/analysis/genome/variants2/${sample}.indel.snp.vcf"
    java -Xmx2g -jar ${GATK}/GenomeAnalysisTK.jar \
   -R ${ref} \
   -T CombineVariants \
   --variant ${snv} \
   --variant ${indels} \
   -o ${output}
    
}

for k in patient_8_PM  #patient_4_NS patient_5_NS patient_6_NS patient_7_NS patient_8_NS patient_2_PM patient_4_PM patient_5_PM patient_6_PM patient_7_PM patient_8_PM NHEM patient_2_NS 
do
    #fasd2vcf $k
    remove_M $k
    merge_snv_indel $k
done
