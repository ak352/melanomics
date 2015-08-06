echo 6 > input
for k in 2 4 5 6 7 8
do
    echo /work/projects/melanomics/analysis/genome/strelka/patient_${k}/results/passed.somatic.indels.vcf
    echo /work/projects/melanomics/analysis/genome/strelka/patient_${k}/results/passed.somatic.indels.gt.vcf
    echo indel
done >> input

