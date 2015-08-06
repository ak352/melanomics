


gene=$1
pos=$2
echo "Using RefSeq..."
sed 's/^>.*/@&@/g' /work/projects/melanomics/data/refseq/human.cds.corrected.protein.fa| tr -d '\n' | sed 's/@/\n/g' |sed '1d' |grep -A1 $gene| cut -c $pos
echo

