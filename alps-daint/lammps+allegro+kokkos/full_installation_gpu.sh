#!/bin/bash -l

uenv image pull pytorch/v2.6.0:v1
uenv start pytorch/v2.6.0:v1 --view=default

# ==================================================================================== #
# Download and patch
# ==================================================================================== #
git clone -b stable_2Aug2023_update3 --depth 1 https://github.com/lammps/lammps.git lammps
git clone --depth 1 https://github.com/mir-group/pair_nequip_allegro.git
cd pair_nequip_allegro
./patch_lammps.sh ../lammps/
cd ../lammps

# ==================================================================================== #
# Compile
#   You can comment the `Download and patch` section and use the following
#   if you already downloaded and patched all the repos
# ==================================================================================== #
INSTALL_DIR=$HOME/lammps-2308023-gcc13-cuda12--torch2.6-nequip-allegro

rm -r build
mkdir build
cd build

# If you want to use the AOT acceleration mode, add the following to the cmake command.
#   -D NEQUIP_AOT_COMPILE=ON \
# NOTE: you also need to have trained the model using the corresponding compile flag.

cmake ../cmake \
    -D CMAKE_PREFIX_PATH=`python -c 'import torch;print(torch.utils.cmake_prefix_path)'` \
    -D MKL_INCLUDE_DIR=/tmp \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME \
    -D PKG_KOKKOS=ON \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D Kokkos_ENABLE_OPENMP=yes \
    -D BUILD_OMP=yes \
    -D CAFFE2_USE_CUDNN=1 \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j $(nproc)
make install