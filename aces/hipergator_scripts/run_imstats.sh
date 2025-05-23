#!/bin/bash
#SBATCH --mail-type=NONE          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=adamginsburg@ufl.edu     # Where to send mail
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=128gb                     # Job memory request
#SBATCH --time=96:00:00               # Time limit hrs:min:sec
#SBATCH --output=/red/adamginsburg/ACES/logs/imstats_ACES_%j.log
#SBATCH --export=ALL
#SBATCH --job-name=imstats_ACES
#SBATCH --qos=astronomy-dept-b
#SBATCH --account=astronomy-dept
pwd; hostname; date

export WORK_DIR="/blue/adamginsburg/adamginsburg/ACES/workdir"

module load git

which python
which git

git --version
echo $?

export IPYTHON=/orange/adamginsburg/miniconda3/envs/python312/bin/ipython

cd ${WORK_DIR}
echo ${WORK_DIR}

export ACES_ROOTDIR="/orange/adamginsburg/ACES/reduction_ACES/"
export SCRIPT_DIR="${ACES_ROOTDIR}/analysis"
export PYTHONPATH=$SCRIPT_DIR

echo $LOGFILENAME

export NO_PROGRESSBAR='True'
export ENVIRON='BATCH'

# TODO: get this from ntasks?
#export DASK_THREADS=8
export DASK_THREADS=$SLURM_NTASKS

env

/orange/adamginsburg/miniconda3/envs/python312/bin/aces_imstats
