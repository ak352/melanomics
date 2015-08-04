#!/bin/bash

gene=BRAF

makeBAM=/work/projects/melanomics/scripts/genome/extractBAM/makeBAMfilePERgene.sh

sample=patient_7_NS
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_7/NS/bam/patient_7_NS.bam
$makeBAM $gene $sample $type $bamfile

sample=patient_7_PM
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_7/PM/bam/patient_7_PM.bam
$makeBAM $gene $sample $type $bamfile
