# How to install QE+SIRIUS

The best (and probably only feasible way) is to compile everything using SPACK.

To do it we follow the steps:

1. Git clone SPACK: `git clone --depth 1 https://github.com/spack/spack.git`
2. Identify compilers, operative system, and already compiled libraries.
  1. Create under `~/.spack/` the files `compilers.yaml` and `packages.yaml`.
  2. You can use the one here (as also an example).
  3. You will have to identify at least the basic compilers and the MPI to put in packages (the rest can be compiled by SPACK).
3. Load the modules:
  * gcc example: `ml GCC OpenMPI CUDA OpenBLAS FFTW CMake git`
  * nvhpc example: `ml NVHPC OpenMPI CUDA OpenBLAS FFTW CMake git`
4. Set the CUDA architecture (80 for A100):
  * `spack config add packages:all:variants:cuda_arch=80`
4. Check everything looks correct:
  * gcc example: `spack spec q-e-sirius@develop-ristretto %gcc +libxc ^sirius@develop +fortran +cuda cuda_arch=80 ^nlcglib+cuda cuda_arch=80 ^openmpi+cuda`
5. Compile QE+SIRIUS with NLCG (enabling "direct minimization").
  * For GCC: `spack install q-e-sirius@develop-ristretto %gcc +libxc ^sirius@develop +fortran +cuda cuda_arch=80 ^nlcglib+cuda cuda_arch=80 ^openmpi+cuda`

## Summary of commands

```console
source $PROJECT_jureap83/builds/spack/share/spack/setup-env.sh

ml GCC OpenMPI CUDA FFTW OpenBLAS git

spack install q-e-sirius@git.ristretto=f3a623349 %gcc +libxc ^sirius@git.develop=248e1b3ae +fortran +nlcglib +cuda cuda_arch=80 ^nlcglib@1.0b+cuda cuda_arch=80 ^openmpi+cuda

spack install q-e-sirius@git.b70bdfb4301d72643064a19c37c049376d2551a2 %gcc +libxc ^sirius@git.develop=248e1b3ae +fortran +nlcglib +cuda cuda_arch=80 ^nlcglib@1.0b+cuda cuda_arch=80 ^openmpi+cuda
```

If something weird happens (some library/compiler not found), you can inspect via:
```console
spack build-env q-e-sirius@develop-ristretto %gcc +libxc ^sirius@develop +fortran +cuda cuda_arch=80 ^nlcglib+cuda cuda_arch=80 ^open
mpi+cuda -- bash
```

# Full history from Anton meeting

```
  703  cp ./etc/spack/user/compilers.yaml $HOME/.spack
  704  cd ~/.spack/
  705  ll
  706  ll $WORK/
  707  ll $WORK/USER-SPACK
  708  cd -
  709  ll
  710  cd etc/
  711  ll
  712  cd spack/
  713  ll
  714  cat packages.yaml 
  715  cat packages.yaml | grep mpi
  716  vim packages.yaml 
  717  ll
  718  cat ~/.spack/packages.yaml.
  719  cat ~/.spack/packages.yaml.tmp 
  720  spack find -l
  721  spack info --help
  722  spack location -i /acfcymh
  723  ll
  724  cd ~/.spack/
  725  ll
  726  cp packages.yaml.bkp packages.yaml
  727  vim packages.yaml
  728  module load git
  729  ll
  730  cd ..
  731  ll
  732  cd builds/
  733  ll
  734  git clone https://github.com/spack/spack.git
  735  ll
  736  rm -rf spack/
  737  git clone --depth 1 https://github.com/spack/spack.git
  738  cd .spack/
  739  ll
  740  cd ..
  741  ll
  742  cd builds/spack/
  743  ll
  744  source share/spack/setup-env.sh 
  745  spack compiler list
  746  spack find
  747  spack spec sirius@develop
  748  spack spec q-e-sirius@ristretto-develop
  749  spack spec q-e-sirius@develop-ristretto
  750  spack external find git
  751  spack spec q-e-sirius@develop-ristretto
  752  spack spec q-e-sirius@develop-ristretto+cuda
  753  spack spec q-e-sirius@develop-ristretto+libxc ^sirius@develop+fortran+cuda
  754  spack install q-e-sirius@develop-ristretto+libxc ^sirius@develop+fortran+cuda
  755  spack install q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran +cuda +nlcglib
  756  spack install q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran +cuda +nlcglib cuda_arch=80
  757  spack spec q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran +cuda +nlcglib 
  758  spack spec q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran+cuda+nlcglib 
  759  spack install nlcglib@master %gcc +cuda
  760  spack install nlcglib@master %gcc +cuda cuda_arch=80
  761  spack install nlcglib %gcc +cuda cuda_arch=80
  762  spack spec q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran+cuda+nlcglib 
```