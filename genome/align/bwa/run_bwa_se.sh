#!/bin/bash --login
module load BWA

read_group=$1
ref=$2
read1=$3
output=$4
cores=$5

echo "Command: bwa mem -t $cores -M -R $read_group -p $ref $read1 > $output"
date
time bwa mem -t $cores -M -R $read_group $ref $read1 > $output
date
