#!/bin/bash # Load modules directive
#. /etc/profile.d/modules.s
#
# Reserve N workers
#$ -pe smp 12
#
# Remember SGE options are marked up with '#$':
# ---------------------------------------------
# Requested resources:
#
# Simulation name
# ----------------
#$ -N dresgTest
#
# Shell
# -----
#$ -S /bin/bash
#
# Output and error files go on the user's home:
# -------------------------------------------------
#$ -o /homedtic/sbarrachina/Matlab/dresg/job-out/output.out
#$ -e /homedtic/sbarrachina/Matlab/dresg/job-out/error.err
#
#
# Start script
# --------------------------------
#
printf "Starting execution of job $JOB_ID from user $SGE_O_LOGNAME\n"
printf "Starting at `date`\n"
printf "Calling Matlab now\n"
# Execute the script
/soft/MATLAB/R2015b/bin/matlab -nosplash -nodesktop -nodisplay -r "run /homedtic/sbarrachina/Matlab/dresg/script/main_learning_parfor_new.m"
# Copy data back, if any
printf "Matlab processing done. Moving data back\n"
