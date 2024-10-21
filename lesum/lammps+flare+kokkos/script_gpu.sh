#!/bin/bash -l

# !!! NOTE !!!
# Use this script in the created `lammps/build` directory _only_ AFTER 
# having patched lammps using the FLARE install.sh script
# ------------------------> Modify here ! <------------------------ #
INSTALL_DIR=${HOME}/builds/lammps/builds/lammps-release-gpu-kokkos-flare-plumed
# ----------------------------------------------------------------- #

# (*) Load modules
module purge
module load gcc/12 CUDA/12.1 openmpi-cuda/4.1.5

cmake ../cmake \
    -D CMAKE_CXX_FLAGS="-std=c++14 -O2 -g -DNDEBUG" \
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