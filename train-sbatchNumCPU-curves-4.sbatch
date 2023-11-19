#!/bin/bash
#SBATCH --array=0-5
#SBATCH --job-name=EE20-II
#SBATCH --time=170:00:00
#SBATCH --constraint=avx
#SBATCH --ntasks=1
#SBATCH --chdir=/home/lthummel/bacon-cuillin/BaCoN-master/
#SBATCH --output=sbatch-slurm/slurm-out/job_output_%j.out
#SBATCH --error=sbatch-slurm/slurm-out/job_output_%j.err
pwd; hostname; date

source /usr/local/anaconda/3.9/etc/profile.d/conda.sh
conda activate tf-lt

NUMBER=('0.01'
'0.03'
'0.04'
'0.05'
'0.10'
'0.20')

python3 sbatch-slurm/train-curves-4.py --sigma_curves=${NUMBER[$SLURM_ARRAY_TASK_ID]}
