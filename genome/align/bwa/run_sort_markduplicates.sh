#!/bin/bash --login
PICARD=/work/projects/melanomics/tools/picard/picard-tools-1.95/

#java -jar $PICARD/SortSam.jar \
#    INPUT=$1 \
#    OUTPUT=${1%.bam}.sorted.bam \
#    SORT_ORDER=coordinate
java -jar -Xmx64g $PICARD/MarkDuplicates.jar \
    INPUT=${1%.bam}.sorted.bam \
    OUTPUT=$2 \
    METRICS_FILE=${1%.bam}.sorted.metrics.txt \
    REMOVE_DUPLICATES=TRUE \
    MAX_RECORDS_IN_RAM=80000000

java -jar $PICARD/BuildBamIndex.jar \
    INPUT=$2


