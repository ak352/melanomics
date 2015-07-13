from subprocess import call
import subprocess

bamfile="/work/projects/melanomics/analysis/genome/patient_2_NS/bam/patient_2_NS.bam"

#p0 = subprocess.Popen(["module load SAMtools"], stdout=subprocess.PIPE)
p1 = subprocess.Popen(["samtools mpileup -q1 -r '1:20000004-20000012'", bamfile], stdout=subprocess.PIPE)

output,err = p1.communicate()
help(output)    
