#!/bin/bash --login
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools

#Include the read groups in the header of the 4 lanes
echo OAR_JOBID = $OAR_JOBID
$samtools view -H $5| grep -vP '^@RG' > $5.header.sam
for k in $1 $2 $3 $4
do
    $samtools view -H $k | grep -P '^@RG' >> $5.header.sam
done

$samtools reheader $5.header.sam $5 > $6
cp $6 $5


