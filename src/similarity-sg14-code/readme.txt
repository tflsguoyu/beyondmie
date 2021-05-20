This directory contains our MATLAB implementation for our SIGGRAPH 2014 paper
titled 'High-Order Similarity Relations in Radiative Transfer'.

The two main source files are 'IfExists.m' and 'ComputeAlteredParameters.m'.
They implement Theorem 1 and Algorithm 1 in the paper, respectively.
We also provided "demo.m" containing two examples corresponding to phase
functions plotted in Figures 1 and 8 of the paper.

No third-party libraries is required to execute our code. However, we
strongly recommend installing the Gurobi Optimizer (http://www.gurobi.com)
since it is more than 10X faster than Matlab's built-in solvers.