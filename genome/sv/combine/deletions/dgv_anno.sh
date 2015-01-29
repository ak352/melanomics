#!/bin/bash --login
module load cgatools

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


INDIR=/work/projects/melanomics/analysis/genome/sv/merged
input=$INDIR/patient_6.INV.list.lumpy.delly.tested 

DGV_DIR=/work/projects/melanomics/data/dgv
dgv=$DGV_DIR/GRCh37_hg19_variants_2014-10-16.txt

get_dgv()
{
    output=$DGV_DIR/inversions
    head -n1 $dgv > $output
    sed '1d' $dgv | awk -F"\t" '$6~/inversion/' >> $output
    out_status $output

}

overlap()
{
    input1=$input
    input2=$DGV_DIR/inversions
    output=$input.dgv
    status "Annotating junctions"
    cgatools join --beta --match chrom:chr --overlap begin,end:start,end --input $input1 $input2 \
	-m compact-pct --select A.*,B.variantaccession > $output
    out_status $output
}

#get_dgv
overlap



