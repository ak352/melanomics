#!/bin/bash

samtools="/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools"
bamfile=$1
chr=$2
start=$3
stop=$4

fbname=$(basename $bamfile .bam)
output=$fbname.$chr.$start.$stop.bam
index=$bamfile.bai

# check for bamfile index
if [ ! -f $index ]
then
    $samtools index $bamfile 
fi
# get alignments
$samtools view -b -o $output $bamfile $chr:$start-$stop 
# make bamfile index
$samtools index $output


