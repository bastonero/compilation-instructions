#!/bin/bash -l
#SBATCH --job-name=OTF
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:4
#SBATCH --time=00:20:00
#SBATCH --partition=a100
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

# -----------------> Modify here <----------------- #
LAMMPS_PATH=$HOME/builds/lammps-release-gpu-kokkos-flare-plumed
# ------------------------------------------------- #

# 1. Load necessary module
module load cmake/3.23.1 gcc/11.2.0 cuda/12.1.1 openmpi/4.1.2-gcc11.2.0-cuda

# 2. Export env variables
export PATH=$LAMMPS_PATH/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LAMMPS_PATH/lib64

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=close
export OMP_PLACES=threads
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

readonly gpu_count=${1:-$(nvidia-smi --list-gpus | wc -l)}
echo "Running on ${gpu_count} GPUS per node..."
echo "Running on ${SLURM_NTASKS} GPUS..."

# 3. Run the simulation!
srun lmp -k on g ${gpu_count} t ${OMP_NUM_THREADS} -sf kk -pk kokkos newton on neigh full gpu/aware off -in in.lammps