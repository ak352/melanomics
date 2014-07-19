#!/bin/bash --login


genome=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.genome
OUTDIR=${SCRATCH}/coverage_genome
mkdir -pv ${OUTDIR}


coverage()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output=${OUTDIR}/${sample}.cov
    oarsub -l nodes=1,walltime=120 -n ${sample}.cov "./run_coverage.sh ${input} ${genome} ${output}"
}


for k in patient_5_PM patient_6_PM patient_7_PM patient_4_NS NHEM patient_5_NS patient_6_NS patient_7_NS patient_2_NS patient_2_PM patient_8_NS patient_8_PM #patient_4_PM
    do
	coverage $k
    done
