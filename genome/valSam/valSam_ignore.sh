#!/bin/bash --login

OUTDIR="/work/projects/melanomics/analysis/genome/ValidateSam/ignore"
mkdir -pv ${OUTDIR}

validate_sam()
{
  sample=$1
  input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
  output="${OUTDIR}/${sample}.ValSam.ignore.MATE-NOT-FOUND.txt"
  ignore="MATE_NOT_FOUND"
  oarsub -l walltime=12 -n ${sample}_val.ign "./run_valSam_ignore.sh ${input} ${output} ${ignore}"
}

for i in 2_NS 8_NS 2_PM 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_PM 8_PM #7_NS
    do
	validate_sam patient_${i}
    done
