#!/bin/bash -l

uenv image pull prgenv-gnu/25.06:rc5
uenv start prgenv-gnu/25.06:rc5 --view=default

python3.11 -m venv --system-site-packages $HOME/.envs/allegro
source $HOME/.envs/allegro/bin/activate

pip install torch --index-url https://download.pytorch.org/whl/cu126
pip install nequip-allegro