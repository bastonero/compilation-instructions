#!/bin/bash -l

module load CMake/3.26.3
module load CUDA/12
module load cuDNN/8.9.5.29-CUDA-12
module load GCC/12.3.0
module load OpenMPI/4.1.5
module load OpenBLAS/0.3.23

INSTALL_DIR=$PROJECT_jureap83/builds/lammps-2308023-gcc12.3-cuda12.2-openblas-openmpi-cudnn8.9-torch2.4-plummed
BUILD=$PROJECT_jureap83/builds

rm -r build_gpu
mkdir build_gpu
cd build_gpu

export LIBTORCH_PATH=$BUILD/libtorch/
export TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0" # trick for libtorch ~v2.2
export CUDNN_ROOT=/p/software/jurecadc/stages/2024/software/cuDNN/8.9.5.29-CUDA-12
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$LIBTORCH_PATH 

cmake ../cmake \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT \
    -D CUDNN_INCLUDE_DIR=$CUDNN_ROOT/include \
    -D CUDNN_LIBRARY_PATH=$CUDNN_ROOT/lib/libcudnn.so \
    -D PKG_KOKKOS=ON \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D Kokkos_ENABLE_OPENMP=yes \
    -D BUILD_OMP=yes \
    -D CAFFE2_USE_CUDNN=1 \
    -D BUILD_SHARED_LIBS=yes \
    -D DOWNLOAD_PLUMED=yes \
    -D PLUMED_MODE=runtime \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 40
make install