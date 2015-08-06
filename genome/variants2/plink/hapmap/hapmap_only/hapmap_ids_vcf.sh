
input=/work/projects/melanomics/analysis/genome/variants2/intermediate/dbsnp/all.dna.dbsnp.vcf
hapmap=/work/projects/melanomics/data/broad2/bundle/hapmap_3.3.b37.vcf
output=/work/projects/melanomics/analysis/genome/variants2/intermediate/dbsnp/all.dna.dbsnp.hapmap.vcf

echo Getting only variants that overlap with HapMap
python get_hapmap.py $input $hapmap > $output
wc -l $output
