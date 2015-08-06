


gene=$1
pos=$2
echo "Using Pan-cancer data..."
sed 's/^>.*/@&@/g' /work/projects/melanomics/data/activeDriver/data/pancancer/sequences_for_TCGA_pancancer.fa| tr -d '\n' | sed 's/@/\n/g' |sed '1d' |grep -A1 $gene| cut -c $pos
echo

