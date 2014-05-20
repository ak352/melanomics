

fqc_sample()
{
    sample=$1
    folder=/work/projects/melanomics/analysis/genome/
    for k in ${folder}/$sample/fastq/*.fastq
    do
	echo $input
	echo $output
	input=$k
	output=${folder}/$sample/fastqc/
	mkdir $output
	#./fastqc.sh $input $output
	oarsub -lcore=2,walltime=12 "./fastqc.sh $input $output"
    done

}

for k in patient_2_PM #NHEM #patient_2_NS patient_2_PM patient_4_NS patient_4_PM patient_5_NS patient_5_PM patient_6_NS patient_6_PM patient_7_NS patient_7_PM patient_8_NS patient_8_PM
do
    fqc_sample $k
done


