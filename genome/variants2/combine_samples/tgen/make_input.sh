for k in /scratch/users/akrishna/plink/tgen/vcf/*.vcf
do
    sample=${k##*/}
    sample=${sample%.vcf}
    echo -e "${sample}\t${k}"
done > vcf_files.in


