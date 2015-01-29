#!/bin/bash --login

for p in 2 4 5 6 7 8
do
    k=TRA
    svtype=$k
    out_lumpy=/work/projects/melanomics/analysis/genome/lumpy_genome/trim/patient_$p.$k.testvariants
    delly=/work/projects/melanomics/analysis/genome/sv/delly/patient_$p/final/patient_${p}_PM.$svtype.testvariants 
    list=/work/projects/melanomics/analysis/genome/sv/merged/patient_$p.$svtype.list 
    lumpy_test=/work/projects/melanomics/analysis/genome/sv/merged/patient_$p.$svtype.list.lumpy 
    delly_test=/work/projects/melanomics/analysis/genome/sv/merged/patient_$p.$svtype.list.delly 
    tested=/work/projects/melanomics/analysis/genome/sv/merged/patient_$p.$svtype.list.lumpy.delly.tested 
    genes=/work/projects/melanomics/analysis/genome/sv/merged/genes 
    annotated=/work/projects/melanomics/analysis/genome/sv/merged/patient_$p.$svtype.list.lumpy.delly.tested.annotated 
    gene_anno=/work/projects/melanomics/analysis/genome/sv/merged/patient_$p.$svtype.list.lumpy.delly.tested.annotated.genes
    inputs=patient_${p}.inputs
    
    echo "$svtype $lumpy $out_lumpy $delly $out_delly $list $lumpy_test $delly_test $tested $genes $annotated $gene_anno $inputs"

done

