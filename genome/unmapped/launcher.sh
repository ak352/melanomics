#!/bin/bash --login

for k in 2 4 5 6 7 8
do
    for m in NS PM
    do
	./commands.sh patient_${k}_${m}
    done
done
./commands.sh NHEM
