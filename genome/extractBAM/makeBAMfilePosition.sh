#!/bin/bash

samtools="/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools"


position=$1 #e.g. chr1:10-15
sample=$2
type=$3
bamfile=$4
OUTDIR=$5

chr=`echo $position | cut -f1 -d ":" `
start=`echo $position | cut -f2 -d ":" | cut -f1 -d"-"`
stop=`echo $position | cut -f2 -d ":"| cut -f2 -d "-"`


fbname=$(basename $bamfile .bam)
output=$OUTDIR/$sample.$type.$chr.$start.$stop.bam
index=$bamfile.bai

# check for bamfile index
if [ ! -f $index ]
then
    cmd="$samtools index $bamfile"
    echo $cmd; eval $cmd;
fi

# get alignments
cmd="$samtools view -b -o $output $bamfile $chr:$start-$stop"
echo $cmd; eval $cmd
# make bamfile index
cmd="$samtools index $output"
echo $cmd; eval $cmd
