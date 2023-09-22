#!/bin/bash

#############################
# les directives Slurm vont ici:

# Your job name (displayed by the queue)
#SBATCH -J SGBJ

# walltime (hh:mm::ss)
#SBATCH -t 02:00:00


# change working directory
# SBATCH --chdir=.

### In filenames, %j=jobid, %a=index in job array
#SBATCH -o data/result_simu/standard/sgbj_%j_%a.out # standard out goes to this file
#SBATCH -e data/result_simu/error/sgbj_%j_%a.out # standard err goes to this file

#SBATCH --array=1-500
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

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

Rscript script/script_simulation/curta/07_simu_from_data_simple_corr_alpha.R
