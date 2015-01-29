#!/bin/bash --login
module load cgatools
module load bedtools

tawk()
{
    awk -F"\t" $1
}

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

csort()
{
    sed 's/chr\([0-9]\t\)/chr0\1/g' | sort -k$1,$1 -k$(($1+1)),$(($1+2))n | sed 's/chr0/chr/g' 
}


#Usage: overlap <BED list file> <BED input file> <output prefix> 

prepare_list()
{
    input=$1
    output=$1.sorted
    status "Input: $input"

    status "Sorting chromosomes such that chrom1 < chrom2..."
    ##TODO: break this into sorting chromosomes+adding fields and adding ids
    ## after sorting chromosomes+add fields, sort
    ## then add ids
    python prepare_list.py $input > $output
    cp $output $input

    out_status $input
    status "Sorting chromosomes and positions..."
    #Sorts based on columns 5,6,7,8
    ./sorted.sh $input > $output
    out_status $output
    cp $output $input
    status "Adding ids..."
    python add_ids.py $input > $output
    cp $output $input 
    out_status $input

}

prepare_test()
{
    input=$1
    output=$1.intervals
    status "Getting intervals for translocations..."
    status "Sorting chromosomes such that chrom1 < chrom2..."
    status "!!List ONLY translocations!!"
    python prepare_test.py $input > $output
    out_status $output
}


overlap()
{
    input=$1
    tests=$2
    tested=$3
    MYTMP=temp
    mkdir -v $MYTMP

    temp=$MYTMP/${input##*/}.tested.temp
    cp $input $temp
    output=$MYTMP/${input##*/}.tested

    while read line
    do
    	set $line
    	#Use allJunctions-*.tsv file for testing the SVs
    	sample=$1
    	intervals=$2
    	>&2 echo "Testing junctions using $intervals ..."
    	input1=$temp
    	input2=$intervals
    	(echo $sample; paste <( cgatools join --beta --match LeftChrSorted:LeftChrSorted --match RightChrSorted:RightChrSorted \
    	    --overlap LeftPos:LeftPosBegin,LeftPosEnd \
    	    --select B.id -a -m compact-pct \
    	    $input1 $input2) \
    	    <( cgatools join --beta --match LeftChrSorted:LeftChrSorted --match RightChrSorted:RightChrSorted \
    	    --overlap RightPos:RightPosBegin,RightPosEnd \
    	    --select B.id -a -m compact-pct \
    	    $input1 $input2;)) > $output.$sample.overlap
    	(echo $sample; paste <( cgatools join --beta --match LeftChrSorted:LeftChrSorted --match RightChrSorted:RightChrSorted \
    	    --overlap LeftPos:LeftPosBegin,LeftPosEnd \
    	    --select B.id -a -m compact-pct \
    	    $input1 $input2) \
    	    <( cgatools join --beta --match LeftChrSorted:LeftChrSorted --match RightChrSorted:RightChrSorted \
    	    --overlap RightPos:RightPosBegin,RightPosEnd \
    	    --select B.id -a -m compact-pct \
    	    $input1 $input2;)) \
    	    | python is_present.py >  $output && paste $temp $output > $temp.tmp && cp $temp.tmp $temp 
    	echo $sample tested.
    done < $tests


    python discordant.py $temp > $output

    mv $output $tested
    out_status $tested
    
}


annotate()
{
    gene_anno=/work/projects/isbsequencing/tools/annovar/2012Oct23/hg19/hg19_refGene.txt
    #output=/work/projects/isbsequencing/shsy5y/analysis/sv/genes/hg19_refGene_locations
    output=$1
    echo -e ">chrom\tbegin\tend\tgene" > $output
    awk -F"\t" 'BEGIN{OFS="\t"}{print $3,$5,$6,$2}' $gene_anno | csort 1 | sed 's/^chr//g' >> $output
    out_status $output
}

while read svtype lumpy_sv delly list out_lumpy out_delly tested genes annotated affected_genes tests
do

    out=$list
    status "Writing list to $out"
    (head -n1 $delly; (sed '1d' $lumpy_sv; sed '1d' $delly;)|sort -u | csort 1)  > $out
    out_status $out
    list=$out
    
    prepare_list $list

    prepare_test $delly
    prepare_test $lumpy_sv

    overlap $list $tests $tested
    # annotate $genes

done < params

