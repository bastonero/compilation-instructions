#!/bin/bash -l

# Load modules
module load cmake/3.23.1
module load git/2.35.2
module load m4
module load nvhpc/22.5
module load openmpi/4.1.3-nvhpc22.5-cuda
module load fftw/3.3.10-nvhpc22.5-ompi-omp-cuda
module load cuda/11.6.2

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
 -D QE_ENABLE_OPENACC=OFF \
 -D QE_ENABLE_OPENMP=ON \
 -D QE_FFTW_VENDOR=FFTW3

make -j8 pwall ph