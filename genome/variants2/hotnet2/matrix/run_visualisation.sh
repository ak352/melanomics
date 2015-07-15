# ========================================================================================================
# | PARAMETER NAME         | REQUIRED/DEFAULT | DESCRIPTION                                              |
# ========================================================================================================
# |-r/--results_files      | REQUIRED         |Paths to results.json files output by HotNet2. Multiple   |
# |                        |                  |file paths may be passed.                                 |
# --------------------------------------------------------------------------------------------------------
# |-ef/--edge_file         | REQUIRED         |Path to TSV file listing edges of the interaction network,|
# |                        |                  |where each row contains the indices of two genes that are |
# |                        |                  |connected in the network.                                 |
# --------------------------------------------------------------------------------------------------------
# |-dsf/                   | None             |Path to a tab-separated file containing a gene name in the|
# |--display_score_file    |                  |first column and the display score for that gene in the   |
# |                        |                  |second column of each line.                               |
# --------------------------------------------------------------------------------------------------------
# |-nn/--network_name      | Network          |Display name for the interaction network.                 |
# --------------------------------------------------------------------------------------------------------
# |-o/--output_directory   | REQUIRED         |Output directory.                                         |
# --------------------------------------------------------------------------------------------------------

echo OAR_JOB_ID = $OAR_JOB_ID
# work_dir=/work/projects/melanomics/tools/hotnet/hotnet2/bin/
work_dir=/work/projects/melanomics/tools/hotnet/hotnet2_mutsigpval/bin/

threshold=0.1
INDIR=/scratch/users/akrishna/hotnet2/iref/hotnet/$threshold
edge_file=/work/projects/melanomics/tools/hotnet/hotnet2/influence_matrices/irefindex/iref_edge_list
network_name=iref_mutsigcv_$threshold
OUTDIR=/scratch/users/akrishna/hotnet2/iref/visualisation
mkdir -v $OUTDIR
OUTDIR=$OUTDIR/$threshold
mkdir -v $OUTDIR

config_dir=$OUTDIR/config
mkdir -v $config_dir
config=$config_dir/website.config


results=
for k in $INDIR/delta_*
do
    results="$results $k/results.json"
done
    

(echo "-r $results";\
 echo "-ef $edge_file";\
 echo "-nn $network_name";\
 echo "-o $OUTDIR";) > $config

echo Config:
cat $config

python $work_dir/makeResultsWebsite.py @$config



