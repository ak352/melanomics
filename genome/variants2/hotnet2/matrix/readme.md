### HotNet2 MutSigCV Pipeline

1. Generate the heat scores using the MutSigCV output file.
   Edit the script below to set the MutSigCV output file path.
   Edit the threshold for p-values. Higher p-value means more genes will be included. The p-value should be the same in steps 1,2,3,4,5
   In practice, setting a p-value higher than 0.15 leads to crashing during the delta selection step, perhaps as there are too many genes.
   ```
   ./run_generate_heat.sh	
   ```
   The default output directories from here onwards are on $SCRATCH/hotnet.

2. Edit the number of permutations for delta selection (set to 100 for now)
   Edit the threshold for p-values. The p-value should be the same in steps 1,2,3,4,5
   ```
   ./run_delta_selection.sh
   ```

3. Run HotNet2
   Edit the threshold for p-values. The p-value should be the same in steps 1,2,3,4,5
   ```
   ./run_hotnet.sh
   ```
4. Create visualisation
   Edit the threshold for p-values. The p-value should be the same in steps 1,2,3,4,5
   ```
   ./run_visualisation.sh
   ```


