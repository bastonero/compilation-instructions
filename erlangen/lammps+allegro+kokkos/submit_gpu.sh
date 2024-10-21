#!/bin/bash
#SBATCH --job-name=TEST
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --time=00:20:00
#SBATCH --partition=a100
#SBATCH --gres=gpu:1
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module purge
module load gcc/11.2.0 
module load cuda/11.7.1 
module load openmpi/4.1.2-gcc11.2.0-cuda
module load cudnn/8.9.6.50-11.x

export LAMMPS_PATH=/home/hpc/e103ef/e103ef10/builds/lammps-2308023-gcc11.2-cuda11.7-mkl-openmpi-cudnn8.9-torch1.13-plummed
export PATH=$LAMMPS_PATH/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/hpc/e103ef/e103ef10/builds/libtorch-1.13-cu11.7/lib:$LAMMPS_PATH/lib64:/apps/SPACK/0.19.1/opt/linux-almalinux8-zen/gcc-8.5.0/intel-oneapi-mkl-2023.2.0-pjoibhyqpiwpgaqtj7joxyjs6ix5g3jy/mkl/2023.2.0/lib/intel64
export CUDA_ROOT=/apps/SPACK/0.19.1/opt/linux-almalinux8-zen/gcc-8.5.0/cuda-11.7.1-2q77ktin6rkv7wz7cjp43l4ckt7rwpc5
export LD_PRELOAD=$CUDA_ROOT/lib64/libnvrtc.so.11.2:$CUDA_ROOT/lib64/libnvToolsExt.so.1:$CUDA_ROOT/lib64/libcudart.so.11.0:$CUDA_ROOT/lib64/libcufft.so.10:$CUDA_ROOT/lib64/libcurand.so.10:$CUDA_ROOT/lib64/libcublas.so.11:$CUDA_ROOT/lib64/libcublasLt.so.11

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
# for Slurm version >22.05: cpus-per-task has to be set again for srun
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

readonly gpu_count=${1:-$(nvidia-smi --list-gpus | wc -l)}
echo "Running on ${gpu_count} GPUS per node..."
echo "Running on ${SLURM_NTASKS} GPUS..."

srun lmp -k on g ${gpu_count} t ${OMP_NUM_THREADS} -sf kk -pk kokkos gpu/aware off -in in.lammps