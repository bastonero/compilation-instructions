#!/bin/bash -l
#SBATCH --job-name=QE-SIRIUS
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:4
#SBATCH --time=00:20:00
#SBATCH --partition=a100
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

source $HOME/builds/spack/share/spack/setup-env.sh
spack load q-e-sirius@develop-ristretto

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

nvidia-cuda-mps-control -d

srun pw.x -nk 4 -in pw.in > pw.out