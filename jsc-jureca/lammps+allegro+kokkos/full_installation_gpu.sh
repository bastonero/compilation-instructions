#!/bin/bash -l

module load CMake/3.26.3
module load CUDA/12
module load cuDNN/8.9.5.29-CUDA-12
module load GCC/12.3.0
module load OpenMPI/4.1.5
module load OpenBLAS/0.3.23

INSTALL_DIR=$PROJECT_jureap83/builds/lammps-2308023-gcc12.3-cuda12.2-openblas-openmpi-cudnn8.9-torch2.4-plummed

BUILD=$PROJECT_jureap83/builds

# ==================================================================================== #
# Download and patch
# ==================================================================================== #
cd ${BUILD}
# LAMMPS 23.08
echo "---------------------------------------------------------------------"
echo "Downloading LAMMPS"
echo "---------------------------------------------------------------------"
git clone -b stable_2Aug2023_update3 --depth 1 https://github.com/lammps/lammps.git lammps
# pair_allegro
echo "---------------------------------------------------------------------"
echo "Downloading pair_allegro"
echo "---------------------------------------------------------------------"
git clone --depth 1 https://github.com/mir-group/pair_allegro.git pair_allegro
echo "Patching LAMMPS from pair_allegro"
cd pair_allegro
./patch_lammps.sh ../lammps/
cd ..
# Libtorch 2.1.0, cuda 12.1
echo "---------------------------------------------------------------------"
echo "Downloading and extracting Libtorch"
echo "---------------------------------------------------------------------"
# wget 'https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.4.0%2Bcu121.zip'
# unzip -q libtorch-cxx11-abi-shared-with-deps-2.4.0+cu121.zip
# rm libtorch-cxx11-abi-shared-with-deps-2.4.0+cu121.zip
wget 'https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.1.0%2Bcu121.zip'
unzip -q libtorch-cxx11-abi-shared-with-deps-2.1.0+cu121.zip
rm libtorch-cxx11-abi-shared-with-deps-2.1.0+cu121.zip

echo "---------------------------------------------------------------------"
echo "Accessing LAMMPS folder and start compilation"
echo "---------------------------------------------------------------------"
cd lammps

# ==================================================================================== #
# Compile
#   You can comment the `Download and patch` section and use the following
#   if you already downloaded and patched all the repos
# ==================================================================================== #
rm -r build_gpu
mkdir build_gpu
cd build_gpu

export LIBTORCH_PATH=$BUILD/libtorch/
export TORCH_CUDA_ARCH_LIST="8.0 8.6 8.9 9.0" # trick for libtorch ~v2.2
export CUDNN_ROOT=/p/software/jurecadc/stages/2024/software/cuDNN/8.9.5.29-CUDA-12
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:$LIBTORCH_PATH 
# -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
# -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \

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