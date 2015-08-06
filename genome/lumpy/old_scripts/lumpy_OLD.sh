#!/bin/bash --login

OUTDIR="${SCRATCH}/lumpy_genome/trim"
mkdir -pv ${OUTDIR}
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"
ref_indes="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.X11_01_65525S"

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


extract_notrim()
{
    sample=$1
    input="/work/projects/melanomics/analysis/genome/${sample}/bam/${sample}.bam"
    output="${OUTDIR}/${sample}.discordant.pe.sort.noTrim.sam"
    oarsub -l walltime=120 -n ${sample}_exNotrim "./run_exNotrim.sh ${input} ${output}"
}


distribution_disReads()
{
    sample=$1
    input="${OUTDIR}/${sample}.discordant.pe.sort.noTrim.sam"
    output="${OUTDIR}/${sample}.pe.histo"
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/pairend_distro.py"
    #script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/pairend_distro_akrishna2.py"
    oarsub -lwalltime=120 -n ${sample}_histo_disReads "./run_lumpy_distribution_disReads_trim.sh ${input} ${script} ${output}"
}

lumpy_DisReads()
{
    sample=$1
    input="${OUTDIR}/${sample}.discordant.pe.sort.bam"
    output="${OUTDIR}/${sample}.pe.bedpe"
    oarsub -lnodes=1,walltime=120 -n ${sample}_lumpy_disReads.sh "./run_lumpy_disReads.sh ${input} ${output}"
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
    histo_file="${OUTDIR}/${sample}.pe.histo"
    param=`grep mean ${OUTDIR}/${sample}.mean.txt | sed 's/\t/,/g'`
    output="${OUTDIR}/${sample}.both.pesr.bedpe"
    oarsub -t bigmem -l core=6,walltime=120 -n ${sample}_lumpy_both "./run_lumpy_both.sh ${input_DR} ${input_SR} ${histo_file} ${param} ${output}" 
}


lumpy_matched()
{
    sample=$1
    input_t="${OUTDIR}/${sample}_PM.discordant.pe.sort.bam"
    input_n="${OUTDIR}/${sample}_NS.discordant.pe.sort.bam"
    histo_t="${OUTDIR}/${sample}_PM.pe.histo"
    histo_n="${OUTDIR}/${sample}_NS.pe.histo"
    param_t=`grep mean ${OUTDIR}/${sample}_PM.mean.txt | sed 's/\t/,/g'`
    param_n=`grep mean ${OUTDIR}/${sample}_NS.mean.txt | sed 's/\t/,/g'`
    output="${OUTDIR}/${sample}.tumor_v_normal.pe.bedpe"
    oarsub -t bigmem -l core=6,walltime=120 -n ${sample}_lumpy_matched "./run_lumpy_matched.sh ${input_t} ${input_n} ${histo_t} ${histo_n} ${param_t} ${param_n} ${output}"    
}

coverage()
{
    sample=$1
    input_pe=""
    input_sr=""
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/get_coverages.py"
    oarsub -l walltime=120 -n ${sample}_lumpy_matched "./run_lumpyMatched.sh ${input} ${output}"
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

#for k in patient_2_PM patient_2_PM patient_4_NS #patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM #patient_2_NS
#    do
#	extract_notrim $k
#    done

#for k in  patient_2_NS patient_4_NS patient_2_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM #patient_4_PM
#    do
#	distribution_disReads $k
#    done

#for k in  patient_2_NS #patient_2_PM patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM NHEM
#    do
#       lumpy_disReads $k
#    done

#for k in patient_8_PM #patient_6_PM patient_7_PM patient_2_PM patient_2_NS patient_4_NS patient_4_PM patient_5_NS patient_6_NS NHEM patient_7_NS patient_8_NS patient_5_PM
#    do
#	lumpy_SR $k
#    done

for k in patient_4 #patient_5 #patient_8 patient_6 patient_7 patient_2
    do
       lumpy_matched $k
    done


#for k in patient_4_NS #patient_2_NS patient_4_PM patient_6_NS NHEM patient_7_NS patient_8_NS #patient_8_PM patient_5_PM patient_6_PM patient_7_PM patient_2_PM patient_5_NS
#    do
#       lumpy_both $k
#    done
