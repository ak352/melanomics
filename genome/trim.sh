#!/bin/bash --login

cutadapt=/work/projects/melanomics/tools/cutadapt/cutadapt-1.3/bin/cutadapt
adapters=/home/users/sreinsbach/bin/FastQC/Contaminants/contaminant_list.txt

extract_adaptor_sequences()
{
    grep -oP '[ATCG]+^M$' /home/users/sreinsbach/bin/FastQC/Contaminants/contaminant_list.txt \
	> /home/users/sreinsbach/bin/FastQC/Contaminants/contaminant_list.sequences.txt
}

trim()
{
    cmd="$cutadapt -O 5 "
    while read line
    do
	cmd="$cmd -b $line"
    done < /home/users/sreinsbach/bin/FastQC/Contaminants/contaminant_list.sequences.txt
    
    cmd="$cmd $fastq > ${fastq}.adaptor_trimmed"
    echo $cmd

}
trim
