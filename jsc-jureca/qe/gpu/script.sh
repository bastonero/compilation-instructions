#!/bin/bash -l

# Load modules
module load CMake/3.26.3
module load git
module load NVHPC/24.3-CUDA-12
module load OpenMPI/4.1.5
module load OpenBLAS
module load FFTW/3.3.10
module load CUDA/12

export NVC=$(which mpicc)
export MPIF90=$(which mpif90)

# Git clone the repository with a specific version
git clone -b qe-7.3.1 --depth 1 https://gitlab.com/QEF/q-e.git 7.3.1
cd 7.3.1 && mkdir build && cd build

#  -D QE_ENABLE_OPENACC=ON \

cmake ../ \
 -D CMAKE_C_COMPILER=$NVC \
 -D CMAKE_Fortran_COMPILER=$MPIF90 \
 -D QE_ENABLE_MPI_GPU_AWARE=ON \
 -D QE_ENABLE_CUDA=ON \
 -D QE_ENABLE_OPENACC=ON \
 -D QE_ENABLE_OPENMP=ON \
 -D QE_FFTW_VENDOR=FFTW3

make -j8 pwall ph