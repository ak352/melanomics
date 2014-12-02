#!/bin/bash --login


coverage()
{
    for k in 2 4 5 6 7 8; do echo $k; python plot.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k} coverage ; echo Done; done
}
quality_snp()
{
    for k in 2 4 5 6 7 8; do echo $k; python plot.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k} coverage snp; echo Done; done
}
quality_indelsub()
{
    for k in 2 4 5 6 7 8; do echo $k; python plot.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k} coverage indelsub; echo Done; done
}

near_indel()
{
    for k in 2 4 5 6 7 8; do echo $k; python plot.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k} NearestIndelDistance ; echo Done; done
}


plot_all()
{
    for k in 2 4 5 6 7 8; do echo $k; python plot_coverage.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k}; echo Done; done
    for k in 2 4 5 6 7 8; do echo $k; python plot_qual.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k}.snp 30; echo Done; done
    for k in 2 4 5 6 7 8; do echo $k; python plot_qual.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k}.indelsub ; echo Done; done
    for k in 2 4 5 6 7 8; do echo $k; python plot_nearest_indel.py patient_${k}_NS patient_${k}_PM /work/projects/melanomics/analysis/genome/variants2/filter/graphs/p${k} ; echo Done; done
}

coverage
quality_snp
quality_indelsub
near_indel

#TODO: NHEM
#TODO: Distance to homopolymer filter
