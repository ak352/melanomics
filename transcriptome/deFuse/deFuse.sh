#!/bin/bash --login

# the proper way to write help?
# the proper way to define a function?
# case - switch?
# ${data_dir} or $data_dir

deFuse(){
	data_dir="/work/projects/melanomics/analysis/transcriptome$1/adapter_quality_filter_trim"
	script_dir="/work/projects/melanomics/tools/defuse/defuse-0.6.2/scripts"
	output_dir="/work/projects/melanomics/analysis/transcriptome$1/deFuse"
	file_name=$3
	oarsub -l nodes=1,walltime=$2 -n $(echo $file_name | sed "s/merged//g" ) "./run_deFuse.sh $data_dir $script_dir $output_dir $file_name"
	# to keep part of the string
	# 1: $(echo file_name | cut -d "m" -f1 )
	# 2: $(echo file_name | sed "s/merged//g" )
	# 3: $(echo file_name | sed "s/merged/@/g" | cut -d "@" -f1 )
}

name=$(echo "patient2merged" | cut -d "2" -f1 )


function helptext {
	echo "The script deFuse.sh should have one parameter:"
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
	dir="/patient_2";
	t=18;
	name="patient2merged";
elif [ $1 = "4ns" ]; then
	dir="/patient_4/NS";
	t=10;
	name="patient4NSmerged";
elif [ $1 = "4pm" ]; then
	dir="/patient_4/PM";
	t=27; 
	name="patient4PMmerged";
elif [ $1 = "6" ]; then
	dir="/patient_6";
	t=10;
	name="patient6merged";
elif [ $1 = "nhem" ]; then
	dir="/NHEM";
	t=37;
	name="NHEMmerged";
elif [ $1 = "pool" ]; then
	dir="/pool";
	t=40;
	name="poolMerged";
elif [ $1 = "-h" ]; then
	helptext
	exit
else
	echo "There is no such sample. Exit."
	helptext
	exit 1
fi

deFuse $dir $t $name
