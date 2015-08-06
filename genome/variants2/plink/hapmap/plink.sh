#!/bin/bash --login
VCFTOOLS=/work/projects/melanomics/tools/vcftools/vcftools_0.1.12a/bin/vcftools

make_panel()
{
    output=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/sample_panel
    for k in 2 4 5 6 7 8
    do
	for m in NS PM
	do
	    echo -e "patient_${k}_${m}\teur"
	done
    done > $output
}

vcf_to_ped()
{
    vcf2ped=/work/projects/melanomics/tools/vcf2ped/vcf_to_ped_convert.pl
    vcf=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap.vcf
    sample_panel=/work/projects/melanomics/analysis/genome/variants2/plink/sample_panel
    for k in {1..22} X Y MT
    do
	perl $vcf2ped -vcf $vcf -sample_panel_file  $sample_panel -population eur -region $k
	echo Chromosome $k done.
    done
}

vcf_to_plink()
{
    vcf=/work/projects/melanomics/analysis/genome/variants2/plink/hapmap/all.filter_annotation.out.hapmap.vcf
    $VCFTOOLS --vcf $vcf --plink
}

get_ped()
{
    cut -f1-6 22.ped > eur.ped
    cp eur.ped eur.temp.ped
    for k in {1..22} X Y MT
    do
	##TODO: check if the order of patients is the same accross different PED files
	paste eur.temp.ped <( cut -f7- $k.ped) > eur.ped
	cp eur.ped eur.temp.ped
	echo $k pasted
    done
}
    

get_map()
{
    output=eur.map
    for k in {1..22} X Y MT
    do
	sed 's/:[^\t]\+//1' $k.info \
	    | awk -F"\t" -v chr=$k\
	    'BEGIN{OFS="\t"}{s += 1; print $1,"rs_"chr"_"s,"0",$2}'
    done > $output
    head $output
}

plink_genome()
{
    module load PLINK
    plink --bfile out --genome --out eur

}


run_plink()
{
    module load PLINK
    #wc -l out.map
    #awk -F"\t" '{print NF}' out.ped
    #plink --file out --cluster --noweb --mds-plot 4
    plink --file out --het
    plink --file out --genome
    module unload PLINK
}

plot()
{
    sed 's/ \+/\t/g' plink.mds > plink.mds.delim
    wc -l plink.mds.delim
    python plotter.py
}

#make_panel
#vcf_to_ped
#get_ped


#head 22.info
#wc -l eur.map
#head 1.ped | cut -f1-20 #awk -F"\t" '{print NF}' 
#head eur.ped | cut -f7- | awk -F"\t" '{print NF}'
#get_map


#vcf_to_plink

#Population stratification - clustering
#ln -s out.ped out.fam
run_plink

#plot


