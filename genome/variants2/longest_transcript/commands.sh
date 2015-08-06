#!/bin/bash --login


fasta=/work/projects/melanomics/data/refseq/human.cds.corrected.fa
symbols=/work/projects/melanomics/data/refseq/gene_symbols
output=/work/projects/melanomics/analysis/genome/variants2/longest_transcript/refseq_longest_transcripts
# paste length of CDS and gene symbol, followed by sorting based on CDS length, 
# followed by choosing the transcript with the longest CDS
echo -e "refseq_longest\tcds_length\tsymbol" > $output
paste \
    <( sed 's/^>.*/@&#/g' $fasta \
    | tr -d '\n' | sed 's/@/\n/g'| sed 's/#/\t/g' | sed '1d'| \
    awk '{print $1,"\t",length($2);}'| cut -c2- | sort -k1,1) \
    <( grep ^NM $symbols \
    | sort -k1,1) \
    | sort -k4,4 -k2,2nr \
    | sort -uk4,4 \
    | cut -f1,2,4 \
    | sed -e 's/\[//g' -e "s/'//g" -e 's/\]//g' \
    >> $output

echo Output written to $output 


