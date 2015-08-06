#!/bin/bash --login

DIR="${SCRATCH}/lumpy_genome/trim"
OUTDIR="${SCRATCH}/lumpy_genome/trim/excluded"
mkdir -pv ${OUTDIR}


exclude_highCov()
{
    sample=$1
    input_DR="${DIR}/${sample}.discordant.pe.sort.bam"
    input_SR="${DIR}/${sample}.sr.sort.bam"
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/get_coverages.py"
    oarsub -t bigsmp -l walltime=120 -n ${sample}_exCov "./run_exCov.sh ${input_DR} ${input_SR} ${script}"
}


get_highCov()
{
    sample=$1
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/get_exclude_regions.py"
    cov=10
    ex_file="${OUTDIR}/${sample}.exclude.bed"
    input_DR="${DIR}/${sample}.discordant.pe.sort.bam"
    input_SR="${DIR}/${sample}.sr.sort.bam"
    oarsub -l nodes=1,walltime=120 -n ${sample}_getCov "./run_getCov.sh ${script} ${cov} ${ex_file} ${input_DR} ${input_SR}"
}


lumpy_both()
{
    sample=$1
    input_DR="${OUTDIR}/${sample}.discordant.pe.sort.bam"
    input_SR="${OUTDIR}/${sample}.sr.sort.bam"
    histo_file="${OUTDIR}/${sample}.pe.histo"
    param=`grep mean ${OUTDIR}/${sample}.mean.txt | sed 's/\t/,/g'`
    output="${OUTDIR}/${sample}.both.pesr.exclude.bedpe"
    exclude_file="${OUTDIR}/${sample}.exclude.bed"
    oarsub -l nodes=1,walltime=120 -n ${sample}_lumpy_both "./run_lumpy_both_exclude.sh ${input_DR} ${input_SR} ${histo_file} ${param} ${output} ${exclude_file}"
}


for k in 8_PM 2_NS 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_NS 7_PM 8_NS 2_PM #NHEM
    do
     exclude_highCov patient_$k #$k
   done


#for k in NHEM #2_PM 8_PM 2_NS 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_NS 7_PM 8_NS
#    do
#	get_highCov $k #patient_$k
#    done


#for k in NHEM #2_PM 8_PM 2_NS 4_NS 4_PM 5_NS 5_PM 6_NS 6_PM 7_NS 7_PM 8_NS
#    do
#	get_highCov $k #patient_$k
#    done

