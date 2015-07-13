for k in 2 4 5 6 7 8
do
    for m in PM NS
    do
	samtools view -H patient_${k}_${m} | uniq