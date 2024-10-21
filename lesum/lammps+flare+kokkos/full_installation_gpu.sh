#!/bin/bash -l

# ------------------------> Modify here ! <------------------------ #
INSTALL_DIR=${HOME}/builds/lammps/builds/lammps-release-gpu-kokkos-flare-plumed
BUILD=${HOME}/builds
# ----------------------------------------------------------------- #

cd ${BUILD}

# (*) Load modules
module load gcc/12 CUDA/12.1 openmpi-cuda/4.1.5

# (*) Download FLARE and LAMMPS
git clone --depth 1 https://github.com/mir-group/flare.git flare
git clone -b release --depth 1 https://github.com/lammps/lammps.git lammps

# (*) Patch LAMMPS
cd ${BUILD}/flare/lammps_plugins && ./install.sh ${BUILD}/lammps

# (*) Compile LAMMPS via CMake
cd ${BUILD}/lammps
rm -r build && mkdir build && cd build

# You might try this CXX flags for slightly faster performance
# -D CMAKE_CXX_FLAGS="-std=c++14 -O2 -g -DNDEBUG" \

cmake ../cmake \
    -D CUDA_TOOLKIT_ROOT_DIR=$CUDA_PATH \
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