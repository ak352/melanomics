#!/bin/bash --login

module load Java/1.7.0_10


if [ ! $# -eq 2 ]; then
    echo "USAGE: ${0} <myPath> <sampleID>"
    exit 1
fi

MYPATH=${1}
sample=${2}

#sample="patient_2"
sample_ex="${sample}.accepted_hits.merged.rg.reordered.recalibrated"
#MYPATH="/work/projects/melanomics/analysis/transcriptome"

MYPATH="${MYPATH}/${sample}"
echo "Running FaSD pipeline on ${MYPATH}"

OUT_DIR="${MYPATH}/FaSD_${sample}"
mkdir ${OUT_DIR}
TMP_DIR="/tmp"
mkdir ${TMP_DIR}/FaSD_${sample} 

reference="/work/projects/melanomics/data/hg19/hg19.fa"
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
    input="${MYPATH}/tophat_out_trimmed/accepted_hits.merged.bam"
    tmp_output="${TMP_DIR}/FaSD_${sample}/${sample}.accepted_hits.merged.rg.bam"
    tmp_output2="${TMP_DIR}/FaSD_${sample}/${sample}.accepted_hits.merged.rg.reordered.bam"
    output="${OUT_DIR}/${sample}.accepted_hits.merged.rg.bam"
    output2="${OUT_DIR}/${sample}.accepted_hits.merged.rg.reordered.bam"

    java -jar $PICARD/AddOrReplaceReadGroups.jar INPUT=${input} OUTPUT=${tmp_output} RGLB=NA RGPL=Illumina RGPU=NA RGSM=${sample} VALIDATION_STRINGENCY=LENIENT
    java -jar $PICARD/ReorderSam.jar INPUT=${tmp_output} OUTPUT=${tmp_output2} REFERENCE=${reference} VALIDATION_STRINGENCY=LENIENT
    $samtools index ${tmp_output2}

    echo "Copying ReadGroup results from ${tmp_output} to ${output}..."  
    # Create checksum, i.e. file fingerprint
    md5sum ${tmp_output}
    # Check filesize etc.
    ls -l ${tmp_output}
    cp ${tmp_output} ${output}
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
      echo "done."
    else
      echo "ERROR: Copy UNsuccessful"
    fi
    md5sum ${output}
    ls -l ${output}	

    echo "Copying BAM results from ${tmp_output2} to ${output2}..."
    # Create checksum, i.e. file fingerprint
    md5sum ${tmp_output2}
    # Check filesize etc.
    ls -l ${tmp_output2}
    cp ${tmp_output2} ${output2}
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
      echo "done."
    else
      echo "ERROR: Copy UNsucecessfull"
    fi
    md5sum ${output2}
    ls -l ${output2}

    echo "Copying BAI results from ${tmp_output2} to ${output2}..."
    # Create checksum, i.e. file fingerprint
    md5sum ${tmp_output2}.bai
    # Check filesize etc.
    ls -l ${tmp_output2}.bai
    
    cp ${tmp_output2}.bai ${output2}.bai
    
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
      echo "done."
    else
      echo "ERROR: Copy UNsuccessful"
    fi
    md5sum ${output2}.bai
    ls -l ${output2}.bai
    date
}


recalibration()
{
    date
    echo "recalibration"
    input="${OUT_DIR}/${sample}.accepted_hits.merged.rg.reordered.bam"
    output="${OUT_DIR}/${sample_ex}.bam"
    output2="${OUT_DIR}/recal_data.grp"
    reference="/work/projects/melanomics/data/hg19/hg19.fa"
    #grp="/work/projects/melanomics/analysis/transcriptome/${sample}/fasd_test/recal_data.grp"
    dbsnp137="/work/projects/melanomics/data/dbsnp/00-All.chr.vcf"
    
    tmp_output="${TMP_DIR}/FaSD_${sample}/${sample_ex}.bam"
    tmp_grp="${TMP_DIR}/FaSD_${sample}/recal_data.grp"

    time java -jar $GATK/GenomeAnalysisTK.jar  -T BaseRecalibrator -I ${input} -R ${reference} -o ${tmp_grp} -knownSites ${dbsnp137} --filter_reads_with_N_cigar -rf BadCigar
    time java -jar $GATK/GenomeAnalysisTK.jar -T PrintReads -R ${reference} -I ${input} -BQSR ${tmp_grp} -o ${tmp_output} --filter_reads_with_N_cigar -rf BadCigar

    echo "Copying recalibration results from ${tmp_output} to ${output}"     
    # Create checksum, i.e. file fingerprint
    md5sum ${tmp_output} 
    # Check filesize etc.
    ls -l ${tmp_output}
    
    cp ${tmp_output} ${output}
    
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
    echo "done."
      else
    echo "ERROR: Copy UNsuccessful"
    fi
    md5sum ${output}
    ls -l ${output}
    

    echo "Copying results from ${tmp_grp} to ${output2}..."  
    # Create checksum, i.e. file fingerprint 
    md5sum ${tmp_grp}
    # Check filesize etc.
    ls -l ${tmp_grp}

    cp ${tmp_grp} ${output2}
    
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
    echo "done."
      else
    echo "ERROR: Copy UNsuccessful"
    fi
    md5sum ${output2}
    ls -l ${output2}
    date
}


