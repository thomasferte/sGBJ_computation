#!/bin/bash

#############################
# les directives Slurm vont ici:

# Your job name (displayed by the queue)
#SBATCH -J REMBRANDT

# walltime (hh:mm::ss)
#SBATCH -t 20:00:00

# Specify the number of nodes(nodes=) and the number of cores per nodes(tasks-pernode=) to be used
#SBATCH --ntasks-per-node=1

# change working directory
# SBATCH --chdir=.

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o result_bash/rembrandt_%j_%a.out # standard out goes to this file
#SBATCH -e result_bash/remabrandt_%j_%a.out # standard err goes to this file
#SBATCH --array 1-189

# fin des directives PBS
#############################


# useful informations to print
echo "#############################" 
echo "User:" $USER
echo "Date:" `date`
echo "Host:" `hostname`
echo "Directory:" `pwd`
echo "SLURM_JOBID:" $SLURM_JOBID
echo "SLURM_SUBMIT_DIR:" $SLURM_SUBMIT_DIR
echo "SLURM_JOB_NODELIST:" $SLURM_JOB_NODELIST
echo "#############################" 

#############################

module load R/4.2.0

Rscript script/rembrandt/rembrandt_pathway_analysis.R
