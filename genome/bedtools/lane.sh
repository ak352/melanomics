#!/bin/bash --login


genome=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.genome
OUTDIR=${SCRATCH}/coverage_genome/lane/
mkdir -pv ${OUTDIR}


coverage()
{
    sample=$1
    input=$sample
    output=${sample##*/}
    output=${output%.bam}
    output=${OUTDIR}/${output}.cov
    #./run_coverage.sh ${input} ${genome} ${output}
    oarsub -l walltime=24 -n ${sample##*/}.cov "./run_coverage.sh ${input} ${genome} ${output}"
}


for k in /scratch/users/sreinsbach/bwa/NHEM.120827.lane8.pe.bam  /scratch/users/sreinsbach/bwa/NHEM.120912.lane5.pe.bam  /scratch/users/sreinsbach/bwa/NHEM.120912.lane8.pe.bam /scratch/users/sreinsbach/bwa/NHEM.120912.lane3.pe.bam  /scratch/users/sreinsbach/bwa/NHEM.120912.lane6.pe.bam /scratch/users/sreinsbach/bwa/NHEM.120912.lane4.pe.bam  /scratch/users/sreinsbach/bwa/NHEM.120912.lane7.pe.bam
    do
	coverage $k
    done
