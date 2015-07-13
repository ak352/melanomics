#!/bin/bash --login
samtools=/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools
PICARD=/work/projects/melanomics/tools/picard/picard-tools-1.95/

#Get the all arguments except last two
argc=$#
x=$((argc-1))
merged=${!x}
x=$((argc))
reheadered=${!x}


echo OAR_JOBID = $OAR_JOBID

#Set the input BAM file names
k=1
input_bams=
while [ $k -lt $((argc-1)) ]
do
    input_bams="$input_bams ${!k}"
    k=$((k+1))
done

cmd="$samtools merge -f $merged $input_bams"
rm -f $merged
eval $cmd

echo input bams = $input_bams
echo merged = $merged
echo reheadered = $reheadered


#Include the read groups in the header of the all lanes
$samtools view -H $merged| grep -vP '^@RG' > $merged.header.sam
for k in $input_bams
do
    $samtools view -H $k | grep -P '^@RG' >> $merged.header.sam
done

$samtools reheader $merged.header.sam $merged > $reheadered
rsync -avz --progress $reheadered $merged


#Index the merged BAM file
java -jar $PICARD/BuildBamIndex.jar \
    INPUT=$merged


