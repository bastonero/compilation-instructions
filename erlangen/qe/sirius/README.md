# How to install QE+SIRIUS

```
source $HOME/builds/spack/share/spack/setup-env.sh 
module load gcc/11.2.0 openmpi/4.1.6-gcc11.2.0-cuda

# Maximum 1 GPU per k-point
spack install q-e-sirius@git.b70bdfb4301d72643064a19c37c049376d2551a2 %gcc +libxc ^sirius@git.develop=248e1b3ae +fortran +nlcglib +cuda cuda_arch=80 ^nlcglib@1.0b +cuda cuda_arch=80 ^openmpi+cuda

# For multiple GPUs per k-point
spack -e q-e-sirius-nlcg add "q-e-sirius@git.feat/md=develop-ristretto %gcc +libxc ^sirius@git.sirius-md=develop +fortran +nlcglib +cuda cuda_arch=80 ^nlcglib@develop+cuda cuda_arch=80 gpu_direct=true ^openmpi+cuda"
```

# How to create an environment for specific version/compilation


```console
spack env create q-e-sirius-nlcg
spack -e q-e-sirius-nlcg add "q-e-sirius@git.develop-ristretto=f3a6233 %gcc +libxc ^sirius@git.develop=248e1b3ae +fortran +nlcglib +cuda cuda_arch=80 ^nlcglib@1.0b+cuda cuda_arch=80 gpu_direct=true ^openmpi+cuda"
spack -e q-e-sirius-nlcg install

spack env create q-e-sirius-nlcg-direct
spack -e q-e-sirius-nlcg-direct add "q-e-sirius@git.feat/md=develop-ristretto %gcc +libxc ^sirius@git.sirius-md=develop +fortran +nlcglib +cuda cuda_arch=80 ^nlcglib@develop +cuda cuda_arch=80 gpu_direct=true ^openmpi+cuda"

spack -e q-e-sirius-nlcg-direct install
```

Problem: the latest version has new dependencies that are not catched, we need the latest spack version.

```console
spack location -i /acfcymh  # or any hash
```

Clone repo

```console
source share/spack/setup-env.sh
spack find external git
spack spec q-e-sirius@develop-ristretto+libxc ^sirius@develop+fortran+cuda ^nlcglib+cuda cuda_arch=80,90
```

# Bash history with Anton

```
  945  module load user-spack/0.19.1
  946  spack compiler list
  947  cd ~/.spack/
  948  ll
  949  vim packages.yaml
  950  mv packages.yaml packages.yaml.tmp
  951  ll
  952  spack find
  953  spack uninstall --all
  954  spack find
  955  spack arch
  956  spack spec sirius@develop
  957  env | grep SPACK
  958  ll $WORK
  959  which spack
  960  cd /apps/SPACK/0.19.1/
  961  ll
  962  find . -name *yaml
  963  find . -name compile*yaml 
  964  vim ./etc/spack/user/compilers.yaml
  965  cat ./etc/spack/user/compilers.yaml
  966  cp ./etc/spack/user/compilers.yaml $HOME/.spack
  967  cd ~/.spack/
  968  ll
  969  ll $WORK/
  970  ll $WORK/USER-SPACK
  971  cd -
  972  ll
  973  cd etc/
  974  ll
  975  cd spack/
  976  ll
  977  cat packages.yaml 
  978  cat packages.yaml | grep mpi
  979  vim packages.yaml 
  980  ll
  981  cat ~/.spack/packages.yaml.
  982  cat ~/.spack/packages.yaml.tmp 
  983  spack find -l
  984  spack info --help
  985  spack location -i /acfcymh
  986  ll
  987  cd ~/.spack/
  988  ll
  989  cp packages.yaml.bkp packages.yaml
  990  vim packages.yaml
  991  module load git
  992  ll
  993  cd ..
  994  ll
  995  cd builds/
  996  ll
  997  git clone https://github.com/spack/spack.git
  998  ll
  999  rm -rf spack/
 1000  git clone --depth 1 https://github.com/spack/spack.git
 1001  cd .spack/
 1002  ll
 1003  cd ..
 1004  ll
 1005  cd builds/spack/
 1006  ll
 1007  source share/spack/setup-env.sh 
 1008  spack compiler list
 1009  spack find
 1010  spack spec sirius@develop
 1011  spack spec q-e-sirius@ristretto-develop
 1012  spack spec q-e-sirius@develop-ristretto
 1013  spack external find git
 1014  spack spec q-e-sirius@develop-ristretto
 1015  spack spec q-e-sirius@develop-ristretto+cuda
 1016  spack spec q-e-sirius@develop-ristretto+libxc ^sirius@develop+fortran+cuda
 1017  spack install q-e-sirius@develop-ristretto+libxc ^sirius@develop+fortran+cuda
 1018  spack install q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran +cuda +nlcglib
 1019  spack install q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran +cuda +nlcglib cuda_arch=80
 1020  spack spec q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran +cuda +nlcglib 
 1021  spack spec q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran+cuda+nlcglib 
 1022  spack install nlcglib@master %gcc +cuda
 1023  spack install nlcglib@master %gcc +cuda cuda_arch=80
 1024  spack install nlcglib %gcc +cuda cuda_arch=80
 1025  spack spec q-e-sirius@develop-ristretto +libxc ^sirius@develop+fortran+cuda ^nlcglib@master+cuda cuda_arch=80 
```