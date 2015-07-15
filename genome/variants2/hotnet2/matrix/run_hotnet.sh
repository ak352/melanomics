
# python bin/findComponents.py <additional_parameters> none

# ========================================================================================================
# | PARAMETER NAME         | REQUIRED/DEFAULT | DESCRIPTION                                              |
# ========================================================================================================
# |-r/--runname            | None             |Name of run/disease. This is only for the user's          |
# |                        |                  |record-keeping convenience; the parameter is not used by  |
# |                        |                  |the HotNet algorithm.                                     |
# --------------------------------------------------------------------------------------------------------
# |-mf/--infmat_file       | REQUIRED         |Path to .mat file containing influence matrix.            |
# --------------------------------------------------------------------------------------------------------
# |-mn/--infmat_name       | PPR              |Variable name of the influence matrix in the .mat file.   |
# --------------------------------------------------------------------------------------------------------
# |-if/--infmat_index_file | REQUIRED         |Path to tab-separated file containing an index in the     |
# |                        |                  |first column and the name of the gene represented at that |
# |                        |                  |index in the second column of each line.                  |
# --------------------------------------------------------------------------------------------------------
# |-hf/--heat_file         | REQUIRED         |JSON heat score file generated via generateHeat.py        |
# --------------------------------------------------------------------------------------------------------
# |-d/--deltas             | REQUIRED         |Weight thresholds for edge removal.                       |
# --------------------------------------------------------------------------------------------------------
# |-ccs/--min_cc_size      | 2                |Minimum size connected components that should be returned.|
# --------------------------------------------------------------------------------------------------------
# |-o/--output_directory   | REQUIRED         |Output directory. Files results.json, components.txt, and |
# |                        |                  |significance.txt will be generated in subdirectories for  |
# |                        |                  |each delta.                                               |
# --------------------------------------------------------------------------------------------------------
# |-c/--classic            | None             |Run classic HotNet (rather than HotNet2).                 |
# --------------------------------------------------------------------------------------------------------


echo OAR_JOB_ID = $OAR_JOB_ID
curr_dir=$PWD
work_dir=/work/projects/melanomics/tools/hotnet/hotnet2/

runname=iref
infmat_name=PPR
infmat_index_file=/work/projects/melanomics/tools/hotnet/hotnet2/influence_matrix_downloaded/iref/iref_index_genes
threshold=0.1
heat_file=/work/projects/melanomics/analysis/genome/variants2/hotnet/mutsig.$threshold.out
num_perm=100
infmat_file=/work/projects/melanomics/tools/hotnet/hotnet2/influence_matrices/irefindex/iref_ppr_0.55.mat
deltas=/scratch/users/akrishna/hotnet2/iref/delta/delta.$threshold.medians
mut_deltas=/scratch/users/akrishna/hotnet2/iref/delta/delta.mutation.medians

OUTDIR=/scratch/users/akrishna/hotnet2/iref/hotnet
mkdir -v $OUTDIR
OUTDIR=$OUTDIR/$threshold
mkdir -v $OUTDIR

config_dir=$OUTDIR/config
mkdir -v $config_dir
config=$config_dir/run.config


# Creating config file
while read line
do
    set $line
    delta_val="$delta_val $2"
done< <( sed '1d' $deltas)

echo "-d $delta_val" > $config
cmd=" -r $runname \n\
      -mf $infmat_file \n\
      -mn $infmat_name \n\
      -if $infmat_index_file \n\
      -hf $heat_file \n\
      -o $OUTDIR"
echo -e $cmd >> $config


# Why do we need this permutations genes file: list of additional genes
# that can have permuted heat values assigned to them in permutation tests?
# permutation_genes_file=
num_permutations=100
num_cores=-1


# Choose "none" to run without significance testing
# cmd_sig="none"
# Running significance testing with permuted heat scores
echo "heat" >> $config
echo "-n $num_permutations" >> $config
echo "-c $num_cores" >> $config
# There is also an option to run with permuted mutation data


echo Config:
cat $config

python $work_dir/bin/findComponents.py @$config
