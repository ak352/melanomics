#!/bin/bash --login
fastqc=/work/projects/melanomics/tools/fastqc/FastQC/fastqc

fqc()
{
    input=$1
    output=$2
    #echo Input = $input
    #echo Output = $output
    #echo "time $fastqc -f fastq -o $2 $1" 
    TMPDIR=$SCRATCH/fastqc/
    mkdir $TMPDIR
    time $fastqc -f fastq -o $TMPDIR $1 
    input=${input##*/}
    cp -r $TMPDIR/${input%.fastq}_fastqc $2/.
}

#Test
#fqc test/input/test.fastq test/output/fastqc/
fqc $1 $2


