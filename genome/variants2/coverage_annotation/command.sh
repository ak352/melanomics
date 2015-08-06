

ref=/work/projects/melanomics/data/NCBI/Homo_sapiens/NCBI/build37.2/Sequence/WholeGenomeFasta/genome.fa
# dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.b37.vcf
dbsnp=/work/projects/melanomics/data/broad2/bundle/dbsnp_138.hg19.bgzipped.vcf.gz
input=/work/projects/melanomics/analysis/genome/strelka/patient_2/results/passed.somatic.indels.vcf

# OUTDIR=/work/projects/isbsequencing/luhmes_cell_line/users/akrishna/analysis/snv/plink/dbsnp
OUTDIR=/scratch/users/akrishna//plink
mkdir -v $OUTDIR
output=$OUTDIR/all.dna.dbsnp.vcf


re_sort()
{
    module load tabix
    input=/work/projects/isbsequencing/luhmes_cell_line/users/akrishna/analysis/snv/merged/merged.testvariants.tested.sorted.uniq.any_variant.sorted.vcf.gz 
    OUTDIR=/tmp/chrom
    mkdir -v $OUTDIR
    echo Separating chromosomes...
    for k in {1..22} X Y MT
    do
    	output=$OUTDIR/chr$k.vcf.gz
    	cmd="zgrep -P '^$k\t' $input | bgzip -c > $output"
    	echo $cmd
    	eval $cmd
    	zcat $output | head -n1
    	echo ...
    	zcat $output | tail -n1
    done

    output=${input%%vcf.gz}gatk_sorted.vcf.gz
    echo Loading chromosomes...
    ( zcat $input | grep -P '^#'; \
    while read line
    do
	zcat $OUTDIR/$line.vcf.gz
    done < order;) | bgzip -c > $output
    
    
}
annotate()
{
    module load tabix
    cores=12
    # input=/work/projects/isbsequencing/luhmes_cell_line/users/akrishna/analysis/snv/merged/merged.testvariants.tested.sorted.uniq.any_variant.sorted.gatk_sorted.vcf.gz
    # cmd="python remove_id.py $input | bgzip -c > ${input%%vcf.gz}no_id.vcf.gz;"
    # cmd="$cmd tabix -fp vcf ${input%%vcf.gz}no_id.vcf.gz"
    # echo $cmd
    # eval $cmd

    # zcat  ${input%%vcf.gz}no_id.vcf.gz | head -n30
    # echo ...
    # zcat  ${input%%vcf.gz}no_id.vcf.gz | tail
    
    # cmd="./run_variant_annotator.sh $input $output $dbsnp $ref $cores"
    cmd="./run_variant_annotator.sh ${input%%vcf.gz}no_id.vcf.gz $output $dbsnp $ref $cores"
    echo $cmd
    eval $cmd
    
    # stdout=$output.stdout
    # stderr=$output.stderr
    #oarsub -lcore=12/nodes=1,walltime=120 -n VariantAnnotator -O $stdout -E $stderr "$cmd"
    
}
