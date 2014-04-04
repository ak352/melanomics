#!/bin/bash --login
fastqc=/work/projects/melanomics/tools/fastqc/FastQC/fastqc

fqc()
{
    input=$1
    output=$2
    time $fastqc -f fastq -o $2 $1 
}

fqc_sample()
{
    sample=$1
    folder=/work/projects/melanomics/analysis/genome/
    for k in ${folder}/$sample/*.fastq
    do
	echo $k
    done

}

#Test
#fqc test/input/test.fastq test/output/fastqc/

for k in NHEM patient_2_NS patient_2_PM patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM
do
    fqc_sample $k
done

