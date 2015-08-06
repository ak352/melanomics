#!/bin/bash --login

MYSCRATCH=/work/projects/melanomics/analysis/genome/
OUTDIR="${MYSCRATCH}/lumpy_genome/trim"
mkdir -pv ${OUTDIR}
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"

extract_discordant()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output="${OUTDIR}/${sample}.discordant.pe.bam"
    oarsub -lwalltime=120 -n ${sample}_exDis  "./run_extractDiscordant.sh ${input} ${output}"
}


extract_sr()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output="${OUTDIR}/${sample}.sr.bam"
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/extractSplitReads_BwaMem"
    oarsub -lwalltime=120 -n ${sample}_exSR  "./run_extractSR.sh ${input} ${script} ${output}"
}


sorting_DisReads()
{
    sample=$1
    input="${OUTDIR}/${sample}.discordant.pe.bam"
    output="${OUTDIR}/${sample}.discordant.pe.sort"
    oarsub -l walltime=120 -n ${sample}_sortDisR "./run_sort.sh ${input} ${output}"
}


sorting_SR()
{
    sample=$1
    input="${OUTDIR}/${sample}.sr.bam"
    output="${OUTDIR}/${sample}.sr.sort"
    oarsub -l walltime=120 -n ${sample}_sortSR "./run_sort.sh ${input} ${output}"
}


distribution()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output="${OUTDIR}/${sample}.histo"
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/pairend_distro.py"
    oarsub -t bigsmp -lwalltime=120 -n ${sample}_histo "./run_distribution.sh ${input} ${script} ${output}"
}

lumpy_DisReads()
{
    sample=$1
    input="${OUTDIR}/${sample}.discordant.pe.sort.bam"
    output="${OUTDIR}/${sample}.pe.bedpe"
    histo_file="${OUTDIR}/${sample}.histo"
    param=`grep mean ${OUTDIR}/${sample}.mean.txt | sed 's/\t/,/g'`
    oarsub -lnodes=1,walltime=120 -n ${sample}_lumpy_disReads "./run_lumpy_disReads.sh ${input} ${histo_file} ${output} ${param}"
}

lumpy_SR()
{
    sample=$1
    input="${OUTDIR}/${sample}.sr.sort.bam"
    output="${OUTDIR}/${sample}.sr.bedpe"
    oarsub -l walltime=120 -n ${sample}_lumpy_SR "./run_lumpy_SR.sh ${input} ${output}"
}

lumpy_both()
{
    sample=$1
    input_DR="${OUTDIR}/${sample}.discordant.pe.sort.bam"
    input_SR="${OUTDIR}/${sample}.sr.sort.bam"
    histo_file="${OUTDIR}/${sample}.histo"
    param=`grep mean ${OUTDIR}/${sample}.mean.txt | sed 's/\t/,/g'`
    output="${OUTDIR}/${sample}.both.pesr.bedpe"
    oarsub -t bigmem -l core=12,walltime=120 -n ${sample}_lumpy_both "./run_lumpy_both.sh ${input_DR} ${input_SR} ${histo_file} ${param} ${output}" 
}


lumpy_matched()
{
    sample=$1
    input_t="${OUTDIR}/${sample}_PM.discordant.pe.sort.bam"
    input_n="${OUTDIR}/${sample}_NS.discordant.pe.sort.bam"
    histo_t="${OUTDIR}/${sample}_PM.histo"
    histo_n="${OUTDIR}/${sample}_NS.histo"
    param_t=`grep mean ${OUTDIR}/${sample}_PM.mean.txt | sed 's/\t/,/g'`
    param_n=`grep mean ${OUTDIR}/${sample}_NS.mean.txt | sed 's/\t/,/g'`
    output="${OUTDIR}/${sample}.tumor_v_normal.pe.bedpe"
    oarsub -t bigsmp -l core=12,walltime=120 -n ${sample}_lumpy_matched "./run_lumpy_matched.sh ${input_t} ${input_n} ${histo_t} ${histo_n} ${param_t} ${param_n} ${output}"    
}

lumpy_matched_pesr()
{
    sample=$1
    input_t="${OUTDIR}/${sample}_PM.discordant.pe.sort.bam"
    split_t="${OUTDIR}/${sample}_PM.sr.sort.bam"
    input_n="${OUTDIR}/${sample}_NS.discordant.pe.sort.bam"
    split_n="${OUTDIR}/${sample}_NS.sr.sort.bam"
    histo_t="${OUTDIR}/${sample}_PM.histo"
    histo_n="${OUTDIR}/${sample}_NS.histo"
    param_t=`grep mean ${OUTDIR}/${sample}_PM.mean.txt | sed 's/\t/,/g'`
    param_n=`grep mean ${OUTDIR}/${sample}_NS.mean.txt | sed 's/\t/,/g'`
    output="${OUTDIR}/${sample}.tumor_v_normal.pesr.bedpe"
    stdout="${OUTDIR}/${sample}.tumor_v_normal.pesr.stdout"
    stderr="${OUTDIR}/${sample}.tumor_v_normal.pesr.stderr"
    oarsub -t bigsmp -l core=12,walltime=120 -n ${sample}_lumpy_matched -O $stdout -E $stderr \
	"./run_lumpy_matched_pesr.sh ${input_t} ${split_t} ${input_n} ${split_n} ${histo_t} ${histo_n} ${param_t} ${param_n} ${output}"    
    #./run_lumpy_matched_pesr.sh ${input_t} ${split_t} ${input_n} ${split_n} ${histo_t} ${histo_n} ${param_t} ${param_n} ${output}
}    

#for k in patient_2_PM patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM patient_2_NS
 #   do
#	extract_discordant $k
 #   done

#for k in patient_2_NS patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM #patient_2_PM
#    do
#	extract_sr $k
#     done

#for k in patient_2_PM patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM patient_2_PM
#    do
#       sorting_DisReads $k
#     done


#for k in patient_2_NS patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM patient_2_PM
#    do
#	sorting_SR $k
#    done


#for k in  patient_2_NS patient_4_NS patient_2_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM patient_4_PM
#    do
#	distribution $k
#    done

#for k in  patient_2_PM patient_4_PM patient_5_NS patient_5_PM #patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM #patient_2_NS patient_4_NS
#    do
#	lumpy_DisReads $k
#    done

#for k in patient_8_PM #patient_6_PM patient_7_PM patient_2_PM patient_2_NS patient_4_NS patient_4_PM patient_5_NS patient_6_NS NHEM patient_7_NS patient_8_NS patient_5_PM
#    do
#	lumpy_SR $k
#    done

#for k in patient_2 patient_4 patient_8 patient_7 #patient_6 #patient_5
#    do
#       lumpy_matched $k
#    done

for k in patient_4 patient_8 patient_7 patient_6 patient_5 #patient_2
do
    lumpy_matched_pesr $k
done


# for k in patient_4_PM patient_8_NS #patient_7_PM patient_5_NS #patient_8_PM patient_5_PM patient_6_PM patient_2_PM #patient_4_NS  patient_2_NS patient_6_NS NHEM patient_7_NS 
#     do
#        lumpy_both $k
#     done
