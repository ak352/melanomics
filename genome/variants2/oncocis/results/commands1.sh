#!/bin/bash

#OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis/germline/results
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis/somatic/results
mkdir -v $OUTDIR

OUTDIR_soma=$OUTDIR/filtered
mkdir -v $OUTDIR_soma


oncocis_germ_res()
{
    sample=$1
    input_germ=$OUTDIR/$sample.oncocis.germ.all.rare.txt
    OUTDIR_germ=$OUTDIR/filtered
    mkdir -v $OUTDIR_germ
    out_germ=$OUTDIR_germ/$sample.oncocis.germ.rare.all.fil.txt

    python output_oncocis.py $input_germ $out_germ
}


oncocis_soma_res()
{
    sample=$1
    for k in $OUTDIR/$sample.oncocis.soma.all.rare_*.txt
	do 
	
	out_soma=$OUTDIR_soma/$sample.oncocis.soma.rare.all.txt

	python output_oncocis.py $k $out_soma
}




for i in 7 #6 4 2 8
    do
	#oncocis_germ_res patient_${i}
	oncocis_soma_res patient_${i}
    done
