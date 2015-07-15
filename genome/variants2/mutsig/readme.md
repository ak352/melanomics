### MutSigCV pipeline
To find significantly mutated genes in cancer genomes

### Steps
1. Download and extract the gene covariates, mutation type dictionary and other files required by MutSigCV.
2. Run ```./commands.sh``` , which
   * converts Complete Genomics testvariants format to MAF format (using tv2maf.py)
   * runs ```run_MutSigCV.sh``` in the MutSigCV directory ```/work/projects/melanomics/tools/mutsigcv/MutSigCV_1.4```


