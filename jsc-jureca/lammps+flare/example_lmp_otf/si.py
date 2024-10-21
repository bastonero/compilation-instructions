from lammps import lammps
import numpy as np

import ase
import ase.io
from ase.calculators.espresso import Espresso

from flare.bffs.sgp._C_flare import SparseGP, NormalizedDotProduct, B2
from flare.bffs.sgp.sparse_gp import optimize_hyperparameters
from flare.learners.lmpotf import LMPOTF

import os

os.system("rm -rf sidft && mkdir sidft")

pwx = 'pw.x'

n = 8
l = 4
rcut = 3.77118 # Angstrom
n_species = 1

# sparse GP with noise hyperparameters for
# energy, force and stress
sigma_e = 0.002 * 64
sigma_f = 0.05
sigma_s = 0.003
kernel = NormalizedDotProduct(2.0, 2)  # sigma, power
sparse_gp = SparseGP([kernel], sigma_e, sigma_f, sigma_s)
sparse_gp.Kuu_jitter = 1e-8

os.environ["ESPRESSO_PSEUDO"] = "/p/home/jusers/bastonero1/jureca/pseudos/SSSP/1.3/PBEsol/precision"
# os.environ["ASE_ESPRESSO_COMMAND"] = f"SLURM_NTASKS_PER_NODE=64 SLURM_CPUS_PER_TASK=1 SLURM_TRES_PER_TASK=cpu:1 OMP_NUM_THREADS=1 mpirun -np 64 {pwx} -in PREFIX.pwi > PREFIX.pwo"
# os.environ["ASE_ESPRESSO_COMMAND"] = f"SLURM_NTASKS_PER_NODE=4 SLURM_CPUS_PER_TASK=32 SLURM_TRES_PER_TASK=cpu:32 OMP_NUM_THREADS=32 srun {pwx} -sirius -in PREFIX.pwi > PREFIX.pwo"
os.environ["ASE_ESPRESSO_COMMAND"] = f"srun {pwx} -sirius -in PREFIX.pwi > PREFIX.pwo"


k = 2
cut = 30
pseudos = {"Si": "Si.pbe-n-rrkjus_psl.1.0.0.UPF"}
dftcalc = Espresso(
    pseudopotentials=pseudos,
    tstress=True,
    tprnfor=True,
    kpts=(k, k, k),
    input_data={
        'control':{
            'pseudo_dir':'/p/home/jusers/bastonero1/jureca/pseudos/SSSP/1.3/PBEsol/precision',
            'outdir':'./out',
        },
        'system':{
            'ecutwfc': cut,
            'ecutrho': 8*cut,
            'occupations': 'smearing',
            'smearing': 'mv',
            'degauss': 0.01,
        },
        'direct_minimization':{
            'nlcg_conv_thr': 1e-10,
        },
    },
)

import sys
sys.argv = ["in.si"]
#import wandb
#wandb.init(anonymous="allow")

def opt_hyps(lmpotf, lmp, step):
    """Return whether to optimize or not the hyperparameters.
    
    This is a custom function that can be passed to the LMPOTF class to 
    optimize the hyperparameters only when desired.
    
    .. note:: consider that the optimization should be performed when a 
        meaningful number of frames are made (otherwise unstabilities may occur),
        and after a certain number the optimization won't change much the
        accuracy, hence it will be just wasted time. The optimal range depends
        on the structre, but something between ~20:50 and ~100:150 should work.
    """
    return 10 <= lmpotf.dft_calls <= 40 and lmpotf.dft_calls % 5 == 0

lmpotf = LMPOTF(
    sparse_gp=sparse_gp,
    descriptors=B2("chebyshev", "quadratic", [0.0, rcut], [], [n_species, n, l]),
    rcut=rcut,
    type2number=14,
    dftcalc=dftcalc,
    dft_call_threshold=0.0005,
    dft_add_threshold=0.0001,
    energy_correction=0, #QE: -125.1, # JDFTx: -102.6,
 #   wandb=wandb,
    std_xyz_fname="sidft/std.*.xyz",
    dft_xyz_fname="sidft/dft.*.xyz",
    model_fname="si.otf.flare",
    log_fname="otf.si.log",
    hyperparameter_optimization=opt_hyps,
)

otf = lmpotf.step