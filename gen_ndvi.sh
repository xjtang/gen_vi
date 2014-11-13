#!/bin/bash

# Submit qsub job 

# Specify which shell to use
#$ -S /bin/bash

# Run for 24 hours
#$ -l h_rt=24:00:00

# Forward my current environment
#$ -V

# Give this job a name
#$ -N gen_ndvi

# Join standard output and error to a single file
#$ -j y

# Name the file where to redirect standard output and error
#$ -o gen_ndvi.qlog

# Now let's keep track of some information just in case anything goes wrong

echo "=========================================================="
echo "Starting on : $(date)"
echo "Running on node : $(hostname)"
echo "Current directory : $(pwd)"
echo "Current job ID : $JOB_ID"
echo "Current job name : $JOB_NAME"
echo "Task index number : $SGE_TASK_ID"
echo "=========================================================="

# Run the bash script
R --slave --vanilla --quiet --no-save  <<EEE
library('RCurl')
script <- getURL('https://raw.githubusercontent.com/xjtang/gen_ndvi/master/gen_ndvi.R',ssl.verifypeer=F)
eval(parse(text=script),envir=.GlobalEnv)
batch_gen_ndvi('$1','$2')
EEE

echo "=========================================================="
echo "Finished on : $(date)"
echo "=="
