#!/bin/bash --login
module load Java
module load pipeline
module load pysam
java=java
sed=sed
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/
ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
BEDTOOLS=/work/projects/melanomics/tools/bedtools/bedtools2/bin/
dict=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.dict
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf

merge()
{
    samples=( patient_2 patient_4_NS patient_4_PM patient_6 pool NHEM )
    name=all
    vcf_files=vcf_files.in

    for x in $(seq 0 $((${#samples[@]}-1)))
    do
	sample=${samples[$x]}
	echo $sample
	vcfs[$x]=/work/projects/melanomics/analysis/transcriptome/$sample/variants/$sample.fasd.indels_from.dindel.varscan.gatk.vcf 
	name=$name.$sample
    done
    name=$name.vcf
    output=/work/projects/melanomics/analysis/transcriptome/variants/$name

    rm -f ${vcf_files}
    for k in ${vcfs[@]}
    do
        echo $k >> ${vcf_files}
    done

    #Do we need a BAM file here? If not, remove it
    python pipeline.py -vc --ignore-source -g $GATK/GenomeAnalysisTK.jar -r $ref -d $dict --list-of-vcf ${vcf_files} -o $output
}


nocallref()
{
    samples=( patient_2 patient_4_NS patient_4_PM patient_6 pool NHEM )
    name=all
    for x in $(seq 0 $((${#samples[@]}-1)))
    do
        sample=${samples[$x]}
        vcfs[$x]=/work/projects/melanomics/analysis/transcriptome/$sample/variants/$sample.fasd.indels_from.dindel.varscan.gatk.vcf
        name=$name.$sample
    done
    name=$name.vcf

    bam_files=bam_files.in
    rm -f ${bam_files}
    echo "rm -f ${bam_files}"


    input=/work/projects/melanomics/analysis/transcriptome/variants/$name
    output=/work/projects/melanomics/analysis/transcriptome/variants/${name%vcf}annotated.vcf
    temp=$SCRATCH/temp_vcf
    
    echo Copying input VCF=$input to temporary VCF:$temp
    #grep ^"#" $input | grep -P '(fileformat|ID=DP|##CHROM)' > $temp
    #grep -v ^"#" $input >> $temp
    sed 's/\.\/\./0\/0/g'  $input > $temp

    #cp -f $input $temp
    for x in $(seq 0 $((${#samples[@]}-1)))
    do
	sample=${samples[$x]}
	bam=/work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_$sample/$sample.bam
        echo -e "${sample}\t$bam" >> ${bam_files}
	cmd="$cmd -I $bam "
	echo Annotating $sample
	#python pipeline.py --nocallref --merged-vcf $temp --bam-file $bam --sample-name $sample -o $output
	#java -Xmx2g -jar $GATK/GenomeAnalysisTK.jar \
	#    -R $ref \
	#    -T VariantAnnotator \
	#    -I $bam \
	#    -o $output \
	#    -A Coverage \
	#    --variant $temp \
	#    --dbsnp $dbsnp \
	#    -nt 8
	#python move_dp_to_sample.py $output $x > $temp
    done

    java -Xmx2g -jar $GATK/GenomeAnalysisTK.jar \
        -R $ref \
        -T VariantAnnotator \
        $cmd \
        -o $output \
        -A DepthPerAlleleBySample \
        --variant $temp \
        --dbsnp $dbsnp \
        -nt 8

    #cp -f $temp $output
    echo Coverage annotation done
}


get_coverages()
{
    samples=( patient_2 patient_4_NS patient_4_PM patient_6 pool NHEM )
    #Make the VCF file name
    name=all
    for x in $(seq 0 $((${#samples[@]}-1)))
    do
        sample=${samples[$x]}
        vcfs[$x]=/work/projects/melanomics/analysis/transcriptome/$sample/variants/$sample.fasd.indels_from.dindel.varscan.gatk.vcf
        name=$name.$sample
    done
    name=$name.vcf

    for x in $(seq 0 $((${#samples[@]}-1)))
    do
	sample=${samples[$x]}
	input=/work/projects/melanomics/analysis/transcriptome/variants/$name
	output=/work/projects/melanomics/analysis/transcriptome/$sample/variants/variants.coverage
	#echo Input = $input 
	#echo Output = $output
	grep -v ^"#" $input | cut -f1-4 | awk -F"\t" 'BEGIN{OFS="\t"}{print $1,$2-1,$2+length($4)-1;}' > $output
	
	input=/work/projects/melanomics/analysis/transcriptome/$sample/variants/variants.coverage
	output=/work/projects/melanomics/analysis/transcriptome/variants/${name%vcf}$sample.coverage
	oarsub -lcore=2,walltime=8 "$BEDTOOLS/coverageBed -split -abam /work/projects/melanomics/analysis/transcriptome/$sample/NCBI_FaSD_$sample/$sample.bam -b $input > $output"
    done
}

sort_coverages()
{
    for k in NHEM patient_2 patient_4_NS patient_4_PM patient_6 pool
    do
	sed 's/^\([0-9]\t\)/0\1/g' /work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.$k.coverage \
	    |sort -k1,1 -k2,3n| sed 's/^0//g' \
	    > /work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.$k.coverage.sorted
    done
}

paste_coverages()
{
    input=/work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.vcf
    output=/work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.vcf.coverages
    temp=/tmp/
    for k in NHEM patient_2 patient_4_NS patient_4_PM patient_6 pool
    do
	
	cut -f4 /work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.$k.coverage.sorted > $temp$k
        cmd="$cmd $temp$k"
    done
    (grep ^"#" $input; paste <( grep -v ^"#" $input | sed 's/^\([0-9]\t\)/0\1/g'| sort -k1,1 -k2,3n| sed 's/^0//g'  )  $cmd;) > $output
}

set_dp()
{
    input=/work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.vcf.coverages
    output=/work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.annotated.vcf
    python set_dp.py $input 2>/dev/null > $output
}

#merge
#nocallref
#get_coverages
#sort_coverages
#paste_coverages
set_dp