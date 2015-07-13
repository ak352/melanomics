#!/bin/bash --login
module load lang/Java
GATK=/work/projects/melanomics/tools/gatk/GenomeAnalysisTK-2.6-5-gba531bd/


date
echo "Realignment"
input=$1
reference=$2
output=$3
intervals=$4 
echo OAR_JOBID = $OAR_JOBID
time java -jar -Xmx64g -XX:-UsePerfData ${GATK}/GenomeAnalysisTK.jar -T RealignerTargetCreator -I ${input} -R ${reference} -o ${intervals}
time java -jar -Xmx64g -XX:-UsePerfData ${GATK}/GenomeAnalysisTK.jar -T IndelRealigner -targetIntervals ${intervals} -I ${input} -o ${output} -R ${reference}
echo "Done"
date

