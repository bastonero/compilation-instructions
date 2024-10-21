# How to install QE+SIRIUS

The best (and probably only feasible way) is to compile everything using SPACK.

To do it we follow the steps:

* `git clone --depth 1 https://github.com/spack/spack.git`
* `spack config add packages:all:variants:cuda_arch=80`
* Check everything looks correct:
  * gcc example: `spack spec q-e-sirius@develop-ristretto %gcc +libxc ^sirius@develop +fortran +cuda cuda_arch=80 ^nlcglib+cuda cuda_arch=80 ^openmpi+cuda`
* Compile QE+SIRIUS with NLCG (enabling "direct minimization").
  * For GCC: `spack install q-e-sirius@develop-ristretto %gcc +libxc ^sirius@develop +fortran +cuda cuda_arch=80 ^nlcglib+cuda cuda_arch=80 ^openmpi+cuda`

## Summary of commands

```console
source ~/builds/spack/share/spack/setup-env.sh 
spack install q-e-sirius@git.b70bdfb4301d72643064a19c37c049376d2551a2 %gcc@11.3.1 +libxc ^sirius@git.develop=248e1b3ae +scalapack +nlcglib ^nlcglib@1.0b
```

Or also

```console
spack install q-e-sirius@develop-ristretto %gcc@11.3.1 +libxc ^sirius +scalapack +nlcglib ^nlcglib@1.0b
```
