

GATK=/work/projects/melanomics/tools/gatk/gatk3
input=$1
output=$2
dbsnp=$3
ref=$4
cores=$5
bam=$6


java -jar $GATK/GenomeAnalysisTK.jar \
     -R $ref \
     -T VariantAnnotator \
     -I $bam \
     -o $output \
     -A Coverage \
     -V $input \
     -L $input \
     --dbsnp $dbsnp \
     -nt $cores


