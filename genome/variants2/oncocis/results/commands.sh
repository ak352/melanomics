#!/bin/bash

#OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis/germline/results
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis/somatic/results
mkdir -v $OUTDIR

OUTDIR_soma=$OUTDIR/filtered
mkdir -v $OUTDIR_soma

#OUTDIR_germ=$OUTDIR/filtered
#mkdir -v $OUTDIR_germ

oncocis_germ_res()
{
    sample=$1
    input_germ=$OUTDIR/$sample.oncocis.germ.all.rare.txt
    out_germ=$OUTDIR_germ/$sample.oncocis.germ.rare.all.fil.txt

    python output_oncocis.py $input_germ $out_germ
}

## if sample has only one input file 
oncocis_soma_res()
{
    sample=$1
    input_soma=$OUTDIR/$sample.oncocis.soma.all.rare.txt
    out_soma=$OUTDIR_soma/$sample.oncocis.soma.rare.all.filt.txt

    python output_oncocis.py $input_soma $out_soma
}



## if sample has multiple input files
oncocis_soma_res_m()
{
    sample=$1
    out_all=$OUTDIR_soma/$sample.oncocis.soma.rare.filt.all.txt
    temp=$OUTDIR_soma/tmp
    header=$OUTDIR_soma/header
    rm $temp
    rm $header

    for k in $OUTDIR/$sample.oncocis.soma.all.rare_*.txt
    do 
	out_soma=${k##*_}
	out_soma=${out_soma%.txt} #leaves you with aa, ab
	out_soma=$OUTDIR_soma/$sample.oncocis.soma.rare.filt.$out_soma.txt
	cmd="python output_oncocis.py $k $out_soma"
	echo $cmd; eval $cmd
	head -n1 $out_soma > $header
	sed '1d' $out_soma >> $temp
    done
    
    cmd="cat $header $temp > $out_all"
    echo $cmd; eval $cmd
    head $out_all| cat -tve 
    echo ..
    tail $out_all
}


for i in 2 #6 7 4 8
    do
	#oncocis_germ_res patient_${i}
	#oncocis_soma_res patient_${i}
	oncocis_soma_res_m patient_${i}
    done
