### HotNet2 Mutation Pipeline

#### Create influence matrices before running HotNet2
This part takes a few hours but only needs to be done once. The approximate storage size for these networks is 1 TB.
1. Download permuted networks
2. Run ```run_iref.sh``` to create the influence matrices for each permuted network using GNU parallel.
   **This has already been done once and the results are stored in my $SCRATCH/hotnet2/iref/matrix/ directory**

#### Prepare mutation input
These scripts prepare input files for HotNet2 and run the pipeline for HotNet2

1. get_cnv.py - Given a tab-separated input files with a 'name2' header for gene name and 'chrom', 'begin', 'end', generates the CNV input file for HotNet2
2. get_mutation.py - Given the SNV/small indels file in Complete Genomics testvariants format with ANNOVAR annotations, generates the SNV input file for HotNet2 (genes with amino-acid changing mutations)

#### Run HotNet2
1. Generate the heat scores using the MutSigCV output file. Edit the script below to set the MutSigCV output file path. Edit the threshold for p-values. Higher p-value means more genes will be included. The p-value should be the same in steps 1,2,3,4,5. In practice, setting a p-value higher than 0.15 leads to crashing during the delta selection step, perhaps as there are too many genes.
   ```
   ./run_generate_heat.sh
   ```

2. Edit the number of permutations for delta selection (set to 100 for now). Edit the threshold for p-values. The p-value should be the same in steps 1,2,3,4,5
   ```
   ./run_delta_selection.sh
   ```

3. Run HotNet2. Edit the threshold for p-values. The p-value should be the same in steps 1,2,3,4,5
   ```
   ./run_hotnet.sh
   ```

4. Create visualisation. Edit the threshold for p-values. The p-value should be the same in steps 1,2,3,4,5
   ```
   ./run_visualisation.sh
   ```

