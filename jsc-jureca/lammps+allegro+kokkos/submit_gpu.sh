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

module load CUDA/12
module load cuDNN/8.9.5.29-CUDA-12
module load GCC/12.3.0
module load OpenMPI/4.1.5
module load OpenBLAS/0.3.23

export LAMMPS_PATH=$PROJECT_jureap83/builds/lammps-2308023-gcc12.3-cuda12.2-openblas-openmpi-cudnn8.9-torch2.1-plummed
export PATH=$LAMMPS_PATH/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PROJECT_jureap83/builds/lammps-2308023-gcc12.3-cuda12.2-openblas-openmpi-cudnn8.9-torch2.1-plummed/lib64:$PROJECT_jureap83/builds/libtorch-2.1.0-cu121/lib

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
# for Slurm version >22.05: cpus-per-task has to be set again for srun
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

readonly gpu_count=${1:-$(nvidia-smi --list-gpus | wc -l)}
echo "Running on ${gpu_count} GPUS per node..."
echo "Running on ${SLURM_NTASKS} GPUS..."

srun lmp -k on g ${gpu_count} t ${OMP_NUM_THREADS} -sf kk -pk kokkos gpu/aware off -in in.lammps