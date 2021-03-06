#!/bin/bash --login
module load cgatools
module load bedtools

tawk()
{
    awk -F"\t" $1
}

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

csort()
{
    sed 's/chr\([0-9]\t\)/chr0\1/g' | sort -k$1,$1 -k$(($1+1)),$(($1+2))n | sed 's/chr0/chr/g' 
}


#Usage: overlap <BED list file> <BED input file> <output prefix> 
overlap()
{
    #cgatools overlap
    list=$1
    input=$2
    output=$3.1
    overlap_cols=$4
    add=$5
    
    #output=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.cg
    cgatools join -a --beta --match chrom:chrom --overlap begin,end:begin,end $list $input | sed '1d' > $output
    overlap=$output
    
    status "Percentage overlap using bedtools, at leats 50 % overlap required to consider as same..."
    #use bedtools to 
    output=$3.2
    (awk -F"\t" '{if($NF!="") print;}' $overlap \
	| bedtools overlap -i stdin -cols $4 | awk -F"\t" 'BEGIN{OFS="\t"}{print $0, ($7/($3-$2)*100)}' \
	| awk -F"\t" 'BEGIN{OFS="\t"}{if($8>50) print $0,1; else print $0, 0}' \
	| cut -f 1-3,9; \
	awk -F"\t" 'BEGIN{OFS="\t"}{if($4=="") print $1,$2,$3,0;}' $overlap;) \
	| sort -u \
	| csort 1 \
	>  $output

    status "Deciding SV present or not for each sample..."
    overlap=$output
    output=$3.3
    if [ add=="True" ]
    then
	python decide_present_or_not.py $overlap $add | csort 1 | cut -f1-3,5> $output
    else
	python decide_present_or_not.py $overlap $add | csort 1 > $output
    fi
    out_status $output

}

#Usgae: combine the separate test variants output
combine()
{
    #one=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.meerkat.3
    #two=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.lumpy.3
    #output=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.meerkat.lumpy.tested
    status "Combining $1 and $2 ..."
    echo -e "chrom\tbegin\tend\tlumpy\tdelly" > $3
    paste $1 $2 | cut -f1-4,8 >> $3
    out_status $3
}    

annotate()
{
    gene_anno=/work/projects/isbsequencing/tools/annovar/2012Oct23/hg19/hg19_refGene.txt
    #output=/work/projects/isbsequencing/shsy5y/analysis/sv/genes/hg19_refGene_locations
    output=$1
    echo -e ">chrom\tbegin\tend\tgene" > $output
    awk -F"\t" 'BEGIN{OFS="\t"}{print $3,$5,$6,$2}' $gene_anno | csort 1 | sed 's/^chr//g' >> $output
    out_status $output
}

while read svtype lumpy_sv delly list out_lumpy out_delly tested genes annotated affected_genes
do

    out=$list
    status "Writing list to $out"
    (head -n1 $delly; (sed '1d' $lumpy_sv; sed '1d' $delly;)|sort -u | csort 1)  > $out
    out_status $out
    list=$out

    overlap $list $lumpy_sv $out_lumpy 2,3,5,6 True
    overlap $list $delly $out_delly 2,3,5,6 True

    status "Writing to $tested..."
    combine $out_lumpy.3 $out_delly.3 $tested
    annotate $genes

    input=$tested
    output=$annotated
    echo -e ">chrom\tbegin\tend\tcg\til\tgenes" > $output
    cgatools join -am compact --beta --match chrom:chrom --overlap begin,end:begin,end $input $genes \
    	| sed '1d' \
    	| cut -f1-5,9 \
    	>> $output
    out_status $output

    input=$annotated
    output=$affected_genes
    echo $output
    awk -F"\t" '{if(($4=="1")&&($5=="1")) print;}' $input| cut -f6 | sed 's/;/\n/g' |sort -u |grep -vP "^$" > $output
    out_status $output
done < params

