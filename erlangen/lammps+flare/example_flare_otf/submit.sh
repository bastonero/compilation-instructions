#!/bin/bash -l
#SBATCH --job-name=OTF
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:4
#SBATCH --time=01-00:00:00
#SBATCH --partition=a100
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

# -----------------> Modify here <----------------- #
LAMMPS_PATH=$HOME/builds/lammps-2308023-cpu-gcc11-openblas-openmp-flare-plumed-lammps/
PYTHON_VENV_PATH=${HOME}/.envs/flare-lammps-gcc11-openblas/
# ------------------------------------------------- #

# 1. Load necessary module
source $HOME/builds/spack/share/spack/setup-env.sh
module load gcc/11.2.0
spack load python q-e-sirius openblas 
source $PYTHON_VENV_PATH/bin/activate

# 2. Export env variables
export PATH=$LAMMPS_PATH/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LAMMPS_PATH/lib64:/home/hpc/e103ef/e103ef10/builds/spack/opt/spack/linux-almalinux8-zen3/gcc-11.2.0/python-3.9.19-7uroys5sdvhscrjl3mgbriwh5j7i2a4v/lib/

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=close
export OMP_PLACES=threads
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

nvidia-cuda-mps-control -d

# 3. Run the simulation!
#$HOME/.envs/flare-lammps-gcc11-mkl/bin/flare-otf inputs.yaml
flare-otf inputs.yaml