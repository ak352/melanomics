### To run Breakdancer - 

1. Place all the BAM files (sample_NS.bam and sample_PM.bam) under $SCRATCH/bwa/
For example, for sample=patient_2, place patient_2_NS.bam and patient_2_PM.bam under $SCRATCH/bwa/

2. Create a folder $SCRATCH/breakdancer

3. Ensure that you have write access to the current folder and $SCRATCH/breakdancer
4. Ensure that you have read access to $SCRATCH/bwa/sample_NS.bam and $SCRATCH/bwa/sample_NS.bam
5. Run 
```bash
./chkpt_breakdancer.sh
```
