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

hp_ms_rm_sr_sd()
{
    input=/work/projects/melanomics/analysis/genome/variants2/filter/all.out
    output=/work/projects/melanomics/analysis/genome/variants2/filter/hp_ms_rm_sr_sd/all.hp_ms_rm_sr_sd.out
    status "Filtering homopolymers, microsatellites, RepeatMasker, self-chained regions and segmental duplications..."
    status "Input: $input"
    status "Output : $output"
    head -n1 $input > $output
    awk -F"\t" '$61=="" && $63=="" && $64=="" && $65=="" && $66==""' $input >> $output
    out_status $output
}

hp_ms_rm_sr_sd_stats()
{
    input=/work/projects/melanomics/analysis/genome/variants2/filter/all.out
    output=/work/projects/melanomics/analysis/genome/variants2/filter/hp_ms_rm_sr_sd/all.hp_ms_rm_sr_sd.out.stats
    status "Counting filtering stats for homopolymers, microsatellites, RepeatMasker, self-chained regions and segmental duplications..."
    status "Input: $input"
    status "Output : $output"

    echo -e "filter\tnum_filtered\tnum_passed" > $output

    val=`awk -F"\t" '$61!=""' $input`
    line="Homopolymer\tval"
    echo -e $line >> $output

    val=`awk -F"\t" '$63!=""' $input`
    line="Microsatellites\tval"
    echo -e $line >> $output

    val=`awk -F"\t" '$64!=""' $input`
    line="RepeatMasker\tval"
    echo -e $line >> $output

    val=`awk -F"\t" '$65!=""' $input`
    line="Self-chained regions\tval"
    echo -e $line >> $output

    val=`awk -F"\t" '$66!=""' $input`
    line="Segmental duplications\tval"
    echo -e $line >> $output

    out_status $output
}



hp_ms_rm_sr_sd
