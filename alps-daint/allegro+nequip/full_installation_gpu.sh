#!/bin/bash -l

uenv image pull pytorch/v2.6.0:v1
uenv start pytorch/v2.6.0:v1 --view=default

python -m venv --system-site-packages $HOME/allegro
source $HOME/allegro/bin/activate

pip install nequip-allegro