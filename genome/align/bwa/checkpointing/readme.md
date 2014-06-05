### Usage:
1. Place all your BAM files under $SCRATCH/bwa and ensure read-write access to this folder. 

2. At the bottom of gatk_best_practices.sh, remove comments from the part of the pipeline to run. For example, comment out
```bash
sort_and_mark_duplicates NHEM
```
in order to run the process sort_and_mark_duplicates on sample NHEM. This will look for all NHEM.*.bam files under $SCRATCH/bwa.

3. Run the checkpointed pipeline
```bash
./gatk_best_practices.sh
```

