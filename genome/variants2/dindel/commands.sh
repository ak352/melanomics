#!/bin/bash --login

sample=$1
input=/work/projects/melanomics/analysis/genome/$sample/bam/$sample.bam
OUTDIR=/work/projects/melanomics/analysis/genome/$sample/variants/dindel/
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
mkdir -pv $OUTDIR
ln -fs $input $OUTDIR/.
echo $OUTDIR/${input##*/} > melanomics.in

# python pipeline.py --dindel -i melanomics.in -r $ref -v --temp $OUTDIR
# python pipeline.py --dindel2 -i melanomics.in -r $ref -v --temp $OUTDIR
python pipeline.py --dindel3 -i melanomics.in -r $ref --dindel3-files-per-node 100 -v --temp $OUTDIR
