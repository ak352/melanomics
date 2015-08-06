#!/bin/bash --login
module load Java
GATK=/work/projects/melanomics/tools/gatk/gatk3/
IGVTOOLS=/work/projects/melanomics/tools/igv/IGVTools/igvtools


add_lane_label()
{
    INDIR=/scratch/users/akrishna/plink/vcf/
    for k in $INDIR/*.vcf
    do
	sample=`echo $k| grep -oP 'patient_[0-9]+_[NSPM]+' | cut -f2-3 -d"_" | sed 's/_//g'`
	echo $sample
	lane=`echo $k| grep -oP 'lane_[0-9]+'| cut -f2 -d"_"`
	output=${k%.vcf}.lane.vcf
	#sed -e "s/patient_.*/$sample$lane/1" $k > $output
	sed "s/^#CHROM.*/&_lane_$lane/1" $k > $output
	#head -n60 $output
	$IGVTOOLS index $output
    done
}


add_lane_label





