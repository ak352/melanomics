#!/bin/bash --login

OUTDIR=${SCRATCH}/kmc_genome
mkdir -pv ${OUTDIR}


kmc()
{
    sample=$1
    input="/scratch/users/sreinsbach/kmc_genome/${sample}_all.fq"
    output="${OUTDIR}/${sample}.kmc"
    work_dir="${SCRATCH}/kmc_tmp"
    oarsub -l nodes=1,walltime=120 -n ${sample}.kmc "./run_kmc.sh ${input} ${output} ${work_dir}"
}


kmc_dump()
{
    sample=$1
    input="${OUTDIR}/${sample}.kmc"
    output="${OUTDIR}/${sample}.kmc_dump"
    oarsub -l nodes=1,walltime=120 -n ${sample}.kmc_dump "./run_kmc_dump.sh ${input} ${output}"
}

#for k in NHEM #patient_4_PM patient_5_PM patient_6_PM patient_7_PM patient_4_NS patient_5_NS patient_6_NS patient_7_NS patient_2_NS patient_2_PM patient_8_NS patient_8_PM
 #   do
#	kmc $k
#    done


for k in NHEM #patient_4_PM patient_5_PM patient_6_PM patient_7_PM patient_4_NS patient_5_NS patient_6_NS patient_7_NS patient_2_NS patient_2_PM patient_8_NS patient_8_PM
    do
	kmc_dump $k
   done
