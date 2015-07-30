#!/bin/bash
module load lang/Python/2.7.3-ictce-5.3.0
module load pysam

OUTDIR=/work/projects/melanomics/analysis/genome/variants2/oncocis
mkdir -v $OUTDIR


oncocis_soma()
{
    sample=$1
    input_soma=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/somatic/$sample.somatic.testvariants.annotated.rare
    fasta=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
    OUTDIR_soma=$OUTDIR/somatic
    mkdir -v $OUTDIR_soma
    out_soma=$OUTDIR_soma/$sample.soma.rare.all.oncocis.txt

    python input_oncocis.soma.all.py $input_soma $out_soma $fasta
}

oncocis_germ()
{   
    sample=$1
    input_germ=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/germline/$sample.testvariants.filter.annotated.germline.rare
    fasta=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
    OUTDIR_germ=$OUTDIR/germline
    mkdir -v $OUTDIR_germ
    out_germ=$OUTDIR_germ/$sample.germ.rare.all.oncocis.txt
    
    python input_oncocis.germ.all.py $input_germ $out_germ $fasta
}

#oncocis_soma

for i in 2 4 6 7 8
    do
	#oncocis_germ patient_${i}
	oncocis_soma patient_${i}
    done
