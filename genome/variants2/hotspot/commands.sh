#!/bin/bash --login

source paths
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/hotspot/
mkdir -v $OUTDIR


status()
{
    d=`date`
    echo [$d] $1
}

out_status()
{
    d=`date`
    echo [$d] Output written to $1
    wc -l $1
}

cluster()
{
    while read line
    do
	status "Clustering variants in $line ..."
	output=$OUTDIR/${line##*/}.clusters
	bedtools cluster -d 50 -i $line > $output
	out_status $output
    done < $1
}

calc_probability()
{
    input=/work/projects/melanomics/analysis/genome/variants2/hotspot//all.dna.coverage_annotated.vcf.clusters
    num_mutations=count_output
    logfile=/work/projects/melanomics/analysis/genome/variants2/hotspot/hotspot.log
    output=/work/projects/melanomics/analysis/genome/variants2/hotspot/hotspot.out
    status "Calculating the mutations probabilities in the clusters..."
    status "Input cluster file: $input"
    python mutation_rate.py $input $num_mutations $logfile > $output
    out_status $output
}

#cluster inputs
calc_probability

