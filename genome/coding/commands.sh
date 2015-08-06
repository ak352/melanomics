#!/bin/bash --login
module load BEDTools

exonic()
{
    python coding.py > temp 2>/dev/null
    sed 's/^\([0-9]\t\)/0\1/g' temp |sort -k1,1 -k2,3n | sed 's/^0//g' > temp.sorted
    
    bedtools merge -i temp.sorted > temp.sorted.merged
    ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa.fai

    ex=`awk -F"\t" '{s+=$3-$2;}END{print s;}' temp.sorted.merged`
    ge=`awk -F"\t" '{s+=$2;}END{print s;}' $ref`

    printf "size of exome (RefSeq) = %'d (%d)\n" $ex $ex
    printf "size of genome = %'d (%d)\n" $ge $ge
    
    per=`perl -le "print ($ex*100/$ge)";`
    printf "Exome percentage = %2.2f %%\n" $per
    
}

exonic