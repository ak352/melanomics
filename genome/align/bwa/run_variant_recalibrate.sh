#!/bin/bash --login
module load Java
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/

input=$1
output=$2
dbsnp=$3
ref=$4
cores=$5
hapmap=/work/projects/melanomics/data/broad2/bundle/hapmap_3.3.b37.vcf
omni=/work/projects/melanomics/data/broad2/bundle/1000G_omni2.5.b37.vcf
#Phase 1 indels (is there a later version? check FTP site)
kG=/work/projects/melanomics/data/broad2/bundle/ftp.broadinstitute.org/bundle/2.8/b37/1000G_phase1.indels.b37.vcf


time java -jar ${GATK}/GenomeAnalysisTK.jar \ 
-T VariantRecalibrator \ 
-R $ref \ 
-input $input \ 
-resource:hapmap,known=false,training=true,truth=true,prior=15.0 $hapmap \ 
-resource:omni,known=false,training=true,truth=true,prior=12.0 $omni \ 
-resource:1000G,known=false,training=true,truth=false,prior=10.0 $kG \ 
-resource:dbsnp,known=true,training=false,truth=false,prior=2.0 $dbsnp \ 
-an DP \ 
-an QD \ 
-an FS \ 
-an MQRankSum \ 
-an ReadPosRankSum \ 
-mode INDEL \ 
-tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 90.0 \ 
-recalFile ${input%.vcf}.recalibrate_INDEL.recal \ 
-tranchesFile ${input%.vcf}.recalibrate_INDEL.tranches \ 
-rscriptFile ${input%.vcf}.recalibrate_INDEL_plots.R 

java -jar ${GATK}/GenomeAnalysisTK.jar \ 
-T ApplyRecalibration \ 
-R $ref \ 
-input $input \ 
-mode INDEL \ 
--ts_filter_level 99.0 \ 
-recalFile ${input%.vcf}.recalibrate_INDEL.recal \
-tranchesFile ${input%.vcf}.recalibrate_INDEL.tranches \
-o $output
