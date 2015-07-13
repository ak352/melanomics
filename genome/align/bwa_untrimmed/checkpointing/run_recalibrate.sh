#! /bin/bash
################################################################################
# launcher_checkpoint_restart.sh -  Example of a generic launcher script
#    for running best effort jobs with checkpointing (using BLCR)
#
# oarsub -S ./launcher_checkpoint_restart.sh
#
################################################################################



##########################
#                        #
#   The OAR  directives  #
#                        #
##########################
#
#          Set number of resources
#          1 core for 1 min
#OAR -l /nodes=1/core=2,walltime=60:00:00
#	   If the job is killed, send signal SIGUSR2(12) 20s before killing the job ;
#          then, resubmit the job in an identical way.
#          Else, the job is terminated normally.

#OAR -t idempotent
#OAR --checkpoint 900
#OAR --signal 12

#####################################
#                                   #
#   The UL HPC specific directives  #
#                                   #
#####################################
if [ -f  /etc/profile ]; then
    .  /etc/profile
fi

#####################################
#
# Job settings
#
#####################################
# Unix signal sent by OAR, SIGUSR1 / 10
CHKPNT_SIGNAL=12

#Disable NSCD
export LIBCR_DISABLE_NSCD=1

# exit value for job resubmission
EXIT_UNFINISHED=99

# The task will be executed in 100s
TASK="/work/projects/melanomics/scripts/genome/align/bwa_untrimmed/run_recalibrate.sh $1 $2 $3 $4 $5"

# Checkpoint context file, use the scratch filesystem if available
CONTEXT=$SCRATCH
[ "`df -T $SCRATCH | grep -c lustre`" == "0" ] && CONTEXT=$WORK
CONTEXT=$PWD
CONTEXT="$CONTEXT/$6"
echo CONTEXT = $CONTEXT

# Run the task with blcr libraries
RUN="cr_run $TASK"
# Terminate the process and save its context and all its child
CHECKPOINT="cr_checkpoint -f $CONTEXT --kill -T" # + Process ID
# Restart the process(es)
RESTART="cr_restart --no-restore-pid $CONTEXT"

##########################################
# Run the job
#
# DIRECTORY WHERE TO RUN
if [ -f $CONTEXT ] ; then
    echo !!! Restart from checkpointed context !!!
    $RESTART &
    echo !!! Copying previous context !!!
else
    echo !!! Execute !!!
    $RUN &
fi
PID=$!
echo !!! PID  $PID !!!

# If we receive the checkpoint signal, then, we kill $CMD,
# and we return EXIT_UNFINISHED, in order to resubmit the job

trap "echo !!! Checkpointing !!! ; $CHECKPOINT $PID ; echo !!! Checkpointing done !!!; exit $EXIT_UNFINISHED" $CHKPNT_SIGNAL


# Wait for $CMD completion
wait $PID
RET=$?

echo !!! Execution ended, with exit value $RET !!!


# Remove the context file
rm -f $CONTEXT

# Return the exit value of the cr_run command
exit $RET

