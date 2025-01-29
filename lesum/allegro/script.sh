#!/bin/bash
export PYTHON_VENV_PATH=/home1/bastonero/builds/allegro

python -m venv $PYTHON_VENV_PATH
source $PYTHON_VENV_PATH/bin/activate
$PYTHON_VENV_PATH/bin/python -m pip install --upgrade pip

# Install PyTorch with CUDA 12.1
pip install torch --index-url https://download.pytorch.org/whl/cu121

# Install NequIP and Allegro
pip install git+https://github.com/mir-group/nequip.git@develop
pip install git+https://github.com/mir-group/allegro.git@develop

cd $HOME