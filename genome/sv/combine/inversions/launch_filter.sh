#!/bin/bash --login


for k in 2 4 5 6 7 8
do
    sample=patient_$k
    testvariants=/work/projects/melanomics/analysis/genome/sv/merged/${sample}.INV.list.lumpy.delly.tested
    exclude=/work/projects/melanomics/analysis/genome/lumpy_genome/trim/whole_genome/${sample}_PM.exclude.bed.2
    out=/work/projects/melanomics/analysis/genome/sv/merged/${sample}.INV.list.lumpy.delly.tested.exclude
    stdout=/work/projects/melanomics/analysis/genome/sv/merged/${sample}.INV.list.lumpy.delly.tested.stdout
    stderr=/work/projects/melanomics/analysis/genome/sv/merged/${sample}.INV.list.lumpy.delly.tested.stderr
    oarsub -t bigmem -lcore=2,walltime=120 -n $sample.INV -O $stdout -E $stderr "./filter.sh $testvariants $exclude $out"
done


