#!/bin/bash --login
module load SAMtools

status()
{
    d=`date`
    echo [$d] $1
}

out_status()
{
    d=`date`
    echo [$d] Output written to $1
    wc -l $1
}

status "Extracting paired-end reads from $1..."
samtools view -b -f 0x0001 $1 > $2
out_status $2
