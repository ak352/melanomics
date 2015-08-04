#!/bin/bash --login

module load Java/1.7.0_10

sample="patient_4"
sample_n="${sample}_PM"
sample_ex="${sample_n}.accepted_hits.merged.rg.reordered.rmDup"
MYPATH="/work/projects/melanomics/analysis/transcriptome/${sample}/PM"
mkdir ${MYPATH}/NCBI_FaSD_${sample_n}
OUT_DIR="${MYPATH}/NCBI_FaSD_${sample_n}"
TMP_DIR="$SCRATCH"
mkdir ${TMP_DIR}/NCBI_FaSD_${sample_n} 
reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/Bowtie2Index/genome.fa"
samtools="/work/projects/melanomics/tools/samtools/samtools-0.1.19/samtools"
FASD="/work/projects/melanomics/tools/fasd/fasd_linux/FaSD-single"

dict()
{
      java -jar $PICARD/CreateSequenceDictionary.jar R=${reference} OUTPUT=${reference%fa}.dict
}


add_read_group()
{
    date
    echo "Adding readgroup"
    input="${MYPATH}/tophat_out_trimmed_NCBI_DE_SNP/accepted_hits.merged.bam"
    tmp_output="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_n}.accepted_hits.merged.rg.bam"
    tmp_output2="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_n}.accepted_hits.merged.rg.reordered.bam"
    output="${OUT_DIR}/${sample_n}.accepted_hits.merged.rg.bam"
    output2="${OUT_DIR}/${sample_n}.accepted_hits.merged.rg.reordered.bam"

    java -jar $PICARD/AddOrReplaceReadGroups.jar INPUT=${input} OUTPUT=${tmp_output} RGLB=NA RGPL=Illumina RGPU=NA RGSM=${sample} VALIDATION_STRINGENCY=LENIENT
    java -jar $PICARD/ReorderSam.jar INPUT=${tmp_output} OUTPUT=${tmp_output2} REFERENCE=${reference} VALIDATION_STRINGENCY=LENIENT
    $samtools index ${tmp_output2}

    echo "Copying results from ${tmp_output} to ${output}..."
    cp ${tmp_output} ${output}
    ls ${output}	
    echo "done."

    echo "Copying results from ${tmp_output2} to ${output2}..."
    cp ${tmp_output2} ${output2}
    ls ${output2}
    cp ${tmp_output2}.bai ${output2}.bai
    echo "done."
    date
}


markDuplicates()
{
    date
    echo "Mark and remove duplicates"
    input="${OUT_DIR}/${sample_n}.accepted_hits.merged.rg.reordered.bam"
    output="${OUT_DIR}/${sample_ex}.bam"
    time java -jar $PICARD/MarkDuplicates.jar Input=${input} OUTPUT=${output} METRICS_FILE=${input}.metrics REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=LENIENT
    echo "done."
}


removeDuplicates()
{
    date
    echo "Samtools remove duplicates"
    input="${OUT_DIR}/${sample_n}.accepted_hits.merged.rg.reordered.bam"
    output="${OUT_DIR}/${sample_ex}.bam"
    time $samtools rmdup ${input} ${output}
    echo "done."
}


index_rmDup()
{
    date
    echo "Indexing"
    input="${OUT_DIR}/${sample_ex}.bam"

    time ${samtools} index ${input}

    echo "done."
    date
}


