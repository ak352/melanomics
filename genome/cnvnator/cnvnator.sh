#!/bin/bash --login

OUTDIR="/work/projects/melanomics/analysis/genome/cnvnator/binSize100"
mkdir -pv ${OUTDIR}

readMapping()
{
sample=$1
output="${OUTDIR}/${sample}.root.orig_readMap"
bam="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
oarsub -t bigsmp -l core=12,walltime=12 -n ${sample}_readMapping  "./run_readMapping.sh ${output} ${bam}"
#./run_readMapping.sh ${name} ${output} ${bam}
}


histogram()
{
sample=$1
input="${OUTDIR}/${sample}.root"
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/Chromosomes"
oarsub -l core=2,walltime=12 -n ${sample}_histo_1000  "./run_histo.sh ${input} ${ref}"
}


stats()
{
sample=$1
input="${OUTDIR}/${sample}.root"
oarsub -l core=2,walltime=12 -n ${sample}_stats_1000 "./run_stats.sh ${input}"
}


rdSignalPart()
{
sample=$1
input="${OUTDIR}/${sample}.root"
oarsub -l core=2,walltime=24 -n ${sample}_rdSignalPart_1000  "./run_rdSignalPart.sh ${input}"
}


cnv()
{
sample=$1
input="${OUTDIR}/${sample}.root"
output="${OUTDIR}/${sample}.cnv"
oarsub -t bigsmp -l core=2,walltime=12 -n ${sample}_cnv_1000  "./run_cnv.sh ${input} > ${output}"
}


#for i in  2_NS 2_PM 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_NS 7_PM 8_NS 8_PM
#    do
#        readMapping patient_${i}
#    done

#for i in 7_NS 8_NS 2_NS 2_PM 4_NS 6_PM 8_PM 4_PM 5_NS 5_PM 6_NS 7_PM
#    do
#        histogram  patient_${i}
#    done


#for i in 2_NS 2_PM 4_NS 6_PM 8_PM 4_PM 5_NS 5_PM 6_NS 7_PM 7_NS 8_NS
#   do
#        stats patient_${i}
#    done


#for i in 7_NS 8_NS 2_NS 4_PM 5_NS 5_PM 6_NS 7_PM 2_PM 4_NS 8_PM 6_PM 
#    do
#        rdSignalPart patient_${i}
#    done


for i in 7_NS 8_NS #2_PM 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_PM 8_PM 2_NS 
    do
        cnv patient_${i}
    done
