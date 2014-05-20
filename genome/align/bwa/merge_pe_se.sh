#!/bin/bash --login
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools

cmds()
{
    rm -f ${1%.sam}.bam
    rm -f ${2%.sam}.bam
    rm -f $3
    time $samtools view -bS $1 > ${1%.sam}.bam
    time $samtools view -bS $2 > ${2%.sam}.bam
    time $samtools merge -f $3  ${1%.sam}.bam ${2%.sam}.bam
}

run()
{
    date
    echo Merging $1 and $2 into $3...
    time cmds $1 $2 $3 
    date
    echo Done
}

run $1 $2 $3




