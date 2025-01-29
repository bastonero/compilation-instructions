#!/bin/bash -l 

module purge
module load python/3.9-anaconda cmake/3.23.1 gcc/11.2.0 cuda/11.7.1 openmpi/4.1.2-gcc11.2.0-cuda cudnn/8.9.6.50-11.x

export PYTHON_VENV_PATH=$HOME/.envs/allegro

python -m venv $PYTHON_VENV_PATH
source $PYTHON_VENV_PATH/bin/activate
$PYTHON_VENV_PATH/bin/python -m pip install --upgrade pip

# Install PyTorch with CUDA 11.8
pip install torch --index-url https://download.pytorch.org/whl/cu118

# Install NequIP and Allegro
pip install git+https://github.com/mir-group/nequip.git@develop
pip install git+https://github.com/mir-group/allegro.git@develop

cd $HOME