


gene=$1
echo "Using Pan-cancer data..."
sed 's/^>.*/@&@/g' /work/projects/melanomics/data/activeDriver/data/example_new/refseq_protein_sequences.txt| tr -d '\n' | sed 's/@/\n/g' |sed '1d' |grep -A1 $gene| awk -F"\t" '{if($0~/>/) print $0; else print length($0);}'
echo

echo "Using Example data..."
#length -1 because of a stop codon
sed 's/^>.*/@&@/g' /work/projects/melanomics/data/activeDriver/data/example/all_proteins.fa| tr -d '\n' | sed 's/@/\n/g' |sed '1d' |grep -A1 $gene|  awk -F"\t" '{if($0~/>/) print $0; else print length($0)-1;}'
echo

echo "Transcript used for gene $gene:"
grep $gene /work/projects/melanomics/analysis/genome/activeDriver/input/gene_symbol_to_refseq.tab
echo

# Length of the AA sequence of all the different isoforms of the gene above-  CPSF3L
echo "Length in the reference RefSeq release 69..."
grep -A1 -f <( grep $gene  /work/projects/melanomics/data/refseq/gene_symbols| cut -f1) <( sed 's/^>.*/@&@/g' /work/projects/melanomics/data/refseq/human.cds.corrected.protein.fa| tr -d '\n' | sed 's/@/\n/g' |sed '1d') | awk -F"\t" '{if($0~/>/) print $0; else print length($0)-1;}'


