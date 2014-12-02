#!/bin/bash --login
module load cgatools
module load bedtools

csort()
{
    sed 's/chr\([0-9]\t\)/chr0\1/g' | sort -k$1,$1 -k$(($1+1)),$(($1+2))n | sed 's/chr0/chr/g' 
}

bp=/work/projects/isbsequencing/shsy5y/analysis/sv/illumina/SS6002862_SH-SY5Y.ALL.merged.bed
il=/work/projects/isbsequencing/shsy5y/analysis/sv/illumina/SS6002862_SH-SY5Y.loci
echo -e ">chrom\tbegin\tend" > $il
grep DEL_ $bp | cut -f1-3 | sed 's/chr\([0-9]\t\)/chr0\1/g' | csort 1 >> $il


cgin=/work/projects/isbsequencing/shsy5y/analysis/sv/cg/allSvEventsBeta-GS00533-DNA_A01_201_37-ASM.tsv
cg=/work/projects/isbsequencing/shsy5y/analysis/sv/cg/allSvEventsBeta-GS00533-DNA_A01_201_37-ASM.loci
echo -e ">chrom\tbegin\tend" > $cg
grep deletion $cgin | cut -f6-8 | csort 1 >> $cg

mkdir /work/projects/isbsequencing/shsy5y/analysis/sv/merged/
out=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list
(head -n1 $cg; (sed '1d' $cg; sed '1d' $il;)|sort -u | csort 1)  > $out
list=$out

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
    
    echo Bedtools
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

    overlap=$output
    output=$3.3
    if [ add=="True" ]
    then
	python decide_present_or_not.py $overlap $add | csort 1 | cut -f1-3,5> $output
    else
	python decide_present_or_not.py $overlap $add | csort 1 > $output
    fi

}

#Usgae: combine the separate test variants output
combine()
{
    cg=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.cg.3
    il=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.il.3
    output=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.cg.il.tested
    echo -e "chrom\tbegin\tend\tcg\til" > $output
    paste $cg $il | cut -f1-4,8 >> $output
}    

annotate()
{
    genes=/work/projects/isbsequencing/tools/annovar/2012Oct23/hg19/hg19_refGene.txt
    output=/work/projects/isbsequencing/shsy5y/analysis/sv/genes/hg19_refGene_locations
    echo -e ">chrom\tbegin\tend\tgene" > $output
    awk -F"\t" 'BEGIN{OFS="\t"}{print $3,$5,$6,$2}' $genes | csort 1 >> $output
}

output=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.cg
overlap $list $cg $output 2,3,5,6 True

output=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.il
overlap $list $il $output 2,3,5,6 True

combine 
annotate

input=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.cg.il.tested
output=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.cg.il.tested.annotated
genes=/work/projects/isbsequencing/shsy5y/analysis/sv/genes/hg19_refGene_locations
echo -e ">chrom\tbegin\tend\tcg\til\tgenes" > $output
cgatools join -am compact --beta --match chrom:chrom --overlap begin,end:begin,end $input $genes \
| sed '1d' \
| cut -f1-5,9 \
>> $output


input=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/deletions.list.cg.il.tested.annotated
output=/work/projects/isbsequencing/shsy5y/analysis/sv/merged/overlapping_deletion_genes
awk -F"\t" '{if(($4=="1")&&($5=="1")) print;}' $input| cut -f6 | sed 's/;/\n/g' |sort -u |grep -vP "^$" >  $output


