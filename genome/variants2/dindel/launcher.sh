for k in 2 4 5 6 7 8
do
    for m in PM NS
    do
	sample=patient_${k}_${m}
	./commands.sh $sample
    done
done
./commands.sh NHEM
