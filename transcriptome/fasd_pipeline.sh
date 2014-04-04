!/bin/bash --login

module load Java/1.7.0_10

OUT_DIR=/work/projects/melanomics/analysis/transcriptome/NHEM/fasd_test/
sample=NHEM
reference=/work/projects/melanomics/data/hg19/hg19.fa

dict()
{
    java -jar $PICARD/CreateSequenceDictionary.jar R=$reference OUTPUT=${reference%fa}.dict
}

remove_duplicates()
{
    mark_duplicates=/work/projects/melanomics/tools/picard/picard-tools-1.95/MarkDuplicates.jar
    input=$WORK/tophat_out_trimmed/accepted_hits.bam
    tmp_output=$WORK/accepted_hits.deduplicated.bam
    tmp_metrics=$WORK/accepted_hits.metrics
    output=/work/projects/melanomics/analysis/transcriptome/NHEM/fasd_test/accepted_hits.deduplicated.bam
    metrics=/work/projects/melanomics/analysis/transcriptome/NHEM/fasd_test/accepted_hits.metrics
    
    
    time java -jar $mark_duplicates I=$input O=$tmp_output M=$tmp_metrics ASSUME_SORTED=true VALIDATION_STRINGENCY=SILENT \
	REMOVE_DUPLICATES=true 
   
    echo "Saving results to $output ..."
    cp $tmp_output $output
    cp $tmp_metrics $metrics
    echo "done."
}

add_read_group()
{
    input=/work/projects/melanomics/analysis/transcriptome/NHEM/fasd_test/accepted_hits.deduplicated.bam
    tmp_output=$WORK/accepted_hits.deduplicated.rg.bam
    tmp_output2=$WORK/accepted_hits.deduplicated.rg.reordered.bam
    output=$OUT_DIR/accepted_hits.deduplicated.rg.bam

    java -jar $PICARD/AddOrReplaceReadGroups.jar INPUT=$input OUTPUT=$tmp_output RGLB=NA RGPL=Illumina RGPU=NA RGSM=$sample
    java -jar $PICARD/ReorderSam.jar INPUT=$tmp_output OUTPUT=$tmp_output2 REFERENCE=$reference
    samtools index $tmp_output2

    cp $tmp_output2 $output
    cp $tmp_output2.bai $output.bai
}


recalibration()
{
    input=/work/projects/melanomics/analysis/transcriptome/NHEM/fasd_test/accepted_hits.deduplicated.rg.bam
    output=/work/projects/melanomics/analysis/transcriptome/NHEM/fasd_test/accepted_hits.deduplicated.rg.recalibrated.bam
    reference=/work/projects/melanomics/data/hg19/hg19.fa
    #grp=/work/projects/melanomics/analysis/transcriptome/NHEM/fasd_test/recal_data.grp
    dbsnp137=/work/projects/melanomics/data/dbsnp/00-All.chr.vcf

    tmp_output=$WORK/accepted_hits.deduplicated.recalibrated.rg.bam
    tmp_grp=$WORK/recal_data.grp
    
    time java -jar $GATK/GenomeAnalysisTK.jar  -T BaseRecalibrator -I $input -R $reference -o $tmp_grp -knownSites $dbsnp137 --filter_reads_with_N_cigar
    time java -jar $GATK/GenomeAnalysisTK.jar -T PrintReads -R $reference -I $input -BQSR $tmp_grp -o $tmp_output --filter_reads_with_N_cigar

    cp $tmp_output $output

}

#dict
remove_duplicates
#add_read_group
#recalibration
