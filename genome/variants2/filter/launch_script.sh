#!/bin/bash --login

for k in distance_hp #rmsk #near_an_indel_all #coverage_anno quality_anno near_an_indel_all #homopolymer #segdup rmsk microsatellite scr #simple_repeat
do
    stdout=script.$k.stdout
    stderr=script.$k.stderr
    name=$k
    oarsub -lcore=2,walltime=120 -n $name -O $stdout -E $stderr "./script.sh $k"
done

