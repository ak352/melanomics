# ========================================================================================================
# | PARAMETER NAME         | REQUIRED/DEFAULT | DESCRIPTION                                              |
# ========================================================================================================
# |-r/--results_files      | REQUIRED         |Paths to results.json files output by HotNet2. Multiple   |
# |                        |                  |file paths may be passed.                                 |
# --------------------------------------------------------------------------------------------------------
# |-n/--networks           | REQUIRED         |List of network names, one per result file.               |
# --------------------------------------------------------------------------------------------------------
# |-o/--output_file        | REQUIRED         |Output directory.                                         |
# --------------------------------------------------------------------------------------------------------
# |-ms/--min_cc_size       | REQUIRED         |Restrict consensus to subnetworks of at least this size.  |
# |                        |                  |Default: 2.                                               |
# --------------------------------------------------------------------------------------------------------


echo OAR_JOB_ID = $OAR_JOB_ID
work_dir=/work/projects/melanomics/tools/hotnet/hotnet2/
#OUTDIR=/scratch/users/akrishna/hotnet2/consensus/
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/hotnet/consensus/
min_cc_size=2
mkdir -v $OUTDIR

# This requires a space-delimited file containing path to results.json file and a network name per line
while read line
do
    set $line
    results_files=" -r $1"
    networks=" -n $2"
done

python identifyConsensus.py $results_files $networks -o $OUTDIR -ms $min_cc_size





