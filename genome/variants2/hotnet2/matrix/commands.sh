# Function for generating influence matrices for permuted networks of iref network (these were downloaded)
iref()
{
    stdout=/work/projects/melanomics/tools/hotnet/hotnet2/influence_matrix_downloaded/iref/matrix/iref.stdout
    stderr=/work/projects/melanomics/tools/hotnet/hotnet2/influence_matrix_downloaded/iref/matrix/iref.stderr
    name=iref
    oarsub -t bigsmp -lnodes=1/core=150,walltime=24 -O $stdout -E $stderr -n $name ./run_iref.sh
}


# Hotnet requires the following 6 steps
# Step 1 - this step should be parallelised
# iref

# The remaining steps can be run interactively - they do not need a lot of memory or parallelism
# Step 2
# ./run_generate_heat.sh

# Step 3
# ./run_delta_selection.sh

# Step 4
# ./run_hotnet.sh

# Step 5
# ./run_visualisation.sh

# Step 6 - Needs to be tested; only used to combine results from different reference networks (e.g. iref and HPRD)
# ./run_consensus.sh
