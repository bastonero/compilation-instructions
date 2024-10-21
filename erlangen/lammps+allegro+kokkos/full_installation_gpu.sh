#!/bin/bash -l

module purge
module load cmake/3.23.1
module load gcc/11.2.0
module load cuda/11.7.1
module load openmpi/4.1.2-gcc11.2.0-cuda
module load cudnn/8.9.6.50-11.x

export MKLROOT=/apps/SPACK/0.19.1/opt/linux-almalinux8-zen/gcc-8.5.0/intel-oneapi-mkl-2023.2.0-pjoibhyqpiwpgaqtj7joxyjs6ix5g3jy/mkl/2023.2.0

INSTALL_DIR=$HOME/builds/lammps-2308023-gcc11.2-cuda11.7-mkl-openmpi-cudnn8.9-torch1.13-plummed

BUILD=$HOME/builds

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
# Libtorch 1.13.0, cuda 11.7
echo "---------------------------------------------------------------------"
echo "Downloading and extracting Libtorch"
echo "---------------------------------------------------------------------"
wget 'https://download.pytorch.org/libtorch/cu117/libtorch-cxx11-abi-shared-with-deps-1.13.0%2Bcu117.zip'
unzip -q libtorch-cxx11-abi-shared-with-deps-1.13.0+cu117.zip
rm libtorch-cxx11-abi-shared-with-deps-1.13.0+cu117.zip

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
export MKL_INCLUDE_DIR=$MKLROOT/include

cmake ../cmake \
    -D CMAKE_PREFIX_PATH=$LIBTORCH_PATH \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT \
    -D CUDNN_INCLUDE_DIR=$CUDNN_ROOT/include \
    -D CUDNN_LIBRARY_PATH=$CUDNN_ROOT/lib/libcudnn.so \
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
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 24
make install