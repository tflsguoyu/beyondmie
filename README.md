# waveoptics

## Requirements (https://github.com/disordered-photonics/celes)
In order to run CELES, the following software (in addition to MATLAB) should be installed on your system:
* the [CUDA toolkit](https://developer.nvidia.com/cuda-downloads) matching the `ToolkitVersion` specified when running `gpuDevice` in MATLAB.
* a [C++ compiler](https://it.mathworks.com/support/compilers.html) which is supported by MATLAB in combination with the given CUDA version.

## Test (running time: within 1 minute)
Checkout the codes, and run `script_for_test.m` to see if there's any error or not. The output image `farfield1.jpg` should be in the folder `../out/single/`. You can verify it by comparing with `out_ref/single/farfield1.jpg`. 

## Run (running time: ~10 hours)
If everything works, you can run `script_to_run.m`. The results will be saved in `../out/multiple/`.

## Notes
When running in Linux, it will compile MEX file first, and that will take some time.
e.g.
```
compiling CUDA-code with lmax=8.
Building with 'nvcc'.
MEX completed successfully.
```
For windows, I already have compiled MEX files (from lmax=1 to 10) checked in.   
