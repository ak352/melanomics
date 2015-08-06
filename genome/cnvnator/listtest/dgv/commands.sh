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


INDIR=/work/projects/melanomics/analysis/genome/cnvnator/binSize100/ 
#input=$INDIR/patient_2.cnv.list.NS.PM.tested

DGV_DIR=/work/projects/melanomics/data/dgv/
dgv=$DGV_DIR/GRCh37_hg19_variants_2014-10-16.txt


prepare_cnv()
{
    input=$1
    echo -e "chr\tbegin\tend\tNS\tPM" > $input.wheader
    sed 's/^chr//g' $input >> $input.wheader
    out_status $input.wheader
}


get_dgv()
{
    output=$DGV_DIR/cnv
    head -n1 $dgv > $output
    sed '1d' $dgv | awk -F"\t" '$5~/CNV/' >> $output
    out_status $output
}

combine()
{

    input0=$1
    input=$input0.wheader
    output=$input.dgv

    status "Joining CNV with DGV variants..."
    cgatools join --beta --match chr:chr --overlap begin,end:start,end \
	-m compact-pct -a --select A.*,B.variantaccession --input $input $dgv \
	> $output
    out_status $output
}

get_ratios()
{
    input=$1
    input=$input.wheader.dgv
    output=$input.ratios
    python get_ratios.py $input > $output.temp
    python in_dgv.py $output.temp > $output
    status "Getting stats for DGV annotation..."
    python dgv_stats.py $output
    out_status $output
}

annotate()
{
    input=$1.wheader.dgv.ratios
    output=$input.genes
    python annotate.py $input > $output
    
}



while read line
do
    echo "Input: $line"
    #prepare_cnv $line
    #get_dgv 
    #combine $line
    get_ratios $line
    
    #annotate $line
done < inputs

