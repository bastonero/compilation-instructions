#!/bin/bash -l
#SBATCH --job-name=QE-GPU
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:4
#SBATCH --time=00:20:00
#SBATCH --partition=a100
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module load nvhpc/22.5
module load openmpi/4.1.3-nvhpc22.5-cuda
module load fftw/3.3.10-nvhpc22.5-ompi-omp-cuda
module load cuda/11.6.2

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

# ! IMPORTANT !
# It allows for overrides the GPU cards. 
# To test for your system what's more efficient depending
# on number of kpoints etc.
nvidia-cuda-mps-control -d

QEBIN=/home/hpc/e103ef/e103ef10/builds/qe/7.3.1/build/bin

srun ${QEBIN}/pw.x -nk 8 -in pw.in > pw.out