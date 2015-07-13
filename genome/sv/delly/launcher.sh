while read line
do
    set $line
    sample=$1
    bam1=$2
    bam2=$3
    OUTDIR=$4
    sv=$5
    stdout=$OUTDIR/$sample.$sv.stdout
    stderr=$OUTDIR/$sample.$sv.stderr
    mkdir -v $OUTDIR
    #./commands.sh $bam1 $bam2 $OUTDIR
    #oarsub -lcore=2,walltime=120 -n $sample$sv -O $stdout -E $stderr -S "./run_delly.sh $bam1 $bam2 $OUTDIR $sv"
    oarsub -lcore=2,walltime=24 -n $sample$sv -O $stdout -E $stderr -S "./run_delly.sh $bam1 $bam2 $OUTDIR $sv"
    break
done < input