recalibration()
{
    date
    echo "recalibration"
    input="${OUT_DIR}/${sample_ex}.bam"
    output="${OUT_DIR}/."
    reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/Bowtie2Index/genome.fa"
    #grp="/work/projects/melanomics/analysis/transcriptome/${sample}/fasd_test/recal_data.grp"
    dbsnp137="/work/projects/melanomics/data/dbsnp/00-All.vcf"
    
    tmp_output="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_ex}.recal.bam"
    tmp_grp="${TMP_DIR}/NCBI_FaSD_${sample_n}/recal_data.grp"

    time java -jar $GATK/GenomeAnalysisTK.jar  -T BaseRecalibrator -I ${input} -R ${reference} -o ${tmp_grp} -knownSites ${dbsnp137} --filter_reads_with_N_cigar -rf BadCigar
    time java -jar $GATK/GenomeAnalysisTK.jar -T PrintReads -R ${reference} -I ${input} -BQSR ${tmp_grp} -o ${tmp_output} --filter_reads_with_N_cigar -rf BadCigar

    echo "Copying results from ${tmp_output} to ${output}"
    cp ${tmp_output} ${output}
    ls ${output}
    echo "done."
    
    echo "Copying results form ${tmp_grp} to ${output}..."
    cp ${tmp_grp} ${output}
    ls ${output}
    echo "done."
    date
}


fix_mate_info()
{
    date
    echo "Fix mate info"
    fix_mate_info="/work/projects/melanomics/tools/picard/picard-tools-1.95/FixMateInformation.jar"
    input="${OUT_DIR}/${sample_ex}.recal.bam"
    tmp_output="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_ex}.recal.fixed.bam"
    output="${OUT_DIR}/${sample_ex}.recal.fixed.bam"

    time java -jar ${fix_mate_info} I=${input} O=${tmp_output} VALIDATION_STRINGENCY=LENIENT

    echo "Saving results to ${output} ..."
    cp ${tmp_output} ${output}
    echo "done."
    date
}


index()
{
    date
    echo "Indexing"
    input="${OUT_DIR}/${sample_ex}.recal.fixed.bam"
    
    time ${samtools} index ${input}

    echo "done."
    date
}


realignment()
{
    date
    echo "Realignment"
    input="${OUT_DIR}/${sample_ex}.recal.fixed.bam"
    output="${OUT_DIR}/${sample_ex}.recal.fixed.realigned.bam"
    reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/Bowtie2Index/genome.fa"

    tmp_output="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_ex}.recal.fixed.forIndelRealigner.intervals"
    tmp_output2="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_ex}.recal.fixed.realigned.bam"

    time java -jar ${GATK}/GenomeAnalysisTK.jar -T RealignerTargetCreator -I ${input} -R ${reference} -o ${tmp_output}
    time java -jar ${GATK}/GenomeAnalysisTK.jar -T IndelRealigner -targetIntervals ${tmp_output} -I ${input} -o ${tmp_output2} -R ${reference}

    echo "Saving results to ${output} ..."
    cp ${tmp_output2} ${output}
    echo "done."
    date
}


pileup()
{
    date
    echo "Pileup"
    input="${OUT_DIR}/${sample_ex}.recal.fixed.realigned.bam"
    output="${OUT_DIR}/${sample_ex}.recal.fixed.realigned.pileup"
    reference="/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/Bowtie2Index/genome.fa"

    tmp_output="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_ex}.recal.fixed.realigned.pileup"

    time ${samtools} mpileup -f ${reference} ${input} > ${tmp_output}

    echo "Saving results to ${output} ..."
    cp ${tmp_output} ${output}
    echo "done."
    date
}


SNP_detection()
{
    date
    input="${OUT_DIR}/${sample_ex}.recal.fixed.realigned.pileup"
    output="${OUT_DIR}/${sample_ex}.recal.fixed.realigned.pileup.vcf"

    tmp_output="${TMP_DIR}/NCBI_FaSD_${sample_n}/${sample_ex}.recal.fixed.realigned.pileup.vcf"

    time ${FASD} ${input} -d 4 -o ${tmp_output}

    echo "Saving results to ${output} ..."
    cp ${tmp_output} ${output}
    echo "done."
    date
}

#dict
#add_read_group
#markDuplicates
#removeDuplicates
#index_rmDup
#recalibration
fix_mate_info
index
realignment
pileup
SNP_detection
