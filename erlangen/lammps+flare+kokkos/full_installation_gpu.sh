#!/bin/bash -l

# ------------------------> Modify here ! <------------------------ #
INSTALL_DIR=${HOME}/builds/lammps-release-gpu-kokkos-flare-plumed
BUILD=${HOME}/builds
# ----------------------------------------------------------------- #

# (*) Load modules
module purge
module load cmake/3.23.1 gcc/11.2.0 cuda/12.1.1 openmpi/4.1.2-gcc11.2.0-cuda

# (*) Download FLARE and LAMMPS
git clone --depth 1 https://github.com/mir-group/flare.git flare
git clone -b release --depth 1 https://github.com/lammps/lammps.git lammps_flare_kokkos

# (*) Patch LAMMPS
cd ${BUILD}/flare/lammps_plugins && ./install.sh ${BUILD}/lammps_flare_kokkos

# (*) Compile LAMMPS via CMake
cd ${BUILD}/lammps_flare_kokkos
rm -r build && mkdir build && cd build

cmake ../cmake \
    -D CMAKE_CXX_FLAGS="-std=c++14 -O2 -g -DNDEBUG" \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT \
    -D PKG_KOKKOS=ON \
    -D Kokkos_ENABLE_CUDA=yes \
    -D Kokkos_ARCH_AMPERE80=yes \
    -D Kokkos_ENABLE_OPENMP=yes \
    -D Kokkos_ENABLE_MPI=yes \
    -D BUILD_OMP=yes \
    -D BUILD_SHARED_LIBS=yes \
    -D DOWNLOAD_EIGEN3=yes \
    -D PKG_MACHDYN=yes \
    -D PKG_PLUMED=yes \
    -D DOWNLOAD_PLUMED=yes \
    -D PLUMED_MODE=runtime \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make -j 20
make install