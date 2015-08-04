#!/bin/bash --login

while read line
do
    ./trim.sh $line
done < <(python trim_input.py)
 