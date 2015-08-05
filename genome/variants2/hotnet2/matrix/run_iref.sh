#!/bin/bash --login

echo OAR_JOB_ID = $OAR_JOB_ID
curr_dir=$PWD
work_dir=/work/projects/melanomics/tools/hotnet/hotnet2/
gene_index=$work_dir/influence_matrix_downloaded/iref/iref_index_genes
alpha=0.6
# out_dir=influence_matrix_downloaded/iref/matrix/
#edge_list_input=edge_list.input
edge_list_input=temp_input

out_dir=$SCRATCH/hotnet2/iref/matrix/
tmp_dir=$out_dir/tmp
mkdir -v $tmp_dir

echo Gene index file: $gene_index
echo Alpha: $alpha
echo Edge list input file: $edge_list_input
echo Output directory: $out_dir
echo Temporary directory: $tmp_dir


create_matrix()
{
    set $1
    edgelist=$1
    prefix=$2
    date
    echo Edge list: $edgelist
    echo Prefix: $prefix
    cmd="time python $work_dir/bin/createPPRMat.py -e $edgelist -i $gene_index -o $out_dir  -a $alpha -p $prefix 2>&1 > $out_dir/$prefix.stderr"
    echo $cmd
    eval $cmd
    date
}

make_input()
{
    # Get all input files for GNU parallel
    for k in $work_dir/influence_matrix_downloaded/iref/iref_edgelist_*
    do
	prefix=${k##*/}
	prefix=iref_matrix.${prefix##iref_edgelist_}
	echo $k $prefix
    done > $edge_list_input
    echo Output written to $edge_list_input
}


parallel_create_matrix()
{
    # Run matrix creation in parallel for all the edge lists (creates 1G * 1000 edge list files = 1TB data)
    export work_dir
    export gene_index
    export out_dir
    export alpha
    export -f create_matrix
    cat $edge_list_input | parallel --tmpdir $tmpdir --progress create_matrix

    
}

make_input
parallel_create_matrix
