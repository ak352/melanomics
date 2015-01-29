
while read line
do
    set $line
    infile=$2
    infile=${infile##*/}
    infile=${infile%%.*}
    echo $infile
    oarsub -lcore=2,walltime=120 -n INV_$infile "./commands.sh $line"
done < params
