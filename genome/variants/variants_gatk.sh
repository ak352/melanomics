#!/bin/bash --login

#OUTDIR=${SCRATCH}/gatk_genome
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf

haplotypeCaller()
{
    sample=$1
    OUTDIR=/work/projects/melanomics/analysis/genome/$sample/gatk_genome
    mkdir ${OUTDIR}
    input=/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam
    output=${OUTDIR}/${sample}.htc.vcf
    cores=12
    nct=12
    #oarsub -t bigmem -l walltime=120 -n ${sample}_hct "./run_htc.sh ${input} ${output} ${dbsnp} ${ref}"
    oarsub -l nodes=1/core=${cores},walltime=120 -n ${sample}_hct_w "./run_htc.sh ${input} ${output} ${dbsnp} ${ref} ${cores} ${nct}"
    #oarsub -t bigsmp -lcore=${cores},walltime=120 -n ${sample}_hct_w "./run_htc.sh ${input} ${output} ${dbsnp} ${ref} ${cores} ${nct}"
}


unifiedgenotyper()
{
    sample=$1
    input=/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam
    OUTDIR=/work/projects/melanomics/analysis/genome/$sample/gatk_genome
    mkdir ${OUTDIR}
    output=${OUTDIR}/${sample}.ugt.indel.vcf
    cores=12
    oarsub -l/nodes=1/core=${cores},walltime=120 -n ${sample}_ugt "./run_ugt.sh ${input} ${output} ${dbsnp} ${ref} ${cores}"
}


variant_recalibrate_htc()
{
    sample=$1
    OUTDIR=/work/projects/melanomics/analysis/genome/${sample}/gatk_genome
    mkdir ${OUTDIR}    
    input=${OUTDIR}/${sample}.htc.vcf
    output=${OUTDIR}/${sample}.htc.vqsr.vcf
    cores=1
    #oarsub -l/nodes=1/core=${cores},walltime=120 -n ${sample}_htc_recal "./run_variant_recalibrate.sh ${input} ${output} ${dbsnp} ${ref} ${cores}"
    #oarsub -t bigmem -lcore=${cores},walltime=120 -n ${sample}_htc_recal "./run_variant_recalibrate.sh ${input} ${output} ${dbsnp} ${ref} ${cores}"
    oarsub -l/nodes=1/core=${cores},walltime=120 -n ${sample}_htc_recal "./run_variant_recalibrate.sh ${input} ${output} ${dbsnp} ${ref} ${cores}"
}


variant_recalibrate_ugt()
{
    sample=$1
    OUTDIR=/work/projects/melanomics/analysis/genome/${sample}/gatk_genome
    mkdir ${OUTDIR}    
    input=${OUTDIR}/${sample}.ugt.indel.vcf
    output=${OUTDIR}/${sample}.ugt.vqsr.vcf
    cores=12
    oarsub -l/nodes=1/core=${cores},walltime=120 -n ${sample}_ugt_recal "./run_variant_recalibrate.sh ${input} ${output} ${dbsnp} ${ref} ${cores}"
}


#for k in patient_7_NS #patient_4_PM patient_8_PM patient_5_PM patient_6_PM patient_7_PM patient_2_PM patient_4_NS patient_8_NS patient_5_NS patient_6_NS patient_7_NS #patient_2_NS patient_2_PM NHEM

 #   do
#	haplotypeCaller $k
#    done

for k in NHEM #patient_4_PM #NHEM #patient_4_PM #patient_8_PM patient_5_NS patient_6_NS patient_7_NS patient_2_NS patient_4_NS patient_8_NS patient_2_PM patient_5_PM patient_6_PM patient_7_PM
    do
	variant_recalibrate_htc $k
    done


#for k in patient_5_NS patient_5_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM #patient_6_NS patient_7_NS patient_2_PM patient_4_PM patient_6_PM patient_8_PM patient_2_NS patient_4_NS patient_5_PM NHEM
#for k in 5 7 8
#do
#    for m in NS PM
#    do
#	unifiedgenotyper $k
#    done
#done

# for k in patient_5_NS #patient_6_NS patient_7_NS patient_2_PM patient_4_PM patient_6_PM patient_8_PM patient_2_NS patient_4_NS patient_5_PM patient_7_PM patient_8_NS NHEM 
#     do
# 	variant_recalibrate_ugt $k
#     done
