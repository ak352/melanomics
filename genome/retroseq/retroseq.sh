#!/bin/bash --login

OUTDIR="/work/projects/melanomics/analysis/genome/retroseq"
mkdir -pv ${OUTDIR}

discovery()
{
  sample=$1
  bam="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
  output="${OUTDIR}/${sample}.retroseq"
  eref="/work/projects/melanomics/data/repeatMasker/sanger/Example/probes.tab"
  refTEs="/work/projects/melanomics/data/repeatMasker/sanger/Example/ref_types.tab"
  oarsub -t bigmem -l core=1,walltime=120 -n ${sample}_discov  "./run_discovery.sh ${bam} ${output} ${eref} ${refTEs}"
}

calling()
{
    sample=$1
    bam="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    input="${OUTDIR}/${sample}.retroseq"
    ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"
    output="${OUTDIR}/${sample}.retroseq.call"
    oarsub -t bigmem -l core=1,walltime=120 -n ${sample}_call  "./run_calling.sh ${bam} ${input} ${ref} ${output}"
}


#for i in 7_NS #8_NS 2_PM 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_PM 8_PM 2_NS
#    do
#	discovery patient_${i}
#    done


for i in 7_NS #8_NS 2_PM 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_PM 8_PM 2_NS
    do
	calling patient_${i}
    done
