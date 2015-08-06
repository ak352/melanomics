for k in /scratch/users/akrishna/plink/vcf/*.lane.vcf
do
    sample=`grep -m1 ^"#CHROM" $k| cut -f10`
    echo -e "${sample}\t${k}"
done > vcf_files.in


