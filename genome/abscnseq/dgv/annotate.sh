#!/bin/bash --login
module load cgatools

status()
{
    d=`date`
    echo [$d] $1
}

out_status()
{
    d=`date`
    echo [$d] Output written to $1
    wc -l $1
}

get_header()
{
    header=/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene_header
    refgene=/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.txt
    refgene_wheader=/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.wheader.txt
    out_status $refgene


    (sed 's/\t/ /g' $header \
	| cut -f1 -d' ' | sed 's/.*/&\t/g'| tr -d '\n'; echo;) > $refgene_wheader
    sed 's/\tchr/\t/g' $refgene >> $refgene_wheader
    out_status $refgene_wheader
}

combine()
{
    input=$1
    genes=/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.wheader.txt 
    output=$input.genes
    status "Annotating CNV segments with genes..."
    status "Input: $input"
    out_status $input
    cgatools join --beta --match chr:chrom --overlap begin,end:txStart,txEnd \
	-m compact-pct -a --select A.*,B.name2 --input $input $genes > $output
    out_status $output
    #head -n5 $output
}

combine_per_gene()
{
    input=$1
    genes=/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.wheader.txt 
    output=$input.per_gene
    # head -n1 $input
    status "Annotating genes with CNV segments..."
    status "Input: $input"
    out_status $genes
    # cgatools join --beta --match chrom:chr --overlap txStart,txEnd:begin,end \
    # 	-m compact-pct -a --select A.name2,B.found_in_dgv,B.PM_NS_ratio --input $genes $input > $output
    cgatools join --beta --match chrom:chr --overlap txStart,txEnd:begin,end \
    	-m compact-pct -a --select A.name2,B.ploidy,B.found_in_dgv --input $genes $input > $output
    out_status $output
    head -n5 $output
   
}
#get_header
while read line
do
    input=$line.wheader.dgv
    #head -n2 $input| column -ts $'\t'
    #combine $input
    #combine_per_gene $input

    #input=$input.genes
    #awk -F"\t" '($8=="gain" || $8=="loss") && $9!=""' $input | cut -f1-3,7,8,9 | head -n5

    input=$input.per_gene
    head -n50 $input| tail -n5
    output=$input.mean
    
    python weighted_mean_ratio.py $input > $output
    echo $input


  
    # (head -n1  $input.per_gene.mean; \
    # sed '1d' $input.per_gene.mean | awk -F"\t" '($4<0.5 || $4 > 1.5)';) \
    # 	| python has_dgv.py;
    #awk -F"\t" '$2==""' $output| wc -l 
    #out_status $output
    #echo
done < inputs

