
for k in 2 4 6 7 8
do
    echo patient_${k} /work/projects/melanomics/analysis/genome/strelka/patient_${k}/results/passed.somatic.indels.gt.vcf /work/projects/melanomics/analysis/genome/patient_${k}_NS/bam/patient_${k}_NS.bam /work/projects/melanomics/analysis/genome/patient_${k}_PM/bam/patient_${k}_PM.bam
done > dna_samples.in

