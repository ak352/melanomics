#!/bin/bash --login


bed2juncs()
{
    junctions=/work/projects/melanomics/analysis/transcriptome/patient_2/tophat_out_trimmed/tophat_out_trimmed_patient2/junctions.bed
    juncs=/work/projects/melanomics/analysis/transcriptome/patient_2/tophat_out_trimmed/tophat_out_trimmed_patient2/junctions.junc
    bed_to_juncs < $junctions > $juncs
}

tophat_se()
{
    #Add bowtie and tophat to path
    PATH=/work/projects/melanomics/tools/tophat-2.0.9.Linux_x86_64/:$PATH
    PATH=/work/projects/melanomics/tools/bowtie2-2.1.0/:$PATH

    index_base=/work/projects/melanomics/data/hg19/hg19
    juncs=/work/projects/melanomics/analysis/transcriptome/patient_2/tophat_out_trimmed/tophat_out_trimmed_patient2/junctions.junc
    output=/work/projects/melanomics/analysis/transcriptome/patient_2/tophat_out_trimmed/tophat_SE_patient2
    temp_output=$WORK/tophat_SE_patient2

    #see manual, not mixing PE and SE reads!!
    filesSE=(/work/projects/melanomics/analysis/transcriptome/patient_2/trim/*trim.fastq_SE)
    readsSE=`echo ${filesSE[@]} | sed 's/ /,/g'`

    #Gene annotation file
    gene=/work/projects/melanomics/data/GRCh37/Homo_sapiens/Ensembl/GRCh37/Annotation/Genes/genes.gtf
    gene_index=/work/projects/melanomics/data/GRCh37_index/genes.chr

    echo Reads SE
    echo $readsSE

    #Parameters
    max_multihits=20
    library=fr-unstranded
    cores=16

    mkdir $output
    mkdir $temp_output

    time tophat2 \
	-g $max_multihits \
	--library-type $library \
	--b2-very-fast \
	--fusion-search \
	--transcriptome-index=$gene_index \
	-o $temp_output \
	-p $cores \
	-j $juncs \
	$index_base $readsSE

    echo Stage out
    cp -r $temp_output $output

}

bed2juncs
tophat_se
