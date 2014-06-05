#!/bin/bash --login
module load SAMtools

fname=$1
echo ${fname##*/}
samtools flagstat $1
echo

