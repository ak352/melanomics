#!/bin/bash --login
module load Java
#module load pysam
source paths
echo $PYTHONPATH
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa

add_GT()
{
    grep "^##" $1 > $2
    cat additional_header >> $2
    grep "^#CHROM" $1 >> $2
    grep -v "^#" $1 >> $2
}    

add_GTs()
{
    patient=$1
    inputdir=/work/projects/melanomics/analysis/genome/strelka/$patient/results
    resultsdir=/work/projects/melanomics/analysis/genome/strelka/$patient/results/combine
    snv=$inputdir/passed.somatic.snvs.gt.vcf
    indels=$inputdir/passed.somatic.indels.gt.vcf
    out_snv=$resultsdir/passed.somatic.snvs.gt.vcf
    out_indels=$resultsdir/passed.somatic.indels.gt.vcf
    add_GT $snv $out_snv
    add_GT $indels $out_indels
}

merge_snv_indel()
{
    patient=$1
    inputdir=/work/projects/melanomics/analysis/genome/strelka/$patient/results/combine/
    resultsdir=/work/projects/melanomics/analysis/genome/strelka/$patient/results/combine/
    mkdir $resultsdir
    snv=$inputdir/passed.somatic.snvs.gt.vcf
    indels=$inputdir/passed.somatic.indels.gt.vcf
    output=$resultsdir/passed.somatic.snvs.indels.vcf
    java -Xmx2g -jar ${GATK}/GenomeAnalysisTK.jar \
	-R ${ref} \
	-T CombineVariants \
	--variant ${snv} \
	--variant ${indels} \
	-o ${output}

}

for k in 2 4 5 6 7 8
do

    add_GTs patient_$k
    merge_snv_indel patient_$k
done
