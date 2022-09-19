# Beyond Mie Theory: Systematic Computation of Bulk Scattering Parameters based on Microphysical Wave Optics

[Yu Guo](https://tflsguoyu.github.io/), [Adrian Jarabo](http://giga.cps.unizar.es/~ajarabo/), [Shuang Zhao](https://shuangz.com/). 
In ACM Transactions on Graphics (SIGGRAPH Asia 2021). 


### Requirements
Our codes is relied on [CELES](https://github.com/disordered-photonics/celes).
In order to run CELES, the following software (in addition to MATLAB) should be installed on your system:
* the [CUDA toolkit](https://developer.nvidia.com/cuda-downloads) matching the `ToolkitVersion` specified when running `gpuDevice` in MATLAB.
* a [C++ compiler](https://it.mathworks.com/support/compilers.html) which is supported by MATLAB in combination with the given CUDA version.

We have precompiled cuda files included in `src/celes/src/scattering/*.mexw64`

### Run
Run `script_to_run.m`. The results will be saved in `out/`.

### Notes
If you download CELES from https://github.com/disordered-photonics/celes, 
it will automatically compile CUDA MEX file during the first time of using a new lmax, and that will take some time.
e.g.
```
compiling CUDA-code with lmax=8.
Building with 'nvcc'.
MEX completed successfully.
```
