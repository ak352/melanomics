#!/bin/bash --login
module load intervaltree

# For all patients-  DEL, DUP, INV


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

prepare_list()
{
    input=$1
    output=$1.sorted
    status "Input: $input"

    status "Sorting chromosomes such that chrom1 < chrom2..."
    ##TODO: break this into sorting chromosomes+adding fields and adding ids
    ## after sorting chromosomes+add fields, sort
    ## then add ids
    python prepare_list.py $input > $output
    cp $output $input

    out_status $input
    status "Sorting chromosomes and positions..."
    #Sorts based on columns 5,6,7,8
    ./sorted.sh $input > $output
    out_status $output
    cp $output $input
    status "Adding ids..."
    python add_ids.py $input > $output
    cp $output $input 
    out_status $input

}

# #prepare_test not required as chrom1=chrom2
# prepare_test()
# {
#     input=$1
#     output=$1.intervals
#     status "Getting intervals for translocations..."
#     status "Sorting chromosomes such that chrom1 < chrom2..."
#     python prepare_test.py $input > $output
#     out_status $output
# }


do_overlap()
{
    input=$1
    tests=$2
    tested=$3

    cmd_paste=""
    while read line
    do
    	set $line
	echo $line
    	#Use allJunctions-*.tsv file for testing the SVs
    	sample=$1
    	intervals=$2
    	>&2 echo "Testing junctions using $intervals ..."
    	input1=$input
    	input2=$intervals
	status "Input 1: $input1"
	status "Input 2: $input2"
	#overlap -h
	logfile=$tested.$sample.log
	overlap -a $input1 -b $input2 -l $logfile -m chrom,chrom:chrom,chrom -o begin,end:begin,end -f binary -t100000 -n $sample -s B.* > $tested.$sample
	out_status $tested.$sample
	cmd_paste="$cmd_paste $tested.$sample"
    	echo $sample tested.
    done < $tests

    cmd_paste="paste $input $cmd_paste > $tested"
    status "$cmd_paste" 
    eval $cmd_paste
    out_status $tested

	


    #python discordant.py $temp > $output

    #mv $output $tested
    #out_status $tested
    
}

OUTDIR=/work/projects/melanomics/analysis/genome/sv/merged_junctions/
mkdir -v $OUTDIR

svtype=DUP
for k in 2 4 5 6 7 8
do
    list=/work/projects/melanomics/analysis/genome/sv/merged/patient_${k}.$svtype.list
    tested=$OUTDIR/patient_${k}.$svtype.list.tested
    tests=patient_${k}.inputs
    do_overlap $list $tests $tested
done
