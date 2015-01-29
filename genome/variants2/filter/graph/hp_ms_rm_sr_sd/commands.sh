#!/bin/bash --login
status()
{
    d=`date`
    echo [$d] $1
}

out_status()
{
    d=`date`
    echo [$d] Output written to $1
    wc -l $1
}

#OUTDIR=/work/projects/melanomics/analysis/genome/variants2/filter/graphs/hp_ms_rm_sr_sd
#OUTDIR=/work/projects/melanomics/analysis/genome/variants2/filter/graphs/hp_ms_rm_sr_sd_absolute
OUTDIR=/work/projects/melanomics/analysis/genome/variants2/filter/graphs/hp_ms_rm_sr_sd_absolute_germline_only
mkdir -v $OUTDIR

coverage()
{
    status "Summarising coverages..."
    for k in 2 4 5 6 7 8; do echo $k; python plot.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k} coverage; echo Done; done
    status "Done."
}

quality_snp()
{
    status "Summarising SNV quality..."
    for k in 2 4 5 6 7 8; 
    do echo $k; python plot.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k} quality snp; done
    status "Done."

    
}

quality_indelsub()
{

    status "Summarising indel, sub variant quality..."
    for k in 2 4 5 6 7 8; do echo $k; python plot.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k} quality indelsub; echo Done; done
    status "Done."
}

near_indel()
{
    status "Summarising distance to nearest indel..."
    for k in 2 4 5 6 7 8; do echo $k; python plot.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k} NearestIndelDistance ; echo Done; done
    status "Done."
}

near_hp()
{
    status "Summarising distance to nearest homopolymer..."
    for k in 2 4 5 6 7 8; do echo $k; python hist_dhp.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k} NearestHpDistance ; echo Done; done
    status "Done."
}

plot_all()
{
    status "Plotting..."
    for k in 2 4 5 6 7 8; do echo $k; python plot_coverage.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k}; echo Done; done
    for k in 2 4 5 6 7 8; do echo $k; python plot_qual.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k}.snp 30; echo Done; done
    for k in 2 4 5 6 7 8; do echo $k; python plot_qual.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k}.indelsub ; echo Done; done
    for k in 2 4 5 6 7 8; do echo $k; python plot_nearest_indel.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k} ; echo Done; done
    for k in 2 4 5 6 7 8; do echo $k; python plot_dhp.py patient_${k}_NS patient_${k}_PM $OUTDIR/p${k} ; echo Done; done
    status "Done."
}

roc()
{
    DIR=/work/projects/melanomics/analysis/genome/variants2/filter/graphs/hp_ms_rm_sr_sd_absolute/
    #attrib=snp.quality
    attrib=coverage

    # Each patient separately
    # for p in 2 #4 5 6 7 8
    # do
    # 	echo patient_$p
    # 	python roc.py -t $DIR/p$p.$attrib.concordant_normal.hist -t $DIR/p$p.$attrib.concordant_tumor.hist -f $DIR/p$p.$attrib.discordant_normal.hist -f $DIR/p$p.$attrib.discordant_tumor.hist -m 200 \
    # 	    -s patient_$p \
    # 	    -a $attrib
    # done

    #All patients
    python roc.py -t $DIR/p$p.$attrib.concordant_normal.hist -t $DIR/p$p.$attrib.concordant_tumor.hist -f $DIR/p$p.$attrib.discordant_normal.hist -f $DIR/p$p.$attrib.discordant_tumor.hist -m 200 \
	-a $attrib

}

# coverage
# quality_snp
# quality_indelsub
# near_indel
# near_hp

#plot_all
roc

#TODO: NHEM
#TODO: Distance to homopolymer filter
