#!/bin/bash --login

module load cgatools

gt=/work/projects/isbsequencing/shsy5y/analysis/genotyping/gt.uniq
temp_gt=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/omni1
input=/work/projects/melanomics/analysis/genome/variants2/all.dna.coverage_annotated.testvariants
output=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap


#(echo -e "chrom\tbegin\tend"; cut -f1-2 $gt | sed 's/^chr//g' \
#    | awk -F"\t" 'BEGIN{OFS="\t"}{print $1,$2-1,$2;}'; ) > $temp_gt
head $gt
head $temp_gt
head $input
cgatools join --beta --match chromosome:chrom --overlap begin,end:begin,end \
    --select A.variantId --input $input $temp_gt \
    > $output
wc -l  $output

