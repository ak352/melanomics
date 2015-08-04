#!/bin/bash --login
module load Java
module load pipeline
module load pysam

#python pipeline.py -i ../../samtools/test/reads.602929.recal.bam.samtools.vcf -i ../../samtools/reads.602929.recal.bam.gatk.variants.vcf -g /home/clusterusers/akrishna/tools/gatk/GenomeAnalysisTKLite-2.1-#12-g2d7797a/GenomeAnalysisTKLite.jar -r ../../reference/hg19.chr.fa -d ../../reference/hg19.chr.dict
#python pipeline.py -i ../../samtools/test/reads.602929.recal.bam.samtools.vcf -i ../../samtools/reads.602929.recal.bam.gatk.variants.vcf -g /home/clusterusers/akrishna/tools/gatk/GenomeAnalysisTKLite-2.1-#12-g2d7797a/GenomeAnalysisTKLite.jar -r ../../reference/hg19.chr.fa -d ../../reference/hg19.chr.dict


#VCF sorter sample command
#perl vcfsorter.pl ../../reference/hg19.chr.dict ../res_tests/contig.1 mysample > contig.1.filt

#Merge VCF files
java=java
sed=sed
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/GenomeAnalysisTK.jar
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
dict=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.dict

merge_old()
{
    sample=$1
    gatk_ugt=$SCRATCH/gatk_bowtie/$sample.accepted_hits.merged.rg.reordered.rmDup.recal.fixed.realigned.vcf
    varscan=/work/projects/melanomics/analysis/transcriptome/${sample}/varscan_variants/${sample}_varscan.indel.vcf
    output=/scratch/users/akrishna/melanomics/indels/$sample.combined.vcf 
    $sed -i "s/Sample1/$sample/g" $varscan
    $java -Xmx2g -jar $GATK -T CombineVariants  --variant:VCF $gatk_ugt --variant:VCF $varscan -o $output -R $ref -genotypeMergeOptions UNIQUIFY
}

merge()
{
    sample=$1
    dindel=/work/projects/melanomics/analysis/transcriptome/$sample/dindel/$sample.dindel.vcf
    dindel_corrected=${dindel%vcf}corrected.vcf
    python correct_dindel.py $dindel > $dindel_corrected 
    vcfs=( $dindel_corrected \
	$SCRATCH/gatk_bowtie/$sample.accepted_hits.merged.rg.reordered.rmDup.recal.fixed.realigned.vcf \
	/work/projects/melanomics/analysis/transcriptome/${sample}/varscan_variants/${sample}_varscan.indel.vcf )
    vcf_files=vcf_files.in
    bam=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_patient_2/$sample.accepted_hits.merged.rg.reordered.rmDup.recal.fixed.realigned.bam
    output=$SCRATCH/melanomics/indels/$sample.combined.vcf

    rm -f ${vcf_files}
    for k in ${vcfs[@]}
    do
	echo $k >> ${vcf_files}
    done

    #Do we need a BAM file here? If not, remove it
    python pipeline.py -vc -g $GATK -r $ref -d $dict --list-of-vcf ${vcf_files} --sample-name $sample --bam-file $bam -o $output
}


nocallref()
{
    sample=$1
    bam=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_patient_2/$sample.accepted_hits.merged.rg.reordered.rmDup.recal.fixed.realigned.bam

    bam_files=bam_files.in
    rm -f ${bam_files}
    echo "rm -f ${bam_files}"
    for k in GATK VARSCAN
    do
	echo -e "${sample}_$k\t$bam" >> ${bam_files}
    done
    input=$SCRATCH/melanomics/indels/$sample.combined.vcf
    output=$SCRATCH/melanomics/indels/$sample.combined.nocallref.vcf
    python pipeline.py --nocallref --merged-vcf $input --list-of-bam-files ${bam_files} -o $output

}

choose()
{
    #If variant found in 2 callers, include
    sample=$1
    echo Sample = $sample
    input=$SCRATCH/melanomics/indels/$sample.combined.vcf
    output=$SCRATCH/melanomics/indels/$sample.combined.merged.indels.vcf
    python merge_callers.py $input $sample > $output

    mkdir /work/projects/melanomics/analysis/transcriptome/$sample/indels/
    cp $output /work/projects/melanomics/analysis/transcriptome/$sample/indels/.

}


#for k in patient_2 patient_4_NS patient_4_PM patient_6  
#merge patient_2
#nocallref patient_2
#choose patient_2


#merge patient_4_NS
#choose patient_4_NS

for m in NHEM #patient_2 patient_4_NS patient_4_PM patient_6 pool
do
    merge $m
    choose $m
done
