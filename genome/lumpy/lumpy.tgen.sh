#!/bin/bash --login

OUTDIR="${SCRATCH}/lumpy_genome/tgen"
mkdir -pv ${OUTDIR}
ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"
ref_indes="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.X11_01_65525S"


extract_discordant()
{
    sample=$1
    #input="/work/projects/melanomics/data/rawdata/Susanne/bams/merged_${sample}.bam.prmdup.bam"
    input="/work/projects/melanomics/data/rawdata/Susanne/bams/remerge.${sample}.bam.prmdup.bam"
    output="${OUTDIR}/${sample}.tgen.discordant.pe.bam"
    oarsub -lwalltime=120 -n ${sample}_exDis_tgen  "./run_extractDiscordant.sh ${input} ${output}"
}


extract_sr()
{
    sample=$1
    #input="/work/projects/melanomics/data/rawdata/Susanne/bams/merged_${sample}.bam.prmdup.bam"
    input="/work/projects/melanomics/data/rawdata/Susanne/bams/remerge_${sample}.bam.prmdup.bam"
    output="${OUTDIR}/${sample}.tgen.sr.bam"
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/extractSplitReads_BwaMem"
    oarsub -lwalltime=120 -n ${sample}_exSR_tgen  "./run_extractSR.sh ${input} ${script} ${output}"
}


sorting_DisReads()
{
    sample=$1
    input="${OUTDIR}/${sample}.tgen.discordant.pe.bam"
    output="${OUTDIR}/${sample}.tgen.discordant.pe.sort"
    oarsub -l walltime=120 -n ${sample}_sortDisR_tgen "./run_sort.sh ${input} ${output}"
}


sorting_SR()
{
    sample=$1
    input="${OUTDIR}/${sample}.tgen.sr.bam"
    output="${OUTDIR}/${sample}.tgensr.sort"
    oarsub -l walltime=120 -n ${sample}_sortSR_tgen "./run_sort.sh ${input} ${output}"
}


distribution_disReads()
{
    sample=$1
    input="${OUTDIR}/${sample}.tgen.discordant.pe.sort.bam"
    output="${OUTDIR}/${sample}.tgen.pe.histo"
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/pairend_distro.py"
    #script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/pairend_distro_akrishna.py"
    oarsub -lwalltime=120 -n ${sample}_histo_disReads_tgen "./run_lumpy_distribution_disReads.sh ${input} ${script} ${output}"
}

lumpy_SR()
{
    sample=$1
    input="${OUTDIR}/${sample}.tgen.discordant.pe.sort.bam"
    output="${OUTDIR}/${sample}.tgen.pe.bedpe"
    oarsub -lnodes=1,walltime=120 -n ${sample}_lumpy_disReads_tgen "./run_lumpy_disReads.sh ${input} ${output}"
}

lumpy_SR()
{
    sample=$1
    input="${OUTDIR}/${sample}.tgen.sr.sort.bam"
    output="${OUTDIR}/${sample}.tgen.sr.bedpe"
    oarsub -l walltime=120 -n ${sample}_lumpy_SR_tgen "./run_lumpy_SR.sh ${input} ${output}"
}

lumpy_both()
{
    sample=$1
    input_DR="${OUTDIR}/${sample}.tgen.discordant.pe.sort.bam"
    input_SR="${OUTDIR}/${sample}.tgen.sr.sort.bam"
    histo_file="${OUTDIR}/${sample}.tgen.pe.histo"
    mean=""
    stdev=""
    output="${OUTDIR}/${sample}.tgen.pesr.bedpe"
    oarsub -l walltime=120 -n ${sample}_lumpy_both_tgen "./run_lumpyBoth.sh ${input_DR} ${input_SR} ${histo_file} ${mean} ${stdev} ${output}" 
}


lumpy_matched()
{
    sample=$1
    input_t=""
    input_n=""
    histo_t="${OUTDIR}/${sample}.tgen.pe.histo"
    histo_n="${OUTDIR}/${sample}.tgen.pe.histo"
    mean=""
    stdev=""
    output="${OUTDIR}/${sample}.tgen.tumor_v_normal.pe.bedpe"
    oarsub -l walltime=120 -n ${sample}_lumpy_matched_tgen "./run_lumpyMatched.sh ${input_t} ${input_n} ${histo_file_t} ${histo_file_n} ${mean} ${stdev} ${output}"    
}

coverage()
{
    sample=$1
    input_pe=""
    input_sr=""
    script="/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/get_coverages.py"
    oarsub -l walltime=120 -n ${sample}_lumpy_matched_tgen "./run_lumpyMatched.sh ${input} ${output}"
    
}


#for k in S4_NS S3_NS #S2_PM 5_NS S6_NS 7_NS S3_PM S4_PM 5_PM S6_PM 7_PM NHEM #S2
#   do
#	extract_discordant $k
#   done

#for k in S4_NS S3_NS #S2_PM 5_NS S6_NS 7_NS S3_PM S4_PM 5_PM S6_PM 7_PM NHEM #S2
#    do
#	extract_sr $k
#     done

#for k in S2 S2_PM 5_NS S6_NS 7_NS S3_PM S3_NS S4_NS S4_PM 5_PM S6_PM 7_PM NHEM
#    do
#       sorting_DisReads $k
#     done


#for k in S2 S2_PM 5_NS S6_NS 7_NS S3_NS S3_PM S4_NS S4_PM 5_PM S6_PM 7_PM NHEM
#    do
#	sorting_SR $k
#    done

for k in S2_PM #S2 5_NS S6_NS 7_NS S3_NS S3_PM S4_PM S4_NS 5_PM S6_PM 7_PM NHEM 
    do
	distribution_disReads $k
    done

#for k in  S2 S2_PM 5_NS S6_NS 7_NS S3_NS S3_PM S4_PM S4_NS 5_PM S6_PM 7_PM NHEM
#    do
#       lumpy_disReads $k
#    done

#for k in S2 S2_PM 5_NS S6_NS 7_NS S3_NS S3_PM S4_NS S4_PM 5_PM S6_PM 7_PM NHEM
#    do
#	lumpy_SR $k
#    done

