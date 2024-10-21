#!/bin/bash -l

# (*) Load modules
source $PROJECT_jureap83/builds/spack/share/spack/setup-env.sh
ml GCC OpenBLAS
# spack install python@3.9.19 %gcc
spack load python openblas cmake
wget "https://bootstrap.pypa.io/get-pip.py"
python get-pip.py

# ------------------------> Modify here ! <------------------------ #
# mkdir ${PROJECT_jureap83}/.envs
PYTHON_VENV_PATH=${PROJECT_jureap83}/.envs/flare-lammps-gcc12.3-openblas
INSTALL_DIR=${PROJECT_jureap83}/builds/lammps-2308023-cpu-gcc12.3-openblas-openmp-flare-plumed-lammps
BUILD=${PROJECT_jureap83}/builds
# ----------------------------------------------------------------- #

# (*) Create Python venv
python -m venv ${PYTHON_VENV_PATH}
source ${PYTHON_VENV_PATH}/bin/activate
$PYTHON_VENV_PATH/bin/python -m pip install --upgrade pip

# (*) Download and install FLARE
# NOTE: Last command is to make sure Numpy is compiled and linked against MKL
cd ${PYTHON_VENV_PATH}
git clone --depth 1 https://github.com/mir-group/flare.git flare-lammps
cd flare-lammps
pip install .
# pip uninstall cmake # might help
pip install --no-binary :all: numpy~=1.22.0 --force-reinstall

# (*) Patch ASE
ase_file="$(dirname $(python3 -c 'import ase; print(ase.__file__)'))/calculators/lammpsrun.py"
sed -i 's/line.startswith(_custom_thermo_mark)/line.strip\(\).startswith\("Step"\)/g' $ase_file

# (*) Download LAMMPS
cd ${BUILD}
git clone -b stable_2Aug2023_update3 --depth 1 https://github.com/lammps/lammps.git stable_2Aug2023_update3

# (*) Patch LAMMPS
# NOTE: the second patch is to use `LMPOTF`, which makes FLARE directly usable from LAMMPS
cd ${PYTHON_VENV_PATH}/flare-lammps/lammps_plugins && ./install.sh ${BUILD}/stable_2Aug2023_update3
cd ${BUILD}
wget https://gist.githubusercontent.com/anjohan/854b7100e5d2040fb0a5db031789c95f/raw/d466a526e952e9c3aab27e2ae5fe1751696faa2c/lmpotf_lib.patch
cd ${BUILD}/stable_2Aug2023_update3/src && git apply ${BUILD}/lmpotf_lib.patch
# NOTE: uncomment the following for LAMMPS versions < 02.08.2023
# cd ${BUILD}
# rm -rf eigen && git clone -b 3.3.7 --depth=1 https://gitlab.com/libeigen/eigen.git
# mv eigen/Eigen ${BUILD}/stable_23Jun2022_update2/src

# (*) Compile LAMMPS via CMake
cd ${BUILD}/stable_2Aug2023_update3
rm -r build
mkdir build
cd build

cmake ../cmake \
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