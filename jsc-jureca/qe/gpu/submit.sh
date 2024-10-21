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

module load NVHPC/24.3-CUDA-12
module load OpenMPI/4.1.5
module load OpenBLAS
module load FFTW/3.3.10
module load CUDA/12

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

nvidia-cuda-mps-control -d

QEBIN=/p/project1/jureap83/builds/qe/7.3.1/build/bin

srun ${QEBIN}/pw.x -nk 4 -in pw.in > pw.out