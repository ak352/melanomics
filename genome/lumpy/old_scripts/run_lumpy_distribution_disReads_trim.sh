#!/bin/bash --login

input=$1
script=$2
output=$3


echo "Run histo on discordant reads"
date
CMD="cat ${input} \
    | ${script} \
    -r 104 \
    -X 4 \
    -N 10000 \
    -o ${output}"
echo "${CMD}"
eval "time ${CMD}"
date
echo "Finished histo for discordant reads."
