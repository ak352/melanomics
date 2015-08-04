### SNV Density and Hom-het Ratio for Circos/POMO plots

#### Steps
1. Set the ```OUTDIR``` variable in ```commands.sh``` in both the functions ```compute_density()``` and ```hom_percent```.
2. Edit the ```input``` file where each line is a variant file for which the tracks need to be computed  -
   ```
   /work/projects/abcd/patient_2.somatic.testvariants.annotated.rare
   /work/projects/abcd/patient_4.somatic.testvariants.annotated.rare
   ```

   It is assumed that each of the above files is of Complete Genomics testvariants format and the genotype is given in the 9th column of the variant file.
3. Run ```./commands.sh```. The output files should be in the ```OUTDIR``` directories.

