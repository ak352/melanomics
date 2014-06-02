MYTMP=$SCRATCH/bwa/
mkdir $MYTMP
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf

#sample=NHEM
#input=$MYTMP/NHEM.120912.lane7.bam
#sample=patient_4_NS
#input=$MYTMP/patient_4_NS.120830.lane3.bam

#for k in patient_4_NS.120914.lane7.sorted.markdup.realn.bam patient_4_NS.120827.lane3.sorted.markdup.realn.bam
#for k in patient_4_NS.120912.lane4.sorted.markdup.realn.bam
for k in patient_4_PM.120830.lane8.sorted.markdup.realn.bam
do
    sample=`echo $k | sed 's/\..*//g'`
    input=$MYTMP/$k
    output=${input%bam}recal.bam
    grp=${output%.bam}.grp
    stout=${output%bam}stdout
    sterr=${output%bam}stderr
    context=${output%bam}context
    context=${context##*/}
    oarsub -n $sample -O $stout -E $sterr -S "./run_recalibrate.sh $input $ref $dbsnp $output $grp $context"

done