fix_mate_info()
{
    date
    echo "FixMateInfo"
    fix_mate_info="/work/projects/melanomics/tools/picard/picard-tools-1.95/FixMateInformation.jar"
    input="${OUT_DIR}/${sample_ex}.bam"
    tmp_output="${TMP_DIR}/FaSD_${sample}/${sample_ex}.fixed.bam"
    output="${OUT_DIR}/${sample_ex}.fixed.bam"

    time java -jar ${fix_mate_info} I=${input} O=${tmp_output} VALIDATION_STRINGENCY=LENIENT

    echo "Saving FixMateInfo results from ${tmp_output} to ${output} ..."
    # Create checksum, i.e. file fingerprint 
    md5sum ${tmp_output}
    # Check filesize etc.
    ls -l ${tmp_output}
    
    cp ${tmp_output} ${output}
    
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
    echo "done."
      else
    echo "ERROR: Copy UNsuccessful."
    fi
    md5sum ${output}
    ls -l ${output}
    date
}


index()
{
    date
    echo "Indexing"
    input="${OUT_DIR}/${sample_ex}.fixed.bam"
    
    time ${samtools} index ${input}

    echo "done."
    date
}


realignment()
{
    date
    echo "Realignment"
    input="${OUT_DIR}/${sample_ex}.fixed.bam"
    output="${OUT_DIR}/${sample_ex}.fixed.realigned.bam"
    reference="/work/projects/melanomics/data/hg19/hg19.fa"

    tmp_output="${TMP_DIR}/FaSD_${sample}/${sample_ex}.fixed.forIndelRealigner.intervals"
    tmp_output2="${TMP_DIR}/FaSD_${sample}/${sample_ex}.fixed.realigned.bam"

    time java -jar ${GATK}/GenomeAnalysisTK.jar -T RealignerTargetCreator -I ${input} -R ${reference} -o ${tmp_output}
    time java -jar ${GATK}/GenomeAnalysisTK.jar -T IndelRealigner -targetIntervals ${tmp_output} -I ${input} -o ${tmp_output2} -R ${reference}

    echo "Saving realignment results from ${tmp_output2} to ${output} ..."
    # Create checksum, i.e. file fingerprint 
    md5sum ${tmp_output2}
    # Check filesize etc.
    ls -l ${tmp_output2}
    
    cp ${tmp_output2} ${output}
    
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
    echo "done."
      else
    echo "ERROR: Copy UNsuccessful."
    fi
    md5sum ${output}
    ls -l ${output}
    date
}


pileup()
{
    date
    echo "Pileup"
    input="${OUT_DIR}/${sample_ex}.fixed.realigned.bam"
    output="${OUT_DIR}/${sample_ex}.fixed.realigned.pileup"
    reference="/work/projects/melanomics/data/hg19/hg19.fa"

    tmp_output="${TMP_DIR}/FaSD_${sample}/${sample_ex}.fixed.realigned.pileup"

    time ${samtools} mpileup -f ${reference} ${input} > ${tmp_output}

    echo "Saving pileup results from ${tmp_output} to ${output} ..."
    # Create checksum, i.e. file fingerprint 
    md5sum ${tmp_out}
    # Check filesize etc.
    ls -l ${tmp_output}    
    
    cp ${tmp_output} ${output}
    
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
    echo "done."
      else
    echo "ERROR: Copy UNsuccessful."
    fi
    md5sum ${output}
    ls -l ${output}
    date
}


SNP_detection()
{
    date
    echo "SNP detection"
    input="${OUT_DIR}/${sample_ex}.fixed.realigned.pileup"
    output="${OUT_DIR}/${sample_ex}.fixed.realigned.pileup.vcf"

    tmp_output="${TMP_DIR}/FaSD_${sample}/${sample_ex}.fixed.realigned.pileup.vcf"

    time ${FASD} ${input} -d 4 -o ${tmp_output}

    echo "Saving SNP results from ${tmp_output} to ${output} ..."
    # Create checksum, i.e. file fingerprint 
    md5sum ${tmp_output}
    # Check filesize etc.
    ls -l ${tmp_output}

    cp ${tmp_output} ${output}
    
    RETSTAT=$?
    if [ ${RETSTAT} -eq 0 ]; then
    echo "done."
      else
    echo "ERROR: Copy UNsuccessful."
    fi
    md5sum ${output}
    ls -l ${output}
    date
}

#dict
#add_read_group
#recalibration
fix_mate_info
index
realignment
pileup
SNP_detection
