#!/bin/bash --login


genome=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.genome
OUTDIR=${SCRATCH}/coverage_genome/tgen
mkdir -pv ${OUTDIR}


coverage()
{
    sample=$1
    input="/work/projects/melanomics/data/rawdata/Susanne/bams/$sample"
    output=${OUTDIR}/${sample%.bam.prmdup.bam}.cov
    #./run_coverage.sh ${input} ${genome} ${output}
    oarsub -l walltime=120 -n ${sample}.cov "./run_coverage.sh ${input} ${genome} ${output}"
}


#for k in merged_5_NS.bam.prmdup.bam  merged_7_PM.bam.prmdup.bam  merged_S2_PM.bam.prmdup.bam  merged_S6_NS.bam.prmdup.bam   remerge.S4_NS.bam.prmdup.bam merged_5_PM.bam.prmdup.bam  merged_NHEM.bam.prmdup.bam  merged_S3_PM.bam.prmdup.bam  merged_S6_PM.bam.prmdup.bam merged_7_NS.bam.prmdup.bam  merged_S2.bam.prmdup.bam    merged_S4_PM.bam.prmdup.bam  remerge.S3_NS.bam.prmdup.bam
for k in merged_5_NS.bam merged_5_PM.bam merged_7_NS.bam merged_7_PM.bam merged_NHEM.bam merged_S2.bam merged_S2_PM.bam merged_S3_PM.bam merged_S4_PM.bam merged_S6_NS.bam merged_S6_PM.bam remerge.S3_NS.bam remerge.S4_NS.bam
    do
	coverage $k
    done
