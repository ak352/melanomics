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
	set $line
	input=$1
	status "Clustering variants in $line ..."
	output=$input.clusters
	bedtools cluster -d 50 -i $line > $output
	out_status $output
    done < $1
}

total()
{
    vcf=`cat $1`
    echo Counting variants in $vcf...
    cols=`grep -vP "^#" $vcf| awk -F"\t" '{print NF}' | head -n1`
    for((k=10;k<=$cols;k++))
    do
	# echo $k
	grep -vP "^#" $vcf| awk -F"\t" -vx=$k '$x!="./."'|wc -l
	# set $line
	# input=$1
	# input=$input.clusters
	# num_mutations=$input.count_output
	
	# echo Counting lines in $input...
	# wc -l $input| cut -f1 -d" " > $num_mutations
	# out_status $num_mutations
    done > $vcf.count_output
    out_status $vcf.count_output
}
    

calc_probability()
{
    while read line
    do
	set $line
	input=$1
	num_mutations=$input.count_output
	input=$input.clusters
	logfile=$input.hotspot.log
	output=$input.hotspot.out
	#input=/work/projects/melanomics/analysis/genome/variants2/hotspot//all.dna.coverage_annotated.vcf.clusters
	#num_mutations=count_output
	#logfile=/work/projects/melanomics/analysis/genome/variants2/hotspot/hotspot.log
	#output=/work/projects/melanomics/analysis/genome/variants2/hotspot/hotspot.out
	status "Calculating the mutations probabilities in the clusters..."
	status "Input cluster file: $input"
	python mutation_rate.py $input $num_mutations $logfile > $output
	out_status $output
    done < $1
}

cluster inputs
total inputs
calc_probability inputs

