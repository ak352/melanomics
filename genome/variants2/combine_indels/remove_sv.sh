

vcf=/work/projects/melanomics/analysis/genome/variants/patient_2_NS.dindel.corrected.vcf
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
output=/work/projects/melanomics/analysis/genome/variants/patient_2_NS.dindel.corrected.no_sv.vcf
source paths
python remove_sv.py $vcf $ref > $output
echo Output written to $output

