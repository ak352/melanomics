#!/bin/bash --login
module load cgatools






# tv2vcf=/work/projects/melanomics/tools/cgatools/scripts/testvariants2VCF-v3/testvariants2VCF-v3.pl
# input=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap.variants
# temp=$input.temp
# crr=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.crr
# output=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap.vcf
# log=$output.log

#testvarOutput.txt hg19.crr > vcf.txt 2> runlog.txt

#python get_hapmap.py

#cut -f1-21 $input > $temp
#head $temp
#$tv2vcf $temp $crr > $output 2> $log


module load vcftools


