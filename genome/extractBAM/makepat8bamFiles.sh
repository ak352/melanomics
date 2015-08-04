#!/bin/bash

gene=PTEN

makeBAM=/work/projects/melanomics/scripts/genome/extractBAM/makeBAMfilePERgene.sh

sample=patient_8_NS
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_8/NS/bam/patient_8_NS.bam
$makeBAM $gene $sample $type $bamfile

sample=patient_8_PM
type=genome
bamfile=/work/projects/melanomics/analysis/genome/patient_8/PM/bam/patient_8_PM.bam
$makeBAM $gene $sample $type $bamfile
