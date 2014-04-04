#!/bin/bash --login
#module load cutadapt/1.3-goolf-1.4.10-Python-2.7.3
#module load cutadapt


cutadapt=/work/projects/isbsequencing/tools/cutadapt-1.2.1/bin/cutadapt
#fast_qc_output=/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L005.ft.R1_1_fastqc/fastqc_data.txt

extract_adaptor_sequences()
{
    grep -oP '[ATCG]+^M$' /home/users/sreinsbach/bin/FastQC/Contaminants/contaminant_list.txt \
	> /home/users/sreinsbach/bin/FastQC/Contaminants/contaminant_list.sequences.txt
}

trim_adapter()
{
    fastq=$1
    fast_qc_output=$2
    mv $fastq $SCRATCH/.
    

    cmd="$cutadapt -O 10 "

    while read line;
    do
	cmd="$cmd -b $line"
    done < <(python get_adaptors.py $fast_qc_output)
    
    #cmd="oarsub -lcore=2,walltime=120 '$cmd $fastq > $SCRATCH/adaptor_trimmed.only2'"
    cmd="$cmd $SCRATCH/${fastq##*/} > $SCRATCH/${fastq##*/}.noadapter"
    echo $cmd
    #eval $cmd

}

trim_quality()
{
    echo "start trimmimg"

    for i in `ls ../FastQC/*fastq`; do ln -s $i; done
    ls *fastq | cut -f 1 -d "." | sort | uniq > trim_files

    for i in `cat trim_files`
    do 
        echo "perl /mnt/nfs/projects/melanomics/tools/trim-fastq.pl --input1 ${i}.ft.R1_1.fastq --input2 ${i}.ft.R2_2.fastq --output $i.trim.fastq --quality-threshold 20 --fastq-type sanger --min-length 40 >$i.qsub"
        oarsub -lwalltime=12 "perl /mnt/nfs/projects/melanomics/tools/trim-fastq.pl --input1 ${i}.ft.R1_1.fastq --input2 ${i}.ft.R2_2.fastq --output $i.trim.fastq --quality-threshold 20 --fastq-type sanger --min-length 40 >$i.qsub"
	
    done

echo "finished trimming"

}

trim_and_filter()
{
    #for i in `ls ../FastQC/*fastq`; do ln -s $i; done
    #ls *fastq | cut -f 1 -d "." | sort | uniq > trim_files

    #for i in `cat trim_files`
    #do
	#fastq1=${i}.ft.R1_1.fastq
	fastq=
	fastqc_output=/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L005.ft.R1_1_fastqc/fastqc_d\
ata.txt
	trim_adapter $fastq $fastqc_output
    
}


trim_and_filter
