#!/bin/bash --login

OUTDIR="/work/projects/melanomics/analysis/genome/mutect"
mkdir -pv ${OUTDIR}

mutect()
{
sample=$1
normal="/work/projects/melanomics/analysis/genome/${sample}_NS/bam/${sample}_NS.bam"
tumor="/work/projects/melanomics/analysis/genome/${sample}_PM/bam/${sample}_PM.bam"
output="${OUTDIR}/${sample}.call_stats.out"
vcf="${OUTDIR}/${sample}.vcf"
coverage_file="${OUTDIR}/${sample}.coverage.wig.txt"
oarsub -l core=2,walltime=120 -n ${sample}_mutect  "./run_mutect.sh ${normal} ${tumor} ${output} ${vcf} ${coverage_file}"
}

for i in patient_2 patient_5 patient_6 patient_7 patient_8 #patient_4
    do
	mutect ${i}
    done
