#!/bin/bash --login
module load biopython
module load pyvcf
module load pysam
module load math/numpy/1.8.0-ictce-5.3.0-Python-2.7.5

pwd=$PWD
WD=/work/projects/melanomics/tools/oncotator/oncotator-1.5.1.0
cd $WD
python setup.py install


cd $pwd


