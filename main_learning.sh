#!/bin/bash # Load modules directive
#. /etc/profile.d/modules.s

# Reserve N workers
#$ -pe smp 12
#


# Copy sources to the SSD:

# First, make sure to delete previous versions of the sources:
# ------------------------------------------------------------
if [ -d /scratch/dresg_experiments ]; then
        rm -Rf /scratch/dresg_experiments
fi

# Second, replicate the structure of the experiment's folder:
# -----------------------------------------------------------
mkdir /scratch/dresg_experiments
mkdir /scratch/dresg_experiments/data
mkdir /scratch/dresg_experiments/error
mkdir /scratch/dresg_experiments/script
mkdir /scratch/dresg_experiments/out

# Third, copy the experiment's data:
# ----------------------------------
cp -rp /homedtic/sbarrachina/workspace/script/* /scratch/dresg_experiments/script

# Fourth, prepare the submission parameters:
# Remember SGE options are marked up with '#$':
# ---------------------------------------------
# Requested resources:
#
# Simulation name
# ----------------
#$ -N "QL-Testing_parameters"
#
# Shell
# -----
#$ -S /bin/bash
#
# Output and error files go on the user's home:
# -------------------------------------------------
#$ -o /homedtic/sbarrachina/workspace/output/output.out
#$ -e /homedtic/sbarrachina/workspace/output/error.err
#

# Start script
# --------------------------------
#
printf "Starting execution of job $JOB_ID from user $SGE_O_LOGNAME\n"
printf "Starting at `date`\n"
printf "Calling Matlab now\n"
# Execute the script
/soft/MATLAB/R2015b/bin/matlab -nosplash -nodesktop -nodisplay -r "run /scratch/dresg_experiments/script/main_learning.m"
# Copy data back, if any
printf "Matlab processing done. Moving data back\n"
