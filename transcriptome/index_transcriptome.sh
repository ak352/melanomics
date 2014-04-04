#!/bin/bash --login

PATH=/work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/:$PATH
PATH=/work/projects/melanomics/tools/bowtie2-2.1.0/:$PATH


index_ncbi()
{
    date
    gtf=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Annotation/Genes/genes.gtf
    output_dir=/work/projects/melanomics/data/Index_NCBI/ncbi
    genome_index_base=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/Bowtie2Index/genome
    time tophat -G $gtf --transcriptome-index=$output_dir $genome_index_base
}

index_ensembl()
{
    date
    gtf=/work/projects/melanomics/data/GRCh37/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf 
    output_dir=/work/projects/melanomics/data/Index_Ensembl/ensembl
    genome_index_base=/work/projects/melanomics/data/GRCh37/Homo_sapiens/Ensembl/GRCh37/Sequence/Bowtie2Index/genome
    time tophat -G $gtf --transcriptome-index=$output_dir $genome_index_base
}    

#index_ncbi

index_ensembl

