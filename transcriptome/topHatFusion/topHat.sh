#!/bin/bash --login

# the proper way to write help?
# the proper way to define a function?
# case - switch?
# ${data_dir} or $data_dir

topHat(){
	#data_dna_dir="/work/projects/melanomics/analysis/genome/$1/fastq/merged"
	#data_dna_dir="/work/projects/melanomics/analysis/genome/$1/trim/merged"
	#data_rna_dir="/work/projects/melanomics/analysis/transcriptome/$2/FastQC/merged"
	#data_rna_dir="/work/projects/melanomics/analysis/transcriptome/$2/adapter_quality_filter_trim/merged"
	#script_dir="/work/projects/melanomics/tools/comrad/comrad-0.1.3/scripts"
	#output_dir="/work/projects/melanomics/analysis/transcriptome/$2/comrad"
	#oarsub -l nodes=1,walltime=$3 -n $(echo $2 | sed "s/\//./g" ) "./run_comrad.sh $data_dna_dir $data_rna_dir $script_dir $output_dir"
	oarsub -l nodes=1,walltime=2 -n testSetStep2 "./run_topHat2.sh"
	# to keep part of the string
	# 1: $(echo file_name | cut -d "m" -f1 )
	# 2: $(echo file_name | sed "s/merged//g" )
	# 3: $(echo file_name | sed "s/merged/@/g" | cut -d "@" -f1 )
}

#name=$(echo "patient2merged" | cut -d "2" -f1 )

topHat #$dna_dir $rna_dir $t
