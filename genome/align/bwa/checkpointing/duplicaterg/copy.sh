#!/bin/bash --login
# for k in 2 #4 8
# do
#     echo patient_${k}_NS
#     out=patient_${k}_NS
#     rsync -avz --progress $SCRATCH/bwa/patient_${k}_NS.bam.temp /work/projects/melanomics/analysis/genome/$out/bam/$out.bam
# done

# echo patient_5_PM
# out=patient_5_PM
# rsync -avz --progress $SCRATCH/bwa/patient_5_PM.bam.temp /work/projects/melanomics/analysis/genome/$out/bam/$out.bam

echo NHEM
out=NHEM
rsync -avz --progress $SCRATCH/bwa/$out.bam.temp /work/projects/melanomics/analysis/genome/$out/bam/$out.bam
