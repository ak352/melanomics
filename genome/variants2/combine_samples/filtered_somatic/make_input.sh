


sorted()
{
    for k in /work/projects/melanomics/analysis/genome/variants2/filter/*/somatic/vcf/*.somatic.testvariants.annotated.short.vcf.1; do ./sorted.sh $k > $k.sorted; done
}


make_input()
{
    for k in 2 4 5 6 7 8
    do
	sample=patient_$k
	vcf=/work/projects/melanomics/analysis/genome/variants2/filter/$sample/somatic/vcf/$sample.somatic.testvariants.annotated.short.vcf.1.sorted
	echo $sample $vcf
    done > vcf_files.in
}

sorted
#make_input


    
