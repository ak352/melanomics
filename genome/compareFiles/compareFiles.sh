#!/bin/bash --login

PATH_A=/scratch/users/sreinsbach/fastqc/patient_2_NS
PATH_B=/work/projects/melanomics/analysis/genome/patient_2_NS/fastqc

FOIS=/scratch/users/sreinsbach/fastqc/patient_2_NS/fois.txt

#for i in *_NHEM*
#    do
#      diff -q ${PATH_A}/${i} ${PATH_B}/${i}
#    done


while read i
    do
	diff -q ${PATH_A}/${i} ${PATH_B}/${i}
    done < ${FOIS}




