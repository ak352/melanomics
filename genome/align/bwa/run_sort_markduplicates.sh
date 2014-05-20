#!/bin/bash --login
PICARD=/work/projects/melanomics/tools/picard/picard-tools-1.95/
#PICARD=/work/projects/melanomics/tools/picard_src/trunk/dist/

sort()
{
    java -jar -XX:-UsePerfData $PICARD/SortSam.jar \
	INPUT=$1 \
	OUTPUT=${1%.bam}.sorted.bam \
	SORT_ORDER=coordinate \
	TMP_DIR=$SCRATCH/tmp/
}

markdup()
{
    java -jar -Xmx64g -XX:-UsePerfData $PICARD/MarkDuplicates.jar \
	INPUT=${1%.bam}.sorted.bam \
	OUTPUT=$2 \
	TMP_DIR=$SCRATCH/tmp/ \
	METRICS_FILE=${1%.bam}.sorted.metrics.txt \
	REMOVE_DUPLICATES=TRUE \
	MAX_RECORDS_IN_RAM=80000000

    java -jar $PICARD/BuildBamIndex.jar \
	INPUT=$2
}


run()
{
    date
    echo Sorting, marking duplicates and building index for $1...
    echo Sorting $1...
    #time sort $1 2>&1
    echo Sorting done.
    echo Marking duplicates for $1...
    time markdup $1 $2 2>&1
    echo Mark duplicates and building BAM index done.
    date
}


run $1 $2
