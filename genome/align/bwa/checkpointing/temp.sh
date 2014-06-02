MYTMP=$SCRATCH/bwa/
mkdir $MYTMP
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf

#sample=NHEM
#input=$MYTMP/NHEM.120912.lane7.bam
#sample=patient_4_NS
#input=$MYTMP/patient_4_NS.120830.lane3.bam

#for k in patient_2_NS.120827.lane1.bam patient_2_NS.120830.lane1.bam patient_2_NS.120830.lane2.bam patient_2_NS.120830.lane3.bam patient_2_NS.120830.lane4.bam patient_4_NS.120827.lane3.bam patient_4_NS.120830.lane3.bam patient_4_NS.120830.lane4.bam patient_4_NS.120912.lane3.bam patient_4_NS.120912.lane4.bam patient_4_NS.120914.lane6.bam patient_4_NS.120914.lane7.bam patient_5_NS.120827.lane5.bam patient_5_NS.120831.lane1.bam patient_5_NS.120831.lane2.bam patient_5_NS.120831.lane3.bam patient_5_NS.120831.lane4.bam patient_6_NS.121010.lane1.bam patient_6_NS.121010.lane2.bam patient_6_NS.121010.lane3.bam patient_6_NS.121010.lane4.bam patient_6_PM.120313.lane8.bam patient_7_NS.120828.lane1.bam patient_7_NS.120828.lane2.bam patient_7_NS.120828.lane3.bam patient_7_NS.120828.lane4.bam patient_7_PM.120828.lane5.bam patient_7_PM.120828.lane6.bam patient_7_PM.120828.lane7.bam patient_7_PM.120828.lane8.bam patient_8_NS.120827.lane7.bam patient_8_NS.121010.lane5.bam patient_8_NS.121010.lane6.bam patient_8_NS.121010.lane7.bam patient_8_NS.121010.lane8.bam patient_8_PM.120328.lane2.bam patient_8_PM.120328.lane4.bam patient_8_PM.120328.lane6.bam patient_8_PM.120328.lane8.bam
#for k in patient_4_NS.120827.lane3.bam
for k in patient_4_NS.120827.lane3.bam patient_4_NS.120830.lane3.bam patient_4_NS.120830.lane4.bam patient_5_NS.120827.lane5.bam
do
    sample=`echo $k | sed 's/\..*//g'`
    input=$MYTMP/$k
    output=${input%bam}sorted.markdup.bam
    stout=${output%bam}stdout
    sterr=${output%bam}stderr
    context=${output%bam}context
    context=${context##*/}
    oarsub -n $sample -O $stout -E $sterr -S "./run_sort_markduplicates.sh $input $output $context"
done


