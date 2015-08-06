#!/bin/bash --login
module load Java


sample=NHEM
input=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_$sample/$sample.fasd.vcf
output=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_$sample/dbsnp/$sample.fasd.dbsnp.vcf
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf
cores=24
java -jar /work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/GenomeAnalysisTK.jar -R $ref -T VariantAnnotator -V $input -o $output --dbsnp $dbsnp -nt $cores



