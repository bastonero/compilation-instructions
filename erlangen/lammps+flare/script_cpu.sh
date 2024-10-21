#!/bin/bash -l

# (*) Load modules
module load cmake/3.23.1 mkl/2023.2.0 python/3.9-anaconda  

# ------------------------> Modify here ! <------------------------ #
PYTHON_VENV_PATH=${HOME}/.envs/flare-lammps-mkl
INSTALL_DIR=${HOME}/builds/lammps-2308023-cpu-mkl-openmp-flare-plumed-lammps
BUILD=${HOME}/builds
# ----------------------------------------------------------------- #

# (*) You might need to specify clearly the compilers
# export CC=/cluster/intel/oneapi/2023.1.0/compiler/2023.1.0/linux/bin/icx
# export CXX=/cluster/intel/oneapi/2023.1.0/compiler/2023.1.0/linux/bin/icpx

# (*) Source Python venv
source ${PYTHON_VENV_PATH}/bin/activate

# (*) Compile LAMMPS via CMake
cd ${BUILD}/stable_2Aug2023_update3
rm -r build
mkdir build
cd build
export MKL_INCLUDE_DIR=$MKLROOT/include

cmake ../cmake \
    -D MKL_INCLUDE_DIR=$MKL_INCLUDE_DIR \
    -D BUILD_MPI=no \
    -D BUILD_OMP=yes \
    -D PKG_PYTHON=yes \
    -D PKG_MANYBODY=yes \
    -D PKG_PLUMED=yes \
    -D BUILD_SHARED_LIBS=yes \
    -D DOWNLOAD_PLUMED=yes \
    -D PLUMED_MODE=runtime \
    -D DOWNLOAD_EIGEN3=yes \
    -D PKG_MACHDYN=yes \
    -D CMAKE_INSTALL_PREFIX=$INSTALL_DIR

make
make install-python
make install