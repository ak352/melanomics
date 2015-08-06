#!/bin/bash --login

#OUTDIR="${SCRATCH}/ValidateSam"
OUTDIR="/work/projects/melanomics/analysis/genome/ValidateSam/primary_alignment"
mkdir -pv ${OUTDIR}

validate_sam()
{
    sample=$1
    #input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    input="/work/projects/melanomics/analysis/genome/mobster/bam/${sample}_primary.bam"
    output="${OUTDIR}/${sample}.ValSam_prim.txt"
    #output="${OUTDIR}/${sample}.ValSam.txt"
    oarsub -l nodes=1,walltime=72 -n ${sample}_val.prim "./run_valSam.sh ${input} ${output}"
}


for k in patient_2_NS #patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM #patient_2_PM
 do
    validate_sam $k
done
