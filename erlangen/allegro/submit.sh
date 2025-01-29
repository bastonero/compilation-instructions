#!/bin/bash
#SBATCH --job-name=NEQUIP
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=16
#SBATCH --time=00:20:00
#SBATCH --partition=a100
#SBATCH --gres=gpu:2
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

module purge
module load python/3.9-anaconda cmake/3.23.1 gcc/11.2.0 cuda/11.7.1 openmpi/4.1.2-gcc11.2.0-cuda cudnn/8.9.6.50-11.x
export PYTHON_VENV_PATH=$HOME/.envs/allegro
source $PYTHON_VENV_PATH/bin/activate

readonly gpu_count=${1:-$(nvidia-smi --list-gpus | wc -l)}
echo "Running on ${gpu_count} GPUS per node..."
echo "Running on ${SLURM_NTASKS} GPUS..."

srun nequip-train -cn minimal.yaml