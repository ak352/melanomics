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

testvariants=$1
exclude=$2
out=$3


status "Joining $testvariants and $exclude..."
cgatools join --beta --input $testvariants --input $exclude --match chrom:chrom --overlap begin,end:begin,end -m compact-pct -a > $out
out_status $out




