#!/bin/bash --login
module load Clang

cmd="clang++ coverage.cpp -o run -I /work/projects/melanomics/tools/samtools/samtools-0.1.19/ -L/work/projects/melanomics/tools/samtools/samtools-0.1.19/ -lbam -lz -lpthread"
echo $cmd
eval $cmd

