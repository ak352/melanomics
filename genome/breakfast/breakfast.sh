#!/bin/bash --login

OUTDIR=${SCRATCH}/breakfast_genome
mkdir -pv ${OUTDIR}
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome"
#annofile="/work/projects/melanomics/tools/breakfast/data/ensembl_genes.bed"
annofile="/work/projects/melanomics/tools/breakfast/data/hg19_refGene.bed"

detection()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output=${OUTDIR}/${sample}.bf
    oarsub -l nodes=1,walltime=120 -n ${sample}.bf "./run_detection.sh ${input} ${ref} ${output}"
    # ./run_detection.sh ${input} ${ref} ${output}
}


blacklist()
{
    sample=$1
    input="/scratch/users/sreinsbach/breakfast_genome/${sample}.bf.sv"
    output=${OUTDIR}/${sample}.bf.blacklist.txt
    #./run_blacklist.sh ${input} ${output}
    oarsub -l nodes=1,walltime=120 -n ${sample}.bl "./run_blacklist.sh ${input} ${output}"
}


filtering()
{
    sample=$1
    sample_bl=$2
    input=${OUTDIR}/${sample}.bf.sv
    output=${OUTDIR}/${sample}.bf.filtered.sv
    blacklist=${OUTDIR}/${sample_bl}.bf.blacklist.txt
    #./run_filtering.sh ${input} ${output} ${blacklist}
     oarsub -l nodes=1,walltime=120 -n ${sample}.filter "./run_filtering.sh ${input} ${output} ${blacklist}"
}


annotation()
{
    sample=$1
    input=${OUTDIR}/${sample}.bf.filtered.sv
    output=${OUTDIR}/${sample}.bf.filtered.anno.RefSeq.sv
    oarsub -t bigmem -l walltime=120 -n ${sample}.anno.RefSeq "./run_annotation.sh ${input} ${output} ${annofile}"
}


tabulate()
{
    sample=$1
    input=${OUTDIR}/${sample}.bf.filtered.anno.sv
    output=${OUTDIR}/${sample}.bf.filtered.anno.cand.sv
    oarsub -t bigmem -l walltime=120 -n ${sample}.cand "./run_tabulate.sh ${input} ${output}"
}


#for k in 4_PM 5_PM 6_PM 7_PM 4_NS 5_NS 6_NS 7_NS 2_NS 2_PM 8_NS 8_PM 
#    do 
#      detection patient_$k
#    done


#for k in 4 8 5 6 7 2
#     do
# 	blacklist patient_${k}_NS
#     done


for k in 2 4 5 6 7 8
     do
       filtering patient_${k}_PM patient_${k}_NS
    done


# for k in patient_2_PM patient_4_PM patient_8_PM patient_5_PM patient_6_PM patient_7_PM
#     do
# 	annotation $k
#     done


# for k in patient_2_PM patient_4_PM patient_8_PM patient_5_PM patient_6_PM patient_7_PM
#     do
# 	tabulate $k
#     done
