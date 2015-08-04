#!/bin/bash --login

#data_dna_dir=$1
#data_rna_dir=$2
#script_dir=$3
#output_dir=$4

# print the message in stdout
echo "Run topHat2" 
# print data in stdout
date

PATH=$PATH:/work/projects/melanomics/tools/bowtie/bowtie-1.0.0/
echo $PATH
bowtie --version

#tophat -o tophat_MCF7 -p 8 --fusion-search --keep-fasta-order --bowtie1 --no-coverage-search -r 0 --mate-std-dev 80 --max-intron-length 100000 --fusion-min-dist 100000 --fusion-anchor-length 13 --fusion-ignore-chromosomes chrM /path/to/h_sapiens/bowtie_index SRR064286_1.fastq SRR064286_2.fastq 


#temp="/work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/tophat -o /work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/testSet/output -p 12 --fusion-search --keep-fasta-order --bowtie1 --no-coverage-search -r 0 --mate-std-dev 80 --max-intron-length 100000 --fusion-min-dist 100000 --fusion-anchor-length 13 --fusion-ignore-chromosomes chrM /work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/refSets/hg19 /work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/testSet/SRR064286_1.fastq /work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/testSet/SRR064286_2.fastq"

temp="/work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/tophat-fusion-post -p 12 --num-fusion-reads 1 --num-fusion-pairs 2 --num-fusion-both 5 /work/projects/melanomics/tools/tophat-2.0.10.Linux_x86_64/refSets/hg19"

#temp="${script_dir}/analyze.pl -c ${script_dir}/config.txt -d ${data_dna_dir} -r ${data_rna_dir} -o ${output_dir} -p 12"

# print the command in stdout
echo ${temp}
# ???
eval "time ${temp}"
# print data in stdout
date
# print the message in stdout
echo "Finished topHat2." 