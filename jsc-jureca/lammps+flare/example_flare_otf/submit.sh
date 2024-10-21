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

# -----------------> Modify here <----------------- #
PYTHON_VENV_PATH=${PROJECT_jureap83}/.envs/flare-lammps-gcc12.3-openblas
LAMMPS_PATH=${PROJECT_jureap83}/builds/lammps-2308023-cpu-gcc12.3-openblas-openmp-flare-plumed-lammps
# ------------------------------------------------- #

# 1. Load necessary module
source ${PROJECT_jureap83}/builds/spack/share/spack/setup-env.sh
ml GCC OpenBLAS
spack load python openblas q-e-sirius
source ${PYTHON_VENV_PATH}/bin/activate

# 2. Export env variables
export PATH=$LAMMPS_PATH/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LAMMPS_PATH/lib64:/p/project1/jureap83/builds/spack/opt/spack/linux-rocky8-zen2/gcc-12.3.0/python-3.9.19-7rgegm6eqq754vermoh2e3cqpk6vnjdf/lib

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export OMP_PROC_BIND=spread
export OMP_PLACES=threads
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

nvidia-cuda-mps-control -d

# 3. Run the simulation!
#$HOME/.envs/flare-lammps-gcc11-mkl/bin/flare-otf inputs.yaml
flare-otf inputs.yaml
lmp in.lammps