#!/bin/bash

gene=BRAF

makeBAM=/work/projects/melanomics/user/patrick/makeBAMfilePERgene.sh

sample=patient_6_NS
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_6/NS/bam/patient_6_NS.bam
$makeBAM $gene $sample $type $bamfile

sample=patient_6_PM
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_6/PM/bam/patient_6_PM.bam
$makeBAM $gene $sample $type $bamfile

sample=patient_6
type=transcriptome
bamfile=/work/projects/melanomics/analysis/transcriptome/patient_6/tophat_out_trimmed_NCBI_DE_SNP/tophat_out_trimmed_NCBI_DE_SNP_patient_6/accepted_hits.bam
$makeBAM $gene $sample $type $bamfile


