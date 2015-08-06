#!/bin/bash --login

module load Java
MUTECT="/work/projects/melanomics/tools/mutect/mutect-src/mutect/target/mutect-1.1.7.jar"

ref="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa"
cosmic="/work/projects/melanomics/data/cosmic/b37_cosmic_v54_120711.vcf"
#cosmic="/work/projects/melanomics/data/cosmic/CosmicAll.vcf"
dbsnp="/work/projects/melanomics/data/dbsnp/00-All.vcf"

normal=$1
tumor=$2
output=$3
vcf=$4
coverage_file=$5

echo "Run mutect on matched tumor normal samples"
date
CMD="java -Xmx2g -jar ${MUTECT} \
--analysis_type MuTect \
--reference_sequence ${ref} \
--cosmic ${cosmic} \
--dbsnp ${dbsnp} \
--input_file:normal ${normal} \
--input_file:tumor ${tumor} \
--out ${output} \
--vcf ${vcf} \
--coverage_file ${coverage_file}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished calling of somatic SNVs and indels using mutect."
