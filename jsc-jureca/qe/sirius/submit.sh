#!/bin/bash -x
#SBATCH --job-name=TEST
#SBATCH --account=jureap83
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=32
#SBATCH --output=slurm.out
#SBATCH --error=slurm.err
#SBATCH --time=00:15:00
#SBATCH --partition=dc-gpu

source $PROJECT_jureap83/builds/spack/share/spack/setup-env.sh
spack load q-e-sirius@develop-ristretto

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

nvidia-cuda-mps-control -d

srun pw.x -nk 4 -in pw.in > pw.out