#!/bin/bash --login
module load BEDTools

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


SCRIPTDIR=/work/projects/melanomics/tools/lumpy/lumpy-sv/scripts/
threshold=$1
exclude=$2
pe=$3
se=$4
status "Creating exclude BED file for $pe and $se ..."
python $SCRIPTDIR/get_exclude_regions.py $threshold $exclude $pe $se
out_status $exclude
