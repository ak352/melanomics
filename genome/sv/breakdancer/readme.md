### To run Breakdancer - 

1. Place all the BAM files (sample_NS.bam and sample_PM.bam) under $SCRATCH/bwa/
For example, for sample=patient_2, place patient_2_NS.bam and patient_2_PM.bam under $SCRATCH/bwa/

2. Create a folder $SCRATCH/breakdancer

3. Write all the sample names in a file called "samples" under the current directory. For example, 
```
[17:17:29] akrishna@access breakdancer> cat samples 
patient_2
patient_4
patient_5
patient_6
patient_7
patient_8
```

The script will look for 2 BAM (tumour and normal) files for each sample under $SCRATCH/bwa.

4. Ensure that you have write access to the current folder and $SCRATCH/breakdancer
5. Ensure that you have read access to $SCRATCH/bwa/sample_NS.bam and $SCRATCH/bwa/sample_NS.bam
6. Run 
```bash
./chkpt_breakdancer.sh
```
