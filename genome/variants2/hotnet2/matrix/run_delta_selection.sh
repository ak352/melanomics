# python bin/findThreshold.py network <additional_parameters>

# =============================================================================================================
# | PARAMETER NAME          | REQUIRED/DEFAULT   | DESCRIPTION                                                |
# =============================================================================================================
# |-r/--runname             | None               |Name of run / disease.                                      |
# -------------------------------------------------------------------------------------------------------------
# |-mn/--infmat_name        | PPR                |Variable name of the influence matrices in the .mat files   |
# -------------------------------------------------------------------------------------------------------------
# |-if/--infmat_index_file  | REQUIRED           |Path to tab-separated file containing an index in the first |
# |                         |                    |column and the name of the gene represented at that index   |
# |                         |                    |in the second column of each line.                          |
# -------------------------------------------------------------------------------------------------------------
# |-hf/--heat_file          | REQUIRED           |JSON heat score file generated via generateHeat.py          |
# -------------------------------------------------------------------------------------------------------------
# |-n/--num_permutations    | REQUIRED           |Number of permuted data sets to generate                    |
# -------------------------------------------------------------------------------------------------------------
# |-s/--test_statistic      | max_cc_size        |If max_cc_size, select smallest delta for each permuted     |
# |                         |                    |dataset such that the size of the largest CC is <= l. If    |
# |                         |                    |num_ccsselect for each permuted dataset the delta that      |
# |                         |                    |maximizes the number of CCs of size >= l.                   |
# -------------------------------------------------------------------------------------------------------------
# |-l/--sizes               | 5, 10, 15, 20      |See test_statistic. For test_statistic 'num_ccs', default   |
# |                         |                    |is 3.                                                       |
# -------------------------------------------------------------------------------------------------------------
# |-c/--num_cores           | 1                  |Number of cores to use for running permutation tests in     |
# |                         |                    |parallel. If -1, all available cores will be used.          |
# -------------------------------------------------------------------------------------------------------------
# |--classic                | False              |Run classic (instead of directed) HotNet.                   |
# -------------------------------------------------------------------------------------------------------------
# |-o/--output_file         | None               |Output file. If none given, output will be written to       |
# |                         |                    |stdout.                                                     |
# -------------------------------------------------------------------------------------------------------------
# |-pnp                     | REQUIRED           |Path to influence matrices for permuted networks. Include   |
# |--permuted_networks_path |                    |##NUM## in the path to be replaced with the iteration       |
# |                         |                    |number                                                      |
# -------------------------------------------------------------------------------------------------------------

echo OAR_JOB_ID = $OAR_JOB_ID
curr_dir=$PWD
work_dir=/work/projects/melanomics/tools/hotnet/hotnet2/

runname=iref
infmat_name=PPR
infmat_index_file=/work/projects/melanomics/tools/hotnet/hotnet2/influence_matrix_downloaded/iref/iref_index_genes
# heat_file=/work/projects/melanomics/analysis/genome/variants2/hotnet/mutsig.out
threshold=0.1
#threshold=0.15
heat_file=/work/projects/melanomics/analysis/genome/variants2/hotnet/mutsig.$threshold.out
mut_heat_file=/work/projects/melanomics/analysis/genome/variants2/hotnet/mutation.out

num_perm=100
#num_perm=10
cores=-1 #All available cores used when cores = -1
permuted_networks_path=/scratch/users/akrishna/hotnet2/iref/matrix/iref_matrix.##NUM##_ppr_0.6.mat 	
#OUTDIR=/scratch/users/akrishna/hotnet2/iref/delta
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/hotnet/iref/delta
mkdir -v $OUTDIR
output=$OUTDIR/delta.$threshold 
mut_output=$OUTDIR/delta.mutation

config_dir=$OUTDIR/config
mkdir -v $config_dir
config=$config_dir/delta.config
mut_config=$config_dir/delta.mutation.config



# Computes the delta threshold for edge removal, required in the HotNet run step. Take the median accross all deltas.
(echo "network";\
 echo "-r $runname";\
 echo "-mn $infmat_name";\
 echo "-if $infmat_index_file";\
 echo "-hf $heat_file";\
 echo "-n $num_perm";\
 echo "-c $cores";\
 echo "-o $output";\
 echo "-pnp $permuted_networks_path") > $config 

cmd="python $work_dir/bin/findThreshold.py @$config"
echo $cmd
echo Config:
cat $config
#eval $cmd

# Extracts the medians for different max. connected component sizes
cmd="python get_delta.py $output $output.medians"
echo $cmd
#eval $cmd


(echo "network";\
 echo "-r $runname";\
 echo "-mn $infmat_name";\
 echo "-if $infmat_index_file";\
 echo "-hf $mut_heat_file";\
 echo "-n $num_perm";\
 echo "-c $cores";\
 echo "-o $mut_output";\
 echo "-pnp $permuted_networks_path") > $mut_config 

cmd="python $work_dir/bin/findThreshold.py @$mut_config"
echo $cmd
echo Config:
cat $mut_config
eval $cmd

# Extracts the medians for different max. connected component sizes
cmd="python get_delta.py $mut_output $mut_output.medians"
echo $cmd
eval $cmd





