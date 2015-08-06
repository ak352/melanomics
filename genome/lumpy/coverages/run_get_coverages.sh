#!/bin/bash --login
module load numpy
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
pe=$1
sr=$2
out=$3
status "Getting coverages for $pe and $sr"
python $SCRIPTDIR/get_coverages.py $pe $sr > $out
out_status $out
