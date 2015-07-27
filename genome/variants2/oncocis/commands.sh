#!/bin/bash
module load lang/Python/2.7.3-ictce-5.3.0
module load pysam

oncocis_soma()
{
    input_soma=/work/projects/melanomics/analysis/genome/variants2/filter/patient_2/somatic/patient_2.somatic.testvariants.annotated.rare
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis
    mkdir -v $OUTDIR/soma
    out_soma=$OUTDIR/patient_8.soma.rare.all.oncocis.txt

    python oncocis_input.py $input_soma $out_soma
}

oncocis_germ()
{   
    input_germ=/work/projects/melanomics/analysis/genome/variants2/filter/patient_8/germline/patient_8.testvariants.filter.annotated.germline.rare
    OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis
    mkdir -v $OUTDIR/germ
    out_germ=$OUTDIR/patient_8.germ.rare.all.oncocis.txt
    
    python oncocis_input.py $input_germ $out_germ
}

oncocis_soma
#oncocis_germ
