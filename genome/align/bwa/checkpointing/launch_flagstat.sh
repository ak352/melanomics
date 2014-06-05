#!/bin/bash --login                                                                                                                                                                                                                   
MYTASK="../flagstats.sh"
OUTFILE=$1
ARG_TASK_FILE="bam_files"
NB_CORES_HEADNODE=2

#The task that must be run by the launcher script                                                                                                                                                                                     
#TASK="#!/bin/bash --login\ncat ${ARG_TASK_FILE} | parallel -j ${NB_CORES_HEADNODE} --colsep ' ' ${MYTASK}\n"                                                                                                                         
TASK="#!/bin/bash --login\ncat ${ARG_TASK_FILE} | parallel -k --colsep ' ' ${MYTASK}\n"
echo -e $TASK > $OUTFILE

#Make the task executable                                                                                                                                                                                                            
chmod 775 $OUTFILE
