#!/bin/bash --login

# the proper way to write help?
# the proper way to define a function?
# case - switch?
# ${data_dir} or $data_dir

comrad(){
	data_dna_dir="/work/projects/melanomics/analysis/genome/$1/fastq/merged"
	#data_dna_dir="/work/projects/melanomics/analysis/genome/$1/trim/merged"
	data_rna_dir="/work/projects/melanomics/analysis/transcriptome/$2/FastQC/merged"
	#data_rna_dir="/work/projects/melanomics/analysis/transcriptome/$2/adapter_quality_filter_trim/merged"
	script_dir="/work/projects/melanomics/tools/comrad/comrad-0.1.3/scripts"
	output_dir="/work/projects/melanomics/analysis/transcriptome/$2/comrad"
	oarsub -l nodes=1,walltime=$3 -n $(echo $2 | sed "s/\//./g" ) "./run_comrad.sh $data_dna_dir $data_rna_dir $script_dir $output_dir"
	# to keep part of the string
	# 1: $(echo file_name | cut -d "m" -f1 )
	# 2: $(echo file_name | sed "s/merged//g" )
	# 3: $(echo file_name | sed "s/merged/@/g" | cut -d "@" -f1 )
}

#name=$(echo "patient2merged" | cut -d "2" -f1 )


function helptext {
	echo "The script comrad.sh should have one parameter:"
	echo "./deFuse <parameter>"
	echo "where <parameter> defines the sample to be analysed"
	echo "2 - patient 2 (primary melanoma)"
	echo "4ns - patient 4 (normal tissue)"
	echo "4pm - patient 4 (primary melanoma)"
	echo "6 - patient 6 (primary melanoma)"
	echo "nhem - melanoma cell line"
	echo "pool - pool of normal tissues from patients 1,2,5,6,8"
}

if [ -z "$1" ]; then 
	echo "Sample is not selected. Exit."
	helptext
    exit 1
fi

if [ $1 = 2 ]; then
	dna_dir="patient_2/PM";
	rna_dir="patient_2";
	t=25;
#	name="patient2merged";
elif [ $1 = "4ns" ]; then
	dna_dir="patient_4/NS";
	rna_dir="patient_4/NS";
	t=10;
#	name="patient4NSmerged";
elif [ $1 = "4pm" ]; then
	dna_dir="patient_4/PM";
	rna_dir="patient_4/PM";
	t=27; 
#	name="patient4PMmerged";
elif [ $1 = "6" ]; then
	dna_dir="patient_6/PM";
	rna_dir="patient_6";
	t=10;
#	name="patient6merged";
elif [ $1 = "nhem" ]; then
	dna_dir="NHEM";
	rna_dir="NHEM";
	t=37;
#	name="NHEMmerged";
#elif [ $1 = "pool" ]; then
#	rna_dir="/pool";
#	t=40;
#	name="poolMerged";
elif [ $1 = "-h" ]; then
	helptext
	exit
else
	echo "There is no such sample. Exit."
	helptext
	exit 1
fi

comrad $dna_dir $rna_dir $t
