#!/bin/bash --login

OUTDIR=${SCRATCH}/breakfast_genome
mkdir -pv ${OUTDIR}
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome"
blacklist=${OUTDIR}/blacklist.txt
annofile="/work/projects/melanomics/tools/breakfast/data/ensembl_genes.bed"

detection()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output=${OUTDIR}/${sample}.bf
    oarsub -t bigmem -l walltime=120 -n ${sample}.bf "./run_detection.sh ${input} ${ref} ${output}"
    # ./run_detection.sh ${input} ${ref} ${output}
}


blacklist()
{
    sample=$1
    input="/scratch/users/sreinsbach/breakfast_genome/${sample}.bf.sv"
    output=${OUTDIR}/${sample}.bf.blacklist.txt
    #./run_blacklist.sh ${input} ${output}
    oarsub -t bigmem -l walltime=120 -n ${sample}.bl "./run_blacklist.sh ${input} ${output}"
}


create_blacklist()
{
    oarsub -l/host=1/core=2,walltime=12 -n create_blacklist -O $OUTDIR/create_blacklist.stdout -E $OUTDIR/create_blacklist.stderr \
	"./run_create_blacklist.sh $blacklist"
}


filtering()
{
    sample=$1
    input=${OUTDIR}/${sample}.bf.sv
    output=${OUTDIR}/${sample}.bf.filtered.sv
    ./run_filtering.sh ${input} ${output} ${blacklist}
    # oarsub -t bigmem -l walltime=120 -n ${sample}.filter "./run_filtering.sh ${input} ${output} ${blacklist}"
}


annotation()
{
    sample=$1
    input=${OUTDIR}/${sample}.bf.filtered.sv
    output=${OUTDIR}/${sample}.bf.filtered.anno.sv
    oarsub -t bigmem -l walltime=120 -n ${sample}.anno "./run_annotation.sh ${input} ${output} ${annofile}"
}


tabulate()
{
    sample=$1
    input=${OUTDIR}/${sample}.bf.filtered.anno.sv
    output=${OUTDIR}/${sample}.bf.filtered.anno.cand.sv
    oarsub -t bigmem -l walltime=120 -n ${sample}.cand "./run_tabulate.sh ${input} ${output}"
}


#for k in patient_4_PM patient_8_PM patient_5_PM patient_6_PM patient_7_PM patient_4_NS patient_8_NS NHEM patient_5_NS patient_6_NS patient_7_NS #patient_2_PM patient_2_NS 
#    do 
#      detection $k
#    done


# for k in patient_4_NS patient_8_NS NHEM patient_5_NS patient_6_NS patient_7_NS #patient_2_NS
#     do
# 	blacklist $k
#     done

# create_blacklist

 for k in patient_4_PM #patient_4_PM patient_8_PM patient_5_PM patient_6_PM patient_7_PM 
     do
       filtering $k
     done


# for k in patient_2_PM patient_4_PM patient_8_PM patient_5_PM patient_6_PM patient_7_PM
#     do
# 	annotation $k
#     done


# for k in patient_2_PM patient_4_PM patient_8_PM patient_5_PM patient_6_PM patient_7_PM
#     do
# 	tabulate $k
#     done
