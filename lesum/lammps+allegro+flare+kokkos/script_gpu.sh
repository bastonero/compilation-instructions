#!/bin/bash

# ==================================================================== #
# LAMMPS + OPENMPI + LIBTORCH v2.2.2 + CUDA 12.1 + GCC 12 + MKL @ GPU
# ==================================================================== #

export INSTALL_DIR=/cluster/applications/LAMMPS/stable_2Aug2023_update3/gcc-12.2/openmpi-4.1.5/cuda-12.1

module purge
module load gcc/12
module load CUDA/12.1
module load openmpi-cuda/4.1.5

rm -r build_gpu
mkdir build_gpu
cd build_gpu

export LIBTORCH_PATH=/home1/bastonero/builds/libtorch/2.2.2/cu121
export CUDNN_PATH=/home1/bastonero/builds/cudnn/12

export TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0" # trick for libtorch v2.2 ~< version ~< v2.3 
export MKL_INCLUDE_DIR=/cluster/intel/oneapi/2023.1.0/mkl/2023.1.0/include

cmake ../cmake \
    -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH \
    -D CUDNN_INCLUDE_DIR=$CUDNN_PATH/include \
    -D CUDNN_LIBRARY_PATH=$CUDNN_PATH/lib/libcudnn.so \
    -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
    -D PKG_KOKKOS=ON \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D Kokkos_ENABLE_OPENMP=yes \
    -D BUILD_OMP=yes \
    -D CAFFE2_USE_CUDNN=1 \
    -D BUILD_SHARED_LIBS=yes \
    -D DOWNLOAD_PLUMED=yes \
    -D PLUMED_MODE=runtime \
    -D DOWNLOAD_EIGEN3=yes \
    -D PKG_MACHDYN=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 20
make install