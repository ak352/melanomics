#!/bin/bash --login
ROOT_FOLDER=/work/projects/melanomics/analysis/genome/ 
INPUT_FILE_PREFIX=NHEM/fastqc/120827_SN386_0257_AC13YAACXX_NHEM_reprep_NoIndex_L00 
OUTPUT_FOLDER=NHEM/trim2
MYTMP=$SCRATCH
input="${ROOT_FOLDER} ${INPUT_FILE_PREFIX} ${OUTPUT_FOLDER}"

#1. Adaptor clipping and quality trimming
cd ../trim
#python trim.sh <( python trim_input.py $input)


#2. Read-mapping
cd ../align/bwa

bwa_pe_se()
{

    sample=$1
    for k in $ROOT_FOLDER/$sample/trim/*trimmed_1
    do
	input=${k##*/}
	input=$SCRATCH/trim/$input
	lane=`echo $k | grep -oP '[0-9].ft.R1_1.fastq.noadapter.quality_trimmed_1' | sed 's/\.ft\.R1_1\.fastq\.noadapter\.quality_trimmed_1//g'`
	read1=$input
	read2=${input%1}2
	readse=${input%1}SE
	sample_name=$sample
	dob=${k##*/}
	dob=${dob%%_*} 

	read_group="\"@RG\tID:$dob_$lane\tSM:$sample_name\tPL:Illumina\tLB:NA\tPU:NA\""
	output_pe=$MYTMP/$sample_name.$dob.lane$lane.pe.sam
	output_se=$MYTMP/$sample_name.$dob.lane$lane.se.sam
	cores_pe=4
	cores_se=4
	

	pe_stdout=$MYTMP/$sample_name.$dob.lane$lane.pe.stdout
	pe_stderr=$MYTMP/$sample_name.$dob.lane$lane.pe.stderr
	se_stdout=$MYTMP/$sample_name.$dob.lane$lane.se.stdout
        se_stderr=$MYTMP/$sample_name.$dob.lane$lane.se.stderr
	#echo  -O $pe_stdout -E $pe_stderr
	#echo -O $se_stdout -E $se_stderr
	echo "./run_bwa.sh $read_group $ref $read1 $read2 $output_pe $cores_pe > $pe_stdout 2>$pe_stderr"
	echo "./run_bwa_se.sh $read_group $ref $readse $output_se $cores_se > $se_stdout 2>$se_stderr"
    done
}

sample=${OUTPUT_FOLDER%%/*}
bwa_pe_se $sample





