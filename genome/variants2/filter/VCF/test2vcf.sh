#!/bin/bash --login
module load vcftools

script=/work/projects/isbsequencing/tools/cgatools-1.5.0.31-linux_binary-x86_64/perl/testvariants2VCF-v2/testvariants2VCF-v2.pl
input=/work/projects/isbsequencing/shsy5y/data/masterfile/master.GS00533.SS6002862.tested.illumina.filtered
output=/work/projects/isbsequencing/shsy5y/data/masterfile/vcf/master.GS00533.SS6002862.tested.illumina.filtered.vcf
log=/work/projects/isbsequencing/shsy5y/data/masterfile/vcf/master.GS00533.SS6002862.tested.illumina.filtered.vcf.log
crr=/work/projects/isbsequencing/resources/refGenomes/hg19.crr

$script $input $crr > $output 2> $log
vcf-sort $output > $output.sorted
