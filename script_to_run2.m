close all; clear;
size_scale = 1;
distance_scale = 1;
out_dir = '../results/out/multiple_1_1/';
flag = 'red'; run('multiple_particle_simulation.m')
flag = 'green'; run('multiple_particle_simulation.m')
flag = 'blue'; run('multiple_particle_simulation.m')
