ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
echo "ref=$ref"

for k in 2 4 6 7 8
do
    for m in PM NS
    do
	bam=/work/projects/melanomics/analysis/genome/patient_${k}_${m}/bam/patient_${k}_${m}.bam
	echo "bam=$bam"
    done
done
echo

for k in /work/projects/melanomics/data/rawdata/Susanne/bams/*.bam
do
    bam=$k
    echo "bam=$bam"
done
location="12:58240187-58240188"

export ref
echo $location 
echo samtools tview "\$bam \$ref"

