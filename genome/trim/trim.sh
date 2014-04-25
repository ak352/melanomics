#!/bin/bash --login         

#Modify
cutadapt=/work/projects/melanomics/tools/cutadapt/cutadapt-1.3/bin/cutadapt
TMPDIR=$SCRATCH/trim/
mkdir $TMPDIR
#Use FASTQC output to trim adapter
trim()
{
    fastq=$1
    fast_qc_output=$2
    out=$TMPDIR/${fastq##*/}.noadapter
    
    cmd="rsync -ah --progress $fastq $TMPDIR/.;"
    cmd="$cmd $cutadapt -O 10 "

    #TODO: If no adapter present, simply copy the input to output
    while read line;
    do
        cmd="$cmd -b $line"
    done < <(python get_adaptors.py $fast_qc_output)

    cmd="$cmd $TMPDIR/${fastq##*/} > $out; "

    
}    

trim_or_copy()
{
    fastq=$1
    fast_qc_output=$2
    if [[ $(python get_adaptors.py $fast_qc_output) ]]
    then 
	echo Adapters found... 
	trim $1 $2
    else 
	echo No adapters found...
	echo Copying fastq file...
	out=$TMPDIR/${fastq##*/}.noadapter
	cmd="rsync -ah --progress $fastq $out;"
    fi
    echo

}
#Use quality trimming and filter from popoolation
quality()
{
    cmd="perl /work/projects/melanomics/tools/trim-fastq.pl --input1 $1 --input2 $2 --output $3 --quality-threshold \
20 --fastq-type sanger --min-length 40 >$1.qsub; "

}


trim_both()
{
    fastq1=$1 #/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L005.ft.R1_1.fastq
    fastq2=$2 #/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L005.ft.R2_2.fastq
    fast_qc_output1=$3 #/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L005.ft.R1_1_fastqc/fastqc_data.txt
    fast_qc_output2=$4 #/work/projects/melanomics/analysis/transcriptome/patient_2/FastQC/120827_SN386_0256_BC16NGACXX_RNA_4_PM_CCGTCC_L005.ft.R2_2_fastqc/fastqc_data.txt
    output_dir=$5 #/work/projects/melanomics/analysis/transcriptome/patient_2/adapter_quality_filter_trim/

    

    cmd1="$cmd1 mkdir $output_dir;"

    trim_or_copy $fastq1 $fast_qc_output1
    cmd1=$cmd1$cmd
    noadapter1=$out
    trim_or_copy $fastq2 $fast_qc_output2
    cmd1=$cmd1$cmd
    noadapter2=$out

    out=$TMPDIR/${fastq1##*/}.noadapter.quality_trimmed
    quality $noadapter1 $noadapter2 $out
    cmd1=$cmd1$cmd

    #Stage out
    input="$out*"
    cmd1="$cmd1 rsync -ah --progress $input $output_dir/.;" 
    input=$TMPDIR/${fastq1##*/}.noadapter.qsub
    cmd1="$cmd1 rsync -ah --progress $input $output_dir/.;"
    
    echo $cmd1
    cmd1="oarsub -lcore=2,walltime=24 '$cmd1'"
    eval $cmd1

}




#Trim 1 lane
trim_both $1 $2 $3 $4 $5





