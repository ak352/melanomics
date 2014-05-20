#!/bin/bash --login
MYTASK="./run_breakdancer.sh"
OUTFILE=task.sh
ARG_TASK_FILE="samples"
NB_CORES_HEADNODE=2

#The task that must be run by the launcher script
#TASK="#!/bin/bash --login\ncat ${ARG_TASK_FILE} | parallel -j ${NB_CORES_HEADNODE} --colsep ' ' ${MYTASK}\n"
TASK="#!/bin/bash --login\ncat ${ARG_TASK_FILE} | parallel --colsep ' ' ${MYTASK}\n" 
echo -e $TASK > $OUTFILE

#Make the task executable
chmod 775 $OUTFILE
