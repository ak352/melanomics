
info=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.info

compute_density()
{
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/density
    mkdir -v $OUTDIR
    # 1. Measure the density of small variants
    input=$1
    output=$OUTDIR/${input##*/}.density
    python 100kb_density.py $input $info $output
    echo Info file:  $info
    echo Output written to $output

    # 2. Sort the density output by chromosome and position
    input=$OUTDIR/${input##*/}.density
    output=$input.sorted
    sed 's/chr\([0-9]\t\)/chr0\1/g' $input |sort -k1,1 -k2,2n|sed 's/chr0/chr/g' > $output
    echo Output written to $output
}

hom_percent()
{
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/hethom
    mkdir -v $OUTDIR
    # 1. Measure the density of small variants
    input=$1
    output=$OUTDIR/${input##*/}.hom_percentage
    python 100kb_het_hom_ratio.py $input $info $output
    echo Info file:  $info
    echo Output written to $output

    # 2. Sort the density output by chromosome and position
    input=$OUTDIR/${input##*/}.hom_percentage
    output=$input.sorted
    sed 's/chr\([0-9]\t\)/chr0\1/g' $input |sort -k1,1 -k2,2n|sed 's/chr0/chr/g' > $output
    echo Output written to $output
}

while read line
do
    compute_density $line
done < inputs

while read line
do
    hom_percent $line
done < inputs #test_input


