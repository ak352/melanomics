#!/bin/bash --login
input=/work/projects/melanomics/analysis/transcriptome/variants/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.annotated.testvariants
tested=/work/projects/melanomics/analysis/transcriptome/variants/annotation/all.patient_2.patient_4_NS.patient_4_PM.patient_6.pool.NHEM.testvariants
#sed 's/^\([0-9]\+\t\)\(.\+\)/\1chr\2/g'  $input | sed 's/chrMT/chrM/g' > $tested
#/work/projects/isbsequencing/scripts/pipeline
./runAnnovarTestvariantFile.sh $tested
