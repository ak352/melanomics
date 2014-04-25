#!/bin/bash --login
module load BWA

read_group=$1
ref=$2
read1=$3
read2=$4
output=$5
cores=$6

echo "Command: bwa mem -t $cores -M -R $read_group -p $ref $read1 $read2 > $output"
date
time bwa mem -t $cores -M -R $read_group $ref $read1 $read2 > $output
date
