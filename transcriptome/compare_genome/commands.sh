PATH=/work/projects/melanomics/tools/bcftools/bcftools-1.2/:$PATH
PATH=/work/projects/melanomics/tools/vcftools/vcftools_0.1.12a/bin/:$PATH
export PATH

patient=patient_2

ref=/mnt/gaiagpfs/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
rna_snp_vcf=/work/projects/melanomics/analysis/transcriptome/snv_indels/$patient.fasd.vcf
dna_all=/work/projects/melanomics/analysis/genome/variants2/intermediate/all.dna.coverage_annotated.vcf.gz
OUTDIR=/work/projects/melanomics/analysis/transcriptome/compare_genome/
mkdir -v $OUTDIR

#output files
dna=$OUTDIR/$patient.dna.vcf.gz
rna_snp=$rna_snp_vcf.gz


extract_dna()
{
    cmd="bcftools view -s ${patient}_PM $dna_all -O z | bcftools view -g ^miss -e 'GT==\"0/0\"' -O z > $dna;"
    cmd="$cmd bcftools index -f $dna;"
    echo $cmd; eval $cmd
    grep -v '^##'  $dna| head 
}

prepare_rna()
{
    cmd="bcftools view -Oz $rna_snp_vcf > $rna_snp"
    echo $cmd; eval $cmd
    cmd="bcftools index -f $rna_snp"
    echo $cmd; eval $cmd
}

norm()
{
    for input in $rna_snp $dna
    do
	output=${input%.vcf.gz}.norm.vcf.gz
	cmd="bcftools norm -f $ref $input -c w -O z > $output;"
	cmd="$cmd bcftools index -f $output;"
	echo $cmd; eval $cmd
    done
}

compare()
{
    #mkdir -v $OUTDIR/$patient/

    cmd="bcftools stats -c none ${dna%.vcf.gz}.norm.vcf.gz ${rna_snp%.vcf.gz}.norm.vcf.gz > $OUTDIR/$patient.dna.rna.stats"
    echo $cmd; eval $cmd
    #cmd="vcf-compare ${dna%.vcf.gz}.norm.vcf.gz ${rna_snp%.vcf.gz}.norm.vcf.gz > $OUTDIR/$patient.dna.rna.compare.stats"
    #echo $cmd; eval $cmd

    
}    



extract_dna
prepare_rna
norm
compare



