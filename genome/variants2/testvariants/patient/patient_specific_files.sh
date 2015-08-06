input=/work/projects/melanomics/analysis/genome/variants2/all.dna.coverage_annotated.testvariants
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/separate_testvariants
mkdir -v $OUTDIR

grep "^>" $input| cut -f9- | sed 's/\t/\n/g' > patients

k=0
while read line
do
    echo $k
    output=$OUTDIR/$line.testvariants
    cut -f1-8,$((9+k)) $input | awk -F"\t" '$9~1' > $output
    echo Output written to $output
    k=$((k + 1))
done < patients

