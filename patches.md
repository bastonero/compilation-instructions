# ASE

## Patches for SIRIUS

Add to the file `/path/to/lib/python3.9/site-packages/ase/io/espresso.py`

```python
    ('DIRECT_MINIMIZATION', [
        'nlcg_conv_thr', 'nlcg_maxiter', 'nlcg_method', 'nlcg_restart',
        'nlcg_bt_step_length', 'nlcg_pseudo_precond', 'nlcg_processing_unit']),
```

## Patches for QE parsing

When forces are squashed together since they are too high.

TODO

# FLARE

## Patch for PyLammps

When specifying energy per atom, the assertion is wrong. So one can simple comment on the file
`/path/to/lib/python3.9/site-packages/flare/md/lammps.py`

The line

```python
assert np.allclose(lmp_energy, gp_energy), (lmp_energy, gp_energy)
```

