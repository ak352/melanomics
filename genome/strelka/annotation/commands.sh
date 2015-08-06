

input=/work/projects/melanomics/analysis/genome/strelka/somatic_indels_all/annotation/variantlist.tested.wochr.annovar
exac2=/work/projects/melanomics/analysis/genome/strelka/somatic_indels_all/annotation/exac2_kg14/variantlist.tested.wochr.annovar
output=/work/projects/melanomics/analysis/genome/strelka/somatic_indels_all/variantlist.tested.wochr.annovar

cmd="paste $input  <( cut -f14- $exac2) > $output"
echo $cmd; eval $cmd

