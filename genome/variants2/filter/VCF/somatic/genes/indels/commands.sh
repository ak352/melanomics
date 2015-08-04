#!/bin/bash --login


# Filters somatic mutations for mutations rare in the population
rare()
{
    for k in 2 4 5 7 8
    do
	patient=patient_$k
	INDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$patient/
	input=$INDIR/somatic/indels/$patient.somatic_indels.testvariants.annotated
	output=$INDIR/somatic/indels/$patient.somatic_indels.testvariants.annotated.rare
	python rare_variants.py $input $output
    done
}

aachanging()
{
    for k in 2 4 5 7 8
    do
	patient=patient_$k
	INDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$patient/
	input=$INDIR/somatic/indels/$patient.somatic_indels.testvariants.annotated.rare
	output=$INDIR/somatic/indels/$patient.somatic_indels.testvariants.annotated.rare.aachanging
	echo "[$patient] Writing somatic variants... "
	#cut -f86-87 $input | sort -u
	#cut -f 1-13,15,17,19,22-26,47-75 $input | head -n1 | sed 's/\t/\n/g' #> $output1
	(head -n1 $input; sed '1d' $input \
	    | awk -F"\t" '(($22=="exonic" && $25!="synonymous SNV")|| $22=="splicing" || $22=="exonic;splicing")';) \
	    > $output
	wc -l $input
	wc -l $output

    done
}    


# Creates a per-gene summary of the types of mutations
# TODO: CNVs and SVs
gene_summary()
{
    for k in 2 4 5 7 8
    do 
	patient=patient_$k
	INDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$patient/somatic/indels/
	OUTDIR=/work/projects/melanomics/analysis/genome/variants2/filter/$patient/somatic/indels/genes/
	mkdir -v $OUTDIR
	input=$INDIR/$patient.somatic_indels.testvariants.annotated.rare
	output=$OUTDIR/genes.$patient.somatic_indels.testvariants.annotated.rare
	
	python per_gene.py $input $output
    done
}    
# Annotations
annotations()
{
    cut -f17  $input | sed '1d' |sort -u| sed 's/;/\n/g' | sort -u > func_annotations
}


# Genes related to clinVAR

# tawk '$73!=""' /work/projects/melanomics/analysis/genome/variants2/filter/patient_2/patient_2.somatic.testvariants.annotated |cut -f73

# Pipeline
cd ..
rare
#aachanging
#gene_summary
cd indels
