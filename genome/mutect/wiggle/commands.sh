source paths

OUTDIR=/work/projects/melanomics/analysis/genome/coverage_genome/wiggle
mkdir -v $OUTDIR

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



bed2wiggle()
{
    while read line
    do
	set $line
	input=$1
	status "Converting $input to wiggle format..."
	output=$OUTDIR/${input##*/}.wiggle.txt
	samtools mpileup $input \
	    | perl -ne 'BEGIN{print "track type=wiggle_0 name=fileName description=fileName\n"};($c, $start, undef, $depth) = split; if ($c ne $lastC) { print "variableStep chrom=$c\n"; };$lastC=$c;next unless $. % 10 ==0;print "$start\t$depth\n" unless $depth<3;'  > $output
	out_status $output
    done < inputs
}

bed2wiggle
