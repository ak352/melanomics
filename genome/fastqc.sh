#!/bin/bash --login
fastqc=/work/projects/melanomics/tools/fastqc/FastQC/fastqc

fqc()
{
    input=$1
    output=$2
    time $fastqc -f fastq -o $2 $1 
}

#Test
fqc test/input/test.fastq test/output/fastqc/
