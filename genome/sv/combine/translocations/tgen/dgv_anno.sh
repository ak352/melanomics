#!/bin/bash --login
module load cgatools
#module load intervaltree
#above module load not working due to new OS; Lmod error so hard-coded the path below
export PATH=/work/projects/melanomics/tools/ak_pipeline/intervaltree:$PATH


cindex()
{
    sed 's/\t/\n/g' $1 | cat -n 
}

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

SV_TYPE=TRA
# DGV_DIR=/work/projects/melanomics/data/dgv
# dgv=$DGV_DIR/GRCh37_hg19_variants_2014-10-16.txt
LIT_DIR=/work/projects/melanomics/data/berger_prex2_nature/
lit=$LIT_DIR/Berger_Prex2_Nature_2012_SUPPL_TABLE.edited.csv

# There are no translocations in DGV
# get_dgv()


sort_input()
{
    input=$1
    #echo Input begins here...
    #head $input
    #echo Input ends here...
    python sort_chromosomes_in_tv.py $input > $input.sorted
}

# No translocations in DGV
# overlap1()


overlap2()
{
    input1=$1
    input2=$2
    output=$input1.${input2##*/}
    status "Annotating junctions"
    overlap -m chrom1,chrom2:chrom1,chrom2 -o pos1,pos2:pos1,pos2 -a $input1 -b $input2 \
    	-f binary -s A.*,B.* -t 100000 -n tgen > $output
    out_status $output

}


genes()
{
    input=$1
    genes=/work/projects/melanomics/tools/annovar/2014Nov12/humandb/hg19_refGene.wheader.txt 
    output=$input.genes
    status "Annotating CNV segments with genes..."
    status "Input: $input"
    out_status $input
    cgatools join --beta --match chrom1:chrom --overlap pos1:txStart,txEnd \
	-m compact -a --select B.name2 --input $input $genes > $output.temp.start
    cgatools join --beta --match chrom1:chrom --overlap pos2:txStart,txEnd \
	-m compact -a --select B.name2 --input $input $genes > $output.temp.end
    cgatools join --beta --match chrom1:chrom --overlap pos1:txStart,txEnd \
	-m compact -a --select B.name --input $input $genes > $output.temp.rna.start
    cgatools join --beta --match chrom1:chrom --overlap pos2:txStart,txEnd \
	-m compact -a --select B.name --input $input $genes > $output.temp.rna.end
    paste $input  $output.temp.start  $output.temp.end $output.temp.rna.start $output.temp.rna.end > $output.temp
    (head -n1 $output.temp | sed 's/>name2/LeftGenes/1' \
	| sed 's/>name2/RightGenes/1' \
	| sed 's/>name/LeftRna/1' \
	| sed 's/>name/RightRna/1'; \
	sed '1d' $output.temp;) > $output

    out_status $output
}

rare_genes()
{
    input=$1
    output=$input.rare_genes
    head -n2 $input
    status "Listing genes overlapping rare breakpoints..."
    python rare_genes.py $input > $output
    out_status $output
}



make_inputs()
{
    infile1=/work/projects/melanomics/analysis/genome/sv/delly/tgen_p6/merged_S2_PM.bam.prmdup.TRA.vcf.testvariants
    infile2=/work/projects/melanomics/analysis/genome/sv/delly/patient_2/final/patient_2_PM.TRA.testvariants
    echo $infile1 $infile2 > inputs
}



make_inputs


#ls /work/projects/melanomics/analysis/genome/sv/delly/testvariants/
while read input_file
do

    set $input_file
    sort_input $1
    sort_input $2

    #get_lit
    overlap2 $2.sorted $1.sorted

    # Join with Berger et al. and DGV
    
    #join $input_file
    #genes $input_file.sorted.berger
    # head $input_file.berger.dgv.genes

    # No translocations in DGV, so treat all genes as rare genes
    # rare_genes $input_file.sorted.berger.genes
    # head $input_file.berger.dgv.genes.rare_genes

    #awk -F"\t" '{print NF}' $input.genes | sort -u
    #head -n1 $input.berger.dgv.genes| column -ts $'\t'
done < inputs




