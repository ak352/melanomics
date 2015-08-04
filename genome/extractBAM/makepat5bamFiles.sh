#!/bin/bash

gene=BRAF

makeBAM=/work/projects/melanomics/scripts/genome/extractBAM/makeBAMfilePERgene.sh

sample=patient_5_NS
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_5/NS/bam/patient_5_NS.bam
$makeBAM $gene $sample $type $bamfile

sample=patient_5_PM
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_5/PM/bam/patient_5_PM.bam
$makeBAM $gene $sample $type $bamfile
