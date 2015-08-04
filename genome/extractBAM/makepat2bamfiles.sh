#!/bin/bash



gene()
{
    gene=STK19
    makeBAM=/work/projects/melanomics/scripts/genome/extractBAM/makeBAMfilePERgene.sh
    sample=patient_2_NS
    type=genome
    bamfile=/work/projects/melanomics/analysis/genome/patient_2/NS/bam/patient_2_NS.bam
    $makeBAM $gene $sample $type $bamfile
    
    sample=patient_2_PM
    type=genome
    bamfile=/work/projects/melanomics/analysis/genome/patient_2/PM/bam/patient_2_PM.bam
    $makeBAM $gene $sample $type $bamfile
    
    sample=patient_2
    type=transcriptome
    bamfile=/work/projects/melanomics/analysis/transcriptome/patient_2/tophat_out_trimmed_NCBI_DE_SNP/tophat_out_trimmed_NCBI_DE_SNP_patient_2/accepted_hits.bam
    $makeBAM $gene $sample $type $bamfile
}

position()
{
    position=6:711485-711686
    makeBAMPosition=/work/projects/melanomics/scripts/genome/extractBAM/makeBAMfilePosition.sh
    sample=patient_8_NS
    type=genome
    bamfile=/work/projects/melanomics/analysis/genome/patient_8/NS/bam/patient_8_NS.bam
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis/germline/results/bam2
    mkdir -v $OUTDIR
    cmd="$makeBAMPosition $position $sample $type $bamfile $OUTDIR"
    echo $cmd; eval $cmd
}

#gene
position


