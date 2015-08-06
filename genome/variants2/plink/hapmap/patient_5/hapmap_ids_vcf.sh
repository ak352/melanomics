
input=$SCRATCH/plink/vcf/all.vcf
hapmap=/work/projects/melanomics/data/broad2/bundle/hapmap_3.3.b37.vcf
output=$SCRATCH/plink/vcf/all.hapmap.vcf

echo Getting only variants that overlap with HapMap
python get_hapmap.py $input $hapmap > $output
wc -l $output