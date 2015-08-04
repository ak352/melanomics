#!/bin/bash

annotation="/work/projects/melanomics/data/NCBI/hg19_refGene.txt"
samtools="/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools"

genename=$1
sample=$2
type=$3
bamfile=$4

genechr=`grep -P  "\t"$genename"\t" $annotation | cut -f 3  | perl -ane '$_=~s/chr//; print $_;'`
genestart=`grep -P  "\t"$genename"\t" $annotation | cut -f 5`
genestop=`grep -P  "\t"$genename"\t" $annotation | cut -f 6`


fbname=$(basename $bamfile .bam)
output=$sample.$type.$genename.$genechr.$genestart.$genestop.bam
index=$bamfile.bai

# check for bamfile index
if [ ! -f $index ]
then
      $samtools index $bamfile
    fi
    # get alignments
    $samtools view -b -o $output $bamfile $genechr:$genestart-$genestop
    # make bamfile index
    $samtools index $output
