#!/bin/bash
#SBATCH --job-name=NEQUIP
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=12
#SBATCH --time=00:30:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:4
#SBATCH -o slurm-report.out
#SBATCH -e slurm-report.err

module load gcc/12 CUDA/12 openmpi-cuda/4.1.5
export PATH=/scratch/macke/software_tests/git/bin/:$PATH
source /home1/bastonero/builds/allegro/bin/activate

srun nequip-train -cn minimal.yaml