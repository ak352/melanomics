#!/bin/bash --login
module load tophat/2.0.10
module load bowtie2
sample=patient_2

bed2juncs()
{
    PATH=/work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/:$PATH
    PATH=/work/projects/melanomics/tools/bowtie2-2.1.0/:$PATH
    junctions=/work/projects/melanomics/analysis/transcriptome/${sample}/tophat_out_trimmed_NCBI/tophat_out_trimmed_NCBI_${sample}/junctions.bed
    juncs=/work/projects/melanomics/analysis/transcriptome/${sample}/tophat_out_trimmed_NCBI/tophat_out_trimmed_NCBI_${sample}/junctions.junc
    bed_to_juncs < $junctions > $juncs
}

tophat_se()
{
    #Add bowtie and tophat to path
    #PATH=/work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/:$PATH
    #PATH=/work/projects/melanomics/tools/bowtie2-2.1.0/:$PATH

    index_base=/work/projects/melanomics/data/hg19/hg19
    juncs=/work/projects/melanomics/analysis/transcriptome/${sample}/tophat_out_trimmed_NCBI/tophat_out_trimmed_NCBI_${sample}/junctions.junc
    output=output/
    temp_output=$WORK/tophat_SE_NCBI_${sample}

    #see manual, not mixing PE and SE reads!!
    #readsSE=input/read_se,input/read_se_1,input/read_se_2,input/read_se_3
    #readsSE=input/read_se_all #Warning
    #readsSE=input/read_se_first2 #Warning
    readsSE=input/read_se_1 #Simplest warning? I suspect because it aligns to chrMT and does not find it in genomic reference
    #readsSE=input/read_se #No warning

    #Gene annotation file
    #gene=transcriptome/ncbi.gff.1
    gene_index=/work/projects/melanomics/data/Index_NCBI/ncbi

    echo Reads SE
    echo $readsSE

    #Parameters
    cores=10

    mkdir $output
    mkdir $temp_output

    time tophat2 \
	--b2-sensitive \
	--transcriptome-index=$gene_index \
	-o $temp_output \
	-p $cores \
	-j $juncs \
	$index_base $readsSE < /dev/null

    echo Stage out
    cp -r $temp_output $output

}
#--transcriptome-index=$gene_index \
#bed2juncs
tophat_se
