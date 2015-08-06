for k in 2 4 5 6 7 8
do
	sample=patient_$k
	vcf=/work/projects/melanomics/analysis/genome/strelka/$sample/results/combine/passed.somatic.snvs.indels.tumor.vcf.temp
	bam=/work/projects/melanomics/analysis/genome/${sample}_PM/bam/${sample}_PM.bam
	echo -e "$sample $vcf $bam"
done
