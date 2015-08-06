#!/bin/bash --login
module load Java
GATK=/work/projects/melanomics/tools/gatk/gatk3/


input=/work/projects/melanomics/analysis/genome/variants2/intermediate/all.dna.vcf

OUTDIR=/work/projects/melanomics/analysis/genome/variants2/intermediate/dbsnp
mkdir -v $OUTDIR
output=$OUTDIR/all.dna.dbsnp.vcf

ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf


annotate()
{
    cores=12
    cmd="./run_variant_annotator.sh $input $output $dbsnp $ref $cores"
    echo $cmd
    #eval $cmd
    stdout=$output.stdout
    stderr=$output.stderr
    oarsub -lcore=12/nodes=1,walltime=48 -n VariantAnnotator -O $stdout -E $stderr "$cmd"
    
}

annotate


