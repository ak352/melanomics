#!/bin/bash --login
module load samtools

k=$1
echo $k; 
(samtools view -H $k| grep -v ^@RG; samtools view -H $k| grep  ^@RG| sort -u; samtools view $k) | samtools view -bS - > $k.temp;
echo;



