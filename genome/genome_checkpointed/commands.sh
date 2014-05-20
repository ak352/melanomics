#!/bin/bash --login
input="/work/projects/melanomics/analysis/genome/ NHEM/fastqc/120827_SN386_0257_AC13YAACXX_NHEM_reprep_NoIndex_L00 NHEM/trim2"

#1. Adaptor clipping and quality trimming
cd ../trim
python trim.sh <( python trim_input.py $input)


# Read-mapping
cd ../align/bwa

