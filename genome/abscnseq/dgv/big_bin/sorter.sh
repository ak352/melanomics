

#OUTDIR=/work/projects/melanomics/analysis/genome/abscnseq/vs2
OUTDIR=/work/projects/melanomics/analysis/genome/abscnseq/vs2_min1000/

mkdir -v $OUTDIR

echo Sorting by genomic location...

for k in /home/users/aginolhac/hotspots/ploidy/VarScan2/P*.vs2
do

    output=$OUTDIR/${k##*/}
    echo Writing to $output ...
    cmd="( head -n1 $k; \
      sed '1d' $k | sed 's/^\([0-9]\t\)/0\1/g' \
	  | sort -k1,1 -k2,3n \
	  | sed 's/^0//g'; ) > $output"
    echo $cmd
    eval $cmd
    head $output
done


