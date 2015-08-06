for k in /work/projects/melanomics/analysis/genome/variants2/intermediate/*.fasd.corr.noM.vcf
do
    sample=`grep -m1 ^"#CHROM" $k| cut -f10`
    echo -e "${sample}\t${k}"
done > vcf_files.in


